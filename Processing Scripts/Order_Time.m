function [time_array new_file_names new_file_path file_names] = Order_Time(ulg_file_path)

ulgdata = importdata(ulg_file_path);

data = ulgdata(12:end);

time_array = zeros(size(data));
file_names = cell(size(data));

for i = 1:length(time_array)
    
    curdata = data{i};
    datasplit = strsplit(curdata,',');
    
    time_array(i) = str2num(datasplit{3});
    file_names{i} = datasplit{6};
    
end

new_file_names = cell(size(data));

for i = 1:length(time_array)
    
end

end