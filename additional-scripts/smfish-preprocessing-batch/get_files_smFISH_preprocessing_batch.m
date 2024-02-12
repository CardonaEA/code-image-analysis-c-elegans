function [selected_files] = get_files_smFISH_preprocessing_batch(dataI, identifiers)
%=== getting archives
cd(dataI.folder)
% identifiers
smFISH_id = identifiers.smFISH;
GFP_id    = identifiers.GFP;

% getting taget files
smFISH_images = dir(smFISH_id); smFISH_images = {smFISH_images.name};
GFP_images    = dir(GFP_id);    GFP_images    = {GFP_images.name};

% remove '.' and '..' files
dataI.smFISH_images = smFISH_images(~startsWith(smFISH_images,{'.','..','._'}));
dataI.GFP_images    = GFP_images(~startsWith(GFP_images,{'.','..','._'}));

% % back to working dir
% cd(dataI.root)

% out variable
selected_files = dataI;
end