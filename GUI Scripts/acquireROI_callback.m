function acquireROI_callback(source, eventdata, handles)

data = guidata(source);
data.rectROI = imrect(data.Img_Box);

RectPos = round(getPosition(data.rectROI));
setPosition(data.rectROI,RectPos);

data.rectxPosText.String = num2str(round(RectPos(1)));
data.rectyPosText.String = num2str(round(RectPos(2)));
data.rectxResText.String = num2str(round(RectPos(3)));
data.rectyResText.String = num2str(round(RectPos(4)));

data.rectROIx = round(RectPos(1));
data.rectROIy = round(RectPos(2));
data.rectROIxRes = round(RectPos(3));
data.rectROIyRes = round(RectPos(4));

assignin('base','rectROI',data.rectROI);

guidata(source, data);

update_figure(source, eventdata, data);

end