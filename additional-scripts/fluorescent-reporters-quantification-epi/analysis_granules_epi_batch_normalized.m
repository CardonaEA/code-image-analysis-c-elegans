%===== set parameters structures
[parameters, blocks_processing, identifiers] = set_parameters_epi_analysis_normalized(filter_size, granule_threshold, small_objects_size, pixel_size_in_x_and_y, pixel_size_in_z, ranking_mask_size, components_conn, slides_out_of_focus, half_gonad, image_files, outline_files);

%===== get the files
[selected_files, ndirs] = get_dirs_files_epi_analysis_batch(identifiers);
% identifiers.paramaters_analysis =  parameters;

%===== performing analysis
%===== loop dirs
k = 1; % first selected folder (normalization ref)
info_image_to_analyze = struct;
info_image_to_analyze.folder = selected_files{k}.folder;
info_image_to_analyze.root = selected_files{k}.root;
info_image_to_analyze.sep = selected_files{k}.sep;

nimgs = length(selected_files{k}.GFP_image);
Cond_IDs = cell(1, nimgs);
CC = cell(1, nimgs);
BP = cell(1, nimgs);

merged_granules = [];
merged_ROIs = [];
merged_means = [];
merged_medians = [];
merged_modes = [];
for i = 1 : nimgs
    info_image_to_analyze.image = [selected_files{k}.folder selected_files{k}.sep selected_files{k}.GFP_image{i}];
    info_image_to_analyze.outlines = [selected_files{k}.folder selected_files{k}.sep selected_files{k}.cell_outlines{i}];
    info_image_to_analyze.name = selected_files{k}.GFP_image{i};
    [T_granules, T_ROIs, Cond_IDs{i}, CC{i}, BP{i}, img_mean, img_median, img_mode] = analysis_granules_by_oocyte_epi_normalization(info_image_to_analyze, parameters, blocks_processing);
    merged_granules = [merged_granules; T_granules];
    merged_ROIs = [merged_ROIs; T_ROIs];
    merged_means = [merged_means; img_mean];
    merged_medians = [merged_medians; img_median];
    merged_modes = [merged_modes; img_mode];
end
disp(newline)
disp('merging data and saving...')
if i>1
    writetable(merged_granules, [selected_files{k}.folder selected_files{k}.sep 'Analysis_GFP_granules_MERGED' '.csv'])
    writetable(merged_ROIs, [selected_files{k}.folder selected_files{k}.sep 'Analysis_ROIs_MERGED' '.csv'])
end
cd(selected_files{k}.folder)
save(['WS_images_by_oocyte' '.mat'], 'Cond_IDs', 'CC', 'normalization')
cd(selected_files{k}.root)
disp('...done')

%==== selecting normalization
switch normalization
    case 'mode'
        ref_int = mean(merged_modes);
    case 'median'
        ref_int = mean(merged_medians);
    case 'mean'
        ref_int = mean(merged_means);
    otherwise
        disp(newline)
        disp('warning: unexpected normalization. "mode" will be used')
        ref_int = mean(merged_modes);
end

%===== loop
for k = 2 : ndirs
% other folders (to normalize)
info_image_to_analyze = struct;
info_image_to_analyze.folder = selected_files{k}.folder;
info_image_to_analyze.root = selected_files{k}.root;
info_image_to_analyze.sep = selected_files{k}.sep;

nimgs = length(selected_files{k}.GFP_image);
Cond_IDs = cell(1, nimgs);
CC = cell(1, nimgs);
BP = cell(1, nimgs);

merged_granules = [];
merged_ROIs = [];
for i = 1 : nimgs
    info_image_to_analyze.image = [selected_files{k}.folder selected_files{k}.sep selected_files{k}.GFP_image{i}];
    info_image_to_analyze.outlines = [selected_files{k}.folder selected_files{k}.sep selected_files{k}.cell_outlines{i}];
    info_image_to_analyze.name = selected_files{k}.GFP_image{i};
    [T_granules, T_ROIs, Cond_IDs{i}, CC{i}] = analysis_granules_by_oocyte_epi_normalized(info_image_to_analyze, parameters, ref_int);
    merged_granules = [merged_granules; T_granules];
    merged_ROIs = [merged_ROIs; T_ROIs];
end
disp(newline)
disp('merging data and saving...')
if i>1
    writetable(merged_granules, [selected_files{k}.folder selected_files{k}.sep 'Analysis_GFP_granules_MERGED' '.csv'])
    writetable(merged_ROIs, [selected_files{k}.folder selected_files{k}.sep 'Analysis_ROIs_MERGED' '.csv'])
end
cd(selected_files{k}.folder)
save(['WS_images_by_oocyte' '.mat'], 'Cond_IDs', 'CC', 'normalization', 'ref_int')
cd(selected_files{k}.root)
disp('...done')
end
