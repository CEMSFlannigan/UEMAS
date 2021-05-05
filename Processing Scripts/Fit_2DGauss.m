function [ fitresult, xys ] = Fit_2DGauss( Data, rect, x0 )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

try
    x_end = rect(1) + rect(3);           %Defines width and height from the selected rectangle
    y_end = rect(2) + rect(4);
catch
    errordlg('There is no image open')
    return
end

[x_mesh, y_mesh] = meshgrid(rect(1):x_end, rect(2):y_end);  %Set up mesh for 2D Gauss
xys = cat(3, x_mesh, y_mesh);

Fit_Data = Data(rect(2):y_end, rect(1):x_end);              % Cuts Data to size of rectangle
FWHM_x = rect(3)/6;                                         % Find FWHM approximation
FWHM_y = rect(4)/6;

if isequal(nargin, 3)
    x0 = x0;
elseif isequal(nargin, 2)
    x0 = [(x_end+rect(1))/2, (y_end+rect(2))/2, FWHM_x, FWHM_y, max(max(Fit_Data)), min(min(Fit_Data))];
else
    errordlg('Incorrect Input');
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section sets bound for fitting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opts = optimset('Algorithm','trust-region-reflective','Display','off');
lb = [rect(1), rect(2), 0, 0, -inf, -inf];
ub = [x_end, y_end, rect(3), rect(4), inf, inf];

fitresult = lsqcurvefit(@Gauss_2D, x0, xys, Fit_Data, lb, ub, opts);      %Fitting Procedure

end

