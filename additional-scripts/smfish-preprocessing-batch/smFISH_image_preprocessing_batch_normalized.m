%=== get parameters
[parameters, blocks_processing, identifiers] = set_parameters_smFISH_preprocessing_batch(image_files_smFISH, image_files_GFP, is_stack_out_of_focus, quantile_BGD_subtraction, ranking_mask_size);

%=== get dirs and files
[selected_files, ndirs] = get_dirs_files_smFISH_preprocessing_batch(identifiers);

%=== performing image ranking
%===== loop dirs
k = 1;
disp(newline)
% smFISH
nimgs = length(selected_files{k}.smFISH_images);
referece_smFISH = nimgs;
means_smFISH   = zeros([nimgs,1]);
medians_smFISH = zeros([nimgs,1]);
modes_smFISH   = zeros([nimgs,1]);
if nimgs
    for j = 1 : nimgs
        disp(['%== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'smFISH image number ' num2str(j) ' of ' num2str(nimgs) '...'])
        image_Data = struct;
        image_Data.root = selected_files{k}.root;
        image_Data.sep = selected_files{k}.sep;
        image_Data.pathname = [selected_files{k}.folder selected_files{k}.sep];
        image_Data.filename = selected_files{k}.smFISH_images{j};
        image_Data.ImageType = 'FISH';
        [means_smFISH(j), medians_smFISH(j), modes_smFISH(j)] = image_ranking_batch_normalization(image_Data, blocks_processing, parameters);
    end
end
% GFP
nimgs = length(selected_files{k}.GFP_images);
referece_GFP = nimgs;
means_GFP   = zeros([nimgs,1]);
medians_GFP = zeros([nimgs,1]);
modes_GFP   = zeros([nimgs,1]);
if nimgs
    for j = 1 : nimgs
        disp(['%== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'GFP image number ' num2str(j) ' of ' num2str(nimgs) '...'])
        image_Data = struct;
        image_Data.root = selected_files{k}.root;
        image_Data.sep = selected_files{k}.sep;
        image_Data.pathname = [selected_files{k}.folder selected_files{k}.sep];
        image_Data.filename = selected_files{k}.GFP_images{j};
        image_Data.ImageType = 'GFP';
        [means_GFP(j), medians_GFP(j), modes_GFP(j)] = image_ranking_batch_normalization(image_Data, blocks_processing, parameters);
    end
end

% normalization
if ndirs > 1
    switch normalization
        case 'mode'
            ref_smFISH = mean(modes_smFISH);
            ref_GFP    = mean(modes_GFP);
        case 'median'
            ref_smFISH = mean(medians_smFISH);
            ref_GFP    = mean(medians_GFP);
        case 'mean'
            ref_smFISH = mean(means_smFISH);
            ref_GFP    = mean(means_GFP);
        otherwise
            disp(newline)
            disp('warning: unexpected normalization. "mode" will be used')
            ref_smFISH = mean(modes_smFISH);
            ref_GFP    = mean(modes_GFP);
    end
end

% loop normalization
for k = 2 : ndirs
    disp(newline)
    disp('normalizing...')
    disp(newline)
    % smFISH
    nimgs = length(selected_files{k}.smFISH_images);
    if nimgs && referece_smFISH
        for j = 1 : nimgs
            disp(['%== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'smFISH image number ' num2str(j) ' of ' num2str(nimgs) '...'])
            image_Data = struct;
            image_Data.root = selected_files{k}.root;
            image_Data.sep = selected_files{k}.sep;
            image_Data.pathname = [selected_files{k}.folder selected_files{k}.sep];
            image_Data.filename = selected_files{k}.smFISH_images{j};
            image_Data.ImageType = 'FISH';
            image_ranking_batch_normalized(image_Data, parameters, ref_smFISH)
        end
    elseif nimgs && ~referece_smFISH
        disp(newline)
        disp('%=== Warning:')
        disp(['%=== There are not smFISH images named ' image_files_smFISH(1:end-4) ' in the first folder.'])
        disp('%=== Normalization cannot be performed.')
    end
    % GFP
    nimgs = length(selected_files{k}.GFP_images);
    if nimgs && referece_GFP
        for j = 1 : nimgs
            disp(['%== processing folder ' num2str(k) ' of ' num2str(ndirs) ' - ' 'GFP image number ' num2str(j) ' of ' num2str(nimgs) '...'])
            image_Data = struct;
            image_Data.root = selected_files{k}.root;
            image_Data.sep = selected_files{k}.sep;
            image_Data.pathname = [selected_files{k}.folder selected_files{k}.sep];
            image_Data.filename = selected_files{k}.GFP_images{j};
            image_Data.ImageType = 'GFP';
            image_ranking_batch_normalized(image_Data, parameters, ref_GFP)
        end
    elseif nimgs && ~referece_GFP
        disp(newline)
        disp('%=== Warning:')
        disp(['%=== There are not GFP images named ' image_files_GFP(1:end-4) ' in the first folder.'])
        disp('%=== Normalization cannot be performed.')
    end
end
disp(newline)
disp('...done')