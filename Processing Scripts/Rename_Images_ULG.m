%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This script will copy all images within a selected directory to a newly
%   created directory named "Renamed Files".  Then it will proceed to
%   organize all the images based on time delay and rename them
%   chronologically to the timepoints
%
%   Requires ULG_Array.m and a .ulg file
%
%   Written by Spencer Reisbick
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    [ Files, Path, Ext, ~ ] = ULG_Array();
    Sorted = Sort_ULG_Array(Files, 3);
    Files = Sorted(:, 6);
    Num = numel(num2str(length(Files)));
catch
    return
end

FolderRI = strcat(Path, 'Renamed_Images');
mkdir(FolderRI);                                                         %Creates new directory for copied files
FolderRI = strcat(FolderRI, '\');                   %Creates new path for the new directory

Vals = num2cell(1:1:length(Files));
Vals = cellfun(@(c) num2str(c), Vals, 'UniformOutput', false).';
L = cellfun('length',Vals);
L = Num-L;

h = waitbar(0, 'Please Wait...  Do not close');

for i = 1:length(Files)
    File = char(Files(i));
    This_File = strcat(File(1:end-4), '.tif');
    copyfile(strcat(Path, This_File), FolderRI);
    file = java.io.File(strcat(FolderRI, This_File));        %

    Zer = zeros(1, L(i));
    Zer = regexprep(num2str(Zer),'[^\w'']','');
    
    fileTo = java.io.File(strcat(FolderRI, Zer, Vals(i), This_File));
    file.renameTo(fileTo);                                       % This is the line which renames the files
        
    waitbar(i/(length(Files)));
end

close(h);

