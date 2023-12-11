%% script to analyze reporters (epi - BATCH)

%==== file identifiers
image_files    = '*.tif';
outline_files  = 'MOD*Cells.csv';

%==== image voxel size
pixel_size_in_x_and_y = 0.1031746;    % micrometers
pixel_size_in_z       = 0.5;          % micrometers

%==== segmentation parameters
% background removal: bigger number will remove less BGD but it will give a better approximation of it
filter_size = 11;
% thresholding: values are between 0 and 1, one is likely to be a pixel that corresponds to granules
granule_threshold = 0.825; 
% excluding small objects: objects smaller than the value will be excluded
small_objects_size = 4; 



% =====================
% === do not modify ===
% =====================
% ranking parameters
ranking_mask_size = 2; % bigger numbers will increase speed but reduce accuracy in the shape of the condensate
components_conn   = 6;

% description of stack
slides_out_of_focus = 0;    % yes = 1, No = 0
half_gonad          = 0;    % yes = 1, No = 0

% run
analysis_granules_epi_batch