function [frames, avg_data] = Batch_Average_in_ROI(file_list, file_path, ROI, dir_avg, rot_deg, drift_correct_file_path)

%%% This function is intended to find the averages in an entire batch of
%%% images that undergo specific operations denoted by rotation and drift
%%% correction. The region of averaging is found by ROI and the direction
%%% of averaging is given.

%%% Arguments
%%%     file_list -> the list of .dm3 files in a character array
%%%     file_path -> the file paths of the .dm3 files.
%%%     ROI -> the region of interest given in an array of [x, y, w, h]
%%%     dir_avg -> the direction of averaging (x = 1, y = 2)
%%%     rot_deg -> the degree of rotation counterclockwise
%%%     drift_correction_file_path -> the path directly to the drift
%%%         correction data

% Initializing return variables
frames = size(file_list,1);
avg_data = struct('frame',[],'distance',[],'average',[]);

% Acquiring the drift correction data
drift_correction = csvread(drift_correct_file_path,1,1,[1,1,frames-1,3]);
drift_correction = [1,0,0;drift_correction];

for frame_iter = 1:frames
    
    % Acquiring the image data
    cur_dm3_name = file_list(frame_iter).name;
    cur_dm3_name = cur_dm3_name(1:end-4);
    cur_dm3_path = [file_path '\' cur_dm3_name];
    cur_dm3_data = DM3Import(cur_dm3_path);
    cur_img_data = cur_dm3_data.image_data';
    
    % Correcting for drift
    cur_drift_corr = drift_correction(frame_iter,2:3);
    cur_img_data_drift_corr = Drift_Correct(cur_img_data,cur_drift_corr);
    
    % Performing image rotations
    cur_img_data_final = imrotate(cur_img_data_drift_corr,rot_deg);
    
    % Acquiring the averages
    [cur_distance, cur_avg] = Acquire_Averaged_Spatial_Plot_in_ROI(cur_img_data_final,ROI,dir_avg);
    
    % Assigning return variable data
    avg_data(frame_iter).frame = frame_iter;
    avg_data(frame_iter).distance = cur_distance;
    avg_data(frame_iter).average = cur_avg;
    
    waitbar(frame_iter/frames);
    
end

end