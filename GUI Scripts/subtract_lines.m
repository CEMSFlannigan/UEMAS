function subtract_lines(source, eventdata, handles)

data = guidata(source);
orderValue = data.order_callback.Value
if data.order_callback.Value == 1
    
    New_place = strcat(data.dm3path, '\Images_dm3 Lines');
    mkdir(New_place);
    
    w = waitbar(0, 'Subtracting backgrounds and making new files.');
    
    for i = 1:data.frames
        dm3path = [data.dm3path '\' data.ULGData{i,6} '.dm3'];
        rewrite_path  = [New_place '\' data.ULGData{i,6} '.tiff'];
        dm3Data = DM3Import(dm3path);
        cur_img_data = dm3Data.image_data';
        
        if data.driftToggle == 1
            cur_img_data = circshift(cur_img_data, [data.drift_correct(curFrame-(data.curScan-1)*data.frames, 3), data.drift_correct(curFrame-(data.curScan-1)*data.frames, 2)]);
        end
        
        cur_img_data = RMOuts(cur_img_data);
        
        [line_means,background_img] = line_background(cur_img_data);
        
        cur_img_data = cur_img_data - background_img;
        imwrite(cur_img_data,rewrite_path);
        waitbar(i/data.frames);
    end

elseif data.order_callback.Value == 2
    ULGTimeSort = sortrows(data.ULGData,3);
    assignin('base','ULGTimeSort',ULGTimeSort);
    
    New_place = strcat(data.dm3path, '\Renamed Images_dm3 Lines');
    mkdir(New_place);
    figsub = figure;
    a1 = subplot(121);
    a2 = subplot(122);
    
    w = waitbar(0, 'Subtracting backgrounds and making new files.');
    
    for i = 1:data.frames
        dm3path = [data.dm3path '\' ULGTimeSort{i,6} '.dm3'];
        
        digits = numel(num2str(i));
        addzero = 4-digits;
        azString = '';
        for j = 1:addzero
            azString = [azString '0'];
        end
        rewrite_path = [New_place '\' azString num2str(i) '_' ULGTimeSort{i,6} '.tiff'];
        
        dm3Data = DM3Import(dm3path);
        cur_img_data = dm3Data.image_data';
        
        if data.driftToggle == 1
            cur_img_data = circshift(cur_img_data, [data.drift_correct(curFrame, 3), data.drift_correct(curFrame, 2)]);
        end
        
        cur_img_data = RMOuts(cur_img_data);
        
        [line_means,background_img] = line_background(cur_img_data);
        imagesc(cur_img_data,'parent',a1);
        %imagesc(background_img,'parent',a1);
        
        cur_img_data = cur_img_data - background_img;
        imagesc(cur_img_data,'parent',a2);
        imwrite(cur_img_data,rewrite_path);
        waitbar(i/data.frames);
    end

end

%% Send data back

guidata(source, data);

update_figure(source, eventdata, data);

end