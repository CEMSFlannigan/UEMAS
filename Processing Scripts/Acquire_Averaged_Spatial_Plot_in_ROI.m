function [distance, avg_counts] = Acquire_Averaged_Spatial_Plot_in_ROI(img_data,ROI_pos,dir_Avg)

%%% Function dedicated towards rectangular averaging of region of interest
%%% (ROI) in one direction on the rectangle and distance down the other
%%% axis. This is assuming the rectangle is purely square with Cartesian
%%% coordinates. 

%%% Arguments:
%%%     dir_Avg -> 2 is averaging across y, 1 is averaging across x
%%%     ROI_pos -> Input as an array with 4 elements, x, y, width, height
%%%     img_data -> the image data, processed with the proper orientation

% Initialize Average Counts and Distance variables
avg_counts = 0;
distance = 0;

if dir_Avg == 2
    % Size the counting and distance variables
    avg_counts = zeros(1,ROI_pos(3)+1);
    distance = 0:ROI_pos(3);
    for i = ROI_pos(1):ROI_pos(1)+ROI_pos(3)
        % Assign count index
        index = i-ROI_pos(1)+1;
        for j = ROI_pos(2):ROI_pos(2)+ROI_pos(4)
            % Sum at the current index across columns (x)
            avg_counts(index) = avg_counts(index) + img_data(i,j);
            
        end
        % Averaging Step
        avg_counts(index) = avg_counts(index)/ROI_pos(4);
    end
elseif dir_Avg == 1
    % Size the counting and distance variables
    avg_counts = zeros(1,ROI_pos(4)+1);
    distance = 0:ROI_pos(4);
    for i = ROI_pos(2):ROI_pos(2)+ROI_pos(4)
        % Assign count index
        index = i-ROI_pos(2)+1;
        for j = ROI_pos(1):ROI_pos(1)+ROI_pos(3)
            % Sum at the current index across rows (y)
            avg_counts(index) = avg_counts(index) + img_data(i,j);
            
        end
        avg_counts(index) = avg_counts(index)/ROI_pos(3);
    end
else
    disp('Not a valid direction to average across.');
end

end