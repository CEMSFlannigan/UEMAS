function orderApply_callback(hObject, eventdata, handles)

data = guidata(hObject);

disp("Order Apply Callback");

if hObject.Value == 1
    data.ordered = 0;
    data.ULGData = sortrows(data.ULGData,7);
    set(data.frameSetSlide,'minimum',1,'maximum',data.frames);
    set(data.frameSetSlide,'Value',data.curFrame);
    set(data.frameSetSlide, 'MajorTickSpacing',round(data.frames/10), 'PaintLabels',true);
    data.frameSetReq.String = num2str(data.curFrame);
elseif hObject.Value == 2
    data.ordered = 1;
    data.ULGData = sortrows(data.ULGData,3);
    set(data.frameSetSlide,'minimum',data.ULGData{1,3},'maximum',data.ULGData{end,3});
    set(data.frameSetSlide,'Value',data.curTime);
    set(data.frameSetSlide, 'MajorTickSpacing',round(abs(data.ULGData{end,3} - data.ULGData{1,3})/10), 'PaintLabels',true);
    data.frameSetReq.String = num2str(data.curTime);
else
    data.ordered = 0;
    data.ULGData = sortrows(data.ULGData,7);
    set(data.frameSetSlide,'Value',data.curFrame,'minimum',1,'maximum',data.frames);
    set(data.frameSetSlide, 'MajorTickSpacing',round(data.frames/10), 'PaintLabels',true);
    data.frameSetReq.String = num2str(data.curFrame);
end

guidata(hObject, data);

update_figure(hObject, eventdata, data);

end