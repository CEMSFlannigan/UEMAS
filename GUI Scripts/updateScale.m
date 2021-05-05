function updateScale(source, eventdata, handles)

data = guidata(source);

data.scale = str2num(data.setScale.String);

guidata(source, data);

update_figure(source, eventdata, data);

end