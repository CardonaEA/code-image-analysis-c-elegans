%=== get parameters
[parameters, blocks_processing, identifiers] = set_parameters_smFISH_preprocessing_batch(image_files_smFISH, image_files_GFP, is_stack_out_of_focus, quantile_BGD_subtraction, ranking_mask_size);

%=== get dirs and files
[selected_files, ndirs] = get_dirs_files_smFISH_preprocessing_batch(identifiers);

%=== performing image ranking
%===== loop dirs
for k = 1 : ndirs
    disp(newline)
    % smFISH
    nimgs = length(selected_files{k}.smFISH_images);
    if nimgs
        for j = 1 : nimgs
            disp(['%== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'smFISH image number ' num2str(j) ' of ' num2str(nimgs) '...'])
            image_Data = struct;
            image_Data.root = selected_files{k}.root;
            image_Data.sep = selected_files{k}.sep;
            image_Data.pathname = [selected_files{k}.folder selected_files{k}.sep];
            image_Data.filename = selected_files{k}.smFISH_images{j};
            image_Data.ImageType = 'FISH';
            image_ranking_batch(image_Data, blocks_processing, parameters);
        end
    end
    % GFP
    nimgs = length(selected_files{k}.GFP_images);
    if nimgs
        for j = 1 : nimgs
            disp(['%== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'GFP image number ' num2str(j) ' of ' num2str(nimgs) '...'])
            image_Data = struct;
            image_Data.root = selected_files{k}.root;
            image_Data.sep = selected_files{k}.sep;
            image_Data.pathname = [selected_files{k}.folder selected_files{k}.sep];
            image_Data.filename = selected_files{k}.GFP_images{j};
            image_Data.ImageType = 'GFP';
            image_ranking_batch(image_Data, blocks_processing, parameters);
        end
    end
end
disp(newline)
disp('...done')