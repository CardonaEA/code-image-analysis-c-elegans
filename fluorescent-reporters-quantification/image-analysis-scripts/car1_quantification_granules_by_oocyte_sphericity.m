%===== get the files
[selected_files] = get_files_car1_by_oocyte(image_file);

%===== Performing segmentation
info_image_to_analyze.fold = selected_files.Folder;
info_image_to_analyze.root = selected_files.root;
info_image_to_analyze.sep = selected_files.sep;

Cond_IDs = cell(1, length(selected_files.GFP_image));
CC = cell(1, length(selected_files.GFP_image));
BP = cell(1, length(selected_files.GFP_image));

T_merge_granules = [];
for i = 1 : length(selected_files.GFP_image)
    info_image_to_analyze.image = [selected_files.Folder selected_files.sep selected_files.GFP_image{i}];
    info_image_to_analyze.outlines = [selected_files.Folder selected_files.sep selected_files.cell_outlines{i}];
    info_image_to_analyze.name = selected_files.GFP_image{i};
    [T_granules, Cond_IDs{i}, CC{i}, BP{i}] = car1_Condensed_Analysis_by_oocyte_sphericity(info_image_to_analyze, parameters, blocks_processing);
    T_merge_granules = [T_merge_granules; T_granules];
end

if i>1
    writetable(T_merge_granules, [selected_files.Folder selected_files.sep 'Analysis_GFP_granules_MERGED' '.csv'])
end

cd(selected_files.Folder)
save(['WS_images_by_oocyte' '.mat'], 'Cond_IDs', 'CC')
cd(selected_files.root)

%=========================%
% cummulative intensities %
%=========================%

%===== Performing segmentation
T_merge = [];
for j = 1 : length(selected_files.GFP_image)
    info_image_to_analyze.image = [selected_files.Folder selected_files.sep selected_files.GFP_image{j}];
    info_image_to_analyze.outlines = [selected_files.Folder selected_files.sep selected_files.cell_outlines{j}];
    info_image_to_analyze.name = selected_files.GFP_image{j};
    [T_img] = car1_Condensed_Analysis_by_oocyte_dilute_BP(info_image_to_analyze, CC, j, flags, BP);
    T_merge = [T_merge; T_img];
end

if j>1
    writetable(T_merge, [selected_files.Folder selected_files.sep 'Analysis_GFP_local_conc_levels_MERGED' '.csv'])
end