function [ Data ] = Cut_Data( Data, rect )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Data = Data(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3));

end

