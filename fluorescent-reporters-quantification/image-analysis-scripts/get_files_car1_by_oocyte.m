function [selected_files] = get_files_car1_by_oocyte(identifiers)
%% Folder containing information to be analysed
dataI.Folder = uigetdir('Select the folder containing files'); % folder for saving results
% root folder
dataI.root = cd;
cd(dataI.Folder)

%% Getting archives
% identifiers
GFP_id              = identifiers.GFP;
cell_outlines_id    = identifiers.ROIs;

% getting taget files
GFP_image       = dir(GFP_id);                      GFP_image       = {GFP_image.name};
cells_outlines  = dir(cell_outlines_id);            cells_outlines  = {cells_outlines.name};

% remove '.' and '..' files
dataI.GFP_image         = GFP_image(~startsWith(GFP_image,{'.','..'}));
dataI.cell_outlines     = cells_outlines(~startsWith(cells_outlines,{'.','..'}));

% back to working dir
cd(dataI.root)

% out variable
selected_files = dataI;

disp(newline)
disp('GFP image: ')
disp(dataI.GFP_image')
disp('cell outlines: ')
disp(dataI.cell_outlines')
disp(newline)
end


