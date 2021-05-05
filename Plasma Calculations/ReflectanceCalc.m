lambda = 515; % nm
k = 2.455; % extinction coefficient (imaginary component of refractive index)
Absorbance = 2*pi*k/lambda; % nm^-1, attenuation coefficient
Thickness = 72; % nm

Exponent_Normalize = 1/integral(@(x) exp(-Absorbance*x),0,Thickness); % unitless

PowerIn = 100; % W
PowerReflect = 50; % W
PowerTransmit = 0; % W

PowerAbsorb = 