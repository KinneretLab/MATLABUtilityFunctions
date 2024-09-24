function tiff_stack = read3Dstack (fileName, Dir) % Determine the number of image frames and the offset to the first image 
% reads a multipage tiff images from fileName in directory Dir (if given)
if exist('Dir', 'dir')
    cd(Dir)
end

tiff_info = imfinfo(fileName); % return tiff structure, one element per image
tiff_stack = imread(fileName, 1) ; % read in first image
%concatenate each successive tiff to tiff_stack
for ii = 2 : size(tiff_info, 1)
    temp_tiff = imread(fileName, ii);
    tiff_stack = cat(3 , tiff_stack, temp_tiff);
end

end