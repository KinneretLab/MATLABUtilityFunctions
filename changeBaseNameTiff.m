function changeBaseNameTiff(dir1,dir2,newbase,digitEnd),
% function changeBaseNameTiff(dir1,dir2,newbase,digitEnd)
% takes the files from dir1 and changes their name to dir2 into newbase
% with digitEnd
cd(dir1);
filenames=dir(['*.tif*']);

for i=1:length(filenames),
    oldFileName=filenames(i).name;
    cd(dir1); thisIm=importdata(oldFileName);
%     C = who('-file',oldFileName); 
    newFileName=[newbase,oldFileName(end-digitEnd-4:end-4),'tiff'];
    cd(dir2);     imwrite(thisIm,newFileName,'tiff');

end
