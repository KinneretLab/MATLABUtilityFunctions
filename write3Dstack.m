function write3Dstack (stack3D, fileName, Dir);
% function write3Dstack (stack3D, fileName, Dir);
% writes a multipage tiff images into fileName in directory Dir (if given)
if exist('Dir')
    cd(Dir)
end

first_frame = stack3D(:,:,1);
imwrite(first_frame,fileName,'tiff');
for i = 2:size(stack3D,3),
    next_frame = stack3D(:,:,i);
    imwrite(next_frame,fileName,'tiff','WriteMode','append');
end

end