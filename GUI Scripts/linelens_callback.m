function linelens_callback(hObject, eventdata, handles)

data = guidata(hObject);

ULGTime = sortrows(data.ULGData,3);

centerLeft = zeros(1,data.frames);
centerRight = zeros(1,data.frames);
widths = zeros(1,data.frames);

timeArr = cell2mat(ULGTime(:,3));

count = 0;

LinePos = getPosition(data.lineROI);
slope = (LinePos(2,2)-LinePos(1,2))/(LinePos(2,1)-LinePos(1,1));
countData = [];
distArr = [];

invslope = -1/slope;
if LinePos(1,1) <= LinePos(2,1)
    xArr = LinePos(1,1):LinePos(2,1);
else
    xArr = fliplr(LinePos(2,1):LinePos(1,1));
end

if LinePos(1,2) <= LinePos(2,2)
    yArr = LinePos(1,2):LinePos(2,2);
else
    yArr = fliplr(LinePos(1,2):LinePos(2,2));
end

if length(xArr) >= length(yArr)
    distArr = zeros(1,length(xArr));
else
    distArr = zeros(1,length(yArr));
end

width = data.width;

w = waitbar(0,'Lensing');
% f = figure;
for i = 1:length(data.ULGData(:,3))
    if ULGTime{i,4} == data.curScan - 1
        count = count + 1;
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
            cur_img_data = circshift(cur_img_data, [data.drift_correct(count, 3), data.drift_correct(count, 2)]);
        end
        
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
                for k = 1:width+1
                    curPosWidth = round(width/2)-width+k-1;
                    xadj = curPosWidth/sqrt(1+invslope^2);
                    yadj = xadj*invslope;
                    
                    xval = round(curx+xadj);
                    yval = round(cury+yadj);
                    
                    curSum = curSum + cur_img_data(yval,xval);
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
                curx = round((cury - LinePos(1,2))./slope + LinePos(1,1));
                distArr(j) = sqrt((curx - LinePos(1,1))^2 + (cury - LinePos(1,2))^2);
                
                curSum = 0;
                for k = 1:width+1
                    curPosWidth = round(width/2)-width+k-1;
                    xadj = curPosWidth/sqrt(1+invslope^2);
                    yadj = xadj*invslope;
                    
                    xval = round(curx+xadj);
                    yval = round(cury+yadj);
                    
                    curSum = curSum + cur_img_data(yval,xval);
                end

                curLineData(j) = curSum/width;
            end
        end
        
        countData = curLineData;
        
        halfway = round(length(countData)/2);
        half1x = distArr(1:halfway);
        half2x = distArr(halfway:end);
        half1Data = countData(1:halfway);
        half2Data = countData(halfway:end);
        
        percntiles = prctile(half1Data,[5 95]); %5st and 95th percentile
        outlierIndex = half1Data < percntiles(1) | half1Data > percntiles(2);
        %remove outlier values
        half1Data(outlierIndex) = [];
        half1x(outlierIndex) = [];
        
        percntiles = prctile(half2Data,[5 95]); %5st and 95th percentile
        outlierIndex = half2Data < percntiles(1) | half2Data > percntiles(2);
        %remove outlier values
        half2Data(outlierIndex) = [];
        half2x(outlierIndex) = [];
        
        half1movmean = half1Data;%movmean(half1Data,10);
        half2movmean = half2Data;%movmean(half2Data,10);
        
        [half1fits, half1func] = fitSigmoidal(half1x,(half1movmean - min(half1movmean)));
        [half2fits, half2func] = fitSigmoidal(half2x,(half2movmean - min(half2movmean)));
        
        %% Plot
        
%         figure(f);
%         
%         plot(distArr,countData);
%         
%         subplot(2,2,1);
%         scatter(half1x,(half1movmean - min(half1movmean)));
% 
%         subplot(2,2,2);
%         scatter(half2x,(half2movmean - min(half2movmean)));
%         
%         subplot(2,2,1);
%         hold on;
%         plot(half1x,half1func(half1fits,half1x));
%         hold off;
%         
%         subplot(2,2,2);
%         hold on;
%         plot(half2x,half2func(half2fits,half2x));
%         hold off;
% 
%         subplot(2,2,3);
%         scatter(half1x,half1movmean);
%         
%         subplot(2,2,4);
%         scatter(half2x,half2movmean);
        
        centerLeft(count) = half1fits(3);
        centerRight(count) = half2fits(3);
        
%         pause(0.01);
    end
    waitbar(i/length(data.ULGData(:,3)));
end

widths = abs(centerRight - centerLeft);
assignin('base','widthData',widths);
assignin('base','timeArrLineLens',timeArr);

[LensBehavior, LensFits, LensFunc] = PlasmaLensingDeconv(timeArr,widths');

assignin('base','LensFits',LensFits);
assignin('base','LensFunc',LensFunc);

figure;
subplot(2,1,1);
plot(timeArr,widths);
hold on;
plot(timeArr, ones(size(timeArr)).*mean(widths));
subplot(2,1,2);
plot(timeArr,(centerRight-min(centerRight)));
hold on;
plot(timeArr,(centerLeft-min(centerLeft)));

close(w);

end