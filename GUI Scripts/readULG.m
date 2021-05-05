function [ULGData, ULGFile] = readULG(ulgpath, InSituToggle)

% Takes a given path and ULG Filename and returns a cell array with
% relevant data taken from the ULG File

% Construct the file path, open the file, acquire the data delimited by
% white spaces, and close the file
ULGFile = fopen(ulgpath);
ULGRaw = textscan(ULGFile, '%s');
fclose(ULGFile);

% Open the raw data and remove the unnecessary rows
RawFilter = ULGRaw{1,1};
assignin('base','ULGRaw',RawFilter);
found = 0;
line = 1;
if InSituToggle == 1
    for i = 1:length(RawFilter)
        curLine = RawFilter{i};
        if length(curLine) >= 3 && isequal('1,',curLine(1:2)) && found == 0 % old script uses 0,1 in isequals, compare 3
            found = 1;
            line = i;
        end
    end
else
    for i = 1:length(RawFilter)
        curLine = RawFilter{i};
        if length(curLine) >= 3 && isequal('0,1',curLine(1:3)) && found == 0
            found = 1;
            line = i;
        end
    end
end
RawFilter = RawFilter(line:end,1);
assignin('base','ULGRawFiltered',RawFilter);

% Initiate the final cell array.
if InSituToggle == 1
    ULGData = cell(length(RawFilter)/5,7); % used to say 7 columns, -1 to length
else
    ULGData = cell(length(RawFilter),7); % used to say 7 columns, -1 to length
end

% % Loop through the entire raw data
% for i = 1:length(RawFilter)-1
%     % Create a delimited cell array of an individual cell component in the
%     % raw data
%     CellString = strsplit(RawFilter{i},',');
%     % Loop through the delimited cell array
%     for j = 1:length(CellString)
%         % Assign the data from the delimited cell array within the final
%         % cell array
%         if j ~= 6 && j ~= 7
%             ULGData{i,j} = str2num(CellString{j});
%         elseif j == 6'
%             index_ps = strfind(CellString{j},'ps');
%             newstring = CellString{j};
%             newstring = newstring(1:index_ps+1);
%             ULGData{i,j} = newstring;
%             %add = ['_' CellString{2} '_' CellString{2}];
%             %ULGData{i,j} = [newstring add];
%         else
%             ULGData{i,j} = CellString{j};
%         end
%     end
% end

if InSituToggle == 1
    % Loop through the entire raw data
    for i = 1:5:length(RawFilter) % used to be -1
        % Create a delimited cell array of an individual cell component in the
        % raw data
        ULGData{(i-1)/5+1,1} = i-1;
        CellString = strsplit(RawFilter{i},',');
        % Loop through the delimited cell array
        for j = 1:length(CellString)
            % Assign the data from the delimited cell array within the final
            % cell array
            if j ~= 5 && j ~= 6
                ULGData{(i-1)/5+1,j+1} = str2num(CellString{j});
            elseif j == 5
                index_ps = strfind(CellString{j},'ps');
                newstring = CellString{j};
                newstring = newstring(1:index_ps+1);
                ULGData{(i-1)/5+1,j+1} = newstring;
                %add = ['_' CellString{2} '_' CellString{2}];
                %ULGData{i,j} = [newstring add];
            else
                ULGData{(i-1)/5+1,j+1} = CellString{j};
            end
        end
    end
    
else
    
    % Loop through the entire raw data
    for i = 1:length(RawFilter) % used to be -1
        % Create a delimited cell array of an individual cell component in the
        % raw data
        CellString = strsplit(RawFilter{i},',');
        % Loop through the delimited cell array
        for j = 1:length(CellString)
            % Assign the data from the delimited cell array within the final
            % cell array
            if j ~= 6 && j ~= 7
                ULGData{i,j} = str2num(CellString{j});
            elseif j == 6
                index_ps = strfind(CellString{j},'ps');
                newstring = CellString{j};
                newstring = newstring(1:index_ps+1);
                ULGData{i,j} = newstring;
                add = ['_' CellString{2} '_' CellString{2}];
                ULGData{i,j} = [newstring add]; % Uncomment for Dan Cremon's old data
            else
                ULGData{i,j} = CellString{j};
            end
        end
    end
    
end

%ULGData(:,3) = circshift(ULGData(:,3),0); % REMOVE FOR ANY SCANS NOT TAKEN ON 03/15/2019

end