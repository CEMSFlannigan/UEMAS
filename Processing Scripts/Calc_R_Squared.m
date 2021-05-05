function [ R_Squared ] = Calc_R_Squared( Obs_Data, Fit )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This is a script which calculates the R^2 Value for a set of data which
%   has been fit.
%  
%   Written by Spencer Reisbick,     Last Edited 7/26/2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Obs_Data = Obs_Data(:);
Fit = Fit(:);

if  length(Obs_Data) == length(Fit)
    n = length(Fit);                                                          %%%%  Checks to see if data is all same length
else
    errordlg('Make sure the two data sets are the same size in length')           %%%%  and ends program if they aren't
    return
end

y_tot = sum(sum(Obs_Data));                     % Finds average of Observed Data                                 
y_avg = y_tot/n;

Obs_Data1 = Obs_Data - y_avg;
SS_Tot = sum(sum(power(Obs_Data1, 2)));       %total sum of squares from the avaerage

e = Obs_Data - Fit;
SS_Res = sum(sum(power(e, 2)));        % sum of the squares of the residuals compared to the fit


R_Squared = 1 - (SS_Res/SS_Tot);                                %Computes R^2
end

