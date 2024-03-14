function segment_and_generate_outlines(selected_files, dir_idx, img_idx, segmentation_parameters_GFP, segmentation_parameters_smFISH, analysis, acquisition, options)
% GFP struct
dataI_GFP = struct;
dataI_GFP.ws = selected_files{dir_idx}.GFP_workspaces{img_idx};
dataI_GFP.outline = selected_files{dir_idx}.outlines{img_idx};
dataI_GFP.raw = selected_files{dir_idx}.GFP_images{img_idx};
dataI_GFP.Folder = selected_files{dir_idx}.folder;
dataI_GFP.root = selected_files{dir_idx}.root;
dataI_GFP.sep = selected_files{dir_idx}.sep;
% smFISH struct
dataI_FISH = struct;
dataI_FISH.ws = selected_files{dir_idx}.smFISH_workspaces{img_idx};
dataI_FISH.outline = selected_files{dir_idx}.outlines{img_idx};
dataI_FISH.raw = selected_files{dir_idx}.smFISH_images{img_idx};
dataI_FISH.Folder = selected_files{dir_idx}.folder;
dataI_FISH.root = selected_files{dir_idx}.root;
dataI_FISH.sep = selected_files{dir_idx}.sep;

%=== load blocks processing variable
disp('loading workspace info...')
load([dataI_FISH.Folder dataI_FISH.sep dataI_FISH.ws], 'blocks_processing');

%=== extracting condensates pixel idx
% GFP segmentation
disp('segmenting GFP channel...')
[segmented_GFP, raw_GFP] = segment_and_rm_local_bdg(dataI_GFP, segmentation_parameters_GFP, blocks_processing);
if options.save_segmentation
    image_save_seg(raw_GFP, segmented_GFP, dataI_GFP, 'GFP_mask')
end

% smFISH segmentation
disp('segmenting smFISH channel...')
[segmented_FISH, raw_FISH] = segment_and_rm_local_bdg(dataI_FISH, segmentation_parameters_smFISH, blocks_processing);
if options.save_segmentation
    image_save_seg(raw_FISH, segmented_FISH, dataI_FISH, 'FISH_mask')
end

%=== create mask
disp('creating mask...')
mask = segmented_GFP;
mask(segmented_FISH) = 1;
if options.save_segmentation
    image_save_seg(raw_FISH, mask, dataI_FISH, 'granules')
end

%=== analysis by cell
disp('segmentation by cell...')
[var_Names, TS_i, Cond_IDs, CC, number_cells, Outlines_Cells] = segmentation_by_cell(dataI_FISH, segmentation_parameters_GFP, mask, raw_FISH);

%=== condensate dilation
if options.Dilate_Granule
    disp('performing condensate dilation...')
    [CC, Cond_IDs] = dilate_condensates(number_cells, mask, CC, Cond_IDs);
end

%=== outlines generation
[FQ_sites, CC, Cond_IDs] = create_outlines_FQ_v3(dataI_FISH, number_cells, Outlines_Cells, mask, CC, Cond_IDs, analysis, acquisition);

%=== masked image
[~] = create_masked_image_v2(raw_FISH, dataI_FISH, number_cells, Outlines_Cells, CC, analysis, acquisition);

%=== alternative masking
disp('generating alternative masking...')
[~, ~] = create_alternative_masked_image_v2(raw_FISH, dataI_FISH, number_cells, Outlines_Cells, CC, analysis, acquisition);

%=== save condensates idxs
if options.save_coordinates
    disp('saving matlab workspace with segmentation...')
    s = acquisition;
    cd(dataI_FISH.Folder)
    save(['Dil_Coor_FISH_GFP_' dataI_FISH.raw(1:end-4) '.mat'],'var_Names', 'TS_i', 'Cond_IDs', 'CC', 'number_cells', 'Outlines_Cells', 'FQ_sites', 'segmentation_parameters_smFISH', 'segmentation_parameters_GFP', 'analysis', 'dataI_FISH', 'dataI_GFP', 's', 'acquisition')
    cd(dataI_FISH.root)
end
end