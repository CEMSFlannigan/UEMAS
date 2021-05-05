function imgRotReq_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.degRot = str2num(hObject.String);
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end