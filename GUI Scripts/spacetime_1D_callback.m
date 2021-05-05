function spacetime_1D_callback(hObject, eventdata, handles)

data = guidata(hObject);

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

width = data.width;

ULGTime = sortrows(data.ULGData,3);

timeArr = cell2mat(ULGTime(:,3));

LinePos = getPosition(data.lineROI);
slope = (LinePos(2,2)-LinePos(1,2))/(LinePos(2,1)-LinePos(1,1));
invslope = -1/slope;
pixel_scale = data.scale; % px/nm
if LinePos(1,1) <= LinePos(2,1)
    xArr = LinePos(1,1):LinePos(2,1);
else
    xArr = LinePos(2,1):LinePos(1,1);
end

if LinePos(1,2) <= LinePos(2,2)
    yArr = LinePos(1,2):LinePos(2,2);
else
    yArr = LinePos(2,2):LinePos(1,2);
end

if length(xArr) >= length(yArr)
    spaceTimePlot = zeros(length(xArr),length(timeArr));
    distArr = 0:length(xArr);
    pixel_distance = sqrt(1 + abs(slope));
    true_distance = pixel_distance/pixel_scale;
else
    spaceTimePlot = zeros(length(yArr),length(timeArr));
    distArr = 0:length(yArr);
    pixel_distance = sqrt(1 + abs(invslope));
    true_distance = pixel_distance/pixel_scale;
end

vertMeans = zeros(1,length(timeArr));
horizMeans = zeros(1,length(distArr));

misalLineSlope = 0;
misalLinePos = 0;

% Calculate misaligned line width slopes
if ~isempty(data.misalLineROI) && ~isempty(data.misalLineToggle) && data.misalLineToggle == 1
    misalLinePos = getPosition(data.misalLineROI);
    misalLineSlope = (misalLinePos(2,2) - misalLinePos(1,2))./(misalLinePos(2,1) - misalLinePos(1,1));
end

if data.misalLineToggle == 1
    if misalLinePos(1,1) <= misalLinePos(2,1)
        MAxArr = misalLinePos(1,1):misalLinePos(2,1);
    else
        MAxArr = fliplr(misalLinePos(2,1):misalLinePos(1,1));
    end
    
    if misalLinePos(1,2) <= misalLinePos(2,2)
        MAyArr = misalLinePos(1,2):misalLinePos(2,2);
    else
        MAyArr = fliplr(misalLinePos(1,2):misalLinePos(2,2));
    end
end

