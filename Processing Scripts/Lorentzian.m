function [ f ] = Lorentzian( imp, x )
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here

imp = imp(:);
x = x(:);
x = transpose(x);

A = imp(1:4:end);
gam = imp(2:4:end)/2;
gam_2 = power(gam, 2);
x0 = imp(3:4:end);
y_shift = imp(4:4:end);

f = sum(bsxfun(@plus, bsxfun(@times, bsxfun(@rdivide, gam, pi*bsxfun(@plus, power(bsxfun(@minus, x, x0), 2), gam_2)), A), y_shift), 1);

f = f(:);