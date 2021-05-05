function update_figure(source, eventdata, handles)

lowprc = 1;
highprc = 99;
prctoggle = 0;
rottoggle = 0;
rot = 0;
final_img_data = [-2 -1; 0 1]; %placeholder "image"

if ~isempty(handles.rectROI)
    hold on;
    rectROIPos = getPosition(handles.rectROI);
end

if ~isempty(handles.lineROI)
    hold on;
    lineROIPos = getPosition(handles.lineROI);
end

if ~isempty(handles.misalLineROI)
    hold on;
    misalLineROIPos = getPosition(handles.misalLineROI);
end

if handles.ordered == 0
    if handles.frames > 1
        curFrame = handles.curFrame;
        dm3path = [handles.dm3path '\' handles.ULGData{curFrame,6} '.dm3']; % used to be 6
        assignin('base','ULGDataUpdate',handles.ULGData);
        assignin('base','cur_path',dm3path);
        dm3Data = DM3Import(dm3path);
        assignin('base','cur_dm3',dm3Data);
        cur_img_data = dm3Data.image_data';
        final_img_data = cur_img_data;
        
        if handles.driftToggle == 1
            final_img_data = circshift(final_img_data, [handles.drift_correct(curFrame-(handles.curScan-1)*handles.frames, 3), handles.drift_correct(curFrame-(handles.curScan-1)*handles.frames, 2)]);
        end  
    else
        if ~isempty(handles.cur_img_data)
            final_img_data = handles.cur_img_data;
        end
    end
elseif handles.ordered == 1
    if handles.frames > 1
        curFrame = handles.curFrame;
        handles.ULGData = sortrows(handles.ULGData,7);
        dm3path = [handles.dm3path '\' handles.ULGData{curFrame,6} '.dm3'];
        handles.ULGData = sortrows(handles.ULGData,3);
        dm3Data = DM3Import(dm3path);
        cur_img_data = dm3Data.image_data';
        final_img_data = cur_img_data;

        if handles.driftToggle == 1
            final_img_data = circshift(final_img_data, [handles.drift_correct(curFrame, 3), handles.drift_correct(curFrame, 2)]);
        end  
    else
        if ~isempty(handles.cur_img_data)
            final_img_data = handles.cur_img_data;
        end
    end
end

if ~isempty(handles.lowprc_cutoff)
    lowprc = handles.lowprc_cutoff;
else
    lowprc = 1;
end

if ~isempty(handles.highprc_cutoff)
    highprc = handles.highprc_cutoff;
else
    highprc = 99;
end

if ~isempty(handles.degRot) && handles.rotToggle == 1
   final_img_data = imrotate(final_img_data,handles.degRot);
end

if handles.prcToggle == 1
    final_img_data = RMOuts(final_img_data,highprc,lowprc);
end

if handles.normToggle == 1
    final_img_data = (final_img_data - min(min(final_img_data)))./(max(max(final_img_data)) - min(min(final_img_data)));
end

if handles.backToggle == 1
    final_img_data = final_img_data - handles.backData;
end

assignin('base','ImageData',final_img_data);

figure(source.Parent);
imagesc(handles.Img_Box, final_img_data);%, [prctile(final_img_data(:), 1), prctile(final_img_data(:), 99)]);

colormap('gray');

if ~isempty(handles.rectROI)
    hold on;
    imrect(handles.Img_Box,rectROIPos);
end

if ~isempty(handles.lineROI)
    hold on;
    mainLine = imline(handles.Img_Box,lineROIPos);
    setColor(mainLine,'b');
end

if ~isempty(handles.misalLineROI) && ~isempty(handles.misalLineToggle) && handles.misalLineToggle == 1
    hold on;
    misalLine = imline(handles.Img_Box,misalLineROIPos);
    setColor(misalLine,'r');
end

end