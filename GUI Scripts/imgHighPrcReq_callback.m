function imgHighPrcReq_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.highprc_cutoff = str2num(hObject.String);
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end