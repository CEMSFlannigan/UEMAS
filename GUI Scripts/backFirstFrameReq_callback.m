function backFirstFrameReq_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.back_first_frame = str2num(hObject.String);

if (data.back_first_frame >= 0) && (data.backToggle == 1)
    ULGTime = sortrows(data.ULGData,3);
    numFrames = data.back_last_frame-data.back_first_frame + 1;
    summed_data = 0;
    w = waitbar(0,'Constructing Space and Time');
    for i = data.back_first_frame:data.back_last_frame
        curFile = [ULGTime{i,6} '.dm3'];
        dm3path = [data.dm3path '\' curFile];
        dm3Data = DM3Import(dm3path);
        cur_img_data = dm3Data.image_data';
        
        if ~isempty(data.lowprc_cutoff)
            lowprc = data.lowprc_cutoff;
        else
            lowprc = 1;
        end
        
        if ~isempty(data.highprc_cutoff)
            highprc = data.highprc_cutoff;
        else
            highprc = 99;
        end
        
        if ~isempty(data.degRot) && data.rotToggle == 1
            cur_img_data = imrotate(cur_img_data,data.degRot);
        end
        
        if data.prcToggle == 1
            cur_img_data = RMOuts(cur_img_data,highprc,lowprc);
        end
        
        if data.normToggle == 1
            cur_img_data = (cur_img_data - min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
        end
        
        summed_data = summed_data + cur_img_data;
        waitbar((i-data.back_first_frame)/(data.back_last_frame-data.back_first_frame));
    end
    close(w);
    data.backData = summed_data./numFrames;
end

guidata(hObject, data);

update_figure(hObject, eventdata, data);

end