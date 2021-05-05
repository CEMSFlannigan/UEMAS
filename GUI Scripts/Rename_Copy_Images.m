function Rename_Copy_Images(Path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This script will copy all images within a selected directory to a newly
%   created directory named "Renamed Files".  Then it will proceed to
%   organize all the images based on time delay and rename them
%   chronologically to the timepoints
%
%   Requires Order_Images_By_Timepoints.m, Find_Curr_FileTime.m,
%   Extension_Input.m in order for the script to run properly.
%
%   If you would just like to move all files to a new directory this can be
%   done by selecting an extension which isn't available in the current
%   folder
%
%   Written by Spencer Reisbick
%
%   Restructured to function by Daniel Du
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[Path, Ext, Files] = All_Files('.dm3', Path);

New_place = strcat(Path, 'Renamed Images_', Ext(2:end));
mkdir(New_place);                                                         %Creates new directory for copied files
FolderRI = strcat(New_place, '\');                                        %Creates new path for the new directory

h = waitbar(0, 'Please Wait...  Copying Images to New Directory.');

% Files = Files(1:end, 2);

for j = 1:length(Files)
    copyfile(strcat(Path, char(Files(j))), FolderRI)                       %Copies all files to new directory
    waitbar(j/length(Files));
end
close(h);

disp(['Files have been copied and moved to ', FolderRI]);

Files = Order_Images_By_Timepoints(Files);                                  % Organizes all selected images by time delay
%disp(['Ordering Timepoints has finished, now renaming images in ', FolderRI]);

h = waitbar(0, 'Please Wait.  Renaming Files.');
for i = 1:length(Files)
    file = java.io.File(strcat(FolderRI, char(Files(i))));        %
    Hold = strcat(num2str(i), char(Files(i)));
    Files(i) = cellstr(Hold);           % This Section finds each filename in the organized array
    counter = numel(num2str(i));                                 % and renames it in the new directory.
    for j = 1:numel(num2str(length(Files)))-1                    % The for loop buffers the beginning of each name
        if counter < numel(num2str(length(Files)))               % with zeros relative to the number of digits in the number of images
            Temp = strcat('0', char(Files(i)));          %
            Files(i) = cellstr(Temp);
            counter = counter +1;                                %
        end
    end
    fileTo = java.io.File(strcat(FolderRI, char(Files(i))));
    file.renameTo(fileTo);                                       % This is the line which renames the files
    
    waitbar(i/length(Files));
end

close(h);

end
