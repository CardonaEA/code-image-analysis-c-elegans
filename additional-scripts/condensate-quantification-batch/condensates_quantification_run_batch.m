%=== organize inputs
[identifiers, crop, par_microscope] = organize_inputs_condensate_quantification_batch(mRNA_image_per_folder,...
    matlab_files_segmentation, image_files_smFISH, average_mRNA_image,...
    pixels_from_xy_center, pixels_from_z_center,...
    define_microscope_parameters);

%===== retrieving dirs and files for analysis
[selected_files, ndirs] = get_dirs_files_condensate_quantification_batch(identifiers);

%=== batch condensate quantification
%===== loop dirs
for k = 1 : ndirs
    % check data dim
    data_check = isequal(length(selected_files{k}.smFISH_images),...
        length(selected_files{k}.segmentation_workspaces));
    if identifiers.mRNA_in_folder
        mRNA_check = isequal(1, length(selected_files{k}.mRNA_image));
    end

    if ~identifiers.mRNA_in_folder
        mRNA_check = ~isequal(selected_files{k}.mRNA_filename, 0);
    end

    if data_check & mRNA_check
        nimgs = length(selected_files{k}.smFISH_images);
        if nimgs
            for j = 1 : nimgs
                disp(newline)
                disp(['%=== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'image number ' num2str(j) ' of ' num2str(nimgs) '...'])
                quantify_condensates(selected_files, k, j, par_microscope, crop)
            end
        end
    else
        disp(newline)
        disp(['%=== processing folder ' num2str(k) ' of ' num2str(ndirs) '...'])
        disp('%=== Warning:')
        disp('%=== option 1: number of images and matlab files do not match')
        disp('%=== option 2: there is no an mRNA image or there are more than one')
        disp('%=== quantification cannot be performed.')
    end
end
disp(newline)
disp('...done')