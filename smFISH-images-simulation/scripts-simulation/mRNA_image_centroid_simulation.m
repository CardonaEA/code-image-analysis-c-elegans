function [center_mass, dim] = mRNA_image_centroid_simulation(avg_mRNA_c_image)

mRNA_image_to_place = avg_mRNA_c_image;
% image dimensions
[dim.Y, dim.X, dim.Z] = size(mRNA_image_to_place);

% % if want to reduce z dimension
% if dim.Z > 7
%     mRNA_image_to_place = mRNA_image_to_place(:,:,ceil(dim.Z/2)-3 : ceil(dim.Z/2)+3); % mRNA_Image_c = mRNA_Image_c(:,:,ceil(dim.Z/2)-2 : ceil(dim.Z/2)+2);
%     figure, montage(mRNA_image_to_place,'DisplayRange', []), colormap jet
%     [dim.Y, dim.X, dim.Z] = size(mRNA_image_to_place);
% end

N_pix                 = dim.X*dim.Y*dim.Z;
%- Generate vectors describing the image 
[Xs,Ys,Zs] = meshgrid(1:dim.X,1:dim.Y,1:dim.Z);

X1         = reshape(Xs,1,N_pix);
Y1         = reshape(Ys,1,N_pix);
Z1         = reshape(Zs,1,N_pix);

xdata = [];
% xdata(1,:) = double(X1)*pixel_size.xy;
% xdata(2,:) = double(Y1)*pixel_size.xy;
% xdata(3,:) = double(Z1)*pixel_size.z;
xdata(1,:) = double(X1);
xdata(2,:) = double(Y1);
xdata(3,:) = double(Z1);

% Reformating image to fit data-format of axis vectors
% ydata          = double(reshape(mRNA_image_to_place,1,N_pix));
%- Determine center of mass - starting point for center 
center_mass = ait_centroid3d_v3(double(mRNA_image_to_place),xdata);
center_mass = round(center_mass);

end
