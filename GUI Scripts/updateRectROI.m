function updateRectROI(source, eventdata, handles)

data = guidata(source);

setPosition(data.rectROI, [str2num(data.rectxPosText.String) str2num(data.rectyPosText.String) str2num(data.rectxResText.String) str2num(data.rectyResText.String)])

RectPos = round(getPosition(data.rectROI));
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