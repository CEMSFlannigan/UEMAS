function saveTime_callback(hObject, eventdata, handles)

data = guidata(hObject);
assignin('base','num_stitched',data.num_stitched);
if data.num_stitched == 1
    %ULGData_circshift = data.ULGData;
    %ULGData_circshift(:,2) = circshift(ULGData_circshift(:,2),1);
    ULGTimeSort = sortrows(data.ULGData,3);% ULGData_circshift,2);%% used to be 3
    assignin('base','ULGTimeSort',ULGTimeSort);
    
    curScan = data.curScan-1;
    
    New_place = strcat(data.dm3path, '\Renamed Images_dm3');
    mkdir(New_place);
    
    w = waitbar(0, 'Copying and reordering files.');
    count = 0;
    
    for i = 1:length(ULGTimeSort(:,6)) % used to be 6
        if curScan == ULGTimeSort{i,4} % used to be 4
            count = count + 1;
            digits = numel(num2str(count));
            addzero = 4-digits;
            azString = '';
            for j = 1:addzero
                azString = [azString '0'];
            end
            curfile = [data.dm3path '\' ULGTimeSort{i,6} '.dm3']; % used to be 6
            newfile = [New_place '\' azString num2str(count) '_' ULGTimeSort{i,6} '.dm3']; % used to be 6
            copyfile(curfile, newfile);
            waitbar(count/data.frames);
        end
    end
    
    close(w);
else
    assignin('base','Full_Path_Data',data.full_path_data);
    DataTimeSort = flipud(sortrows(data.full_path_data,2));
    assignin('base','DataTimeSort',DataTimeSort);
    
    names = cell(1,data.num_stitched);
    
    save_folder_name = '\Stitched';
    
    for i = 1:data.num_stitched
    
        cur_dir = data.dm3path{i};
        idcs   = strfind(cur_dir,'\');
        newdir = cur_dir(1:idcs(end)-1);
        names{i} = newdir(idcs(end-1)+1:idcs(end)-1);
        
        save_folder_name = strcat(save_folder_name,names{i});
    
    end
    
    savedir = cur_dir(1:idcs(end-1)-1);
    
    New_place = strcat(savedir, save_folder_name);
    
    mkdir(New_place);
    
    w = waitbar(0, 'Copying and reordering files.');
    count = 0;
    
    for i = 1:length(DataTimeSort(:,2))
        count = count + 1;
        digits = numel(num2str(count));
        addzero = 4-digits;
        azString = '';
        for j = 1:addzero
            azString = [azString '0'];
        end
        curfile = [DataTimeSort{i,3} '\' DataTimeSort{i,4} '.dm3'];
        newfile = [New_place '\' azString num2str(count) '_' DataTimeSort{i,4} '.dm3'];
        copyfile(curfile, newfile);
        waitbar(count/data.frames);
    end
    close(w);
end

end