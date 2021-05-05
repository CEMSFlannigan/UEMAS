function acquireROI_callback(source, eventdata, handles)

data = guidata(source);
data.lineROI = imline(data.Img_Box);

LinePos = round(getPosition(data.lineROI));
setPosition(data.lineROI,LinePos);

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