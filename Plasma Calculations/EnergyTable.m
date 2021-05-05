FOV = 6.31; % um, 1700x

FWHM = 62; % um
stdev = FWHM/2/sqrt(2*log(2)); % um

laserPower = 0:1:500; % nJ
photonEnergyGreen = 6.626e-34.*2.9979e8./515e-9.*1e9; % nJ
photonEnergyRed = 6.626e-34.*2.9979e8./1030e-9.*1e9; % nJ

laserGauss = @(x,y) exp(-(x.^2 + y.^2)./(2.*stdev.^2)); % Norm Intensity
total = integral2(@(x,y) laserGauss(x,y), -Inf, Inf, -Inf, Inf);
TotalConst = laserPower./total; % nJ
TotalFOVEnergy = TotalConst.*integral2(@(x,y) laserGauss(x,y), -FOV/2, FOV/2, -FOV/2, FOV/2); % nJ
TotalInversedAreaEnergy = TotalConst.*integral2(@(x,y) laserGauss(x,y), -3*stdev*sqrt(2), 3*stdev*sqrt(2), -3*stdev*sqrt(2), 3*stdev*sqrt(2)); % nJ
TotalFOVFluence = TotalFOVEnergy/(FOV.^2); % nJ/um^2
TotalFOVFluenceCM2 = TotalFOVFluence.*1e8./1e6; % mJ/cm^2
TotalFluence = TotalInversedAreaEnergy./((3*stdev.*sqrt(2)).^2); % nJ per um^2
TotalFluenceCM2 = TotalFluence./1e6.*1e8; % mJ/cm^2

AbsorbanceGreen = 5.97e-2; % nm^-1
AbsorbanceRed = 0.16e-2; % nm^-1

TotalCarrierZoomGreen = TotalFOVEnergy.*(integral(@(x) exp(-AbsorbanceGreen.*x),0,100)./integral(@(x) exp(-AbsorbanceGreen.*x),0,Inf))./photonEnergyGreen; % 100 nm sample
TotalCarrierDensityZoomGreen = TotalCarrierZoomGreen/(FOV.^2.*(.100)); % per um^3
TotalCarrierDensityZoomGreenCM2 = TotalCarrierDensityZoomGreen*1e12; % per cm^3

TotalCarrierZoomRed = TotalFOVEnergy.*(integral(@(x) exp(-AbsorbanceRed.*x),0,100)./integral(@(x) exp(-AbsorbanceRed.*x),0,Inf))./photonEnergyRed; % 100 nm sample
TotalCarrierDensityZoomRed = TotalCarrierZoomRed/(FOV.^2.*.100); % per um^3
TotalCarrierDensityZoomRedCM2 = TotalCarrierDensityZoomRed*1e12; % per cm^3

TotalCarrierGreen = TotalInversedAreaEnergy.*(integral(@(x) exp(-AbsorbanceGreen.*x),0,100)./integral(@(x) exp(-AbsorbanceGreen.*x),0,Inf))./photonEnergyGreen; % 100 nm sample
TotalCarrierDensityGreen = TotalCarrierGreen/((3*stdev*sqrt(2)).^2.*(.100)); % per um^3
TotalCarrierDensityGreenCM2 = TotalCarrierDensityGreen*1e12; % per cm^2

TotalCarrierRed = TotalInversedAreaEnergy.*(integral(@(x) exp(-AbsorbanceRed.*x),0,100)./integral(@(x) exp(-AbsorbanceRed.*x),0,Inf))./photonEnergyRed; % 100 nm sample
TotalCarrierDensityRed = TotalCarrierRed/((3*stdev*sqrt(2)).^2.*(.100)); % per um^3
TotalCarrierDensityRedCM2 = TotalCarrierDensityRed*1e12; % per cm^2