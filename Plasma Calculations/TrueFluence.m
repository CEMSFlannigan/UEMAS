FOV = 7; %6.47; % um, 1700x


%% UV
% beam_width_x = 55.3/2; % um
% beam_width_y = 55.3/2; % um

%% Green
beam_width_x = 98.5/2; % um
beam_width_y = 61.0/2; % um

%% Calculation

laserPower = 50.181;%e-3/100000*1e9; % nJ

wavelength_energy = 2.4; % eV
photonEnergy = wavelength_energy*1.602e-19/1e-9; % nJ

thickness = 0.1; % um
Optics_Transmission = 0.95^4; % fraction remaining after optics
laserPower = laserPower*Optics_Transmission;

AbsorbanceEnergy = [0.675393891105713;0.738274311334860;0.801186485342686;0.864058967127163;0.921674213929093;0.989756300028099;1.05786815529462;1.11550126359705;1.17834199160285;1.24643796998003;1.30407107828247;1.36684829873091;1.36696737540095;1.42556738626417;1.49259326229986;1.56065748689836;1.62350615334883;1.68525931443487;1.74385297454235;1.80665797954713;1.87465671197710;1.93218265127650;1.97397260862927;1.99476339521936;2.02082332445901;2.08242287664069;2.05744535433176;2.10945804380801;2.14059659302514;2.13028455339912;2.18223770454035;2.16142310261624;2.22399789272561;2.26574220402152;2.32847179380195;2.39124901425039;2.45404211158817;2.51683520892595;2.57968387537641;2.64250872649287;2.70538120827735;2.76823185933898;2.83106266428894;2.89387957696073;2.95668061274318;3.01423830582126;3.08217154608270;3.14482373602760;3.12401508793700;3.18657797037935;3.22832625089760;3.28578074419497;3.35370604601175;3.39550394180919;3.43033585240892;3.47904217968021;3.52081824475481;3.56257446371773;3.61480149120007;3.66702851868240;3.72974858232922;3.78825809492319;3.83418040964881;3.87594853627873;3.91770872446399;3.95943318964823;3.98549907272138;4.00518244628005;4.02211514876064;4.05666325996342;4.04986795132611;4.08439820102839;4.11906737351238;4.10523066445300;4.13983434476847;4.16057750069054;4.18815565747328;4.17785552551427;4.19844388176528;4.21911559168533;4.20877973672531;4.25445754735509;4.22945144664536;4.26392017340144;4.25007552589739;4.29150229940651;4.28117835211349;4.30526359324154;4.33295288824965;4.34671815130701;4.37453446142984];
AbsorbanceValues = [0.0395399372684331;0.0262112886679091;-0.0438613624320361;-0.0430040104076994;-0.0102996029794689;0.0438266973901023;0.0447554954164637;0.0455414014387685;0.103142755962530;0.132443555238602;0.133229461260907;0.304318820783514;0.0915288114106723;0.237026213006917;0.306033524832181;0.392078326607678;0.435493680506585;0.564010748954214;0.720856951050347;0.842295308385957;1.04537461531651;1.23767152977438;1.46167260763209;1.75986440476218;2.00493014555109;2.40794632608969;2.10118577178306;2.78282826179643;3.31523196124071;3.01718305611467;3.80522055081446;3.54958675555894;4.08241913101538;4.38798971246601;4.64419507573776;4.81528443526036;4.95800179353326;5.10071915180615;5.14413450570505;5.23010786147852;5.23096521350286;5.27083406724555;5.34616792255037;5.44632727894870;5.57485863659674;5.71041154855518;6.03052536064081;6.42504423000490;6.15877093428073;6.71288231067446;7.01135989181266;7.33133081189422;7.66563062460470;7.87544570183756;8.04970051617223;8.39792436083346;8.64675093978467;8.93104252029801;9.22966299344027;9.52828346658253;9.80151203060410;10.1087298393237;10.4384737786382;10.7014863582143;10.9786849384152;11.3197205214280;11.5541467617482;11.9587192743643;11.6610418884488;12.3424462251221;12.0018869487895;12.7152097868687;13.1802776140130;12.9389250807183;13.5210274130176;13.9043352138969;14.5572722879844;14.2379443819211;14.8978791949850;15.4088610014879;15.1533700982365;15.9200428567965;15.6643519047394;16.4876162476612;16.2604497149915;17.1334603214363;16.8566904172476;17.5095798606671;17.9639129260066;18.3329394649250;18.5602965202668];
AbsorbanceEnergy = smooth(AbsorbanceEnergy);
AbsorbanceValues = smooth(AbsorbanceValues);
found = 0;
for i = 1:length(AbsorbanceEnergy)
    if wavelength_energy < AbsorbanceEnergy(i) && found == 0
        Absorbance = ((AbsorbanceValues(i) - AbsorbanceValues(i-1))/(AbsorbanceEnergy(i) - AbsorbanceEnergy(i-1))*(wavelength_energy - AbsorbanceEnergy(i-1)) + AbsorbanceValues(i-1))*1e5; % cm^-1
        found = 1;
    end
