function driftCorrectReq_callback(hObject, eventdata, handles)

data = guidata(hObject);
[FileName,PathName,FilterIndex] = uigetfile(data.FolderPath);
drift_correct_path = [PathName FileName];
data.drift_correct_path = drift_correct_path;

drift_correction = csvread(drift_correct_path,1,0,[1,0,data.frames-1,2]);
drift_correction = [1,0,0;drift_correction];
data.drift_correct = drift_correction;

assignin('base','drift_correct',drift_correction);

guidata(hObject, data);

update_figure(hObject, eventdata, data);

end