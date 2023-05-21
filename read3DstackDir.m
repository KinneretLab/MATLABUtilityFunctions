function im_stack = read3DstackDir (Dir,varargin)
% function tiff_stack = read3DstackDir (Dir,filetype,framenums);
% reads a directory of tiff images (default) or other file types in directory Dir into im_stack
cd(Dir)

if nargin==0
    fileNames=dir ('*.tif*');
    im_stack = importdata(fileNames(1).name); % read in first image
    %concatenate each successive tiff to tiff_stack
    for ii = 2 : size(fileNames, 1)
        thisFile=fileNames(ii).name;
        thisIm=importdata(thisFile);
        im_stack = cat(3 , im_stack, thisIm);
    end
else
    fileNames=dir (['*.',varargin{1},'*']);
    sortedFileNames = natsortfiles({fileNames.name});
    theseFileNames = sortedFileNames(varargin{2});
    im_stack = importdata(theseFileNames{1}); % read in first image
    %concatenate each successive tiff to tiff_stack
    for ii = 2 : size(theseFileNames,2)
        thisFile=theseFileNames{ii};
        thisIm=importdata(thisFile);
        im_stack = cat(3 , im_stack, thisIm);
    end

end