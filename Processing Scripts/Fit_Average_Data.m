function [f,gof,const] = Fit_Average_Data(distance, avg_data, approx_center_peak, approx_width_peak)

%%% This function is intended to fit a single set of data to a Gaussian
%%% curve by finding minima surrounding a central peak and applying
%%% MATLAB's built in fit function.

%%% Arguments
%%%     distance -> The x-data (in pixels)
%%%     avg_data -> The average data (y)
%%%     approx_center_peak -> The point thought to be near the maxima
%%%     approx_width_peak -> The approximate width of the peak (in pixels)

% Finding the minimia near the center
curMin = 1e10;
curPos = 1;
left_search = approx_center_peak-round(1/3*approx_width_peak);
right_search = approx_center_peak+round(1/3*approx_width_peak);
if left_search < 0
    left_search = 1;
end
if right_search > length(avg_data)
    right_search = length(avg_data);
end

for i = left_search:right_search
    
    if avg_data(i) < curMin
        curMin = avg_data(i);
        curPos = i;
    end
    
end
Min = curMin;
MinPos = curPos;

%

left_search = MinPos - round(approx_width_peak/2);
right_search = MinPos + round(approx_width_peak/2);
if left_search < 1
    left_search = 1;
end
if right_search > length(avg_data)
    right_search = length(avg_data);
end

% Finding the left minima

curMax = -1e10;
curPos = 0;
for i = left_search:MinPos
    
    if avg_data(i) > curMax
        curMax = avg_data(i);
        curPos = i;
    end
    
end
leftMax = curMax;
leftPos = curPos;

% Finding the right minima
curMax = -1e10;
curPos = 0;
for i = MinPos:right_search
    
    if avg_data(i) > curMax
        curMax = avg_data(i);
        curPos = i;
    end
    
end
rightMax = curMax;
rightPos = curPos;

% Acquiring only the relevant data to fit
fitDistance = distance(leftPos:rightPos);
fitAvgData = avg_data(leftPos:rightPos) - max([leftMax rightMax]).*ones(size(avg_data(leftPos:rightPos)));
const = max([leftMax rightMax]);

% Fitting the data and returning the fit parameters as well as the goodness
% of fit
[f, gof] = fit(fitDistance',fitAvgData','gauss1');

end