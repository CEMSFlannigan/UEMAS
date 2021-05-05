function backgroundReq_callback(hObject, eventdata, handles)

data = guidata(hObject);
[FileName,PathName,FilterIndex] = uigetfile();%data.FolderPath
background_path = [PathName FileName];
data.back_data_path = background_path;

back_dm3 = DM3Import(background_path);
data.backData = back_dm3.image_data';

guidata(hObject, data);

update_figure(hObject, eventdata, data);

end