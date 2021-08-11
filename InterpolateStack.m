addpath ('\\phhydra\data-new\phhydra\data\analysis\users\Yonit\Layer Separation - Matlab\matlabCode');

image_dir='\\phhydra\data-new\phhydra\Analysis\users\Yonit\Layer Separation - Matlab\Examples\2018_10_22_pos4\Original_Files';

out_dir='\\phhydra\data-new\\phhydra\Analysis\users\Yonit\Layer Separation - Matlab\Examples\2018_10_22_pos4\US_Original_Files';

exp_name = '2018_10_22_pos4';

mkdir(out_dir);

cd (image_dir);

tpoints = dir('*.tiff*');

for j = 1:length(tpoints)
    
    % Read raw data for each time point
    
    fileName = [image_dir,'\',tpoints(j).name];
    image3D = read3Dstack (fileName,image_dir);
    
    V = double(image3D);
    
    [X1,Y1,Z1] = size(V);
    [X,Y,Z] = meshgrid((1:X1),(1:Y1),(1:Z1));
    x_res = 1;
    y_res = 1;
    z_res = 2;
    
    [Xq,Yq,Zq] = meshgrid(1:(X1*x_res),1:(Y1*y_res),1:(1/z_res):Z1);
    
    Vq = interp3(X,Y,Z,V,Xq,Yq,Zq);
    Vq_uint16= uint16(Vq);
    
    first_frame = Vq_uint16(:,:,1);
    
    t_point_name = strcat(exp_name,'_T_',num2str(j,'%03.f'),'.tiff');
    
    cd(out_dir);
    
    imwrite(first_frame,t_point_name,'tiff');
    
    for i = 2:((Z1-1)*z_res+1)
        
        next_frame = Vq_uint16(:,:,i);
        imwrite(next_frame,t_point_name,'WriteMode','append');
        
    end
end