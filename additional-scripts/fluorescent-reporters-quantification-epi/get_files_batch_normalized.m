function [selected_files] = get_files_batch_normalized(dataI, identifiers)
%=== getting archives
cd(dataI.folder)
% identifiers
GFP_id              = identifiers.GFP;
cell_outlines_id    = identifiers.ROIs;

% getting taget files
GFP_image       = dir(GFP_id);                      GFP_image       = {GFP_image.name};
cells_outlines  = dir(cell_outlines_id);            cells_outlines  = {cells_outlines.name};

% remove '.' and '..' files
dataI.GFP_image         = GFP_image(~startsWith(GFP_image,{'.','..','._'}));
dataI.cell_outlines     = cells_outlines(~startsWith(cells_outlines,{'.','..','._'}));

% % back to working dir
% cd(dataI.root)

% out variable
selected_files = dataI;
end