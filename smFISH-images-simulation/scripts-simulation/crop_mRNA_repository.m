function [img_fit_p, img_det_p, img_fit_p_wo_BGD, img_det_p_wo_BGD, flag_control] = crop_mRNA_repository(RNAi_mRNA, dim, xy_crop, z_crop, RNAi_image, BGD_to_substract, flag)

%[dim.Y, dim.X, dim.Z] = size(img);


% fit
y_coord = RNAi_mRNA.pos_fit_Y - xy_crop : RNAi_mRNA.pos_fit_Y + xy_crop;
x_coord = RNAi_mRNA.pos_fit_X - xy_crop : RNAi_mRNA.pos_fit_X + xy_crop;
z_coord = RNAi_mRNA.pos_fit_Z - z_crop  : RNAi_mRNA.pos_fit_Z + z_crop;

if flag.fit
    y_control = ismember([0 dim.Y+1], y_coord);
    x_control = ismember([0 dim.X+1], x_coord);
    z_control = ismember([0 dim.Z+1], z_coord);

    if ~sum([y_control x_control z_control])
        img_fit_p = RNAi_image(y_coord, x_coord, z_coord);
        img_fit_p_wo_BGD = img_fit_p; img_fit_p_wo_BGD(img_fit_p_wo_BGD < BGD_to_substract) = 0;
        flag_control.fit = 0; %disp('A')
    else
        img_fit_p = [];
        img_fit_p_wo_BGD = [];
        flag_control.fit = 1; %disp('B')
    end
else
    img_fit_p = RNAi_image(y_coord, x_coord, z_coord);
    img_fit_p_wo_BGD = img_fit_p; img_fit_p_wo_BGD(img_fit_p_wo_BGD < BGD_to_substract) = 0;
    flag_control.fit = 0; %disp('C')
end


% det
y_coord = RNAi_mRNA.pos_det_Y - xy_crop : RNAi_mRNA.pos_det_Y + xy_crop;
x_coord = RNAi_mRNA.pos_det_X - xy_crop : RNAi_mRNA.pos_det_X + xy_crop;
z_coord = RNAi_mRNA.pos_det_Z - z_crop  : RNAi_mRNA.pos_det_Z + z_crop;

if flag.det
    y_control = ismember([0 dim.Y+1], y_coord);
    x_control = ismember([0 dim.X+1], x_coord);
    z_control = ismember([0 dim.Z+1], z_coord);

    if ~sum([y_control x_control z_control])
        img_det_p = RNAi_image(y_coord, x_coord, z_coord);
        img_det_p_wo_BGD = img_det_p; img_det_p_wo_BGD(img_det_p_wo_BGD < BGD_to_substract) = 0;
        flag_control.det = 0; %disp('D')
    else
        img_det_p = [];
        img_det_p_wo_BGD = [];
        flag_control.det = 1; %disp('E')
    end
else
    img_det_p = RNAi_image(y_coord, x_coord, z_coord);
    img_det_p_wo_BGD = img_det_p; img_det_p_wo_BGD(img_det_p_wo_BGD < BGD_to_substract) = 0;
    flag_control.det = 0; %disp('F')
end

end