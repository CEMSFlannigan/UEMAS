function lineSum_Dynamic(hObject, eventdata, handles)

data = guidata(hObject);

width = data.width; % pixel width
pixel_scale = data.scale; % px/nm .4701236
if ~isempty(data.ULGData)
    ULGTime = sortrows(data.ULGData,3);
    
    timeArr = cell2mat(ULGTime(:,3));
else
    timeArr = 0;
end

if data.prcToggle == 1
    backData = RMOuts(data.backData,data.highprc_cutoff,data.lowprc_cutoff);
else
    data.backData = RMOuts(data.backData);
end

if data.normToggle == 1 && data.backToggle == 1
    backData = (backData - ones(size(backData)).*min(min(backData)))./(max(max(backData)) - min(min(backData)));
end
   
if ~isempty(data.degRot) && data.rotToggle == 1 && data.backToggle == 1
    backData = imrotate(backData,data.degRot);
end
        
degVar = data.degVar;
assignin('base','degVar',degVar);

LinePos = getPosition(data.lineROI);

lengthLine = sqrt((LinePos(2,2) - LinePos(1,2))^2 + (LinePos(2,1) - LinePos(1,1))^2);
centerx = (LinePos(2,1) - LinePos(1,1))/2 + LinePos(1,1);
centery = (LinePos(2,2) - LinePos(1,2))/2 + LinePos(1,2);
gam = atand((LinePos(2,2) - LinePos(1,2))/(LinePos(2,1) - LinePos(1,1)));

lines = cell(1,degVar*2+1); % [x3 y3 x4 y4] per cell
slopes = zeros(1,degVar*2+1);
invslopes = zeros(1,degVar*2+1);
xArrs = cell(1,degVar*2+1);
yArrs = cell(1,degVar*2+1);
distArrs = cell(1,degVar*2+1);
if degVar == 0
    timeSums = zeros(length(timeArr),1);
else
    timeSums = zeros(length(timeArr),1);
    timeSumArrs = zeros(length(timeArr),degVar*2+1);
end
timeVar = zeros(length(timeArr),1);
point_distances = zeros(1,degVar*2+1);
true_distances = zeros(1,degVar*2+1);

for alph = -1*degVar:degVar
    x3 = round(centerx - lengthLine/2*cosd(gam + alph));
    y3 = round(centery - lengthLine/2*sind(gam + alph));
    
    dx = x3 - LinePos(1,1);
    dy = y3 - LinePos(1,2);
    
    x4 = LinePos(2,1) - dx;
    y4 = LinePos(2,2) - dy;
    lines{alph+degVar+1} = [x3 y3 x4 y4];
    
    slopes(alph+degVar+1) = (y4 - y3)/(x4 - x3);
    invslopes(alph+degVar+1) = -1/slopes(alph+degVar+1);
    
    if x3 <= x4
        xArrs{alph+degVar+1} = x3:x4;
    else
        xArrs{alph+degVar+1} = x4:x3;
    end
    
    if y3 <= y4
        yArrs{alph+degVar+1} = y3:y4;
    else
        yArrs{alph+degVar+1} = y4:y3;
    end
    
    if length(xArrs{alph+degVar+1}) >= length(yArrs{alph+degVar+1})
        distArrs{alph+degVar+1} = 0:length(xArrs{alph+degVar+1});
        point_distances(alph+degVar+1) = sqrt(1 + abs(slopes(alph+degVar+1)));
        true_distances(alph+degVar+1) = point_distances(alph+degVar+1)/pixel_scale;
    else
        distArrs{alph+degVar+1} = 0:length(yArrs{alph+degVar+1});
        point_distances(alph+degVar+1) = sqrt(1 + abs(invslopes(alph+degVar+1)));
        true_distances(alph+degVar+1) = point_distances(alph+degVar+1)/pixel_scale;
    end
end

assignin('base','lines',lines);

h3 = figure;
hold on;

sizePlot = ceil(sqrt(2*degVar+1));
C = linspecer(degVar*2+1,'sequential');

