Ablation = 8.3; % mW
RepRates = 5:5:200; % kHz
AblationEnergies = Ablation./(RepRates.*1000).*1e6; % nJ
MaxFluence = AblationEnergies./((3.*stdev*sqrt(2)).^2); % nJ/um^2
MaxFluenceCM2 = MaxFluence.*1e8./1e6; % mJ/cm^2

FOV = 6.31; % um
FWHM = 62; % um
stdev = FWHM/2/sqrt(2*log(2)); % um
laserGauss = @(x,y) exp(-(x.^2 + y.^2)./(2.*stdev.^2)); % Norm Intensity
total = integral2(@(x,y) laserGauss(x,y), -Inf, Inf, -Inf, Inf);
TotalConst = AblationEnergies./total; % nJ

TotalFluences = cell(1,length(MaxFluenceCM2));

for i = 1:length(MaxFluenceCM2)
    TotalFluences{i} = 0:0.001:MaxFluenceCM2(i);
end

TotalFOVEnergy = TotalConst.*integral2(@(x,y) laserGauss(x,y), -FOV/2, FOV/2, -FOV/2, FOV/2); % nJ
TotalFOVFluence = TotalFOVEnergy/(FOV.^2); % nJ/um^2
TotalFOVFluenceCM2 = TotalFOVFluence.*1e8./1e6; % mJ/cm^2

Proportion = TotalFOVFluenceCM2./MaxFluenceCM2;