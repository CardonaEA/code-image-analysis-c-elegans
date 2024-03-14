%=== organize initial parameters in structures
[identifiers, pixel_size, acquisition, options, filter_options] = organize_inputs_segmentation_batch(...
    image_files_smFISH, matlab_files_smFISH, image_files_GFP, matlab_files_GFP, outline_files,...
    pixel_size_in_x_and_y, pixel_size_in_z,...
    emission, excitation, numerical_aperture, refractive_index, type_microscope,...
    normalized_intensity_threshold_GFP, normalized_intensity_threshold_smFISH, volume_threshold_in_pixels, dilate_granules,...
    FQ_outline, removed_granules_outline,...
    save_mat_file_with_segmentation, save_segmented_images, show_local_bgd_removal,...
    kernel_bgd_xy, kernel_bgd_z, kernel_snr_xy, kernel_snr_z);

%=== set segmentation parameters and outlines preferences
[segmentation_parameters_GFP, segmentation_parameters_smFISH, analysis] = set_segmentation_parameters(options);

%=== get dirs and files
[selected_files, ndirs] = get_dirs_files_segmentation_batch(identifiers);

%=== batch image segmentation - outlines
%===== loop dirs
for k = 1 : ndirs
    % check data dim
    data_check = isequal(length(selected_files{k}.smFISH_images),...
        length(selected_files{k}.GFP_images),...
        length(selected_files{k}.smFISH_workspaces),...
        length(selected_files{k}.GFP_workspaces),...
        length(selected_files{k}.outlines));

    if data_check
        nimgs = length(selected_files{k}.smFISH_images);
        if nimgs
            for j = 1 : nimgs
                disp(newline)
                disp(['%=== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'image number ' num2str(j) ' of ' num2str(nimgs) '...'])
                segment_and_generate_outlines(selected_files, k, j, segmentation_parameters_GFP, segmentation_parameters_smFISH, analysis, acquisition, options)  
            end
        end
    else
        disp(newline)
        disp(['%=== processing folder ' num2str(k) ' of ' num2str(ndirs) '...'])
        disp('%=== Warning:')
        disp('%=== number of images, matlab files, and otlines do not match ')
        disp('%=== segmentation cannot be performed.')
    end
end
disp(newline)
disp('...done')