function [ Data ] = RMOuts( Data, Hp, Lp )
%UNTITLED3 Summary of this function goes here
%   This function removes the outliers of a dataset 

if isequal(nargin, 1)
    Hp = 95;
    Lp = 5;
elseif ~isequal(nargin, 3)
    errordlg('Either 1 or 3 inputs are required');
    return
end

high = prctile(Data(:), Hp);
low = prctile(Data(:), Lp);

Outs = Data > high;
Outs2 = Data < low;

Meds = medfilt2(Data);

%Means=conv2(Data,ones(3)/9,'same');

Data(Outs) = Meds(Outs);
Data(Outs2) = Meds(Outs2);

end