end

Absorbance = Absorbance/1e7; % nm^-1
Reflectance = 0;%0.916; %Aluminum %0.508; % green (unknown geometry)
%AbsorbanceRed = ; % nm^-1
%ReflectanceRed = ;

laserGauss = @(x,y) exp(-(2*x.^2./(beam_width_x.^2)) - (2.*y.^2./beam_width_y.^2)); % Norm Intensity
total = integral2(@(x,y) laserGauss(x,y), -Inf, Inf, -Inf, Inf);
TotalConst = laserPower/integral2(@(x,y) laserGauss(x,y), -Inf, Inf, -Inf, Inf); % nJ/um^2
TotalFOVEnergy = TotalConst.*integral2(@(x,y) laserGauss(x,y), -FOV/2, FOV/2, -FOV/2, FOV/2); % nJ
TotalFOVAbsorbed = (1-Reflectance).*TotalConst.*integral2(@(x,y) laserGauss(x,y), -FOV/2, FOV/2, -FOV/2, FOV/2); % nJ
TotalInversedAreaAbsorbed = TotalConst.*integral2(@(x,y) laserGauss(x,y), -beam_width_x, beam_width_x, -beam_width_y, beam_width_y); % nJ (1-Reflectance).*
TotalFOVFluence = TotalFOVEnergy/(FOV.^2); % nJ/um^2
TotalFOVFluenceCM2 = TotalFOVFluence.*1e8./1e6; % mJ/cm^2

xR = -50:0.1:50;
xRZoom = [-FOV/2 FOV/2];
yR = -50:0.1:50;
yRZoom = [-FOV/2 FOV/2];

Result = zeros(length(xR),length(yR));
ResultZoom = zeros(length(xRZoom),length(yRZoom));

for i = 1:length(xR)
    for j = 1:length(yR)
        Result(i,j) = laserGauss(xR(i),yR(j)).*TotalConst;
    end
end

for i = 1:length(xRZoom)
    for j = 1:length(yRZoom)
        ResultZoom(i,j) = laserGauss(xRZoom(i),yRZoom(j)).*TotalConst;
    end
end

TotalCarrierZoom = TotalFOVAbsorbed.*(integral(@(x) exp(-Absorbance.*x),0,thickness*1000)./integral(@(x) exp(-Absorbance.*x),0,Inf))./photonEnergy; % 100 nm sample
TotalCarrierDensityZoom = TotalCarrierZoom/(FOV.^2.*(thickness - 1/(1000*Absorbance))); % per um^3
TotalCarrierDensityZoomCM2 = TotalCarrierDensityZoom*1e12; % per cm^3

TotalCarrier = (1-Reflectance)*laserPower/photonEnergy*(integral(@(x) exp(-Absorbance.*x),0,thickness*1000)./integral(@(x) exp(-Absorbance.*x),0,Inf)); % 100 nm sample
PeakCarrierDensity = 2*TotalCarrier/((pi*beam_width_x*beam_width_y).*thickness); % per um^3
PeakCarrierDensityCM2 = PeakCarrierDensity*1e12; % per cm^3
AverageCarrierDensityCM2 = PeakCarrierDensityCM2/2; % per cm^3
PeakFluence = 2*laserPower./(pi*beam_width_x*beam_width_y); % nJ per um^2
PeakFluenceCM2 = PeakFluence./1e6.*1e8; % mJ/cm^2
AverageFluenceCM2 = PeakFluenceCM2/2; % mJ/cm^2

s1 = surf(xR,yR,Result);
hold on;
s2 = surf([xR(1) xR(end)],[yR(1) yR(end)], ResultZoom);
legend({'Beam Gaussian','Minimum Energy in FOV'},'FontName','Arial','FontSize',20);
set(s1,'linestyle','none');
set(s2,'facecolor',[0 0 1]);
set(gcf,'Position',[0 0 1250 750]);
set(gca,'FontName','Arial','FontSize',20);
xlabel('x-Direction (microns)', 'FontName','Arial','FontSize',35);
ylabel('y-Direction (microns)', 'FontName','Arial','FontSize',35);
zlabel('Energy (nJ)', 'FontName','Arial','FontSize',35);