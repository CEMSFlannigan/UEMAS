function updateMisalLine(source, eventdata, handles)

data = guidata(source);

setPosition(data.misalLineROI, [str2num(data.misalLineROIx1.String) str2num(data.misalLineROIy1.String); str2num(data.misalLineROIx2.String) str2num(data.misalLineROIy2.String)]);

LinePos = getPosition(data.misallineROI);

data.misallinex1Text.String = num2str(round(LinePos(1,1)));
data.misallinex2Text.String = num2str(round(LinePos(2,1)));
data.misalliney1Text.String = num2str(round(LinePos(1,2)));
data.misalliney2Text.String = num2str(round(LinePos(2,2)));

data.misalLineROIx1 = round(LinePos(1,1));
data.misalLineROIx2 = round(LinePos(2,1));
data.misalLineROIy1 = round(LinePos(1,2));
data.misalLineROIy2 = round(LinePos(2,2));

guidata(source, data);

update_figure(source, eventdata, data);

end