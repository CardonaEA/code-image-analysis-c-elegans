%::::::::::::::::::: generate label matrix batch :::::::::::::::::::%
% (1) folders should contain: 
%  - MATLAB workspaces obtained in segmentation ("Dil_Coor..." .mat)
% (2) optional: 
%  - raw smFISH images

%=== file identifiers
matlab_files_segmentation = '*Coor*';   % file identifier for MATLAB workspaces
image_files_smFISH        = 'w*smFISH'; % file identifier for smFISH images (optional)



% =====================
% === do not modify ===
% =====================
% file identifiers
matlab_files_segmentation = [matlab_files_segmentation '.mat'];
image_files_smFISH        = [image_files_smFISH        '.tif'];

%=== run
label_matrix_run