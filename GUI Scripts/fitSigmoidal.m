function[fits, func] = fitSigmoidal(xdata, ydata)

func = @(param,xdata) (param(1)-param(4))./(1+exp(param(2)*(xdata-param(3))));
fit0 = [max(ydata), 1, xdata(round(length(xdata)/2)),min(ydata)];

% Identify inflection points
dyData = smooth(diff(smooth(ydata))./diff(smooth(xdata)));
mxData = xdata(1:end-1) + diff(xdata)./2;

%h3 = figure;
%plot(mxData,dyData);
%pause();
%close(h3);

% Identify orientation
if xdata(1) > xdata(end)
    xdata = fliplr(xdata);
    ydata = fliplr(ydata);
end

if ydata(1) < ydata(end)
    maxs = [max(ydata),Inf,xdata(end),max(ydata(1:round(length(ydata)/2)))];
    mins = [min(ydata(round(length(ydata)/2):end)),-Inf,xdata(1),min(ydata)];
else
    maxs = [max(ydata),Inf,xdata(end),max(ydata(round(length(ydata)/2):end))];
    mins = [min(ydata(1:round(length(ydata)/2))),-Inf,xdata(1),min(ydata)];
end

options = optimoptions('lsqcurvefit','Display','off');
fits = lsqcurvefit(func,fit0,xdata,ydata,mins,maxs,options); %

end