function degVarReq_callback(source, eventdata, handles)

data = guidata(source);

if ~isnan(str2num(data.degVarReq.String))
    data.degVar = str2num(data.degVarReq.String);
end

guidata(source, data);

end