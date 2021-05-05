%assumes you already have the spacetime plot uploaded as I

%first section of the code needs to open up the spacetime plot then have
%the user choose which velocity contrast band they would like to analyze
%then draw a parralelogram

%I = 1./I;

options = optimoptions('lsqcurvefit','Display','off');
completeFitData = cell(1,length(spaceTimePlots));

initCenter = 0;
initx1 = 0;
initx2 = 0;
y1 = 0;
y2 = 0;

for i = 1:length(spaceTimePlots)
    
    h1 = figure;
    I = spaceTimePlots{i};
    tArr = 1:size(I,2);
    if i == 1
        initmaxY = length(I(:,1));
    end
    curmaxY = length(I(:,1));
    imagesc(I)
    xlabel('Image Slice')
    ylabel('Average Line Intensity')
    title(i);
    set(gca, 'TickLength',[0,0])
    hold on
    if i == 1
        ppoly = impoly();
        pos = getPosition(ppoly);
        
        peak = '2';
        run = '1';
        
        curDistArr = distArrs{i};
        
        %straighten out the y coordinates
        
        y1 = round(abs((pos(1,2)+pos(2,2))/2));
        y2 = round(abs((pos(3,2)+pos(4,2))/2));
        x1 = pos(1,1);
        x2 = pos(2,1);
        x3 = pos(3,1);
        x4 = pos(4,1);
        
        %update position coordinates
        pos(1:2,2) = y1;
        pos(3:4,2) = y2;
        pos = round(pos);
        
        %update polygon position
        setPosition(ppoly,pos);
        
        %Create a mask
        BW = createMask(ppoly);
        
        horizDist = abs(x2 - x1);
        initCenter = horizDist/2+(x2>x1)*x1+(x1>x2)*x2;
        inity1 = y1;
        inity2 = y2;
        initx1 = x1;
        initx2 = x2;
        initWidth = abs(x2-x1);
        finWidth = abs(x4-x3);
        vertDist = abs(y2 - y1);
        
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
        adjustcenters = zeros(size(C,1),1);
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
        
        curModel = fitlm(y1:y2 - 1,centers);
        origcenter = centers(1);
        
        initYAvg = (y1+y2)/2;
        yArr = (y1:y2-1);
        
        coefficients = curModel.Coefficients.Estimate;
        slope = (coefficients(2));
        const = (coefficients(1));
        adjustcenters = (y1:y2-1).*slope + const;
        plot(adjustcenters, y1:y2-1, 'b');
    else
        curCenter = initCenter;
        w3 = waitbar(0,'Fitting');
        newy1 = round(inity1*curmaxY/initmaxY);
        newy2 = round(inity2*curmaxY/initmaxY);
        yArr = newy1:newy2;
        
        adjustcenters = yArr.*slope + const;
        %plot(adjustcenters, yArr, 'r');
        WidthProportions = linspace(initWidth,finWidth,length(yArr))./initWidth;
        
        centers = zeros(length(yArr),1);
        amp = zeros(length(yArr),1);
        width = zeros(length(yArr),1);
        yshift = zeros(length(yArr),1);
        R2 = zeros(length(yArr),1);
        
        for k = yArr
            curWidth = abs(initx2 - initx1)*WidthProportions(k-yArr(1)+1);
            curx1 = round(adjustcenters(k-yArr(1)+1) - curWidth/2);
            curx2 = round(adjustcenters(k-yArr(1)+1) + curWidth/2);
            if curx1 < 1
                curx1 = 1;
            end
            if curx2 > length(tArr)
                curx2 = length(tArr);
            end
            curXData = curx1:curx2;
            curData = I(k,curx1:curx2);
            
            lower = [-Inf, 1, curx1, -Inf];
            upper = [+Inf, curx2 - curx1, curx2, +Inf];
            x0 = [amp0,width0,(curx2+curx1)/2,0];
            
            f = lsqcurvefit(@Lorentzian,x0,curXData',curData',lower,upper,options);
            
            %             curx1 = round(curCenter - curWidth/2);
            %             curx2 = round(curCenter + curWidth/2);
            %             curXData = curx1:curx2;
            %             curData = I(k,curx1:curx2);
            %             plot([curx1 curx2], [k k], 'r');
            %
            %             lower = [-Inf, 1, curx1, -Inf];
            %             upper = [+Inf, curx2 - curx1, curx2, +Inf];
            %             x0 = [amp0,width0,(curx2+curx1)/2,0];
            %
            %             f = lsqcurvefit(@Lorentzian,x0,curXData',curData',lower,upper,options);
            %
            %             curCenter = f(3);
            amp(k-yArr(1)+1) = f(1);
            centers(k-yArr(1)+1) = f(3);
            width(k-yArr(1)+1) = f(2);
            yshift(k-yArr(1)+1) = f(4);
        end
        
        curModel = fitlm(yArr,centers);
        
        coefficients = curModel.Coefficients.Estimate;
        slope = (coefficients(2));
        const = (coefficients(1));
        
        adjustcenters = yArr.*slope + const;
        plot(adjustcenters, yArr, 'b');
        
        for k = yArr
            curWidth = abs(initx2 - initx1)*WidthProportions(k-yArr(1)+1);
            curx1 = round(adjustcenters(k-yArr(1)+1) - curWidth/2);
            curx2 = round(adjustcenters(k-yArr(1)+1) + curWidth/2);
            if curx1 < 1
                curx1 = 1;
            end
            if curx2 > length(tArr)
                curx2 = length(tArr);
            end
            curXData = curx1:curx2;
            curData = I(k,curx1:curx2);
            
            plot([curx1 curx2], [k k], 'r');
            
            lower = [-Inf, 1, curx1, -Inf];
            upper = [+Inf, curx2 - curx1, curx2, +Inf];
            x0 = [amp0,width0,(curx2+curx1)/2,0];
            
            f = lsqcurvefit(@Lorentzian,x0,curXData',curData',lower,upper,options);
            
            pause(0.001);
            amp(k-yArr(1)+1) = f(1);
            centers(k-yArr(1)+1) = f(3);
            width(k-yArr(1)+1) = f(2);
            yshift(k-yArr(1)+1) = f(4);
            waitbar((k-yArr(1)+1)/length(yArr));
        end
        
        curModel = fitlm(yArr,centers);
        
        coefficients = curModel.Coefficients.Estimate;
        slope = (coefficients(2));
        const = (coefficients(1));
    end
    close(w3);
    %plots the centers of the gaussian peaks on to the space time plot
    hold on;
    plot(centers,yArr,'*','Color','r');
    hold off;
    
    %concatenates the data into one array to save for the future
    fitdata = [yArr', amp, centers, width];
    completeFitData{i} = fitdata;
    pause(0.5);
    close(h1);
end