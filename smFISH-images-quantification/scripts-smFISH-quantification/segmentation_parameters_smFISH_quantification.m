function [SegParameters_GFP, SegParameters_FISH, Analysis] = segmentation_parameters_smFISH_quantification(options)
%======= DEFINE segmentation parameters - Condensates analysis 3D
SegParameters_FISH = struct;
SegParameters_GFP = struct;
% Intensity, vol and dilate GFP
SegParameters_GFP.Int_Th = options.Int_Threshold_GFP; % Normalized [0 -1] Intensity Threshold
SegParameters_GFP.Vol_Th = options.Volume_Threshold; % Volume Threshold (in pixels)
SegParameters_GFP.dilate = options.Dilate_Granule; % Make sure condensate borders are included
% Intensity, vol and dilate FISH
SegParameters_FISH.Int_Th = options.Int_Threshold_FISH; % Normalized [0 -1] Intensity Threshold
SegParameters_FISH.Vol_Th = options.Volume_Threshold; % Volume Threshold (in pixels)
SegParameters_FISH.dilate = options.Dilate_Granule; % Make sure condensate borders are included
% BGD parameters GFP
SegParameters_GFP.Max_Bgd = SegParameters_GFP.Int_Th + 0.05;
SegParameters_GFP.Min_Bgd = 0;
SegParameters_GFP.Bgd_Area = 5000;
SegParameters_GFP.show_Bgd_corr = 1;
% BGD parameters FISH
SegParameters_FISH.Max_Bgd = SegParameters_FISH.Int_Th - 0.05;
SegParameters_FISH.Min_Bgd = 0;
SegParameters_FISH.Bgd_Area = 5000;
SegParameters_FISH.show_Bgd_corr = 1;
% Small granules parameters GFP
SegParameters_GFP.Int_Th_small = SegParameters_GFP.Int_Th - 0.05;
SegParameters_GFP.Vol_Th_small = 300;
% Small granules parameters FISH
SegParameters_FISH.Int_Th_small = SegParameters_FISH.Int_Th - 0.1;
SegParameters_FISH.Vol_Th_small = 300;
% saving parameters GFP
SegParameters_GFP.old_Version = 0; % = 1 uses '\' to in path manes, and adapts line codes to older matlab versions
% saving parameters FISH
SegParameters_FISH.old_Version = 0; % = 1 uses '\' to in path manes, and adapts line codes to older matlab versions

%===== DEFINE Outlines preferences
Analysis = struct;
Analysis.FQ = options.FQ_outline; % if 1 outlines for FQ are output
Analysis.NoGranules = options.Exclude_Granules; % to create images and outlines without granules
Analysis.ImageType = 2; % if FISH  = 1, if GFP = 0, GFP + FISH = 2;
% alternative masking
Analysis.Filt = options.Filt;
end