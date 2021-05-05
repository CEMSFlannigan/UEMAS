function misalLine_callback(source, eventdata, handles)

data = guidata(source);
data.misalLineROI = imline(data.Img_Box);

LinePos = round(getPosition(data.misalLineROI));
setPosition(data.misalLineROI,LinePos);
data.misallinex1Text.String = num2str(round(LinePos(1,1)));
data.misalliney1Text.String = num2str(round(LinePos(1,2)));
data.misallinex2Text.String = num2str(round(LinePos(2,1)));
data.misalliney2Text.String = num2str(round(LinePos(2,2)));

assignin('base','misalign_line',LinePos);

data.misalLineROIx1 = round(LinePos(1,1));
data.misalLineROIx2 = round(LinePos(2,1));
data.misalLineROIy1 = round(LinePos(1,2));
data.misalLineROIy2 = round(LinePos(2,2));

guidata(source, data);

update_figure(source, eventdata, data);

end