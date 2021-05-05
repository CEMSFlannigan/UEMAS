function [SData_mini SData_maxi] = findExtrema(xvals, yvals)

SData_x = xvals';
SData_y = yvals;

%SData_x = smooth(SData_x);
%SData_y = smooth(SData_y);

%% Discrete derivatives

dSData_y = diff(SData_y)./diff(SData_x); % First derivative
dSData_y_smooth = dSData_y,round(length(dSData_y)/20); %smooth(movmean(dSData_y,round(length(dSData_y)/20))); % Smoothed first derivative
mSData_x = zeros(length(SData_x)-1,1); % Array for the position of each half-x point on the array (-1 number of values)
for i = 1:length(SData_x)-1 % Calculating half-positions for x on first derivative
    mSData_x(i) = mean([SData_x(i) SData_x(i+1)]);
end
ddSData_y = diff(dSData_y_smooth)./diff(mSData_x), round(length(dSData_y)/20); % Second derivative
mmSData_x = zeros(length(mSData_x)-1,1); % Second set of half-values to first set
for i = 1:length(mSData_x)-1 % Calculating second half-values
    mmSData_x(i) = mean([mSData_x(i) mSData_x(i+1)]);
end

%% Calculating Extrema Points (dh/dx = 0)

% SData_extr_pos: Extrema positions on the data array in real space
% SData_extr_posi: Extrema positions on the data array in index

[mSData_x_extr_pos mSData_x_extr_posi] = findZeros(dSData_y_smooth, mSData_x);

SData_extr_pos = zeros(size(mSData_x_extr_pos));
SData_extr_posi = zeros(size(mSData_x_extr_pos));

% Reconfiguring derivative x-values to closest discrete original array values
for i = 1:length(mSData_x_extr_pos)
    [SData_extr_pos(i) SData_extr_posi(i)] = closestDiscrete(mSData_x_extr_pos(i), SData_x);
end

%% curvature array

curv_arr = zeros(size(SData_extr_pos));
num_max = 0; % Tracking the number of maximums
num_min = 0; % Tracking the number of minimums
for i = 1:length(SData_extr_pos)
    [curmmSData_x curmmSData_x_i] = closestDiscrete(SData_extr_pos(i),mmSData_x); %Readjust closest discrete x-value and index
    [SData_x_extrema SData_x_extrema_i] = closestDiscrete(SData_extr_pos(i),mmSData_x);
    curddSData_y = ddSData_y(curmmSData_x_i);
    if curddSData_y > 0 % If minimum (second derivative is > 0), set curv_arr(i) = 1
        if i > 1 && curv_arr(i-1) == 1
        else
            curv_arr(i) = 1;
            num_min = num_min + 1;
        end
    elseif curddSData_y < 0 % If maximum (second derivative is < 0), set curv_arr(i) = -1
        if i > 1 && curv_arr(i-1) == -1
        else
            curv_arr(i) = -1;
            num_max = num_max + 1;
        end
    end
end

%% min/max identification

SData_max_pos = zeros(1,num_max); % Positions of maximums in real-space
SData_min_pos = zeros(1,num_min); % Positions of minimums in real-space

min_ind = 1; % Index of min position array
max_ind = 1; % Index of max position array
for i = 1:length(curv_arr)
    if curv_arr(i) == 1 % If curving down, append to minimum arrays and extend min index by 1
        SData_min_pos(min_ind) = SData_extr_pos(i);
        min_ind = min_ind + 1;
    elseif curv_arr(i) == -1 % If curving up, append to maximum arrays and extend max index by 1
        SData_max_pos(max_ind) = SData_extr_pos(i);
        max_ind = max_ind + 1;
    end
end

%% max indexes on data-array

% Due to discrepancies between real x-space and discrete x-values in the
% array, identify the closest x-values of each of the maximums

SData_max_x = zeros(1,length(SData_max_pos));
SData_max = zeros(1,length(SData_max_pos));
SData_maxi = zeros(1,length(SData_max_pos));
for i = 1:length(SData_max_pos)
    [SData_max_x(i) SData_maxi(i)] = closestDiscrete(SData_max_pos(i),SData_x);
end
SData_max = SData_y(SData_maxi);

%% min indexes on data-array

% Due to discrepancies between real x-space and discrete x-values in the
% array, identify the closest x-values of each of the minimums

SData_min_x = zeros(1,length(SData_min_pos));
SData_min = zeros(1,length(SData_min_pos));
SData_mini = zeros(1,length(SData_min_pos));
for i = 1:length(SData_min_pos)
    [SData_min_x(i) SData_mini(i)] = closestDiscrete(SData_min_pos(i),SData_x);
end
SData_min = SData_y(SData_mini);

%% Left/Right Inflection at each max for SData

[mmSData_Inf mmSData_Inf_i] = findZeros(ddSData_y, mmSData_x);

SData_Inf = zeros(size(mmSData_Inf));
SData_Inf_i = zeros(size(mmSData_Inf_i));

for i = 1:length(mmSData_Inf)
    [SData_Inf(i) SData_Inf_i(i)] = closestDiscrete(mmSData_Inf(i), SData_x);
end

%scatter(SData_Inf,zeros(size(SData_Inf)),'kd','MarkerFaceColor','g');

total_curv = zeros(1,length(SData_Inf)-1);

num_trough = 0;
num_crest = 0;

for i = 1:length(SData_Inf)-1
    if mean(ddSData_y(SData_Inf_i(i):SData_Inf_i(i+1))) > 0
        total_curv(i) = 1;
        num_trough = num_trough + 1;
    elseif mean(ddSData_y(SData_Inf_i(i):SData_Inf_i(i+1))) < 0
        total_curv(i) = -1;
        num_crest = num_crest + 1;
    end
end

end