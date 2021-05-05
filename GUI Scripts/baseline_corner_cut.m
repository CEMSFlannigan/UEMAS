function [yval_list xval_list Elim_Ratio] = baseline_corner_cut(xvals, yvals)

%% Corner elimination

corner_present = true;
pvals = yvals;
new_xvals = xvals;
index_array = 1:length(yvals);
corner_indices = [];
index_array_pruned = index_array;
new_corner_indices = [];
Elim_Ratio = [];
Area_List = [];
pval_list = {};
xval_list = {};
yval_list = {};

figure;

while (corner_present)
    for i = 2:length(pvals)-1
        left_side = pvals(i) - pvals(i-1);
        right_side = (pvals(i+1) - pvals(i-1))/(new_xvals(i+1) - new_xvals(i-1))*(new_xvals(i) - new_xvals(i-1));
        if left_side > right_side
            new_corner_indices = [new_corner_indices i];            
        end
    end
    
    if (length(new_corner_indices) == 0)
        corner_present = false;
    end
    
    cur_index_array = index_array_pruned;
    index_array_pruned = setdiff(index_array_pruned, cur_index_array(new_corner_indices));
    pvals = yvals(index_array_pruned);
    new_xvals = xvals(index_array_pruned);
    
    Area_List = [Area_List 0];
    for i = 1:length(pvals)-1
        Area_List(end) = Area_List(end) + abs((new_xvals(i+1) - new_xvals(i))*(pvals(i+1) - pvals(i))/2);
    end
    
    if length(new_corner_indices) ~= 0
        N_i = length(new_corner_indices);
    else
        N_i = 1;
    end
    
    if (length(Area_List) > 1)
        curER = abs(Area_List(end) - Area_List(end-1))/N_i;
    else
        curER = Area_List(end)/N_i;
    end
    Elim_Ratio = [Elim_Ratio curER];
    
    plot(xvals, yvals);
    hold on;
    scatter(new_xvals, pvals);
    hold off;
    
    pval_list{end+1} = pvals;
    xval_list{end+1} = new_xvals;
    
    new_corner_indices = [];
    pause(0.1);
    
    for i = 1:length(xvals)
        cur_baseline = interp1(new_xvals,pvals,xvals,'linear');
    end
    
    yval_list{end+1} = cur_baseline;
end

[maxER maxERI] = max(Elim_Ratio);
plot(xvals, yvals);
hold on;
scatter(cell2mat(xval_list(maxERI)), cell2mat(pval_list(maxERI)),'k');
hold off;

end