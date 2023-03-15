function [image_mRNAs_3D_sum, removed_mRNAs_sum] = generate_syn_image_simulation_from_repository_v3(pos_mRNAs, model_image_size, BGD_image, positions_in_oocyte, false_image, concentration, replicate, dim, mRNA_image_PSF_to_place, repository_intensity, BGD_max)
                
% 3D coordinates of random spots
[pos_mRNAs.y, pos_mRNAs.x, pos_mRNAs.z] = ind2sub([model_image_size.y model_image_size.x model_image_size.z], pos_mRNAs.list);

% image where to place mRNAs
image_mRNAs_3D_sum = BGD_image;

% position to erase mRNA our oocute
out_oocyte = positions_in_oocyte;
entire_image = false_image;
removed_mRNAs = zeros(1, length(pos_mRNAs.list));

% loop to mRNAs
number_cycles = length(pos_mRNAs.list);
disp(newline)

k = concentration;
j = replicate;

for i = 1 : number_cycles
    disp(['   concentration ' num2str(k) '  - replicate ' num2str(j) '  - placing ' num2str(i) ' of ' num2str(number_cycles)])
    % make sure is not out the image
    y_coor = pos_mRNAs.y(i) - dim.ymin : pos_mRNAs.y(i) + dim.ymax;
    y_coor = y_coor(y_coor>0 & y_coor<model_image_size.y);
    x_coor = pos_mRNAs.x(i) - dim.xmin : pos_mRNAs.x(i) + dim.xmax;
    x_coor = x_coor(x_coor>0 & x_coor<model_image_size.x);
    z_coor = pos_mRNAs.z(i) - dim.zmin : pos_mRNAs.z(i) + dim.zmax;
    z_coor = z_coor(z_coor>0 & z_coor<model_image_size.z);

    % make sure is within the oocyte
    entire_image(y_coor, x_coor, z_coor) = 1;
    entire_mRNA = find(entire_image);
    entire_image(y_coor, x_coor, z_coor) = 0;

    if sum(ismember(out_oocyte, entire_mRNA)) == (dim.Y * dim.X * dim.Z)
        % mRNA_image_to_place_wo_BGD = repository{pos_mRNAs.imgs(i)} - BGD_max;
        mRNA_image_to_place_wo_BGD = uint16(mRNA_image_PSF_to_place * repository_intensity(pos_mRNAs.imgs(i))) - BGD_max;
        image_mRNAs_3D_sum(y_coor, x_coor, z_coor) = image_mRNAs_3D_sum(y_coor, x_coor, z_coor) + mRNA_image_to_place_wo_BGD;
    else
        removed_mRNAs(i) = 1;
    end
end
removed_mRNAs_sum = sum(removed_mRNAs);

end