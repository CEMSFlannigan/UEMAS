% function designed to find perpindicular to a certain band of finite
% thickness

curData = ImageData; %INSERT HERE
curData = RMOuts(curData,1e-3,0);
curData = (curData - ones(size(curData)).*min(min(curData)))./(max(max(curData)) - min(min(curData)));
h4 = figure;
set(gcf,'Position',[0 0 1000 1000]);
imagesc(curData);
pbaspect([1 1 1]);
colormap('gray');
init_Line = imline();

init_LinePos = round(getPosition(init_Line));
setPosition(init_Line,init_LinePos);

%% Adapted from var_dir_callback (need to add linesum information later)

width = 100; % pixel width
pixel_scale = 158.9094; % nm/px .4701236

degVar = 10;

lengthLine = sqrt((init_LinePos(2,2) - init_LinePos(1,2))^2 + (init_LinePos(2,1) - init_LinePos(1,1))^2);
centerx = (init_LinePos(2,1) - init_LinePos(1,1))/2 + init_LinePos(1,1);
centery = (init_LinePos(2,2) - init_LinePos(1,2))/2 + init_LinePos(1,2);
gam = atand((init_LinePos(2,2) - init_LinePos(1,2))/(init_LinePos(2,1) - init_LinePos(1,1)));

spaceTimePlots = cell(1,degVar*2+1);
lines = cell(1,degVar*2+1); % [x3 y3 x4 y4] per cell
invlines = cell(1,degVar*2+1);
slopes = zeros(1,degVar*2+1);
invslopes = zeros(1,degVar*2+1);
xArrs = cell(1,degVar*2+1);
yArrs = cell(1,degVar*2+1);
distArrs = cell(1,degVar*2+1);
point_distances = zeros(1,degVar*2+1);
true_distances = zeros(1,degVar*2+1);

for alph = -1*degVar:degVar
    x3 = round(centerx - lengthLine/2*cosd(gam + alph));
    y3 = round(centery - lengthLine/2*sind(gam + alph));
    
    dx = x3 - init_LinePos(1,1);
    dy = y3 - init_LinePos(1,2);
    
    x4 = init_LinePos(2,1) - dx;
    y4 = init_LinePos(2,2) - dy;
    lines{alph+degVar+1} = [x3 y3 x4 y4];
    
    slopes(alph+degVar+1) = (y4 - y3)/(x4 - x3);
    invslopes(alph+degVar+1) = -1/slopes(alph+degVar+1);
    
    if isinf(invslopes(alph+degVar+1))
        invlines{alph+degVar+1} = [x3 y3 x4 y3];
    else
        invy4 = ((x4-x3)*invslopes(alph+degVar+1)+y3)
        invlines{alph+degVar+1} = [x3 y3 x4 invy4];
    end
    
    if alph == 0
        center_inv = imline(gca, [x3 y3;x4 y4]);
    end
    
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
        lineSums{alph+degVar+1} = zeros(length(xArrs{alph+degVar+1}),1);
        distArrs{alph+degVar+1} = 0:length(xArrs{alph+degVar+1})-1;
        point_distances(alph+degVar+1) = sqrt(1 + abs(slopes(alph+degVar+1)));
        true_distances(alph+degVar+1) = point_distances(alph+degVar+1)/pixel_scale;
    else
        lineSums{alph+degVar+1} = zeros(length(yArrs{alph+degVar+1}),1);
        distArrs{alph+degVar+1} = 0:length(yArrs{alph+degVar+1})-1;
        point_distances(alph+degVar+1) = sqrt(1 + abs(invslopes(alph+degVar+1)));
        true_distances(alph+degVar+1) = point_distances(alph+degVar+1)/pixel_scale;
    end
end

% if data.backToggle == 1
%     cur_img_data = cur_img_data - data.backData;
% end
% 
% if data.driftToggle == 1
%     cur_img_data = circshift(cur_img_data, [data.drift_correct(i, 3), data.drift_correct(i, 2)]);
% end
% 
% if ~isempty(data.degRot) && data.rotToggle == 1
%     cur_img_data = imrotate(cur_img_data,data.degRot);
% end

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
                xadj = curPosWidth/sqrt(1+invslope^2);
                if ~isinf(invslope)
                    yadj = xadj*invslope;
                else
                    yadj = -1*round(width/2) + k - 1;
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
                    curSum = curSum + curData(round(yval),round(xval));
                end
            end
            
            curLineData(j) = curSum/width;
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
                xadj = curPosWidth/sqrt(1+invslope^2);
                if ~isinf(invslope)
                    yadj = xadj*invslope;
                else
                    yadj = -1*round(width/2) + k - 1;
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
                    curSum = curSum + curData(round(yval),round(xval));
                end
            end
            
            curLineData(j) = curSum/width;
        end
        
        if y3 > y4
            curLineData = fliplr(curLineData);
        end
        
    end
    
    lineSums{alph+degVar+1} = curLineData;
    waitbar((alph+degVar+1)/(degVar*2+1));
end
close(w2);

squareSlots = round(sqrt(degVar*2))+1;
h2 = figure;

