function spacetime_1D_callback(hObject, eventdata, handles)

data = guidata(hObject);

width = data.width; % pixel width
pixel_scale = data.scale; % px/nm .4701236

if ~isempty(data.ULGData)
    ULGTime = sortrows(data.ULGData,3);
    
    timeArr = cell2mat(ULGTime(:,3));
end
degVar = data.degVar;
assignin('base','degVar',degVar);

LinePos = getPosition(data.lineROI);

lengthLine = sqrt((LinePos(2,2) - LinePos(1,2))^2 + (LinePos(2,1) - LinePos(1,1))^2);
centerx = (LinePos(2,1) - LinePos(1,1))/2 + LinePos(1,1);
centery = (LinePos(2,2) - LinePos(1,2))/2 + LinePos(1,2);
gam = atand((LinePos(2,2) - LinePos(1,2))/(LinePos(2,1) - LinePos(1,1)));

spaceTimePlots = cell(1,degVar*2+1);
lines = cell(1,degVar*2+1); % [x3 y3 x4 y4] per cell
slopes = zeros(1,degVar*2+1);
invslopes = zeros(1,degVar*2+1);
xArrs = cell(1,degVar*2+1);
yArrs = cell(1,degVar*2+1);
distArrs = cell(1,degVar*2+1);
point_distances = zeros(1,degVar*2+1);
true_distances = zeros(1,degVar*2+1);

misalLineSlope = 0;
misalLinePos = 0;

% Calculate misaligned line width slopes
if ~isempty(data.misalLineROI) && ~isempty(data.misalLineToggle) && data.misalLineToggle == 1
    misalLinePos = getPosition(data.misalLineROI);
    misalLineSlope = (misalLinePos(2,2) - misalLinePos(1,2))./(misalLinePos(2,1) - misalLinePos(1,1));
end

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
        spaceTimePlots{alph+degVar+1} = zeros(length(xArrs{alph+degVar+1}),length(timeArr));
        distArrs{alph+degVar+1} = 0:length(xArrs{alph+degVar+1});
        point_distances(alph+degVar+1) = sqrt(1 + abs(slopes(alph+degVar+1)));
        true_distances(alph+degVar+1) = point_distances(alph+degVar+1)/pixel_scale;
    else
        spaceTimePlots{alph+degVar+1} = zeros(length(yArrs{alph+degVar+1}),length(timeArr));
        distArrs{alph+degVar+1} = 0:length(yArrs{alph+degVar+1});
        point_distances(alph+degVar+1) = sqrt(1 + abs(invslopes(alph+degVar+1)));
        true_distances(alph+degVar+1) = point_distances(alph+degVar+1)/pixel_scale;
    end
end

