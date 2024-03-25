function [selected_files, ndirs] = get_dirs_files_label_matrix(identifiers)
%=== root dir
% root folder
dataI = struct;
dataI.root = cd;
dataI.sep = filesep;

selected_files = {};
%=== select folders
disp(newline)
disp('%=== select folder to process... ===%')
dataI.folder = uigetdir('select folder to process');
k = 1;
[selected_files{k}] = get_files_label_matrix(dataI, identifiers);
disp('folder selected:')
disp(dataI.folder)
disp('smFISH images:')
disp(selected_files{k}.smFISH_images')
disp('segmentation workspaces:')
disp(selected_files{k}.segmentation_workspaces')
disp(newline)

while dataI.folder
    disp('%=== select folder to process... ===%')
    dataI.folder = uigetdir('select folder to process');
    if dataI.folder
        k = k + 1;
        [selected_files{k}] = get_files_label_matrix(dataI, identifiers);
        disp('folder selected:')
        disp(dataI.folder)
        disp('smFISH images:')
        disp(selected_files{k}.smFISH_images')
        disp('segmentation workspaces:')
        disp(selected_files{k}.segmentation_workspaces')
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