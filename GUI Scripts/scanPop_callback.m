function scanPop_callback(hObject, eventdata, handles)

data = guidata(hObject);

data.curScan = hObject.Value;

if data.order_callback.Value == 1
    data.curFrame = data.curFrame+data.frames*(data.curScan - 1);
    set(data.frameSetSlide,'Value',data.curFrame,'minimum',1+data.frames*(data.curScan - 1),'maximum',data.frames*data.curScan);
    set(data.frameSetSlide, 'MajorTickSpacing',round(data.frames/10), 'PaintLabels',true);
    
    data.curTime = data.ULGData{data.curFrame,3};
elseif data.order_callback.Value == 2
    TimeData = cell2mat(data.ULGData(:,3));
    for i = 1:length(TimeData)
        if TimeData(i) == data.curTime && (data.curScan-1) == data.ULGData{i,4}
            data.curFrame = data.ULGData{i,2};
        end
    end
end

guidata(hObject, data);

update_figure(hObject, eventdata, data);

end