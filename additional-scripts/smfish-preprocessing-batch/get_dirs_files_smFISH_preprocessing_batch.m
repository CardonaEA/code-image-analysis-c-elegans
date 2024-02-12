function [selected_files, ndirs] = get_dirs_files_smFISH_preprocessing_batch(identifiers)
%=== root dir
% root folder
dataI = struct;
dataI.root = cd;
dataI.sep = filesep;

selected_files = {};
%=== select folders
disp(newline)
disp('%=== select folder to pre-process... ===%')
dataI.folder = uigetdir('select folder to pre-process');
k = 1;
[selected_files{k}] = get_files_smFISH_preprocessing_batch(dataI, identifiers);
disp('folder selected:')
disp(dataI.folder)
disp('smFISH images:')
disp(selected_files{k}.smFISH_images')
disp('GFP images:')
disp(selected_files{k}.GFP_images')
disp(newline)

while dataI.folder
    disp('%=== select folder to pre-process... ===%')
    dataI.folder = uigetdir('select folder to pre-process');
    if dataI.folder
        k = k + 1;
        [selected_files{k}] = get_files_smFISH_preprocessing_batch(dataI, identifiers);
        disp('folder selected:')
        disp(dataI.folder)
        disp('smFISH images:')
        disp(selected_files{k}.smFISH_images')
        disp('GFP images:')
        disp(selected_files{k}.GFP_images')
        disp(newline)
    else
        disp('none selected')
        disp(newline)
    end
end

% number of experiments
ndirs = k;

% back to working dir
cd(dataI.root)
end