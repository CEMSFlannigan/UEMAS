function driftCorrectToggle_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.ROIToggle = hObject.Value;
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end