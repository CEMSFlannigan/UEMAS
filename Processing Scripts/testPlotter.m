ksquare = ceil(sqrt(length(trueDistArr)-1));

ave_max_dist = zeros(1,length(timeArr));
ave_min_dist = zeros(1,length(timeArr));
ave_extr_dist = zeros(1,length(timeArr));
var_extr_dist = zeros(1,length(timeArr));

figure; hold on;
for k = 1:length(timeArr)
    
    subplot(ksquare,ksquare,k);
    
    curx = trueDistArr(1:end-1);
    cury = spaceTimePlot(:,k);
    
    smooth_cury = sgolayfilt(cury,3,31);
    residual = cury - smooth_cury;
    
    [SDatamini, SDatamaxi] = findExtrema(curx, smooth_cury);
    
    plot(trueDistArr(1:end-1),smooth_cury,'b');
    
    hold on;
    
    plot(trueDistArr(1:end-1),cury,'r');
    
    scatter(trueDistArr(SDatamini),smooth_cury(SDatamini));
    scatter(trueDistArr(SDatamaxi),smooth_cury(SDatamaxi));
    
    ave_max_dist(k) = mean(trueDistArr(SDatamaxi));
    ave_min_dist(k) = mean(trueDistArr(SDatamini));
    
    ave_extr_dist(k) = mean(diff(sort([trueDistArr(SDatamini) trueDistArr(SDatamaxi)])));
    var_extr_dist(k) = sqrt(var(2*diff(sort([trueDistArr(SDatamini) trueDistArr(SDatamaxi)]))));
    
    hold off;
    
end

ave_extr_dist(var_extr_dist > trueDistArr(round(end/4))) = NaN;

figure; hold on;
plot(timeArr,ave_max_dist);
plot(timeArr,ave_min_dist);
scatter(timeArr,movmean(ave_extr_dist,10).*2);
errorbar(timeArr,movmean(ave_extr_dist,10).*2,var_extr_dist);
hold off;

figure; hold on;
scatter(timeArr,movmean(ave_extr_dist.*2,10),'k','LineWidth',1.5);
errorbar(timeArr,movmean(ave_extr_dist.*2,10),var_extr_dist,'LineStyle', 'none');
set(gcf,'Position',[0 0 1000 1000]); set(gca,'FontSize',20); box on; xlabel('Time (ps)', 'FontSize', 20); ylabel('Average Width of Waves in ROI (nm)', 'FontSize', 20);
hold off;