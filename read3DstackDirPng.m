function png_stack = read3DstackDirPng (Dir); 
% function png_stack = read3DstackDirPng (Dir);
% reads a directory of png images in directory Dir into png_stack
cd(Dir)
fileNames=dir ('*.png*');

png_stack = importdata(fileNames(1).name); % read in first image
%concatenate each successive png to png_stack
for ii = 2 : size(fileNames, 1)
    thisFile=fileNames(ii).name;
    thisIm=importdata(thisFile);
    png_stack = cat(3 , png_stack, thisIm);
end

end