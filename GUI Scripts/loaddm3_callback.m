function loaddm3_callback(hObject, eventdata, handles)

data = guidata(hObject);
if ~isempty(data.FolderPath)
    [FileName,PathName,FilterIndex] = uigetfile(data.FolderPath);
else
    [FileName,PathName,FilterIndex] = uigetfile();
end
dm3path = [PathName '\' FileName];
dm3Data = DM3Import(dm3path);
img_data = dm3Data.image_data';
data.cur_img_data = img_data;
data.ordered = 1;
data.order_callback.String = 'Time is Sorted';
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end