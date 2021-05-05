%assumes you already have the spacetime plot uploaded as I

%first section of the code needs to open up the spacetime plot then have
%the user choose which velocity contrast band they would like to analyze
%then draw a parralelogram

%I = 1./I;

options = optimoptions('lsqcurvefit','Display','off');
completeFitData = cell(1,length(spaceTimePlots));

for i = 1:length(spaceTimePlots)
    
    h1 = figure;
    I = spaceTimePlots{i};
    imagesc(I)
    xlabel('Image Slice')
    ylabel('Average Line Intensity')
    title(i);
    set(gca, 'TickLength',[0,0])
    hold on
    ppoly = impoly();
    pos = getPosition(ppoly);
    peak = '2';
    run = '1';
    
    curDistArr = distArrs{i};
    
    %straighten out the y coordinates
    
    y1 = round(abs((pos(1,2)+pos(2,2))/2));
    y2 = round(abs((pos(3,2)+pos(4,2))/2));
    
    %update position coordinates
    pos(1:2,2) = y1;
    pos(3:4,2) = y2;
    pos = round(pos);
    
    %update polygon position
    setPosition(ppoly,pos);
    
    %Create a mask
    BW = createMask(ppoly);
    %figure;imagesc(BW)
    
    %finds the row and column indices of what would be inside the polygon
    [row, col] = find(BW);
    mn = min(row);
    mx = max(row);
    
    
    %need to format this into an array that basically goes down in rows or up
    %in y and then gives the endpoints for the x or columns
    j = 1; %this is our counter
    C = zeros(size(mn:mx,2),3); %constructing our empty array
    %this loop constructs the array C which gives the row or y-coordinate in
    %its first column, then the second column is the min in the x coordinate
    %for that specific y coordinate and the third column is the max x
    %coordinate that way we can iterate for our fitting with the min and max x
    %coordinates giving us bounds for fitting and we can loop through the y
    %coordinates
    for k = mn:mx
        A = find(row == k);
        B = col(A);
        C(j,1) = k;
        C(j,2) = min(B);
        C(j,3) = max(B);
        j = j+1;
    end
    
    %setting up empty arrays for fit data
    centers = zeros(size(C,1),1);
    amp = zeros(size(C,1),1);
    width = zeros(size(C,1),1);
    yshift = zeros(size(C,1),1);
    R2 = zeros(size(C,1),1);
    
    %initiate the starting points for the amplitude and width fit parameters
    amp0 = 1;
    width0 = 50;
    
    %for loop for fitting the data to a 1D gaussian
    w3 = waitbar(0,'Fitting');
    for k = 1:size(C,1)
        xdata = C(k,2):C(k,3);
        ydata = I(C(k,1),C(k,2):C(k,3));
        xdata = xdata';
        ydata = ydata';
        
        lower = [-Inf, 1, C(k,2), -Inf];
        upper = [+Inf, C(k,3)-C(k,2), C(k,3), +Inf];
        x0 = [amp0,width0,(C(k,2)+C(k,3))/2,0];
        
        f = lsqcurvefit(@Lorentzian,x0,xdata,ydata,lower,upper,options);
        %f = fit(xdata,ydata,'gauss1','Lower',lower,'Upper',upper,'StartPoint',x0);
        
        R2(k) = Calc_R_Squared(ydata,Lorentzian(f,xdata));
        
        amp(k) = f(1);
        centers(k) = f(3);
        width(k) = f(2);
        yshift(k) = f(4);
        
        %amp0 = f(1);
        %width0 = f(2);
        waitbar(k/size(C,1));
    end
    close(w3);
    
    %plots the centers of the gaussian peaks on to the space time plot
    plot(centers,C(:,1),'*','Color','r')
    
    %concatenates the data into one array to save for the future
    fitdata = [C(:,1), amp, centers, width];
    completeFitData{i} = fitdata;
    
    %now we need to fit the centers with a line to extract a velocity
%     f2 = fit(centers,C(:,1),'poly1');
%     plot(f2)
%     xlabel('Delay (ps)')
%     ylabel('Pixel')
%     
%     f2.p1
    
    % figure;
    % hold on
    % for i = 1:size(C,1)
    %     xdata = C(i,2):C(i,3);
    %     zdata = I(C(i,1),C(i,2):C(i,3));
    %     xdata = xdata';
    %     zdata = zdata';
    %
    %     yy = zeros(numel(xdata));
    %     yy(:) = 2*i;
    %     f3 = [amp(i), width(i), centers(i), yshift(i)];
    %
    %     plot3(xdata,yy,zdata,'Color','b')%,'*','Color','b')
    %     plot3(xdata,yy,Lorentzian(f3,xdata),'Color','r')
    %
    % end
    pause(0.5);
    close(h1);
end
