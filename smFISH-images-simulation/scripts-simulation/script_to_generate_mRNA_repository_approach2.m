% =========== script to generate mRNA images repository (Approach # 2)

% pixel size of images
pixel_size = struct;
pixel_size.xy = 49;
pixel_size.z = 250;

% keyword to identiify images and tables for anlysis 
id_for_mRNA_positions_file = 'L44440'; % .csv file
id_for_image_files         = 'distal'; % tiff images

% (a) .csv file with columns: "Image", "Pos_Y", "Pos_X", "Pos_Z", "Y_det", "X_det", "Z_det" (i.e.: obtained using FISH-quant)  
% Image: names should match images where mRNAs are extracted 
% Pos_Y, _X, and _Z: mRNA positions in nm
% Y_, X_, and Z_det: mRNA position in px index

% (b) images corresponding to positions given in a


% ======= load files to generate repository
[mRNA_positions, image_Data] = load_files_to_generate_mRNA_repository(id_for_mRNA_positions_file, id_for_image_files);

% ========= generate repository
BGD_to_substract = 96;

[repository_mRNA_fit_8_pix, repository_mRNA_fit_5_pix, repository_mRNA_fit_4_pix,...
    repository_mRNA_fit_8_pix_wo_BGD, repository_mRNA_fit_5_pix_wo_BGD, repository_mRNA_fit_4_pix_wo_BGD,...
    repository_mRNA_det_8_pix, repository_mRNA_det_5_pix, repository_mRNA_det_4_pix,...
    repository_mRNA_det_8_pix_wo_BGD, repository_mRNA_det_5_pix_wo_BGD, repository_mRNA_det_4_pix_wo_BGD,...
    repository_mRNA_positions, repository_fit_values] = generate_mRNA_repository(pixel_size, image_Data, mRNA_positions, BGD_to_substract);

disp(newline)
disp('select the folder to save repository...')
cd(uigetdir('select the folder to save repository...'))
save('mRNA_repository_approach2.mat', 'image_Data',...
    'repository_mRNA_fit_8_pix', 'repository_mRNA_fit_5_pix', 'repository_mRNA_fit_4_pix',...
    'repository_mRNA_fit_8_pix_wo_BGD', 'repository_mRNA_fit_5_pix_wo_BGD', 'repository_mRNA_fit_4_pix_wo_BGD',...
    'repository_mRNA_det_8_pix', 'repository_mRNA_det_5_pix', 'repository_mRNA_det_4_pix',...
    'repository_mRNA_det_8_pix_wo_BGD', 'repository_mRNA_det_5_pix_wo_BGD', 'repository_mRNA_det_4_pix_wo_BGD',...
    'repository_mRNA_positions', 'repository_fit_values')
cd(image_Data.root)