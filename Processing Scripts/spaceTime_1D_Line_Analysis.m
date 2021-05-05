pixConv = .1582703; % px/nm
timeScale = 1/5; % px/ps

velocities = zeros(1,length(completeFitData));
errors = zeros(1,length(completeFitData));

degArr = -1*degVar:degVar;

convertedFitData = cell(size(completeFitData));
for i = 1:length(completeFitData)
    curDistArr = distArrs{i};
    distConv = curDistArr(2) - curDistArr(1);
    curFitData = completeFitData{i};

    if ~isnan(curFitData)
        curFitData(:,1) = curFitData(:,1).*distConv./pixConv;
        curFitData(:,3) = curFitData(:,3)./timeScale;
        
        convertedFitData{i} = curFitData;
        
        curModel = fitlm(curFitData(:,3),curFitData(:,1));
        
        coefficients = curModel.Coefficients.Estimate;
        coeffErr = curModel.Coefficients.SE;
        velocities(i) = abs((coefficients(2)));
        errors(i) = abs(coeffErr(2));
    end
end

offset = max(velocities);
[minVel, minVel_i] = min(velocities);
[pVfits pVfunc] = fitPseudVoigt(degArr(minVel_i:end),velocities(minVel_i:end)-offset);

degVar = (length(completeFitData) - 1)/2;
h3 = figure;
errorbar(-1*degVar:degVar,velocities,errors,'Color','r','LineStyle','none','LineWidth',2);
hold on;
scatter(-1*degVar:degVar,velocities,100,'ks','MarkerFaceColor','k');
%plot(-1*degVar:degVar,pVfunc(pVfits,-1*degVar:degVar)+offset,'k','LineWidth',2);
hold off;

set(gca,'FontSize',20);
xlabel('Degree Rotation','FontSize',26);
ylabel('Speed (km/s)','FontSize',26);
box on;
set(gcf,'Position',[0 0 1000 1000]);
pbaspect([1 1 1]);
set(gcf,'Position',[0 0 1250 1000]);
set(gca,'LineWidth',2);