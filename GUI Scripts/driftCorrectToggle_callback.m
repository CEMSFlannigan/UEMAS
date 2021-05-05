function driftCorrectToggle_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.driftToggle = hObject.Value;
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end