function hLineSubtract_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.hToggle = hObject.Value;
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end