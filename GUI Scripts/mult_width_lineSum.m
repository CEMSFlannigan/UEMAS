function multlineSum_Dynamic(hObject, eventdata, handles)

data = guidata(hObject);

width = data.width; % pixel width
pixel_scale = data.scale; % px/nm .4701236
ULGTime = sortrows(data.ULGData,3);

timeArr = cell2mat(ULGTime(:,3));

degVar = data.degVar;
assignin('base','degVar',degVar);

LinePos = getPosition(data.lineROI);
initslope = (LinePos(2,2) - LinePos(1,2))/(LinePos(2,1) - LinePos(1,1));

lengthLine = abs(LinePos(2,1) - LinePos(1,1))
centerx = (LinePos(2,1) - LinePos(1,1))/2 + LinePos(1,1);
centery = (LinePos(2,2) - LinePos(1,2))/2 + LinePos(1,2);
gam = atand((LinePos(2,2) - LinePos(1,2))/(LinePos(2,1) - LinePos(1,1)));

minLine = 2;
maxLine = round(lengthLine)+250;
numLines = maxLine - minLine + 1;
rand_lengths = minLine:1:maxLine;%round(randperm(1000,numLines)/1000*lengthLine);
lines = cell(1,numLines); % [x3 y3 x4 y4] per cell
slopes = zeros(1,numLines);
invslopes = zeros(1,numLines);
xArrs = cell(1,numLines);
yArrs = cell(1,numLines);
distArrs = cell(1,numLines);
timeSums = zeros(length(timeArr),1);
meantimeSums = zeros(length(timeArr),1);
vartimeSums = zeros(length(timeArr),numLines);
meanvartimeSums = zeros(length(timeArr),1);
timeSumArrs = zeros(length(timeArr),numLines);
timeVar = zeros(length(timeArr),1);
point_distances = zeros(1,numLines);
true_distances = zeros(1,numLines);

for line_num = 1:numLines
    x3 = round(centerx - rand_lengths(line_num)/2);
    y3 = round(initslope*(x3-centerx)+centery);
    
    x4 = round(centerx + rand_lengths(line_num)/2);
    y4 = round(initslope*(x4-centerx)+centery);
    
    lines{line_num} = [x3 y3 x4 y4];
    slopes(line_num) = (y4 - y3)/(x4 - x3);
    invslopes(line_num) = -1/slopes(line_num);
    
    if x3 <= x4
        xArrs{line_num} = x3:x4;
    else
        xArrs{line_num} = x4:x3;
    end
    
    if y3 <= y4
        yArrs{line_num} = y3:y4;
    else
        yArrs{line_num} = y4:y3;
    end
    
    if length(xArrs{line_num}) >= length(yArrs{line_num})
        distArrs{line_num} = 0:length(xArrs{line_num});
        point_distances(line_num) = sqrt(1 + abs(slopes(line_num)));
        true_distances(line_num) = point_distances(line_num)/pixel_scale;
    else
        distArrs{line_num} = 0:length(yArrs{line_num});
        point_distances(line_num) = sqrt(1 + abs(invslopes(line_num)));
        true_distances(line_num) = point_distances(line_num)/pixel_scale;
    end
end

assignin('base','multlines',lines);

% h3 = figure;
% hold on;

sizePlot = ceil(sqrt(numLines));
C = linspecer(line_num,'sequential');

for line_num = 1:numLines
    
    LinePos = lines{line_num};
    slope = slopes(line_num);
    invslope = invslopes(line_num);
    pixel_scale = .4701236; % px/nm
    disp(LinePos);
    if LinePos(1) <= LinePos(2)
        xArr = xArrs{line_num};
    else
        xArr = xArrs{line_num};
    end
    
    if LinePos(3) <= LinePos(4)
        yArr = yArrs{line_num};
    else
        yArr = yArrs{line_num};
    end
    
    if length(xArr) >= length(yArr)
        distArr = distArrs{line_num};
        pixel_distance = sqrt(1 + abs(slope));
        true_distance = pixel_distance/pixel_scale;
        if degVar == 0
            timeSum = zeros(length(timeArr),length(xArr));
        end
    else
        distArr = distArrs{line_num};
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
    for i = 1:length(data.ULGData(:,3))
        
        curFile = [ULGTime{i,6} '.dm3'];
        dm3path = [data.dm3path '\' curFile];
        dm3Data = DM3Import(dm3path);
        cur_img_data = dm3Data.image_data';
        
        if data.backToggle == 1
            cur_img_data = cur_img_data - data.backData;
        end
        
        if data.prcToggle == 1
            cur_img_data = RMOuts(cur_img_data,data.highprc_cutoff,data.lowprc_cutoff);
        else
            cur_img_data = RMOuts(cur_img_data);
        end
        
        if data.normToggle == 1
            cur_img_data = (cur_img_data - ones(size(cur_img_data)).*min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
        end
        
        if data.driftToggle == 1
            cur_img_data = circshift(cur_img_data, [data.drift_correct(i, 3), data.drift_correct(i, 2)]);
        end
        
        if ~isempty(data.degRot) && data.rotToggle == 1
            cur_img_data = imrotate(cur_img_data,data.degRot);
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
                for k = 1:width+1
                    curPosWidth = round(width/2)-width+k-1;
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
                for k = 1:width+1
                    curPosWidth = round(width/2)-width+k-1;
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
        
        timeVar(i) = var(timeSums(i,:));
        
        waitbar(i/length(data.ULGData(:,3)));
    end
    
    meantimeSums(line_num) = mean(timeSum);
    vartimeSums(:,line_num) = timeVar;
    meanvartimeSums(line_num) = mean(timeVar);
    
    
    close(w);
    timeSumArrs(:,line_num) = timeSum;
%     plot(timeArr(:),timeSum(:));
%     subplot(sizePlot,sizePlot,line_num);
%     errorbar(timeArr(:),timeSum(:),timeVar,'o');
    
end

assignin('base','multtimeVar',timeVar);
assignin('base','meantimeSums',meantimeSums);
assignin('base','vartimeSums',vartimeSums);
assignin('base','meanvartimeSums',meanvartimeSums);
assignin('base','multtimeArr',timeArr);
assignin('base','multdistArrs',distArrs);
assignin('base','multdistanceScales',true_distances);
assignin('base','multtimeSums',timeSums);
assignin('base','multtimeSum',timeSum);
assignin('base','multtimeSumArrs',timeSumArrs);

end