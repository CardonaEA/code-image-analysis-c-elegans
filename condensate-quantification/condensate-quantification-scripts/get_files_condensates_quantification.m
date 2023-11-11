function [dataI] = get_files_condensates_quantification(folder_back, files)
%===== load folder containing information for analysis
disp(newline)
disp('select the folder with the files for condensates quantification...')
disp('1. raw smFISH image')
disp('2. MATLAB workspace obtained during segmentation. i.e.: Dil_Coor...mat')
disp('3. averange mRNA image (experimental PSF of a single molecule)')

% folder_back = cd;
folder_files = uigetdir('select the folder with the files for analysis'); % folder for saving results
cd(folder_files)

%===== retrieving files
% workspace
Img_WS    = dir(files.matlab_ws);
Img_WS    = {Img_WS.name};
dataI.ws  = char(Img_WS(~startsWith(Img_WS,{'.','..','._'})));
% smFISH image
Imgs      = dir(files.FISH_img);
Imgs      = {Imgs.name};
dataI.raw = char(Imgs(~startsWith(Imgs,{'.','..','._'})));
% mRNA image
mRNA_img   = dir(files.mRNA_img);
mRNA_img   = {mRNA_img.name};
dataI.mRNA = char(mRNA_img(~startsWith(mRNA_img,{'.','..','._'})));
% folder data
dataI.folder  = folder_files;
dataI.root    = folder_back;
cd(folder_back)
dataI.sep = filesep;

disp(newline)
disp('folder info: ')
disp(dataI)
end