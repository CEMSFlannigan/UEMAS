function [peak_center, gof_array] = Get_Peak_Centers(fit_struct, gof_struct, consts, frames)

% This script is intended to provide the center of a gaussian fit from a
% previously executed code.

% Arguments
%     fit_struct -> the struct of fits
%     gof_struct -> the struct of goodness of the fits
%     consts -> the constants applied to each gaussian (y-shift)
%     frames -> the number of frames

peak_center = zeros(frames,1);

gof_array = zeros(frames,1);

for frame_iter = 1:frames
    
    % Try to find the peak center and gof from the structs
    try
        peak_center(frame_iter) = fit_struct(frame_iter).fit.b1;
        gof_array(frame_iter) = gof_struct(frame_iter).gof.rsquare;
    catch
        fprintf('Could not access values at frame %u.',frame_iter);
    end
    
    % if the gof or the width of the peak are not good, count it as NaN
    if gof_array(frame_iter) < 0.5 || fit_struct(frame_iter).fit.c1 < 5
        peak_center(frame_iter) = NaN;
    end
    
end

orig_pos = 0;

% find the original position of the peak in the first 10 frames
for frame_iter = 1:10
    orig_pos = orig_pos + peak_center(frame_iter);
end
orig_pos = orig_pos/10;

peak_center = peak_center-orig_pos.*ones(size(peak_center));

end