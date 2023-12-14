function [selected_files, ndirs] = get_dirs_files_epi_analysis_batch(identifiers)
%=== root dir
% root folder
dataI = struct;
dataI.root = cd;
dataI.sep = filesep;

selected_files = {};
%=== folder with the higher-intensity images
disp(newline)
disp('%=== select the folder with higher-intensity images... ===%')
dataI.folder = uigetdir('select folder with higher-intensity images');
k = 1;
[selected_files{k}] = get_files_batch_normalized(dataI, identifiers);
disp('folder selected:')
disp(dataI.folder)
disp('GFP image:')
disp(selected_files{k}.GFP_image')
disp('cell outlines:')
disp(selected_files{k}.cell_outlines')
disp(newline)

while dataI.folder
    disp('%=== select a folder with lower-intensity images... ===%')
    dataI.folder = uigetdir('select folder with lower-intensity images');
    if dataI.folder
        k = k + 1;
        [selected_files{k}] = get_files_batch_normalized(dataI, identifiers);
        disp('folder selected:')
        disp(dataI.folder)
        disp('GFP image:')
        disp(selected_files{k}.GFP_image')
        disp('cell outlines:')
        disp(selected_files{k}.cell_outlines')
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