function [mRNA_positions, image_Data] = load_files_to_generate_mRNA_repository(id_for_mRNA_positions_file, id_for_image_files)
% ======= define folder containing mRNA position table
image_Data.root = cd;

disp(newline)
disp('select the folder containing mRNA positions table...')
image_Data.pathname_pos = uigetdir('mRNA positions FOLDER'); % folder for saving results
cd(image_Data.pathname_pos)

mRNAs_list = dir(['*' id_for_mRNA_positions_file '*.csv']);
dataI.mRNAs_pos = {mRNAs_list.name};
dataI.mRNAs_pos = dataI.mRNAs_pos{~startsWith(dataI.mRNAs_pos,{'.','..','._'})};


% ======= define folder containing images
disp(newline)
disp('select the folder containing the image files...')
image_Data.pathname_img = uigetdir('images FOLDER'); % folder for saving results
cd(image_Data.pathname_img)


% ========= list of smiFISH images for repository
image_list = dir(['*' id_for_image_files '*.tif']);

dataI.raw = {image_list.name};
dataI.raw = {dataI.raw{~startsWith(dataI.raw,{'.','..','._'})}};
cd(image_Data.root)


% ========= get mRNA positions
spots_data.Folder = image_Data.pathname_pos;
spots_data.mRNA_pos =  dataI.mRNAs_pos;
if ismac; sep = '/'; elseif ispc; sep = '\'; end
image_Data.sep = sep;

mRNA_positions = readtable([spots_data.Folder sep spots_data.mRNA_pos]);

disp(newline)
disp('positions:')
disp(unique(mRNA_positions.Image))
disp('images:')
disp(dataI.raw')

image_Data.files_IDs = dataI;
end