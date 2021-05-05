figure;
subplot(1,2,1);
hold on;
plot(timeArr,timeSum);
plot(timeArr(1:end-1),diff(timeSum));

timeArrQ = timeArr(1):1:timeArr(end);

timeSumInt = interp1(timeArr,timeSum,timeArrQ);
diffTS = diff(timeSumInt);
% subplot(1,2,2);
% hold on;
% plot(timeArrQ,timeSumInt);
% plot(timeArrQ(1:end-1),diffTS);

% figure;
% plot(timeArrQ,timeSumInt);

min_max_indices = [];

for i = 1:length(diffTS)-1
    
    if sign(diffTS(i)) ~= sign(diffTS(i+1))
        min_max_indices = [min_max_indices i];
    end
    
end

% figure;
% hold on;
% plot(timeArrQ(1:end-1), diffTS);
% scatter(timeArrQ((min_max_indices+1)), diffTS((min_max_indices+1)));

figure;
hold on;
plot(timeArrQ,timeSumInt);
scatter(timeArrQ(min_max_indices+1), timeSumInt(min_max_indices+1));

timePeaks = timeArrQ(min_max_indices+1);
timeSumPeaks = timeSumInt(min_max_indices+1);

figure;
hold on;
scatter(timePeaks(1:end-1),movmean(abs(diff(timeSumPeaks)),3));