function updateLineROI(source, eventdata, handles)

data = guidata(source);

setPosition(data.lineROI, [str2num(data.linex1Text.String) str2num(data.liney1Text.String); str2num(data.linex2Text.String) str2num(data.liney2Text.String)]);

if ~isnan(str2num(data.widthText.String))
    data.width = str2num(data.widthText.String);
end

LinePos = getPosition(data.lineROI);

data.linex1Text.String = num2str(round(LinePos(1,1)));
data.liney1Text.String = num2str(round(LinePos(1,2)));
data.linex2Text.String = num2str(round(LinePos(2,1)));
data.liney2Text.String = num2str(round(LinePos(2,2)));

data.lineROIx1 = round(LinePos(1,1));
data.lineROIx2 = round(LinePos(2,1));
data.lineROIy1 = round(LinePos(1,2));
data.lineROIy2 = round(LinePos(2,2));

guidata(source, data);

update_figure(source, eventdata, data);

end