w = waitbar(0,'Constructing Space and Time');
%h1 = figure;
%h2 = figure;
for i = 1:length(data.ULGData(:,3))
    
    curFile = [ULGTime{i,6} '.dm3'];
    dm3path = [data.dm3path '\' curFile];
    dm3Data = DM3Import(dm3path);
    assignin('base','analysis_dm3',dm3path);
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
    %cur_img_data = medfilt2(cur_img_data);
    
    %% Normalization and Histogram Shifting
    
%     assignin('base','init_img_data',cur_img_data);
%     
%     cur_img_data = (cur_img_data - ones(size(cur_img_data)).*min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
%     
%     [counts,binLocations] = imhist(cur_img_data);
%     
%     assignin('base','counts',counts);
%     assignin('base','binLocations',binLocations);
%     
%     % Calculate location of first peak and drop off area
%     
%     dcdbL = diff(counts)./diff(binLocations);
%     mbL = binLocations(1:end-1) + diff(binLocations)/2;
%     
%     [zero_pos, zero_pos_i] = findZeros(dcdbL,mbL);
%     
%     d2cdbL2 = diff(dcdbL)./diff(mbL);
%     mmbL = mbL(1:end-1) + diff(mbL)/2;
%     
% %     set(0, 'CurrentFigure', h2);
% %     stem(binLocations,counts);
%     
%     first_max = 0;
%     first_max_i = 0;
%     
%     for j = 1:length(zero_pos_i)
%         [cur_bL cur_bL_i] = closestDiscrete(mbL(zero_pos_i(j)),mmbL);
%         if d2cdbL2(cur_bL_i) < 0
%             first_max = zero_pos(j);
%             first_max_i = j;
%             break;
%         end
%     end
%     
%     assignin('base','zero_pos_i',zero_pos_i);
%     assignin('base','dcdbL',dcdbL);
%     assignin('base','mbL',mbL);
%     assignin('base','d2cdbL2',d2cdbL2);
%     assignin('base','mmbL',mmbL);
% 
%     [high highi] = closestDiscrete(zero_pos(first_max_i+1),binLocations);
%     [low lowi] = closestDiscrete(zero_pos(first_max_i),binLocations);
%     Upper = cur_img_data > high;
%     Lower = cur_img_data < low;
%     cur_img_data(Upper) = high;
%     cur_img_data(Lower) = low;
%     
% %     hold on;
% %     scatter(binLocations([lowi, highi]), counts([lowi, highi]), 'MarkerFaceColor','r');
% %     hold off;
%     
%     cur_img_data = (cur_img_data - ones(size(cur_img_data)).*min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
%     assignin('base','cur_img_data',cur_img_data);
        
%     set(0, 'CurrentFigure', h1);
%     imagesc(cur_img_data);
%     
    %%
    
    % Make the inherent design choice to move along the axis of greatest
    % length
    % Need to add width integration
    
    if length(xArr) >= length(yArr)
        if LinePos(1,1) <= LinePos(2,1)
            curLineData = zeros(1,LinePos(2,1) - LinePos(1,1));
        else
            curLineData = zeros(1,LinePos(1,1) - LinePos(2,1));
        end
        
        for j = 1:length(xArr)
            curx = xArr(j);
            cury = slope*(curx - LinePos(1,1)) + LinePos(1,2);
            distArr(j) = sqrt((curx - LinePos(1,1))^2 + (cury - LinePos(1,2))^2);
            
            curSum = 0;
            
            for k = 1:width
                curPosWidth = round(width/2)-width+k;
                if data.misalLineToggle == 1
                    if length(MAxArr) >= length(MAyArr)
                        xadj = curPosWidth;
                        yadj = xadj*misalLineSlope;
                    elseif length(MAyArr) > length(MAxArr)
                        yadj = curPosWidth;
                        if ~isinf(misalLineSlope)
                            xadj = 0;
                        else
                            xadj = yadj/misalLineSlope;
                        end
                    end
                else
                    xadj = curPosWidth;
                    if ~isinf(invslope)
                        yadj = xadj*invslope;
                    else
                        yadj = curPosWidth;
                        xadj = 0;
                    end
                end
                
                xval = curx+xadj;
                yval = cury+yadj;
                
                curSum = curSum + cur_img_data(round(yval),round(xval));
            end
            curLineData(j) = curSum/width;
        end
    else
        if LinePos(1,2) <= LinePos(2,2)
            curLineData = zeros(1,LinePos(2,2) - LinePos(1,2));
        else
            curLineData = zeros(1,LinePos(1,2) - LinePos(2,2));
        end
        
        for j = 1:length(yArr)
            cury = yArr(j);
            curx = (cury - LinePos(1,2))/slope + LinePos(1,1);
            distArr(j) = sqrt((curx - LinePos(1,1))^2 + (cury - LinePos(1,2))^2);
            
            curSum = 0;
            
            for k = 1:width
                curPosWidth = round(width/2)-width+k;
                if data.misalLineToggle == 1
                    if length(MAxArr) >= length(MAyArr)
                        xadj = curPosWidth;
                        yadj = xadj*misalLineSlope;
                    elseif length(MAyArr) > length(MAxArr)
                        yadj = curPosWidth;
                        if ~isinf(misalLineSlope)
                            xadj = 0;
                        else
                            xadj = yadj/misalLineSlope;
                        end
                    end
                else
                    xadj = curPosWidth/sqrt(1+invslope^2);
                    if ~isinf(invslope)
                        yadj = xadj*invslope;
                    else
                        yadj = -1*round(width/2) + k - 1;
                    end
                end
                
                xval = curx+xadj;
                yval = cury+yadj;
                
                curSum = curSum + cur_img_data(round(yval),round(xval));
            end
            
            curLineData(j) = curSum/width;
        end
    end
    
    vertMeans(i) = mean(curLineData);
    if isnan(vertMeans(i))
        curLineData = zeros(size(curLineData));
    else
        assignin('base','curLineData',curLineData);
    end
    spaceTimePlot(:,i) = curLineData;

    waitbar(i/length(data.ULGData(:,3)));
end

assignin('base','spaceTimePlot_preProcess',spaceTimePlot);

sizeSpaceTime = size(spaceTimePlot);
for i = 1:sizeSpaceTime(1)
    mean(spaceTimePlot(i,:));
    horizMeans(i) = mean(spaceTimePlot(i,:));
end

if data.hToggle == 1
    for i = 1:sizeSpaceTime(1)
        spaceTimePlot(i,:) = spaceTimePlot(i,:) - horizMeans(i).*ones(size(spaceTimePlot(i,:)));
    end
end

if data.vToggle == 1
    for i = 1:length(timeArr)
        spaceTimePlot(:,i) = spaceTimePlot(:,i) - vertMeans(i).*ones(size(spaceTimePlot(:,i)));
    end
end

%figure;

assignin('base','timeArr',timeArr);
assignin('base','distArr',distArr);
assignin('base','spaceTimePlot',spaceTimePlot);
assignin('base','trueDistArr',true_distance.*distArr);
assignin('base','distanceScale',true_distance);

%data.spaceTime_1D_Data = spaceTimePlot;

close(w);

h3 = figure;
imagesc(spaceTimePlot);
set(gca,'XTick',linspace(0,length(data.ULGData(:,3)),5),'XTickLabel',linspace(0,ULGTime{end,3},5));
set(gca,'YTick',linspace(0,size(spaceTimePlot,1),5),'YTickLabel',linspace(0,distArr(end)*true_distance,5));

end