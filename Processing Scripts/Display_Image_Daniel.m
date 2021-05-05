function [ im_handle ] = Display_Image( Data, PercLow, PercHigh )

%%% This function is intended to produce a scaled image of the data with
%%% the given percentile marks using the function imagesc.

im_handle = imagesc(Data, [prctile(Data(:), PercLow), prctile(Data(:), PercHigh)]);

end

