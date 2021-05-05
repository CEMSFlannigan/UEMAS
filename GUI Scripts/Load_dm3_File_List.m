function [dm3_files] = Load_dm3_File_List(Path)

%%% This function will load a list of file names within the specified path
%%% that are of the type dm3

%%% The argument 'Path' is of type string
%%% The output is a struct that contains file properties
%%% To access the list of file names, simply access dm3_files(i).name

dm3_files = dir([Path,'\*.dm3']);

end