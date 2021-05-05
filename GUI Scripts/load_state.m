function load_state(source, eventdata, handles)

data = guidata(source);

[FileName, FilePath] = uigetfile('*.txt','Save file name, overwrites previous data (do not include extension).');
saveName = [FilePath FileName];

saveFile = fopen(saveName);
saveData = textscan(saveFile, '%s','delimiter','\n');
fclose(saveFile);

saveData = saveData{1};

assignin('base','saveData',saveData);

%% establish image editing variables
data.lowprc_cutoff = str2num(saveData{7});
data.highprc_cutoff = str2num(saveData{8});
data.back_first_frame = str2num(saveData{43});
data.back_last_frame = str2num(saveData{44});
data.prcToggle = str2num(saveData{9});
data.degRot = str2num(saveData{10});
data.rotToggle = str2num(saveData{11});
data.driftToggle = str2num(saveData{14});
data.scale = str2num(saveData{25});
data.backToggle = str2num(saveData{27});
data.normToggle = str2num(saveData{31});
% Update toggles and text boxes

%% establish timeline variables
data.curScan = str2num(saveData{1});
data.scanNum = str2num(saveData{2});
data.curTime = str2num(saveData{3});
data.TimeIncr = str2num(saveData{4});
data.frames = str2num(saveData{12});
data.curFrame = str2num(saveData{13});
data.ordered = str2num(saveData{15});
data.num_stitched = str2num(saveData{38});

%% establish file loading data
data.ulgpath = saveData{5};
data.dm3path = saveData{6};
data.FolderPath = saveData{37};
data.drift_correct_path = saveData{41};
data.back_data_path = saveData{42};
data.InSituToggle = str2num(saveData{39});

%% establish ROI variables
data.rectROIx = str2num(saveData{16});
data.rectROIy = str2num(saveData{17});
data.rectROIxRes = str2num(saveData{18});
data.rectROIyRes = str2num(saveData{19});
data.lineROIx1 = str2num(saveData{20});
data.lineROIx2 = str2num(saveData{21});
data.lineROIy1 = str2num(saveData{22});
data.lineROIy2 = str2num(saveData{23});
data.lineWidth = str2num(saveData{24});
data.width = str2num(saveData{26});
data.vToggle = str2num(saveData{28});
data.hToggle = str2num(saveData{29});
data.misalLineToggle = str2num(saveData{32});
data.misalLineROIx1 = str2num(saveData{33});
data.misalLineROIx2 = str2num(saveData{34});
data.misalLineROIy1 = str2num(saveData{35});
data.misalLineROIy2 = str2num(saveData{36});
data.ROIToggle = str2num(saveData{40});
data.degVar = str2num(saveData{30});

%% Processed values, need to store references to GUI objects at initialization and store them in guidat

data.ULGData = readULG(data.ulgpath, data.InSituToggle);
assignin('base','ULGData',data.ULGData);

scanNum = length(unique(cell2mat(data.ULGData(:,4))));
data.scanNum = scanNum;
data.curScan = 1;

for i = 1:scanNum
    scanPopStr{i} = ['Scan ' num2str(i)];
end

data.scanPop.String = scanPopStr;

dm3_files = Load_dm3_File_List(data.dm3path);

if data.ordered == 0
    data.ULGData = sortrows(data.ULGData,7); % used to be 7
    set(data.frameSetSlide,'Value',data.curFrame,'minimum',data.curFrame,'maximum',(data.frames*data.curScan));
    set(data.frameSetSlide, 'MajorTickSpacing',round(data.frames/10), 'PaintLabels',true);
    
    data.curTime = data.ULGData{data.curFrame,3};
elseif data.ordered == 1
    data.ULGData = sortrows(data.ULGData,3);
    
    set(data.frameSetSlide,'minimum',data.ULGData{1,3},'maximum',data.ULGData{end,3});
    set(data.frameSetSlide,'Value',data.curTime);
    set(data.frameSetSlide, 'MajorTickSpacing',round(abs(data.ULGData{end,3} - data.ULGData{1,3})/10), 'PaintLabels',true);
    data.frameSetReq.String = num2str(data.curTime);
end

