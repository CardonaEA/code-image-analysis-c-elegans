function [gfp, fish, analysis] = set_segmentation_parameters(options)
% structures
fish = struct;
gfp = struct;
analysis = struct;

% intensity, volume, dilation GFP
gfp.Int_Th = options.Int_Threshold_GFP;   % normalized [0 - 1] intensity threshold: GFP
gfp.Vol_Th = options.Volume_Threshold;    % volume threshold segmentation (in pixels)
gfp.dilate = options.Dilate_Granule;      % whether condensates are dilated to include edges
% intensity, volume, dilation smFISH
fish.Int_Th = options.Int_Threshold_FISH; % normalized [0 - 1] intensity threshold: smFISH
fish.Vol_Th = options.Volume_Threshold;   % volume threshold segmentation (in pixels)
fish.dilate = options.Dilate_Granule;     % whether condensates are dilated to include edges

% parameters local bgd removal GFP
gfp.Max_Bgd        = gfp.Int_Th + 0.05;   % max weak normalized [0 - 1] intensity threshold
gfp.Min_Bgd        = 0;                   % min weak normalized [0 - 1] intensity threshold
gfp.Bgd_Area       = 5000;                % volume threshold for large local bgd objects (in pixels)
gfp.show_Bgd_corr  = options.show_bgd_rm; % whether local bgd removal is shown
% parameters local bgd removal smFISH
fish.Max_Bgd       = fish.Int_Th - 0.05;  % max weak normalized [0 - 1] intensity threshold
fish.Min_Bgd       = 0;                   % min weak normalized [0 - 1] intensity threshold
fish.Bgd_Area      = 5000;                % volume threshold for large local bgd objects (in pixels)
fish.show_Bgd_corr = options.show_bgd_rm; % whether local bgd removal is shown

% parameters small objects det GFP
gfp.Int_Th_small    = gfp.Int_Th - 0.05;  % normalized [0 - 1] intensity threshold for small ojects: GFP
gfp.Vol_Th_small    = 300;                % volume threshold for small objects (in pixels)
% parameters small objects det smFISH
fish.Int_Th_small   = fish.Int_Th - 0.1;  % normalized [0 - 1] intensity threshold for small ojects: smFISH
fish.Vol_Th_small   = 300;                % volume threshold for small objects (in pixels)

% connected colponents
gfp.conn_comp  = 6;                       % connected components for object labeling
fish.conn_comp = 6;                       % connected components for object labeling

% outline preferences
analysis.FQ         = options.FQ_outline;       % FQ outlines as output
analysis.NoGranules = options.Exclude_Granules; % images and outlines without granules
analysis.ImageType  = 2;                        % 1: smFISH, 0: GFP, 2: GFP + smFISH

% alternative masking
analysis.Filt       = options.filter;
end