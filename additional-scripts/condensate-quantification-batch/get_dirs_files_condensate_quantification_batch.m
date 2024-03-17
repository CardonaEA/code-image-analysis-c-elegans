function [selected_files, ndirs] = get_dirs_files_condensate_quantification_batch(identifiers)
%=== root dir
% root folder
dataI = struct;
dataI.root = cd;
dataI.sep = filesep;

if ~identifiers.mRNA_in_folder
    disp(newline)
    disp('selected mRNA image:')
    disp(identifiers.mRNA_filename)
end

selected_files = {};
%=== select folders
disp(newline)
disp('%=== select folder to process... ===%')
dataI.folder = uigetdir('select folder to process');
k = 1;
[selected_files{k}] = get_files_condensate_quantification_batch(dataI, identifiers);
disp('folder selected:')
disp(dataI.folder)
disp('smFISH images:')
disp(selected_files{k}.smFISH_images')
disp('segmentation workspaces:')
disp(selected_files{k}.segmentation_workspaces')
selected_files{k}.mRNA_in_folder = identifiers.mRNA_in_folder;
if identifiers.mRNA_in_folder
    disp('average mRNA image:')
    disp(selected_files{k}.mRNA_image')
else
    selected_files{k}.mRNA_path = identifiers.mRNA_path;
    selected_files{k}.mRNA_filename = identifiers.mRNA_filename;
end
disp(newline)

while dataI.folder
    disp('%=== select folder to process... ===%')
    dataI.folder = uigetdir('select folder to process');
    if dataI.folder
        k = k + 1;
        [selected_files{k}] = get_files_condensate_quantification_batch(dataI, identifiers);
        disp('folder selected:')
        disp(dataI.folder)
        disp('smFISH images:')
        disp(selected_files{k}.smFISH_images')
        disp('segmentation workspaces:')
        disp(selected_files{k}.segmentation_workspaces')
        selected_files{k}.mRNA_in_folder = identifiers.mRNA_in_folder;
        if identifiers.mRNA_in_folder
            disp('average mRNA image:')
            disp(selected_files{k}.mRNA_image')
        else
            selected_files{k}.mRNA_path = identifiers.mRNA_path;
            selected_files{k}.mRNA_filename = identifiers.mRNA_filename;
        end
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