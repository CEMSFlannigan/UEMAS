function percentileToggle_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.prcToggle = hObject.Value;
if isempty(data.lowprc_cutoff)
    data.lowprc_cutoff = 1;
end
if isempty(data.highprc_cutoff)
    data.highprc_cutoff = 99;
end
guidata(hObject, data);

update_figure(hObject, eventdata, data);

end