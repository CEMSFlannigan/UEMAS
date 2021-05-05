function frameSetReq_callback(hObject, eventdata, handles)

data = guidata(hObject);

if data.order_callback.Value == 1
    data.curFrame = round(str2num(get(hObject, 'string')));
    set(data.frameSetSlide,'Value',data.curFrame);
    data.curTime = data.ULGData{data.curFrame,3};
elseif data.order_callback.Value == 2
    data.curTime = str2num(get(hObject, 'string')) - mod(str2num(get(hObject, 'string')),data.TimeIncr);
    
    hObject.String = num2str(data.curTime);
    set(data.frameSetSlide,'Value',data.curTime);
    TimeData = cell2mat(data.ULGData(:,3));
    for i = 1:length(TimeData)
        if TimeData(i) == data.curTime && (data.curScan-1) == data.ULGData{i,4}
            data.curFrame = data.ULGData{i,2};
        end
    end
end

guidata(hObject, data);

update_figure(hObject,[], data);

end