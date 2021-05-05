function frameSetSlider_callback(hObject, frameSetReq)

data = guidata(frameSetReq);
assignin('base','ULGDataSlider',data.ULGData);

if data.ordered == 0
    data.curFrame = round(get(hObject, 'Value'));
    data.frameSetReq.String = num2str(data.curFrame);
    data.curTime = data.ULGData{data.curFrame,3};
elseif data.ordered == 1
    data.curTime = get(hObject, 'Value') - mod(get(hObject, 'Value'),data.TimeIncr);
    
    set(data.frameSetSlide,'Value',data.curTime);
    data.frameSetReq.String = num2str(data.curTime);
    TimeData = cell2mat(data.ULGData(:,3));
    for i = 1:length(TimeData)
        if TimeData(i) == data.curTime && (data.curScan-1) == data.ULGData{i,4}
            data.curFrame = data.ULGData{i,2};
        end
    end
end

guidata(frameSetReq, data);

update_figure(frameSetReq,[], data);

end