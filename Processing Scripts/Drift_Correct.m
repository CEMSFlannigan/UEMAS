function [img_data] = Drift_Correct(init_data,drift)

%%% This function is intended to shift an unrotated image (i.e.
%%% rectangular) using circshift such that all possible drift has been
%%% accounted for and features of importance remain in the same position.

%%% The function used to shift will be circshift so that the original
%%% dimensions of the image are maintained and any rotations that are
%%% applied to the processed image afterward are the same across the entire
%%% stack of images.

%%% The input parameters are:
%%%    init_data -> the image data given in a 2D array with intensities
%%%    drift -> the drift given in a 2D vector indicating x and y drift

%%% In MATLAB, the real x direction is given by the columns and the real y
%%% direction is given by the rows.

img_data = circshift(init_data, [drift(2), drift(1)]);

end