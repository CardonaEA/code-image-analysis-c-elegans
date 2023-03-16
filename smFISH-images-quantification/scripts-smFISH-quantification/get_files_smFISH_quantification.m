function [dataI_GFP, dataI_FISH] = get_files_smFISH_quantification(folder_back, files)
%========= Select Folder where files are, CSV outlines, WorkSpace with SDc variable and original image
disp(newline)
disp('Select the folder containing the files segmentation ...')
disp('1. smFISH channel')
disp('2. GFP channel')
disp('3. WS smiFISH image preprocessing')
disp('4. WS GFP image preprocessing')
disp('5. MOD smFISH or GFP channel Cells (outlines)')

% folder_back = cd;
folder_Files = uigetdir('Select the folder containing files'); % folder for saving results
cd(folder_Files)

%========== Getting archives
% workspace
Img_WS_GFP    = dir(['*' files.GFP '*.mat']);
Img_WS_GFP    = {Img_WS_GFP.name};
dataI_GFP.ws  = char(Img_WS_GFP(~startsWith(Img_WS_GFP,{'.','..','._'})));
Img_WS_FISH   = dir(['*' files.FISH_ws '*.mat']);
Img_WS_FISH   = {Img_WS_FISH.name};
dataI_FISH.ws = char(Img_WS_FISH(~startsWith(Img_WS_FISH,{'.','..','._'})));
% outlines
Img_OutL           = dir('*.csv');
Img_OutL           = {Img_OutL.name};
Img_OutL           = char(Img_OutL(~startsWith(Img_OutL,{'.','..','._'})));
dataI_GFP.outline  = Img_OutL;
dataI_FISH.outline = Img_OutL;
% FISH image
Imgs_GFP       = dir(['*' files.GFP '*.tif']);
Imgs_GFP       = {Imgs_GFP.name};
dataI_GFP.raw  = char(Imgs_GFP(~startsWith(Imgs_GFP,{'.','..','._'})));
Imgs_FISH      = dir(['*' files.FISH_img '*.tif']);
Imgs_FISH      = {Imgs_FISH.name};
dataI_FISH.raw = char(Imgs_FISH(~startsWith(Imgs_FISH,{'.','..','._'})));
% Folder data
dataI_GFP.Folder  = folder_Files;
dataI_GFP.root    = folder_back;
dataI_FISH.Folder = folder_Files;
dataI_FISH.root   = folder_back;
cd(folder_back)

if ismac; sep = '/'; elseif ispc; sep = '\'; end
dataI_FISH.sep = sep;
dataI_GFP.sep = sep;

disp(newline)
disp('GFP image info: ')
disp(dataI_GFP')
disp('smFISH image info: ')
disp(dataI_FISH)
disp(newline)
end
