function [ Files ] = Order_Images_By_Timepoints( Files )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This function will take an input array of filenames and order them
%   according to the timepoints.  Filenames must include either ps or ns as
%   units in the file in order to properly sort.
%   
%   The script will work best if ps or ns appear exactly one time
%   immediately after the time.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Original = Files;                                                       % Makes a copy of array of files to be ordered
Array = zeros(1, length(Files));                                        % Create new array so array doesn't need to change size each iteration    
for i = 1:length(Files)
    String = Files{i};                                             % Parse through each file    
    Time = Find_Curr_FileTime(String);                                  % Finds the timepoint of the current file, see Find_Curr_FileTime.m
    Array(i) = Time;                                                    % Put time into array
end

Array = sort(Array);                                                    % Sort array of times

h = waitbar(0, 'Please Wait.  Currently Ordering Images.');
Steps = length(Files);

for j = 1:length(Files)                                                   
    for k = 1:length(Files)                 % This section finds when the time in the array matches the time on the file and arranges accordingly
        if or(or(isempty(strfind(Original{j}, strcat('_', num2str(Array(k)), 'ns','_')))==0, isempty(strfind(Original{j}, strcat('_', num2str(Array(k)), 'ps', '_'))) == 0), isempty(strfind(Original{j}, strcat('_', num2str(Array(k)), 'fs', '_'))) == 0); 
            Files{k} = Original{j};
        end
    end
    waitbar(j/Steps)
end
close(h)

end

