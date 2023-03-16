%=============== smiFISH image analysis (segmentation)
%% DEFINE segmentation parameters - Condensates analysis 3D and DEFINE Outlines preferences
[SegParameters_GFP, SegParameters_FISH, Analysis] = segmentation_parameters_smFISH_quantification(options);

%% Select Folder where files are, CSV outlines, WorkSpace with SDc variable and original image
%===== Getting archives
[dataI_GFP, dataI_FISH] = get_files_smFISH_quantification(cd, files);

%% loading block processing FISH
load([dataI_FISH.Folder dataI_FISH.sep dataI_FISH.ws], 'blocks_processing');
disp(newline)
disp(blocks_processing)

%% Extracting condensates pixel IDs
% --- segmentation GFP
[r_GFP, Raw_Image_c_GFP] = TSx_IDs_dil_v2_Segmentation(dataI_GFP, SegParameters_GFP, blocks_processing);
% Save outlined image for condensates
disp(newline)
disp(bwconncomp(r_GFP,6))
image_save_seg(Raw_Image_c_GFP, r_GFP, dataI_GFP, 'GFP_mask')

% --- segmentation FISH
[r_FISH, Raw_Image_c] = TSx_IDs_dil_v2_Segmentation(dataI_FISH, SegParameters_FISH, blocks_processing);
disp(bwconncomp(r_FISH,6))
image_save_seg(Raw_Image_c, r_FISH, dataI_FISH, 'FISH_mask')

%% Creating new mask, image intersection
Mask_GFP_FISH = r_GFP;
Mask_GFP_FISH(r_FISH) = 1;
disp(bwconncomp(Mask_GFP_FISH,6))
image_save_seg(Raw_Image_c, Mask_GFP_FISH, dataI_FISH, 'granules')

% %% New mask by cells
% % You can put dataI_FISH, SegParameters_FISH or dataI_GFP, SegParameters_GFP
% [var_Names, TS_i, Cond_IDs, CC, number_cells, Outlines_Cells] = TSx_IDs_dil_v4_Cells(dataI_FISH, SegParameters_GFP, Mask_GFP_FISH, Raw_Image_c);
% 
% %% Outlines generation
% tic
% [FQ_sites, CC, Cond_IDs] = Create_Outlines_FQ_v2(dataI_FISH, number_cells, Outlines_Cells, Mask_GFP_FISH, CC, Cond_IDs, SegParameters_FISH, Analysis, s);
% toc
% 
% %% Masked Image
% [Masked_Image] = Create_Masked_Image(Raw_Image_c, dataI_FISH, number_cells, Outlines_Cells, CC, Analysis, s);
% 
% %% Alternative Masking
% [Alternative_Masked_Image, Alternative_Filtered_Image] = Create_Alternative_Masked_Image(Raw_Image_c, dataI_FISH, number_cells, Outlines_Cells, CC, Analysis, s);
% 
% %% Save coordinates
% if options.Save_Coordinates
% cd(dataI_FISH.Folder)
% save(['Dil_Coor_FISH_GFP_' dataI_FISH.raw(1:end-4) '.mat'],'var_Names', 'TS_i', 'Cond_IDs', 'CC', 'number_cells', 'Outlines_Cells', 'FQ_sites', 'SegParameters_FISH', 'SegParameters_GFP', 'Analysis', 'dataI_FISH', 'dataI_GFP', 's')
% cd(dataI_FISH.root)
% end