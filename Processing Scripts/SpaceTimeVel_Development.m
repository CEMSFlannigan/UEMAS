figure;
hold on;
plot(spaceTimePlot(200,:)+40);
plot(diff(spaceTimePlot(200,:)));

STPROI = spaceTimePlot(100:250, 25:100);
diffSTP = zeros(size(STPROI,1),size(STPROI,2)-1);
cross_sign_indices = zeros(size(STPROI,1),size(STPROI,2)-1);

for j = 1:size(STPROI,1)-1
    
    diffSTP(j,:) = diff(STPROI(j,:));
    
    for i = 1:size(STPROI,2)-2
        
        if sign(diffSTP(j,i)) == -1 && sign(diffSTP(j,i+1)) == 1
            cross_sign_indices(j,i) = 1;
            cross_sign_indices(j,i+1) = 1;
            cross_sign_indices(j+1,i) = 1;
            cross_sign_indices(j+1,i+1) = 1;
        end
        
    end
    
end

figure;
imagesc(cross_sign_indices);