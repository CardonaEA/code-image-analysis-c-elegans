function [selected_files] = get_files_segmentation_batch(dataI, identifiers)
%=== getting archives
cd(dataI.folder)
% identifiers
smFISH_id     = identifiers.smFISH;
smFISH_mat_id = identifiers.smFISH_mat;
GFP_id        = identifiers.GFP;
GFP_mat_id    = identifiers.GFP_mat;
outlines_id   = identifiers.outlines;

% getting taget files
smFISH_images     = dir(smFISH_id);     smFISH_images     = {smFISH_images.name};
GFP_images        = dir(GFP_id);        GFP_images        = {GFP_images.name};
smFISH_workspaces = dir(smFISH_mat_id); smFISH_workspaces = {smFISH_workspaces.name};
GFP_workspaces    = dir(GFP_mat_id);    GFP_workspaces    = {GFP_workspaces.name};
outlines          = dir(outlines_id);   outlines          = {outlines.name};

% remove '.' and '..' files
dataI.smFISH_images     = smFISH_images(~startsWith(smFISH_images,{'.','..','._'}));
dataI.GFP_images        = GFP_images(~startsWith(GFP_images,{'.','..','._'}));
dataI.smFISH_workspaces = smFISH_workspaces(~startsWith(smFISH_workspaces,{'.','..','._'}));
dataI.GFP_workspaces    = GFP_workspaces(~startsWith(GFP_workspaces,{'.','..','._'}));
dataI.outlines          = outlines(~startsWith(outlines,{'.','..','._'}));

% % back to working dir
% cd(dataI.root)

% out variable
selected_files = dataI;
end