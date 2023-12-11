%% script to analyze reporters (epi)

%==== file identifier
image_name = 'w1';

%==== image voxel size
parameters.pixel_size.xy = 0.1031746;  % micrometers
parameters.pixel_size.z = 0.5;         % micrometers

%==== segmentation parameters
% background removal: bigger number will remove less BGD but it will give a better approximation of it
parameters.filter_size = 11;
% thresholding: values are between 0 and 1, one is likely to be a pixel that corresponds to granules 
parameters.threshold_granules = 0.825;
% excluding small objects: objects smaller than the value will be excluded
parameters.small_objects_size = 4;



% =====================
% === do not modify ===
% =====================
% ranking parameters
parameters.ranking_mask_size = 2; % bigger numbers will increase speed but reduce accuracy in the shape of the condensate
parameters.components_conn = 6;
% file identifiers
image_file.GFP  = [image_name '.tif'];
image_file.ROIs = ['MOD_' image_name '_Cells.csv'];
% run
analysis_granules_epi