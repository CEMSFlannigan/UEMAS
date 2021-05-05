function[fits, func] = fitLogistic(xdata, ydata)

func = @(param,xdata) param(1)./(1+exp(-2*param(2)*(xdata-param(3)))) + param(4);
fit0 = [max(ydata), 1, xdata(round(length(xdata)/2)),min(ydata)];

options = optimoptions('lsqcurvefit','Display','off');
fits = lsqcurvefit(func,fit0,xdata,ydata,[],[],options);

end