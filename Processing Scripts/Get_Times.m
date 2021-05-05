function [times] = Get_Times(time_path)

M = dlmread(time_path);
N = M(1:end,3);

times = sort(N);

end