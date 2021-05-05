function [ Time, Unit] = Find_Curr_FileTime( Curr_File )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


Unit_Loc = strfind(Curr_File, 'ps_');                                  % Determine what units we are dealing with
Unit = 'ps';
if isempty(Unit_Loc) == 1                                                   
    if isempty(strfind(Curr_File, 'ns_')) == 0  
        Unit_Loc = strfind(Curr_File, 'ns_');
        Unit = 'ns';
    elseif isempty(strfind(Curr_File, 'fs_')) == 0
        Unit_Loc = strfind(Curr_File, 'fs_');
        Unit = 'fs';
    else
        errordlg('Please ensure files are either in ns, ps or fs');
        return
    end
end
Time_Loc = strfind(Curr_File, '_');                                    % Find all the Underscores to be used to find which is before time               

Holder = size(Time_Loc);                                            % Create a counter for a for loop       
New_Hold = 0;                                                       % Initialize variable to find which Time_loc will be
for l = 1:Holder(2)-1                                                   
    if Unit_Loc > Time_Loc(l) && Unit_Loc < Time_Loc(l+1)           % Condition for when Time_loc is correct spot                                        
         New_Hold = Time_Loc(l);                                                   
    end
end
        
Time = str2double(Curr_File(New_Hold+1:Unit_Loc-1));                % Output of the time point

end