num_max_vals = zeros(1,degVar*2+1);
ave_max_distances = zeros(1,degVar*2+1);
ave_min_distances = zeros(1,degVar*2+1);
periodicity_score = zeros(1,degVar*2+1);
ave_mag = zeros(1,degVar*2+1);
amp = zeros(1,degVar*2+1);
centers = zeros(1,degVar*2+1);
width = zeros(1,degVar*2+1);
yshift = zeros(1,degVar*2+1);

for alph = -1*degVar:degVar
    curLine = lines{alph+degVar+1};
    curInvLine = invlines{alph+degVar+1};
    curDistArr = distArrs{alph+degVar+1};
    
    x1 = curLine(1);
    y1 = curLine(2);
    x2 = curLine(3);
    y2 = curLine(4);
    
    x3 = curInvLine(1);
    y3 = curInvLine(2);
    x4 = curInvLine(3);
    y4 = curInvLine(4);
    
    lineSum = lineSums{alph+degVar+1};
    
    lower = [-Inf, 1, curDistArr(round(length(curDistArr)/3)), -Inf];
    upper = [+Inf, curDistArr(end) - curDistArr(1), curDistArr(length(curDistArr) - round(length(curDistArr)/3)), +Inf];
    x0 = [1,10,(x2+x1)/2,0];
    
    [f, resSq, res] = lsqcurvefit(@Lorentzian,x0,curDistArr',lineSum',lower,upper);
    
    pause(0.001);
    amp(alph+degVar+1) = f(1);
    centers(alph+degVar+1) = f(3);
    width(alph+degVar+1) = f(2);
    yshift(alph+degVar+1) = f(4);
    
%     [min_indexes, max_indexes] = findExtrema(curDistArr,lineSum);
%     num_max_vals(alph+degVar+1) = length(max_indexes);
%     
%     for k = 1:length(max_indexes)-1
%         ave_max_distances(alph+degVar+1) = ave_max_distances(alph+degVar+1) + curDistArr(max_indexes(k+1)) - curDistArr(max_indexes(k));
%     end
%     
%     for k = 1:length(min_indexes)-1
%         ave_min_distances(alph+degVar+1) = ave_min_distances(alph+degVar+1) + curDistArr(min_indexes(k+1)) - curDistArr(min_indexes(k));
%     end
%     ave_max_distances(alph+degVar+1) = ave_max_distances(alph+degVar+1)/length(max_indexes);
%     ave_min_distances(alph+degVar+1) = ave_min_distances(alph+degVar+1)/length(min_indexes);
%     periodicity_score(alph+degVar+1) = sum(diff(curDistArr(max_indexes)) - ones(1,length(max_indexes)-1).*ave_max_distances(alph+degVar+1))/length(max_indexes) + sum(diff(curDistArr(min_indexes)) - ones(1,length(min_indexes)-1).*ave_min_distances(alph+degVar+1))/length(min_indexes);
%     
%     ave_mag(alph+degVar+1) = sum(lineSum(max_indexes))/length(max_indexes) - sum(lineSum(min_indexes))/length(min_indexes);
%     
%     periodicity_score(alph+degVar+1) = abs(periodicity_score(alph+degVar+1)/ave_mag(alph+degVar+1));
%     if length(max_indexes) == 1 || length(min_indexes) == 1
%         periodicity_score(alph+degVar+1) = 1e100;
%     end
    
    figure(h4);
    setPosition(init_Line,[x1 y1; x2 y2]);
    setPosition(center_inv,[x3 y3; x4 y4]);
    
    figure(h2);
    subplot(squareSlots,squareSlots,alph+degVar+1);
    plot(curDistArr,lineSum);
    hold on;
    plot(curDistArr,lineSum); % + res'
    scatter(curDistArr(min_indexes), lineSum(min_indexes));
    scatter(curDistArr(max_indexes), lineSum(max_indexes));
    hold off;
    title(width(alph+degVar+1)); %periodicity_score(alph+degVar+1)
end

%max_val = max(num_max_vals);

%[max_lines_row max_lines_col] = find(num_max_vals == max_val);

%[min_ave min_ave_i] = min(ave_distances(max_lines_col));

[best_periodicity, perp_line_i] = min(width);%max_lines_col(min_ave_i);periodicity_score
perp_line = lines{perp_line_i};
inv_perp_line = invlines{perp_line_i};

finDistArr = distArrs{perp_line_i}*true_distances(perp_line_i);
finLineSum = lineSums{perp_line_i};

% [min_indexes, max_indexes] = findExtrema(finDistArr,finLineSum);
% 
% figure(h4);
% setPosition(init_Line,[perp_line(1:2);perp_line(3:4)]);
% setPosition(center_inv,[inv_perp_line(1:2);inv_perp_line(3:4)]);
% 
% h5 = figure;
% plot(finDistArr,finLineSum);
% hold on;
% scatter(finDistArr(max_indexes),finLineSum(max_indexes));
% scatter(finDistArr(min_indexes),finLineSum(min_indexes));
% hold off;
% title(best_periodicity);