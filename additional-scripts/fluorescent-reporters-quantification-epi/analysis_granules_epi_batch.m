%===== set parameters structures
[parameters, blocks_processing, image_file] = set_parameters_epi_analysis(filter_size, granule_threshold, small_objects_size, pixel_size_in_x_and_y, pixel_size_in_z, ranking_mask_size, components_conn, slides_out_of_focus, half_gonad, image_files, outline_files);

%===== get the files
[selected_files] = get_files_epi_analysis_batch(image_file);
image_file.paramaters_analysis =  parameters;

%===== performing analysis
info_image_to_analyze.folder = selected_files.folder;
info_image_to_analyze.root = selected_files.root;
info_image_to_analyze.sep = selected_files.sep;

Cond_IDs = cell(1, length(selected_files.GFP_image));
CC = cell(1, length(selected_files.GFP_image));
BP = cell(1, length(selected_files.GFP_image));

T_merge_granules = [];
T_merge_ROIs = [];
for i = 1 : length(selected_files.GFP_image)
    info_image_to_analyze.image = [selected_files.folder selected_files.sep selected_files.GFP_image{i}];
    info_image_to_analyze.outlines = [selected_files.folder selected_files.sep selected_files.cell_outlines{i}];
    info_image_to_analyze.name = selected_files.GFP_image{i};
    [T_granules, T_ROIs, Cond_IDs{i}, CC{i}, BP{i}] = analysis_granules_by_oocyte_epi(info_image_to_analyze, parameters, blocks_processing);
    T_merge_granules = [T_merge_granules; T_granules];
    T_merge_ROIs = [T_merge_ROIs; T_ROIs];
end
disp(newline)
disp('merging data and saving...')
if i>1
    writetable(T_merge_granules, [selected_files.folder selected_files.sep 'Analysis_GFP_granules_MERGED' '.csv'])
    writetable(T_merge_ROIs, [selected_files.folder selected_files.sep 'Analysis_ROIs_MERGED' '.csv'])
end
cd(selected_files.folder)
save(['WS_images_by_oocyte' '.mat'], 'Cond_IDs', 'CC')
cd(selected_files.root)
disp('...done')