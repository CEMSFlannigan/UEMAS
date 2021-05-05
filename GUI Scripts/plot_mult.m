figure;
hold on;
plot(mean(abs(diff(multtimeSumArrs(49:80,:),1,1)),1));
plot(mean(vartimeSums(49:80,:),1));
% 
% diff

figure;
errorbar(timeArr,multtimeSumArrs(:,137),vartimeSums(:,137));

% figure;
% for i = 1:223
% errorbar(timeArr(:),multtimeSumArrs(:,i),vartimeSums(:,i));
% title(i);
% ylim([0.1 0.5]);
% pause(1);
% end
% 
% figure;
% numSquares = length(multiSquareArray);
% plot(mean(abs(diff(multiintensitylens_counts(49:80,:),1,1)),1));
% 
% figure;
% for i = 1:numSquares
%     subplot(round(sqrt(numSquares))+1,round(sqrt(numSquares))+1,i);
%     plot(timeArr(49:80),multiintensitylens_counts(49:80,i));
%     ylim([0.1 0.2]);
%     xlim([210 365]);
% end

% figure;
% plot(timeArr,multiintensitylens_counts(:,numSquares-9));