%  ----------------- smFISH image analysis (segmentation)
%% File ID indicators
files = struct; % do not modify
files.FISH_img = 'Spn4'; % file indicator for smFISH image
files.FISH_ws  = 'FISH'; % file indicator for smFISH workspace
files.GFP      = 'GFP';  % file indicator for GFP image and workspace

%% Microscope parameters
% Define pixel size in nm
pixel_size = struct; % do not modify
pixel_size.xy = 49;  % pixel size in x and y
pixel_size.z  = 250; % pixel size in z

% Acquisition parameters
s = struct; % do not modify
s.Em    = 568;        % cy3 Emission 
s.Ex    = 554;        % cy3 Excitation
s.NA    = 1.4;        % Numerical aperture
s.RI    = 1.518;      % Diffractive index
s.type  = 'confocal'; % Microscope type
s.Pixel = pixel_size;

%% Segmentation parameters
options = struct; % do not modify
options.Int_Threshold_GFP  = 0.6; % Normalized [0 - 1] Intensity Threshold: GFP
options.Int_Threshold_FISH = 0.8; % Normalized [0 - 1] Intensity Threshold: smFISH
options.Volume_Threshold   = 32;  % Volume threshold for segmentation (in pixels)
options.Dilate_Granule     = 1;   % if 1, condensate are dilated to include edges 

%% Outlines settings
options.FQ_outline       = 0; % if 1, outlines for FQ are an output
options.Exclude_Granules = 0; % if 1, scripts creates images and outlines without granules
options.Save_Coordinates = 0; % if 1, segmented objects coordinates for are saved
options.Filt             = 0;

%% RUN
Segmentation_TEST