if ~isempty(data.ULGData)
    w = waitbar(0,'Constructing Space and Time');
    for i = 1:length(data.ULGData(:,3))
        
        curFile = [ULGTime{i,6} '.dm3'];
        dm3path = [data.dm3path '\' curFile];
        assignin('base','dm3path',dm3path);
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
        %
        %     assignin('base','cur_img_data',cur_img_data);
        
        %     set(0, 'CurrentFigure', h1);
        %     imagesc(cur_img_data);
        %
        %%
        
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
        
        w2 = waitbar(0,'Cycle Lines');
        for alph = -1*degVar:degVar
            curLine = lines{alph+degVar+1};
            
            x3 = curLine(1);
            y3 = curLine(2);
            x4 = curLine(3);
            y4 = curLine(4);
            
            slope = slopes(alph+degVar+1);
            invslope = invslopes(alph+degVar+1);
            
            if x3 <= x4
                xArr = xArrs{alph+degVar+1};
            else
                xArr = xArrs{alph+degVar+1};
            end
            
            if y3 <= y4
                yArr = yArrs{alph+degVar+1};
            else
                yArr = yArrs{alph+degVar+1};
            end
            
            spaceTimePlot = spaceTimePlots{alph+degVar+1};
            distArr = distArrs{alph+degVar+1};
            
            if length(xArr) >= length(yArr)
                if x3 <= x4
                    curLineData = zeros(1,x4 - x3);
                else
                    curLineData = zeros(1,x3 - x4);
                end
                
                for j = 1:length(xArr)
                    curx = xArr(j);
                    cury = slope*(curx - x3) + y3;
                    distArr(j) = sqrt((curx - x3)^2 + (cury - y3)^2);
                    
                    curSum = 0;
                    for k = 1:width+1
                        curPosWidth = round(width/2)-width+k-1;
                        if data.misalLineToggle == 1
                            xadj = curPosWidth/sqrt(1+misalLineSlope^2);
                            if ~isinf(misalLineSlope)
                                yadj = xadj*misalLineSlope;
                            else
                                yadj = -1*round(width/2) + k - 1;
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
                        
                        if 1 == 0 %(xval ~= floor(xval) && xval ~= ceil(yval)) || (yval ~= floor(yval) && yval ~= ceil(yval))
                            d1 = sqrt((xval - floor(xval))^2 + (yval - floor(yval))^2);
                            d2 = sqrt((xval - ceil(xval))^2 + (yval - floor(yval))^2);
                            d3 = sqrt((xval - floor(xval))^2 + (yval - ceil(yval))^2);
                            d4 = sqrt((xval - ceil(xval))^2 + (yval - ceil(yval))^2);
                            
                            dtot = d1 + d2 + d3 + d4;
                            
                            d1val = (1-d1/dtot)*cur_img_data(floor(yval),floor(xval));
                            d2val = (1-d2/dtot)*cur_img_data(floor(yval),ceil(xval));
                            d3val = (1-d3/dtot)*cur_img_data(ceil(yval),floor(xval));
                            d4val = (1-d4/dtot)*cur_img_data(ceil(yval),ceil(xval));
                            
                            curval_interp = d1val+d2val+d3val+d4val;
                            
                            curSum = curSum + curval_interp;
                        else
                            curSum = curSum + cur_img_data(round(yval),round(xval));
                        end
                    end
                    
                    curLineData(j) = curSum;%/width;
                end
                
                if x3 > x4
                    curLineData = fliplr(curLineData);
                end
            else
                if y3 <= y4
                    curLineData = zeros(1,y4 - y3);
                else
                    curLineData = zeros(1,y3 - y4);
                end
                
                for j = 1:length(yArr)
                    cury = yArr(j);
                    curx = (cury - y3)/slope + x3;
                    distArr(j) = sqrt((curx - x3)^2 + (cury - y3)^2);
                    
                    curSum = 0;
                    for k = 1:width+1
                        curPosWidth = round(width/2)-width+k-1;
                        if data.misalLineToggle == 1
                            xadj = curPosWidth/sqrt(1+misalLineSlope^2);
                            if ~isinf(misalLineSlope)
                                yadj = xadj*misalLineSlope;
                            else
                                yadj = -1*round(width/2) + k - 1;
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
                        
                        if 1 == 0 %(xval ~= floor(xval) && xval ~= ceil(yval)) || (yval ~= floor(yval) && yval ~= ceil(yval))
                            d1 = sqrt((xval - floor(xval))^2 + (yval - floor(yval))^2);
                            d2 = sqrt((xval - ceil(xval))^2 + (yval - floor(yval))^2);
                            d3 = sqrt((xval - floor(xval))^2 + (yval - ceil(yval))^2);
                            d4 = sqrt((xval - ceil(xval))^2 + (yval - ceil(yval))^2);
                            
                            dtot = d1 + d2 + d3 + d4;
                            
                            d1val = (1-d1/dtot)*cur_img_data(floor(yval),floor(xval));
                            d2val = (1-d2/dtot)*cur_img_data(floor(yval),ceil(xval));
                            d3val = (1-d3/dtot)*cur_img_data(ceil(yval),floor(xval));
                            d4val = (1-d4/dtot)*cur_img_data(ceil(yval),ceil(xval));
                            
                            curval_interp = d1val+d2val+d3val+d4val;
                            
                            curSum = curSum + curval_interp;
                        else
                            curSum = curSum + cur_img_data(round(yval),round(xval));
                        end
                    end
                    
                    curLineData(j) = curSum;%/width;
                end
                
                if y3 > y4
                    curLineData = fliplr(curLineData);
                end
                
            end
            if data.vToggle == 1
                spaceTimePlot(:,i) = curLineData - mean(curLineData);
            else
                spaceTimePlot(:,i) = curLineData;
            end
            spaceTimePlots{alph+degVar+1} = spaceTimePlot;
            waitbar((alph+degVar+1)/(degVar*2+1));
        end
        close(w2);
        
        waitbar(i/length(data.ULGData(:,3)));
    end
end
close(w);

h1 = figure;
h2 = figure;
squareSlots = round(sqrt(degVar*2))+1;

for alph = -1*degVar:degVar
    curLine = lines{alph+degVar+1};
    
    x3 = curLine(1);
    y3 = curLine(2);
    x4 = curLine(3);
    y4 = curLine(4);
    
    spaceTimePlot = spaceTimePlots{alph+degVar+1};
    
    %h1 = figure;
    %h2 = figure;
    
    sizeSpaceTime = size(spaceTimePlot);
    if data.hToggle == 1
        for i = 1:sizeSpaceTime(1)
            spaceTimePlot(i,:) = spaceTimePlot(i,:) - mean(spaceTimePlot(i,:));
        end
    end
    
    high = prctile(spaceTimePlot(:), 99);
    low = prctile(spaceTimePlot(:), 1);
    
    Outs = spaceTimePlot > high;
    Outs2 = spaceTimePlot < low;
    
    Meds = medfilt2(spaceTimePlot);
    
    spaceTimePlot(Outs) = Meds(Outs);
    spaceTimePlot(Outs2) = Meds(Outs2);
    
    spaceTimePlots{alph+degVar+1} = spaceTimePlot;
    
    %figure;
    
    %data.spaceTime_1D_Data = spaceTimePlot;
    
    figure(h1);
    hold on;
    plot([x3, x4], [y3, y4]);
    pbaspect([1 1 1])
    hold off;
    
    figure(h2);
    subplot(squareSlots,squareSlots,alph+degVar+1);
    imagesc(spaceTimePlot);
    title(alph);
end

figure(h1);
set(gca,'Ydir','reverse');

assignin('base','lines',lines);
assignin('base','timeArrs',timeArr);
assignin('base','distArrs',distArrs);
assignin('base','spaceTimePlots',spaceTimePlots);
assignin('base','distanceScale',true_distances);

end