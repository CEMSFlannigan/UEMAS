function[fits, func] = fitPseudVoigt(xdata, ydata)

func = @(param,xdata) param(3).*exp(-1*((param(1) - xdata)./param(2)).^2/2);
fit0 = [xdata(round(length(xdata)/2)), 1, 0.5, 0.5];

options = optimoptions('lsqcurvefit','Display','off');
fits = lsqcurvefit(func,fit0,xdata,ydata,[],[],options);

end