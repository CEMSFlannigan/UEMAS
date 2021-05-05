function [ im_handle ] = Display_Image( Data, low, high )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if isequal(nargin, 1)
    low = 1;
    high = 99;
elseif or(isequal(isequal(nargin, 3), 0), low>high)
    errordlg('There must be either 1 or 3 inputs.  Inputs must be a matrix and 2 integers')
    return
end

im_handle = imagesc(Data, [prctile(Data(:), low), prctile(Data(:), high)]);

end

