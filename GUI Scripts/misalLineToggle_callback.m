function misalLineToggle_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.misalLineToggle = hObject.Value;
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end