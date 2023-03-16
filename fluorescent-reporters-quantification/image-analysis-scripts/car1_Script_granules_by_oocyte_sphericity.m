%% script to analyzed CAR-1 in live worms

% file identifiers
image_file.GFP  = '*.tif';
image_file.ROIs = 'MOD*Cells.csv';


% Segmentation parameters
clear parameters
parameters.quantile = 0.95; % BGD approximation quantile
% thresholding 
parameters.threshold_granules = 0.6; % values are between 0 and 1, one is likely to be a pixel that corresponds to granules
% excluding small objects
parameters.small_objects_size = 32; % objects smaller than the value will be excluded

% Description_ of _ stack
slides_out_of_focus = 0;    % yes = 1, No = 0
half_gonad          = 1;    % yes = 1, No = 0

pixel_size_in_x_and_y   = 0.0670922;    % micro meters
pixel_size_in_z         = 0.5;            % micro meters



% Flags for specific analysis
clear flags
flags.Gauss = 0; % 1 if BGD estimation should be performed


% =====================
% === do not modify ===
% =====================
parameters.ranking_mask_size = 2; % bigger numbers will increase speed but reduce accuracy in the shape of the condensate
parameters.components_conn = 6;
% parameters.threshold_granules_BGD_corrected = 0.6;
parameters.threshold_granules_BGD_corrected = parameters.threshold_granules;
parameters.Max_Bgd = parameters.threshold_granules_BGD_corrected + 0.05;
parameters.Min_Bgd = 0;
parameters.Bgd_Area = 5000;
parameters.show_Bgd_corr = 1;
% Image parameters (micro-meters)
parameters.pixel_size_xy = pixel_size_in_x_and_y; %
parameters.pixel_size_z  = pixel_size_in_z; %
parameters.voxel_size = parameters.pixel_size_xy * parameters.pixel_size_xy * parameters.pixel_size_z; %

blocks_processing.is_out_focus = slides_out_of_focus ;
blocks_processing.is_half = half_gonad;


%% RUN
car1_quantification_granules_by_oocyte_sphericity