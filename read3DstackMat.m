function mat_stack = read3DstackMat (Dir); 
% function tiff_stack = read3DstackDir (Dir);
% reads a directory of tiff images in directory Dir into tiff_stack
cd(Dir)
fileNames=dir ('*.mat*');

mat_stack = importdata(fileNames(1).name); % read in first image
%concatenate each successive tiff to tiff_stack
for ii = 2 : size(fileNames, 1)
    thisFile=fileNames(ii).name;
    thisIm=importdata(thisFile);
    mat_stack = cat(3 , mat_stack, thisIm);
end

end