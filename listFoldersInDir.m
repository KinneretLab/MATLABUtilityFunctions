function [sortedFolderNames] = listFoldersInDir(thisDir)
% The function lists in alphabetical and numerical order all folder names
% within a directory.
files = dir(thisDir);
folders = files([files.isdir]);
sortedFolderNames = natsortfiles({folders.name});
index = cellfun(@(x) x(1)~= '.', sortedFolderNames , 'UniformOutput',1);
sortedFolderNames = sortedFolderNames(index);
end

