function mult_squareSum_Dynamic(hObject, eventdata, handles)

data = guidata(hObject);

ULGTime = sortrows(data.ULGData,3);

timeArr = cell2mat(ULGTime(:,3));

RectPos = getPosition(data.rectROI);

SquareWidth = min([RectPos(3), RectPos(4)]);
numIter = 0;

if (mod(SquareWidth,2) == 0)
    numIter = SquareWidth/2 - 1;
else
    numIter = (SquareWidth-1)/2;
end

SquareArray = cell(1,numIter);
counts = zeros(length(timeArr),numIter);

for i = 1:numIter
    SquareArray{i} = [RectPos(1) + i, RectPos(2) + i, SquareWidth - 2*i, SquareWidth - 2*i];
end

w = waitbar(0,'Summing Intensities');
for i = 1:length(data.ULGData(:,3))
    if ULGTime{i,4} == data.curScan - 1
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
        
        for j = 1:numIter
            curRect = SquareArray{j};
            data_cut = cur_img_data(curRect(2):curRect(2) + curRect(4),curRect(1):curRect(1) + curRect(3));
            counts(i,j) = sum(sum(data_cut))/size(data_cut,1)/size(data_cut,2);
        end
        
%         pause(0.01);
    end
    waitbar(i/length(data.ULGData(:,3)));
end

assignin('base','multiintensitylens_counts',counts);
assignin('base','multiSquareArray',SquareArray);
assignin('base','timeArr',timeArr);

figure;
surf(counts,'EdgeColor','none');

close(w);

end