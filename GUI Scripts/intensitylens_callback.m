function intensitylens_callback(hObject, eventdata, handles)

data = guidata(hObject);

ULGTime = sortrows(data.ULGData,3);

timeArr = cell2mat(ULGTime(:,3));

counts = zeros(size(timeArr));

RectPos = getPosition(data.rectROI);

w = waitbar(0,'Lensing');
w1 = figure;
a1 = subplot(121);
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
        
        data_cut = cur_img_data(RectPos(2):RectPos(2) + RectPos(4),RectPos(1):RectPos(1) + RectPos(3));
        
        data_cut = MedFiltImg(data_cut,3);

        imagesc(data_cut,'parent',a1);
        
        counts(i) = sum(sum(data_cut))/size(data_cut,1)/size(data_cut,2);
        
%         pause(0.01);
    end
    waitbar(i/length(data.ULGData(:,3)));
end

assignin('base','intensitylens_counts',counts);
assignin('base','timeArr',timeArr);

figure;
plot(timeArr,counts);

close(w);

end