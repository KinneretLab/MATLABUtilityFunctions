function changeBaseNameMat(dir1,dir2,newbase,digitEnd),

cd(dir1);
filenames=dir(['*.mat']);

for i=1:length(filenames),
    oldFileName=filenames(i).name;
    cd(dir1); load(oldFileName);
    C = who('-file',oldFileName); 
    newFileName=[newbase,oldFileName(end-digitEnd-4:end-4)];
    cd(dir2); save(newFileName,C{:});
end
