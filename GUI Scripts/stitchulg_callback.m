function loadulg_callback(hObject, eventdata, handles)

data = guidata(hObject);

num_ulg = inputdlg('Please input the number of scans to stitch:');

num_ulg = str2num(num_ulg{1});

data.num_stitched = num_ulg;

data.frames = 0;

FolderPaths = cell(1,num_ulg);
ulgPaths = cell(1,num_ulg);
ULGDataSet = cell(1,num_ulg);
dm3paths = cell(1,num_ulg);
dm3_files = cell(1,num_ulg);

for cur_ulg_val = 1:num_ulg
    
    [ULGFileName, ULGPathName] = uigetfile('ULG File Query');
    FolderPaths{cur_ulg_val} = ULGPathName;
    ulgPaths{cur_ulg_val} = [ULGPathName '\' ULGFileName];
    ULGDataSet{cur_ulg_val} = readULG(ulgPaths{cur_ulg_val});
    curULGData = ULGDataSet{cur_ulg_val};
    curULGDataString = ['ULGData',num2str(cur_ulg_val)];
    
    assignin('base',curULGDataString,curULGData);
    
    for i = 1:length(curULGData(:,4))
        if curULGData{i,4} ~= 0
            data.frames = curULGData{i-1,2};
            break;
        elseif i == length(curULGData(:,4))
            data.frames = data.frames + length(curULGData(:,4));
        end
    end
    
    QueryMessage = ['DM3 Path Query for Scan ', num2str(cur_ulg_val)];
    dm3paths{cur_ulg_val} = uigetdir(ULGPathName,QueryMessage);
    dm3_files{cur_ulg_val} = Load_dm3_File_List(dm3paths{cur_ulg_val});
    %% FIX THIS PORTION LATER
%     if data.order_callback.Value == 1 && cur_ulg_val == 1
%         curULGData = sortrows(curULGData,7);
%         
%         data.TimeIncr = abs(curULGData{1,3} - curULGData{2,3});
%         data.curFrame = 1;
%         
%         data.curTime = curULGData{data.curFrame,3};
%     elseif data.order_callback.Value == 2 && cur_ulg_val == 1
%         curULGData = sortrows(curULGData,3);
%         
%         data.curTime = curULGData{1,3};
%         data.TimeIncr = abs(curULGData{1,3} - curULGData{2,3});
%         data.frameSetReq.String = num2str(data.curTime);
%         data.curFrame = curULGData{1,2};
%     end
    
    cur_paths = [];
    
    for k = 1:length(curULGData(:,2))
        curpath = string([dm3paths{cur_ulg_val}]);
        cur_paths = [cur_paths; curpath];
    end
    
    add_path_data = [string(curULGData(:,2)), string(curULGData(:,3)), cur_paths, string(curULGData(:,6))];
    
    data.full_path_data = [data.full_path_data; add_path_data];

end

% if data.order_callback.Value == 1
%     set(data.frameSetSlide,'Value',data.curFrame,'minimum',data.curFrame,'maximum',(data.frames*data.curScan));
%     set(data.frameSetSlide, 'MajorTickSpacing',round(data.frames/10), 'PaintLabels',true);
% elseif data.order_callback.Value == 2
%     set(data.frameSetSlide,'minimum',data.ULGData{1,3},'maximum',data.ULGData{end,3});
%     set(data.frameSetSlide,'Value',data.curTime);
%     set(data.frameSetSlide, 'MajorTickSpacing',round(abs(data.ULGData{end,3} - data.ULGData{1,3})/10), 'PaintLabels',true);
% end

data.FolderPath = FolderPaths;
data.ulgpath = ulgPaths;
data.ULGData = ULGDataSet;
data.dm3path = dm3paths;

% first_dm3path = [data.dm3path '\' dm3_files(1).name];
% first_dm3Data = DM3Import(first_dm3path);
% first_img_data = first_dm3Data.image_data';
% data.cur_img_data = first_img_data;
% assignin('base','load_img_data',data.cur_img_data);

guidata(hObject, data);
% 
% update_figure(hObject, eventdata, data);

end