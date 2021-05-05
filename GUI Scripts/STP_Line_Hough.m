numX = size(spaceTimePlot,1);
numT = size(spaceTimePlot,2);

numshift =  0;%-1*round(numX/3);
numTshift = 1:numT;

STP_XShift = circshift(spaceTimePlot(:,numTshift),numshift,1);
curSTP = [];

HoughSet = cell(1,numT);
ThetaSet = cell(1,numT);
RhoSet = cell(1,numT);
STPSet  = cell(1,numT);
lineSet = cell(1,numT);

square_numT = round(sqrt(numTshift(end) - numTshift(1))) + 1;

f1 = figure;
%f2 = figure;
f3 = figure;
imagesc(spaceTimePlot);
for i = numTshift
    curSTP = 100*circshift(STP_XShift,-1*i,2);
    curSTP(100*circshift(STP_XShift,-1*i,2) >= 0.20) = 0; %3.25
    curSTP(100*circshift(STP_XShift,-1*i,2) < 0.20) = 1;
    curSTP = curSTP(round(1*numX/3):round(3*numX/5),numTshift);%
    STPSet{i} = curSTP;
    figure(f1);
    subplot(square_numT,square_numT,i-numTshift(1)+1);
    imagesc(curSTP);
    title(i);
    %pause(0.5);
    [HoughSet{i},ThetaSet{i},RhoSet{i}] = hough(curSTP,'RhoResolution',1,'Theta',2:0.1:8);
    curHough = HoughSet{i};
    curTheta = ThetaSet{i};
    curRho = RhoSet{i};
%     figure(f2);
%     subplot(square_numT,square_numT,i-numTshift(1)+1);
%     imshow(HoughSet{i},[],'XData',ThetaSet{i},'YData',RhoSet{i},...
%             'InitialMagnification','fit');
%     hold on;
    HoughPeaks  = houghpeaks(HoughSet{i}, 20,'threshold',ceil(0.1*max(curHough(:))));%,'threshold',ceil(0.3*max(H(:))));
    HoughPeakx = curTheta(HoughPeaks(:,2)); HoughPeaky = curRho(HoughPeaks(:,1));
%     plot(HoughPeakx,HoughPeaky,'s','color','white');
%     hold off;
    figure(f1);
    subplot(square_numT,square_numT,i-numTshift(1)+1);
    hold on;
    lines = houghlines(curSTP,curTheta,curRho,HoughPeaks,'FillGap',5,'MinLength',10);
    lineSet{i} = lines;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    end
    
    figure(f3);
    hold on;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1) + i,xy(:,2) - numshift + round(numX/3),'LineWidth',2,'Color','green');
    end
    
end



%[H,theta,rho] = hough(BW,RhoResolution,RhoResolution,Theta,-90:89);