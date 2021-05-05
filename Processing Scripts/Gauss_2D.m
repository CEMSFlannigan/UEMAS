function [ G ] = Gauss_2D( x, Mesh )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

    xmesh = Mesh(:,:,1);% get x mesh-grid from input data
    ymesh = Mesh(:,:,2);% get y mesh-grid from input data
     
    x0 = x(1);                              % Center of x     
    y0 = x(2);                              % Center of y
    
    FWHM_x = x(3);
    sigma_x = FWHM_x/(2*sqrt(2*log(2)));
    sig_2x = power(sigma_x, 2);
    
    FWHM_y = x(4);
    sigma_y = FWHM_y/(2*sqrt(2*log(2)));
    sig_2y = power(sigma_y, 2);
    
    A = x(5);                               % Intensity Scaling Factor
    bkg = x(6);                             % Uniform Background to be subtracted

    G = exp(-(power(xmesh-x0, 2)./(2*sig_2x)) - (power(ymesh-y0, 2)./(2*sig_2y))) ;
    G = A.*G + bkg;

end

