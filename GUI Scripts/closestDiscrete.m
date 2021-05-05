% Find the cloesest value and its index in an array of given values
% compared to a given true value.

function [value, index] = closestDiscrete(trueVal, array)

closest = 1e999; % Comparison tracking variable (initially set to 1e999)
closesti = 0; % Tracking index of closest value.

for j = 1:length(array)
    if abs(array(j) - trueVal) < closest
        closest = abs(array(j) - trueVal);
        closesti = j;
    end
end

index = closesti;
value = array(index);

end