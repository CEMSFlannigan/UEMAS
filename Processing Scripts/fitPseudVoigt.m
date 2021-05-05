function[fits, func] = fitPseudVoigt(xdata, ydata)

func = @(param,xdata) param(3)./(1 + ((param(1) - xdata)./(param(2)/2)).^2) + param(4).*exp(-1*((param(1) - xdata)./param(2)).^2/2);
if mean(ydata) > 0
    fit0 = [xdata(round(length(xdata)/2)), 1, max(ydata) - min(ydata), 0.5];
else
    fit0 = [xdata(round(length(xdata)/2)), 1, min(ydata) - max(ydata), 0.5];
end

options = optimoptions('lsqcurvefit','Display','off');
fits = lsqcurvefit(func,fit0,xdata,ydata,[],[],options);

end