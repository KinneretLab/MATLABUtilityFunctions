function write4Dstack (stack4D, fileName, Dir);
% function write3Dstack (stack3D, fileName, Dir);
% writes a multipage tiff images into fileName in directory Dir (if given)
if exist('Dir')
    cd(Dir)
end


first_frame = stack4D(:,:,:,1); 
imwrite(first_frame,fileName,'tiff');
for i = 2:size(stack4D,4),
    next_frame = stack4D(:,:,:,i);
    imwrite(next_frame,fileName,'tiff','WriteMode','append');
end

end