function [selected_files] = get_files_epi_analysis(identifiers)
%=== Folder containing information to be analysed
disp(newline)
disp('select folder containing files to anlayze...')
dataI.folder = uigetdir('Select the folder containing files');
% root folder
dataI.root = cd;
dataI.sep = filesep;
cd(dataI.folder)

%=== getting archives
% identifiers
GFP_id              = identifiers.GFP;
cell_outlines_id    = identifiers.ROIs;

% getting taget files
GFP_image       = dir(GFP_id);                      GFP_image       = {GFP_image.name};
cells_outlines  = dir(cell_outlines_id);            cells_outlines  = {cells_outlines.name};

% remove '.' and '..' files
dataI.GFP_image         = GFP_image{~startsWith(GFP_image,{'.','..'})};
dataI.cell_outlines     = cells_outlines{~startsWith(cells_outlines,{'.','..'})};

% back to working dir
cd(dataI.root)

% out variable
selected_files = dataI;

disp(newline)
disp(['GFP image: ' dataI.GFP_image])
disp(['cell outlines: ' dataI.cell_outlines])
disp(newline)
end