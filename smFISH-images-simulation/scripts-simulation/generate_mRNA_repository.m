function [fit_8px, fit_5px, fit_4px, fit_8px_wo_BGD, fit_5px_wo_BGD, fit_4px_wo_BGD, det_8px, det_5px, det_4px, det_8px_wo_BGD, det_5px_wo_BGD, det_4px_wo_BGD, repository_mRNA_pos, repository_fit_values] = generate_mRNA_repository(pixel_size, image_Data, mRNA_positions, bgd_to_remove)

% ========= generate repository
data_image_loop.pathname = [image_Data.pathname_img image_Data.sep];
repository_size = size(mRNA_positions,1);

dataI = image_Data.files_IDs;

fit_8px = cell(repository_size,1);
fit_5px = cell(repository_size,1);
fit_4px = cell(repository_size,1);
fit_8px_wo_BGD = cell(repository_size,1);
fit_5px_wo_BGD = cell(repository_size,1);
fit_4px_wo_BGD = cell(repository_size,1);
det_8px = cell(repository_size,1);
det_5px = cell(repository_size,1);
det_4px = cell(repository_size,1);
det_8px_wo_BGD = cell(repository_size,1);
det_5px_wo_BGD = cell(repository_size,1);
det_4px_wo_BGD = cell(repository_size,1);
repository_mRNA_pos = cell(repository_size,2);
repository_fit_values =  [];

repository_pos_adj = 0;
BGD_to_substract = bgd_to_remove;

number_RNAi_images = length(dataI.raw);
for j = 1 : number_RNAi_images
    % load mRNA image
    data_image_loop.filename = dataI.raw{j};
    [RNAi_image] = load_mRNA_for_simulation(data_image_loop);
    [dim.Y, dim.X, dim.Z] = size(RNAi_image);

    % select position from table
    mRNA_positions_loop = mRNA_positions(string(mRNA_positions.Image) == data_image_loop.filename(1:end-4),:);
    repository_fit_values =  [repository_fit_values; mRNA_positions_loop];
    
    % repository position
    repository_pos = repository_pos_adj;
    % geting mRNA images
    number_RNAi_spots = size(mRNA_positions_loop,1);
    disp(newline)
    for k = 1 : number_RNAi_spots
        % by FQ fit
        RNAi_mRNA.pos_fit_Y = round(mRNA_positions_loop.Pos_Y(k)/pixel_size.xy);
        RNAi_mRNA.pos_fit_X = round(mRNA_positions_loop.Pos_X(k)/pixel_size.xy);
        RNAi_mRNA.pos_fit_Z = round(mRNA_positions_loop.Pos_Z(k)/pixel_size.z);
        % by FQ det
        RNAi_mRNA.pos_det_Y = mRNA_positions_loop.Y_det(k);
        RNAi_mRNA.pos_det_X = mRNA_positions_loop.X_det(k);
        RNAi_mRNA.pos_det_Z = mRNA_positions_loop.Z_det(k);
        flag.fit = 1; flag.det = 1;
        % mRNA imgs 8 pixels
        [img_fit_8, img_det_8, img_fit_8_wo_BGD, img_det_8_wo_BGD, flag] = crop_mRNA_repository(RNAi_mRNA, dim, 8, 3, RNAi_image, BGD_to_substract, flag);

        % mRNA imgs 5 pixels
        [img_fit_5, img_det_5, img_fit_5_wo_BGD, img_det_5_wo_BGD, flag] = crop_mRNA_repository(RNAi_mRNA, dim, 5, 3, RNAi_image, BGD_to_substract, flag);

        % mRNA imgs 4 pixels
        [img_fit_4, img_det_4, img_fit_4_wo_BGD, img_det_4_wo_BGD, flag] = crop_mRNA_repository(RNAi_mRNA, dim, 4, 3, RNAi_image, BGD_to_substract, flag);

        
        % repository_build
        disp(['iteration : ' num2str(repository_pos + k) ' of ' num2str(repository_size)])
        fit_8px{repository_pos + k} = img_fit_8;
        det_8px{repository_pos + k} = img_det_8;
        fit_8px_wo_BGD{repository_pos + k} = img_fit_8_wo_BGD;
        det_8px_wo_BGD{repository_pos + k} = img_det_8_wo_BGD;
        
        fit_5px{repository_pos + k} = img_fit_5;
        det_5px{repository_pos + k} = img_det_5;
        fit_5px_wo_BGD{repository_pos + k} = img_fit_5_wo_BGD;
        det_5px_wo_BGD{repository_pos + k} = img_det_5_wo_BGD;
        
        fit_4px{repository_pos + k} = img_fit_4;
        det_4px{repository_pos + k} = img_det_4;
        fit_4px_wo_BGD{repository_pos + k} = img_fit_4_wo_BGD;
        det_4px_wo_BGD{repository_pos + k} = img_det_4_wo_BGD;
        
        repository_mRNA_pos{repository_pos + k,1} = RNAi_mRNA;
        repository_mRNA_pos{repository_pos + k,2} = data_image_loop;
        
    end
    repository_pos_adj = repository_pos_adj + k;
end
