function [fit_struct, gof_struct, consts, frames] = Bulk_Fit_Average_Data(avg_data, approx_center_peak, approx_width_peak)

%%% This function fits a single gaussian to a set of average data taken
%%% over many frames within a region of interest. The average data has
%%% already been acquired before.

% Getting the number of frames
frames = avg_data(end).frame;

% Initializing the return variables
fit_struct = struct('fit',[]);
gof_struct = struct('gof',[]);
consts = zeros(frames,1);

% Iterating through each frame and fitting each plot
for frame_iter = 1:frames
    
    % Getting the data at the current frame
    cur_distance = avg_data(frame_iter).distance;
    cur_avg_data = avg_data(frame_iter).average;
    
    % Try to fit. If could not, notify the user on that frame.
    try
        [fit_struct(frame_iter).fit, gof_struct(frame_iter).gof, consts(frame_iter)] = Fit_Average_Data(cur_distance,cur_avg_data, approx_center_peak, approx_width_peak);
        plot(fit_struct(frame_iter).fit,cur_distance,cur_avg_data-consts(frame_iter).*ones(size(cur_avg_data)));
        title(frame_iter);
        pause(0.05)
    catch
        fprintf('Could not fit %u.', frame_iter);
    end
    
end

end