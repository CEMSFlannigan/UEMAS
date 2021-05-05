function [fits, fun] = fitStep(XData,avgYData,guess)

fun = [];
centerfit = guess;%XData(round(end/2));
maxValCur = [];
maxVal = max(avgYData);
minValCur = [];

if avgYData(1) > avgYData(end)
    maxValCur = max(avgYData(1:centerfit));
    minValCur = min(avgYData(centerfit:end));
    fun = @(center) -maxVal.*(heaviside(XData - center)-1) - avgYData;
else
    maxValCur = max(avgYData(centerfit:end));
    minValCur = min(avgYData(1:centerfit));
    fun = @(center) maxVal.*heaviside(XData - center) - avgYData;
end

options = optimoptions('lsqcurvefit','Display','iter');
fits = lsqnonlin(fun,centerfit,[],[],options);

end

% 