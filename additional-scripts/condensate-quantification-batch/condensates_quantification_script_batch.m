%:::::::::::::::: condensate quantification batch ::::::::::::::::%
% (1) folders should contain: 
%  - MATLAB workspaces obtained in segmentation ("Dil_Coor..." .mat)
%  - raw smFISH images
% (2) optional:
%  - an average mRNA image (experimental PSF of single molecules)

%=== average mRNA image (experimental PSF)
mRNA_image_per_folder = 1;
% yes = 1, no = 0; window will appear to select one

%=== file identifiers
matlab_files_segmentation = '*Coor*';          % file identifier for MATLAB workspaces
image_files_smFISH        = 'w*smFISH';        % file identifier for smFISH images
% optional
average_mRNA_image        = 'exp_single_mol*'; % file identifier for mRNA image



% =====================
% === do not modify ===
% =====================
% cropping around center of average mRNA
pixels_from_xy_center = 10;
pixels_from_z_center  = 10;

% file identifiers
matlab_files_segmentation = [matlab_files_segmentation '.mat'];
image_files_smFISH        = [image_files_smFISH        '.tif'];
average_mRNA_image        = [average_mRNA_image        '.tif'];

% modify only if you need to change the microscope parameters
define_microscope_parameters = 0; % yes = 1, no = 0

%=== run
condensates_quantification_run_batch