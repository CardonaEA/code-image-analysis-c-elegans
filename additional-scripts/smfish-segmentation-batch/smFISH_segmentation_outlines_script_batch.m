%=== smFISH image analysis (segmentation) batch

%=== file identifiers
image_files_smFISH  = 'w*smFISH';  % file identifier for smFISH images
matlab_files_smFISH = 'WS*FISH';   % file identifier for smFISH matlab workspaces
image_files_GFP     = 'w*GFP';     % file identifier for GFP images
matlab_files_GFP    = 'WS*GFP';    % file identifier for GFP matlab workspaces
outline_files       = 'MOD*Cells'; % file identifier for outlines

%=== voxel size
pixel_size_in_x_and_y = 49;   % nanometers
pixel_size_in_z       = 250;  % nanometers

%=== acquisition parameters
emission           = 568;        % cy3 emission 
excitation         = 554;        % cy3 excitation
numerical_aperture = 1.4;        % numerical aperture
refractive_index   = 1.518;      % diffractive index
type_microscope    = 'confocal'; % type of microscope

%=== segmentation parameters
normalized_intensity_threshold_GFP    = 0.6; % normalized [0 - 1] intensity threshold: GFP
normalized_intensity_threshold_smFISH = 0.8; % normalized [0 - 1] intensity threshold: smFISH
volume_threshold_in_pixels            = 32;  % volume threshold segmentation (in pixels)
dilate_granules                       = 1;   % no = 0, yes = 1; condensates are dilated to include edges 

%=== outline settings
FQ_outline               = 0; % no = 0, yes = 1; outlines for FQ are outputs
removed_granules_outline = 0; % no = 0, yes = 1; creates images and outlines without granules
% alternative outline are always output

%=== output options
save_mat_file_with_segmentation = 1; % no = 0, yes = 1; segmented objects and coordinates are saved
save_segmented_images           = 0; % no = 0, yes = 1; whether segmented images are saved
show_local_bgd_removal          = 0; % no = 0, yes = 1; whether local bgd removal is shown



% =====================
% === do not modify ===
% =====================
%=== filtering for alternative masking ("2xGauss")
kernel_bgd_xy = 5;
kernel_bgd_z  = 5;
kernel_snr_xy = 0.1;
kernel_snr_z  = 0.1;

% file identifiers
image_files_smFISH  = [image_files_smFISH  '.tif'];
matlab_files_smFISH = [matlab_files_smFISH '.mat'];
image_files_GFP     = [image_files_GFP     '.tif'];
matlab_files_GFP    = [matlab_files_GFP    '.mat'];
outline_files       = [outline_files       '.csv'];

% segmentation parameters
% to modify additional segmentation parameters type:
% edit set_segmentation_parameters

%=== run
segment_and_generate_outlines_batch