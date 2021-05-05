function [line_means,background_img] = line_background(Data)

size_data = size(Data);
background_img = zeros(size(Data));

line_means = zeros(1,size_data(1));
line_var = zeros(1,size_data(1));

for i = 1:length(line_means)
    
    cur_line = Data(i,:);
    line_means(i) = min(cur_line);
    line_var(i) = var(cur_line);
    
    background_img(i,:) = mean(cur_line);
    
end

end