%% Code acquired from Wyatt Curtis and adapted for use in UI script
function [packetdata, a, F] = PlasmaLensingDeconv(timeArr,widthData)

%%
loc=0;
packetdata=[];

%% Outlier removal
high = prctile(widthData, 99);
low = prctile(widthData, 1);

Outs = widthData > high;
Outs2 = widthData < low;

Meds = medfilt1(widthData);

%Means=conv2(Data,ones(3)/9,'same');

widthData(Outs) = Meds(Outs);
widthData(Outs2) = Meds(Outs2);
%% End outlier removal

yc2=[timeArr widthData];
assignin('base','yc2',yc2);
[val, idx] = max(yc2(:,2));
assignin('base','val',val);
assignin('base','idx',idx);

x=linspace(min(yc2(:,1)),max(yc2(:,1)),(max(yc2(:,1))-min(yc2(:,1)))*10);

%Extract gaussian part of plasma response
ygauss=yc2(1:idx,:);
%Extract decay part of plasma response
ydecay=yc2(idx:length(yc2),:);

%plot data
PLfig = figure;
scatter(ygauss(:,1),ygauss(:,2),'ks','filled')
hold on
scatter(ydecay(:,1),ydecay(:,2),'ks','filled')

%define fitting function
F=@(a,xdata)(a(5).*exp(0.5*a(2)*(a(2)*a(1)^2-2.*(xdata-a(3)))).*erfc(sqrt(1/2/a(1)).*(a(2).*a(1)^2-(xdata-a(3))))+a(4));

%Define Initial parameters
sig0=5;
lam0=0.1;
t0=-800;
y0=0;
a50=1/(exp(0.5*(lam0*sig0)^2)*erfc(sqrt(0.5)*lam0*sig0));
a0=[sig0 lam0 t0 y0 a50];

%define lower bounds
lb=[10^-6 10^-6 timeArr(1) min(widthData) 0];

%define upper bounds
ub=[Inf Inf timeArr(length(timeArr)) max(widthData) Inf];

%fit curve to data
[a,resnorm,~,exitflag,output]=lsqcurvefit(F,a0,yc2(:,1),yc2(:,2),lb,ub);

%Plot fitted line
fit=F(a,x);
plot(x,fit,'--r');

%Extract characteristic decay time of packet
decay=1/a(2);

%Known laser parameters
fwhm=299; %FWHM of laser pulse duration in fs
pumpsd=299/(2*sqrt(2*log(2)))*10^-3; % Standard deviation of gaussian laser pulse in ps

%calculate probe standard deviation (ps) from deconvoluted parameters
probesd=sqrt(a(1)^2-pumpsd^2);
probeFWHM = (2*sqrt(2*log(2))*probesd);

% aribtrarily state true time zero as the initial point where the gaussian
% rises above 1/2 the maximum in the initial rise:
true_t0 = a(3) - probeFWHM/2;

% x=linspace(-200,200,10^5);
% y1=exp(-x.^2/2/probesd^2);
% y2=exp(-x.^2/2/a(1)^2);
% y3=exp(-x.^2/2/pumpsd^2);

%Plot formatting and data extraction
str=['Packet FWHM: ', num2str(round(2*sqrt(2*log(2))*probesd),3),' ps'];
%text(-790,max(widthData),str)

%packetdata=[probe FWHM (ps), characteristic decay time (ps)]
packetdata=[probeFWHM, decay];

assignin('base','LensBehavior',packetdata);
assignin('base','TrueTimeZero',true_t0);
hold off;

end