function vLineSubtract_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.vToggle = hObject.Value;
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end