cur_dm3path = [data.dm3path '\' dm3_files(data.curFrame).name];
cur_dm3Data = DM3Import(cur_dm3path);
cur_img_data = cur_dm3Data.image_data';
data.cur_img_data = cur_img_data;

imagesc(data.Img_Box,data.cur_img_data);
assignin('base','load_img_data',data.cur_img_data);

if (~isempty(data.back_data_path))
    back_dm3 = DM3Import(data.back_data_path);
    data.backData = back_dm3.image_data';
end

if (~isempty(data.drift_correct_path))
    drift_correction = csvread(data.drift_correct_path,1,0,[1,0,data.frames-1,2]);
    drift_correction = [1,0,0;drift_correction];
    data.drift_correct = drift_correction;
    assignin('base','drift_correct',drift_correction);
end

if (data.rectROIx ~= -1)
    data.rectROI = imrect(data.Img_Box,[data.rectROIx, data.rectROIy, data.rectROIxRes, data.rectROIyRes]);
    
    data.rectxPosText.String = num2str(data.rectROIx);
    data.rectyPosText.String = num2str(data.rectROIy);
    data.rectxResText.String = num2str(data.rectROIxRes);
    data.rectyResText.String = num2str(data.rectROIyRes);
end

if (data.lineROIx1 ~= -1)
    data.lineROI = imline(data.Img_Box,[data.lineROIx1 data.lineROIy1; data.lineROIx2, data.lineROIy2]);
    
    data.linex1Text.String = num2str(data.lineROIx1);
    data.linex2Text.String = num2str(data.lineROIx2);
    data.liney1Text.String = num2str(data.lineROIy1);
    data.liney2Text.String = num2str(data.lineROIy2);
end

if (data.misalLineROIx1 ~= -1)
    data.misalLineROI = imline(data.Img_Box, [data.misalLineROIx1 data.misalLineROIy1; data.misalLineROIx2, data.misalLineROIy2]);
    
    data.misallinex1Text.String = num2str(data.misalLineROIx1);
    data.misallinex2Text.String = num2str(data.misalLineROIx2);
    data.misalliney1Text.String = num2str(data.misalLineROIy1);
    data.misalliney2Text.String = num2str(data.misalLineROIy2);
end

%% Flip Toggles

data.inSituButton.Value = data.InSituToggle;
data.driftCorrectButton.Value = data.driftToggle;
data.backgroundButton.Value = data.backToggle;
data.normButton.Value = data.normToggle;
data.percentileButton.Value = data.prcToggle;
data.rotateButton.Value = data.rotToggle;
data.vLineSubButton.Value = data.vToggle;
data.hLineSubButton.Value = data.hToggle;
data.misalLineButton.Value = data.misalLineToggle;

%% Fill Text Boxes

data.setScaleText.String = num2str(data.scale);
data.lprcText.String = num2str(data.lowprc_cutoff);
data.hprcText.String = num2str(data.highprc_cutoff);
data.rotText.String = num2str(data.rotToggle);
data.widthText.String = num2str(data.width);

if (data.degVar ~= -1)
    data.semiText.String = num2str(data.degVar);
end

if data.ordered == 1
    data.frameSetReq.String = num2str(data.curTime);
else
    data.frameSetReq.String = num2str(data.curFrame);
end

%% Set order pulldown value



%data.FolderStitchPaths = saveData{1};
%data.full_path_data = saveData{1};

%% Update background data

if (data.back_first_frame >= 0) && (data.backToggle == 1)
    ULGTime = sortrows(data.ULGData,3);
    numFrames = data.back_last_frame-data.back_first_frame + 1;
    summed_data = 0;
    w = waitbar(0,'Constructing Space and Time');
    for i = data.back_first_frame:data.back_last_frame
        curFile = [ULGTime{i,6} '.dm3'];
        dm3path = [data.dm3path '\' curFile];
        dm3Data = DM3Import(dm3path);
        cur_img_data = dm3Data.image_data';
        
        if ~isempty(data.lowprc_cutoff)
            lowprc = data.lowprc_cutoff;
        else
            lowprc = 1;
        end
        
        if ~isempty(data.highprc_cutoff)
            highprc = data.highprc_cutoff;
        else
            highprc = 99;
        end
        
        if ~isempty(data.degRot) && data.rotToggle == 1
            cur_img_data = imrotate(cur_img_data,data.degRot);
        end
        
        if data.prcToggle == 1
            cur_img_data = RMOuts(cur_img_data,highprc,lowprc);
        end
        
        if data.normToggle == 1
            cur_img_data = (cur_img_data - min(min(cur_img_data)))./(max(max(cur_img_data)) - min(min(cur_img_data)));
        end
        
        summed_data = summed_data + cur_img_data;
        waitbar((i-data.back_first_frame)/(data.back_last_frame-data.back_first_frame));
    end
    close(w);
    data.backData = summed_data./numFrames;
end

guidata(source, data);

update_figure(source, eventdata, data);

end