% figure;
% hold on;
% 
% plot(smooth(smooth(smooth(spaceTimePlot(:,18)))));
% plot(smooth(smooth(smooth(spaceTimePlot(:,63)))) + 10);
% plot(smooth(smooth(smooth(spaceTimePlot(:,64)))) + 20);
% plot(smooth(smooth(smooth(spaceTimePlot(:,65)))) + 30);
% plot(smooth(smooth(smooth(spaceTimePlot(:,66)))) + 40);
% plot(smooth(smooth(smooth(spaceTimePlot(:,67)))) + 50);
% plot(smooth(smooth(smooth(spaceTimePlot(:,68)))) + 60);
% plot(smooth(smooth(smooth(spaceTimePlot(:,69)))) + 70);
% plot(smooth(smooth(smooth(spaceTimePlot(:,70)))) + 80);
% plot(smooth(smooth(smooth(spaceTimePlot(:,71)))) + 90);

smoothSTP = zeros(size(spaceTimePlot));
diffSmoothSTP = zeros(size(spaceTimePlot,1)-1,size(spaceTimePlot,2));
for i = 1:length(timeArr)
    
    smoothSTP(:,i) = smooth(smooth(smooth(spaceTimePlot(:,i))));
    diffSmoothSTP(:,i) = diff(smoothSTP(:,i));
    
end

figure;
hold on;
plot(smoothSTP(:,110)+40);
plot(diffSmoothSTP(:,110).*10);
plot(1:length(smoothSTP(:,1)),zeros(1,length(smoothSTP(:,1))));

%% need to find global minima
% then find nearest local maximas

min_indices = zeros(1,length(timeArr));
left_max_indices = ones(1,length(timeArr));
right_max_indices = ones(1,length(timeArr));
xQuery = 1:0.1:length(smoothSTP(:,1));

for i = 1:length(timeArr)

    candidates = [];
    
    smoothSTPInterp = interp1(1:length(smoothSTP(:,1)),smoothSTP(:,i),xQuery);
    diffSmoothSTPInterp = interp1(1:length(smoothSTP(:,1))-1,diffSmoothSTP(:,i),xQuery(1:end-20));
    
    for j = 2:length(diffSmoothSTPInterp)-1
        if diffSmoothSTPInterp(j-1) > 0 && diffSmoothSTPInterp(j+1) < 0
            candidates = [candidates (mod(j-1,10)+round((j-1-mod(j-1,10))/10))];
        end
    end
    
    width_candidates = abs(diff(candidates));
    
    if ~isempty(width_candidates)
        [max_width mwi] = max(width_candidates);
        
        right_max_indices(i) = candidates(mwi+1);
        left_max_indices(i) = candidates(mwi);
    else
        left_max_indices(i) = 1;
        right_max_indices(i) = 1;
    end
    
end

% figure;
% hold on;
% 
% plot(smooth(smooth(smooth(spaceTimePlot(:,62)))));
% plot(right_max_indices(62),smooth(smooth(smooth(spaceTimePlot(right_max_indices(62),62)))),'ko');
% plot(left_max_indices(62),smooth(smooth(smooth(spaceTimePlot(left_max_indices(62),62)))),'ko');
% plot(smooth(smooth(smooth(spaceTimePlot(:,63)))) + 10);
% plot(smooth(smooth(smooth(spaceTimePlot(:,64)))) + 20);
% plot(smooth(smooth(smooth(spaceTimePlot(:,65)))) + 30);
% plot(smooth(smooth(smooth(spaceTimePlot(:,66)))) + 40);
% plot(smooth(smooth(smooth(spaceTimePlot(:,67)))) + 50);
% plot(smooth(smooth(smooth(spaceTimePlot(:,68)))) + 60);
% plot(smooth(smooth(smooth(spaceTimePlot(:,69)))) + 70);
% plot(smooth(smooth(smooth(spaceTimePlot(:,70)))) + 80);
% plot(smooth(smooth(smooth(spaceTimePlot(:,71)))) + 90);

% figure;
% hold on;
% %plot(smoothSTP(:,62)+45);
% plot(diffSmoothSTP(:,62));
% plot(right_max_indices(62),diffSmoothSTP(right_max_indices(62),62),'ko');
% plot(left_max_indices(62),diffSmoothSTP(left_max_indices(62),62),'ko');

widths = abs(distArr(right_max_indices) - distArr(left_max_indices));
widths = RMOuts(widths, 99, 1);
% figure;
% hold on;
% scatter(timeArr,widths);

widthROI = widths(1:end);
timeArrROI = timeArr(1:end);

% for i = 1:length(timeArrROI)
%     if widthROI(i) == 0
%         widthROI(i) = (widthROI(i-1) + widthROI(i+1))/2;
%     end
% end
% 
figure;
hold on;
scatter(timeArrROI,movmean(widthROI,3));
% plot(timeArrROI,70696.*timeArrROI.^(-0.87997));