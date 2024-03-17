function [selected_files] = get_files_condensate_quantification_batch(dataI, identifiers)
%=== getting archives
cd(dataI.folder)
% identifiers
smFISH_id  = identifiers.smFISH;
seg_mat_id = identifiers.segmentation;

% getting taget files
smFISH_images           = dir(smFISH_id);  smFISH_images           = {smFISH_images.name};
segmentation_workspaces = dir(seg_mat_id); segmentation_workspaces = {segmentation_workspaces.name};

% remove '.' and '..' files
dataI.smFISH_images           = smFISH_images(~startsWith(smFISH_images,{'.','..','._'}));
dataI.segmentation_workspaces = segmentation_workspaces(~startsWith(segmentation_workspaces,{'.','..','._'}));

if identifiers.mRNA_in_folder
    % getting taget file
    mRNA_id   = identifiers.mRNA;
    mRNA_image = dir(mRNA_id); mRNA_image = {mRNA_image.name};
    % remove '.' and '..' files
    dataI.mRNA_image = mRNA_image(~startsWith(mRNA_image,{'.','..','._'}));
end

% % back to working dir
% cd(dataI.root)

% out variable
selected_files = dataI;
end