for alph = -1*degVar:degVar
    
    LinePos = lines{alph+degVar+1};
    slope = slopes(alph+degVar+1);
    invslope = invslopes(alph+degVar+1);
    pixel_scale = .4701236; % px/nm
    disp(LinePos);
    if LinePos(1) <= LinePos(2)
        xArr = xArrs{alph+degVar+1};
    else
        xArr = xArrs{alph+degVar+1};
    end
    
    if LinePos(3) <= LinePos(4)
        yArr = yArrs{alph+degVar+1};
    else
        yArr = yArrs{alph+degVar+1};
    end
    
    if length(xArr) >= length(yArr)
        distArr = distArrs{alph+degVar+1};
        pixel_distance = sqrt(1 + abs(slope));
        true_distance = pixel_distance/pixel_scale;
        if degVar == 0
            timeSum = zeros(length(timeArr),length(xArr));
        end
    else
        distArr = distArrs{alph+degVar+1};
        pixel_distance = sqrt(1 + abs(invslope));
        true_distance = pixel_distance/pixel_scale;
        if degVar == 0
            timeSum = zeros(length(timeArr),length(yArr));
        end
    end
    
    timeSum = zeros(1,length(timeArr));
    
    w = waitbar(0,'Constructing Space and Time');
    %h1 = figure;
    %h2 = figure;
    for i = 1:length(timeArr)
        
        curFile = [ULGTime{i,6} '.dm3'];
        dm3path = [data.dm3path '\' curFile];
        dm3Data = DM3Import(dm3path);
        cur_img_data = dm3Data.image_data';
        
        if data.prcToggle == 1
            cur_img_data = RMOuts(cur_img_data,data.highprc_cutoff,data.lowprc_cutoff);
        else
            cur_img_data = RMOuts(cur_img_data);
        end
        
        if data.normToggle == 1
            cur_img_data = (cur_img_data - ones(size(cur_img_data)).*min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
        end
        
        if ~isempty(data.degRot) && data.rotToggle == 1
            cur_img_data = imrotate(cur_img_data,data.degRot);
        end
        
        if data.driftToggle == 1
            cur_img_data = circshift(cur_img_data, [data.drift_correct(i, 3), data.drift_correct(i, 2)]);
        end
        
        if data.backToggle == 1
            cur_img_data = cur_img_data - backData;
        end
        
        % Make the inherent design choice to move along the axis of greatest
        % length
        % Need to add width integration
        
        curSum = 0;
        
        if length(xArr) >= length(yArr)
            for j = 1:length(xArr)
                curx = xArr(j);
                cury = slope*(curx - LinePos(1,1)) + LinePos(1,2);
                distArr(j) = sqrt((curx - LinePos(1,1))^2 + (cury - LinePos(1,2))^2);
                
                tempSum = 0;
                for k = 1:width
                    curPosWidth = round(width/2)-width+k;
                    xadj = curPosWidth/sqrt(1+invslope^2);
                    if ~isinf(invslope)
                        yadj = xadj*invslope;
                    else
                        yadj = -1*round(width/2) + k - 1;
                    end
                    xval = curx+xadj;
                    yval = cury+yadj;
                    tempSum = tempSum + cur_img_data(round(yval),round(xval));
                    curSum = curSum + cur_img_data(round(yval),round(xval));
                end
                timeSums(i,j) = tempSum/width;
            end
            timeSum(i) = curSum/length(xArr)/width;
        else
            for j = 1:length(yArr)
                cury = yArr(j);
                curx = (cury - LinePos(1,2))/slope + LinePos(1,1);
                distArr(j) = sqrt((curx - LinePos(1,1))^2 + (cury - LinePos(1,2))^2);
                
                tempSum = 0;
                for k = 1:width
                    curPosWidth = round(width/2)-width+k;
                    xadj = curPosWidth/sqrt(1+invslope^2);
                    if ~isinf(invslope)
                        yadj = xadj*invslope;
                    else
                        yadj = -1*round(width/2) + k - 1;
                    end
                    xval = curx+xadj;
                    yval = cury+yadj;
                    tempSum = tempSum + cur_img_data(round(yval),round(xval));
                    curSum = curSum + cur_img_data(round(yval),round(xval));
                end
                timeSums(i,j) = tempSum/width;
            end
            timeSum(i) = curSum/length(yArr)/width;
        end
        
        if degVar == 0
            timeVar(i) = var(timeSums(i,:));
        end
        waitbar(i/length(timeArr));
    end
    
    close(w);
    
    if degVar == 0
        plot(timeArr(:),timeSum(:));
        errorbar(timeArr(:),timeSum(:),timeVar,'o');
    else
        timeSumArrs(:,alph+degVar+1) = timeSum';
        subplot(sizePlot,sizePlot,degVar+alph+1);
        plot(timeArr(:),timeSum(:),'Color',C(alph+degVar+1,:));
    end
    
end

assignin('base','timeVar',timeVar);
assignin('base','timeArr',timeArr);
assignin('base','distArrs',distArrs);
assignin('base','distanceScales',true_distances);
assignin('base','timeSums',timeSums);
assignin('base','timeSum',timeSum);
%assignin('base','timeSumArrs',timeSumArrs);

% min_max_diff = zeros(1,degVar*2+1);
% for i = 1:degVar*2+1
% min_max_diff(i) = max(timeSumArrs(:,i)) - min(timeSumArrs(:,i));
% end
% figure;
% plot(min_max_diff);

end