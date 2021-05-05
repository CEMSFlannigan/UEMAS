function loadulg_callback(hObject, eventdata, handles)

data = guidata(hObject);

[ULGFileName, ULGPathName] = uigetfile('*.ulg','ULG File Query');
data.FolderPath = ULGPathName;
data.ulgpath = [ULGPathName ULGFileName]; %'\' 
data.ULGData = readULG(data.ulgpath, data.InSituToggle);
assignin('base','ULGData',data.ULGData);

scanNum = length(unique(cell2mat(data.ULGData(:,4))));
data.scanNum = scanNum;
data.curScan = 1;

for i = 1:scanNum
    scanPopStr{i} = ['Scan ' num2str(i)];
end

data.scanPop.String = scanPopStr;

for i = 1:length(data.ULGData(:,4)) % used to be 4
    if data.ULGData{i,4} ~= 0 % used to be 4
        data.frames = data.ULGData{i-1,2}; % used to be 2
        break;
    elseif i == length(data.ULGData(:,4)) % used to be 4
        data.frames = length(data.ULGData(:,4));
    end
end

data.dm3path = uigetdir(ULGPathName,'DM3 Path Query');
dm3_files = Load_dm3_File_List(data.dm3path);

if data.ordered == 0
    data.ULGData = sortrows(data.ULGData,7); % used to be 7
    
    data.TimeIncr = abs(data.ULGData{1,3} - data.ULGData{2,3}); % second argument used to be 3
    data.curFrame = 1+data.frames*(data.curScan - 1);
    set(data.frameSetSlide,'Value',data.curFrame,'minimum',data.curFrame,'maximum',(data.frames*data.curScan));
    set(data.frameSetSlide, 'MajorTickSpacing',round(data.frames/10), 'PaintLabels',true);
    
    data.curTime = data.ULGData{data.curFrame,3};
elseif data.ordered == 1
    data.ULGData = sortrows(data.ULGData,3);

    data.curTime = data.ULGData{1,3};
    data.TimeIncr = abs(data.ULGData{1,3} - data.ULGData{2,3});
    set(data.frameSetSlide,'minimum',data.ULGData{1,3},'maximum',data.ULGData{end,3});
    set(data.frameSetSlide,'Value',data.curTime);
    set(data.frameSetSlide, 'MajorTickSpacing',round(abs(data.ULGData{end,3} - data.ULGData{1,3})/10), 'PaintLabels',true);
    data.frameSetReq.String = num2str(data.curTime);
    data.curFrame = data.ULGData{1,2};
end

first_dm3path = [data.dm3path '\' dm3_files(1).name];
first_dm3Data = DM3Import(first_dm3path);
first_img_data = first_dm3Data.image_data';
data.cur_img_data = first_img_data;
assignin('base','load_img_data',data.cur_img_data);

guidata(hObject, data);

update_figure(hObject, eventdata, data);

end