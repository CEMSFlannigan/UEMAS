function inSituActivate_callback(hObject, eventdata, handles)

data = guidata(hObject);
data.InSituToggle = hObject.Value;

%% NOTE: INSITU MODE BECAME STANDARD ON MARCH 19TH, 2019

guidata(hObject, data);

end