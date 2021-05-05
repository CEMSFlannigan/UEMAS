function [Path, Ext, Files] = All_Files(Ext, Path)
%Loads all the files of a specific directory with designated extension into an array.
% Written by Spencer Reisbeck
% Edited by Daniel Du

%     try
%         %'S:\DanielD\RepRate Study\2017_05_30\Run_01_NS\Renamed_dm3'
%         start = uigetdir();
%         if start == 0
%             errordlg('No Path Was Selected');
%             return
%         end
%         Path = strcat(start, '\');
%     catch
%         errordlg('Error loading Files');
%         return
%     end

    %Ext = Extension_Input; 
    Files = dir([Path '*' Ext]);   % Create Array of all Files in Directory
    
    %Files = Order_Images_By_Timepoints(Files);
    
    Ext = strrep(Ext, '\*', '.');

    Files = struct2cell(Files);
    Files = transpose(Files);
    Files = Files(1:end, 1);
    
end

