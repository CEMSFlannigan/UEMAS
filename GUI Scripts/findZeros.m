function [extr_pos extr_pos_i] = findZeros(array_y, array_x)

extr_pos = [];
extr_pos_i = [];

cons_zero = 0; % Used to determine how many zeros are present in a chain. Resulting zero-point is taken as mean of chain of zeros in x-space. This is an edge-case tracking tool
zero_cond = 0;
flip_cond = 0;
for i = 1:length(array_y) - 1
    if abs(array_y(i)) < 1e-99 % If the data is exactly zero, append to zero-chain tracker
        cons_zero = cons_zero + 1;
        zero_cond = 1;
    elseif (array_y(i) > 0 && array_y(i+1) < 0) || (array_y(i) < 0 && array_y(i+1) > 0) % If there is a change in sign, calculate the zero-passing point
        cons_zero = cons_zero + 1;
        zero_cond = 1;
        flip_cond = 1;
    else
        zero_cond = 0;
    end
    
    if cons_zero > 1 && zero_cond == 0 % If the zero-chain edge case occurs, calculate the mean point in x-space
        cons_zero = 0;
        zero_cond = 0;
        flip_cond = 0;
        zero_loc = (array_x(i-1) - array_x(i-cons_zero-1))/2 + array_x(i-cons_zero-1);
        extr_pos = [extr_pos zero_loc];
        extr_pos_i = [extr_pos_i i];
    elseif cons_zero == 1 && zero_cond == 0 && flip_cond == 1
        cons_zero = 0;
        zero_cond = 0;
        flip_cond = 0;
        slope = (array_y(i) - array_y(i-1))/(array_x(i) - array_x(i-1));
        interc = array_y(i) - slope*array_x(i);
        extr_pos = [extr_pos -interc/slope];
        extr_pos_i = [extr_pos_i i-1];
    end
end

end