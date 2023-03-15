function [BGD_max, avg_mRNA_c_image_PSF_reduced, mRNA_image_to_place, dim] = mRNA_image_reduce_PSF_simulation_3D(avg_mRNA_c_image, additional_BGD_to_substract_mRNA, center_mass, dim)

% reduce PSF
avg_mRNA_c_image_PSF_reduced = avg_mRNA_c_image;
BGD_max = min(avg_mRNA_c_image_PSF_reduced,[],'all');

%avg_mRNA_c_image_2(avg_mRNA_c_image_2 < min(avg_mRNA_c_image_2,[],'all')) = 0;
avg_mRNA_c_image_PSF_reduced(avg_mRNA_c_image_PSF_reduced < (BGD_max + additional_BGD_to_substract_mRNA)) = 0;

disp(newline)
disp(['BGD = ' num2str(BGD_max) ' ... BGD susbtracted = ' num2str(BGD_max + additional_BGD_to_substract_mRNA)])


% iamge to place
mRNA_image_to_place = avg_mRNA_c_image_PSF_reduced;

% ======= reduce z dim according to to image to place and center_mass(3) % center_z
% z limits mRNA_image_to_place
% A = max(mRNA_image_to_place,[],[1 2]);
xy_proj_mRNA = mean(mRNA_image_to_place,[1 2]);
xy_proj_mRNA = double(xy_proj_mRNA(:));
xy_proj_mRNA_pos = find(xy_proj_mRNA);
[S, L] = bounds(xy_proj_mRNA_pos); xy_proj_mRNA_pos = S + 1 : L - 1;
% ======= reduce x dim according to to image to place and center_mass(3) % center_z
xz_proj_mRNA = mean(mRNA_image_to_place,[1 3]);
% xz_proj_mRNA = double(xz_proj_mRNA(:));
xz_proj_mRNA_pos = find(xz_proj_mRNA); 
[S, L] = bounds(xz_proj_mRNA_pos); xz_proj_mRNA_pos = S - 0 : L + 0; % xz_proj_mRNA_pos = S - 1 : L + 1;
% ======= reduce x dim according to to image to place and center_mass(3) % center_z
yz_proj_mRNA = mean(mRNA_image_to_place,[2 3]);
% yz_proj_mRNA = double(yz_proj_mRNA(:));
yz_proj_mRNA_pos = find(yz_proj_mRNA);
[S, L] = bounds(yz_proj_mRNA_pos); yz_proj_mRNA_pos = S - 0 : L + 0; % yz_proj_mRNA_pos = S - 1 : L + 1;

% reduced image
mRNA_image_to_place = avg_mRNA_c_image_PSF_reduced(yz_proj_mRNA_pos,xz_proj_mRNA_pos,xy_proj_mRNA_pos);
% figure, imshow(max(mRNA_image_to_place,[],3), [], 'InitialMagnification','fit'), colormap jet

% new center mass x y z
center_mass_MOD.x = find(xz_proj_mRNA_pos == center_mass(1));
center_mass_MOD.y = find(yz_proj_mRNA_pos == center_mass(2));
center_mass_MOD.z = find(xy_proj_mRNA_pos == center_mass(3));

dim.xmin = center_mass_MOD.x - 1;
dim.ymin = center_mass_MOD.y - 1;
dim.zmin = center_mass_MOD.z - 1;

% new dim for palcing
[dim.Y, dim.X, dim.Z] = size(mRNA_image_to_place);

dim.xmax = dim.X - center_mass_MOD.x;
dim.ymax = dim.Y - center_mass_MOD.y;
dim.zmax = dim.Z - center_mass_MOD.z;

end