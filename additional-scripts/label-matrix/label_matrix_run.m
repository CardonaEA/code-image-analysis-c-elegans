%=== organize inputs
[identifiers] = organize_inputs_label_matrix(matlab_files_segmentation, image_files_smFISH);

%=== retrieving dirs and files for analysis
[selected_files, ndirs] = get_dirs_files_label_matrix(identifiers);

%=== batch condensate quantification
%=== loop dirs
for k = 1 : ndirs
    % check data dim
    data_check = isequal(length(selected_files{k}.smFISH_images),...
        length(selected_files{k}.segmentation_workspaces));

    if data_check
        nimgs = length(selected_files{k}.smFISH_images);
        if nimgs
            for j = 1 : nimgs
                disp(newline)
                disp(['%=== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'workspace/image number ' num2str(j) ' of ' num2str(nimgs) '...'])
                label_matrix(selected_files, k, j, data_check)
            end
        end
    else
        matfiles = length(selected_files{k}.segmentation_workspaces);
        if matfiles
            for i = 1 : matfiles
                disp(newline)
                disp(['%=== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'workspace number ' num2str(i) ' of ' num2str(matfiles) '...'])
                label_matrix(selected_files, k, i, data_check)
            end
        else
            disp(newline)
            disp(['%=== processing folder ' num2str(k) ' of ' num2str(ndirs) '...'])
            disp('%=== Warning:')
            disp('%=== no matlab files in the folder')
            disp('%=== labelling cannot be performed.')
        end
    end
end
disp(newline)
disp('...done')