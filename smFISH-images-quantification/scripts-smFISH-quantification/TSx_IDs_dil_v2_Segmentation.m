function [r, fc] = TSx_IDs_dil_v2_Segmentation(Folder_Data, seg_parameters, blocks_processing)
%% Structures
imageData = Folder_Data;
par = seg_parameters;
% Analysis = anaysis_parameters;

%% load files
load([imageData.Folder imageData.sep imageData.ws],'SDc');
sDir = [imageData.Folder imageData.sep imageData.raw];

%% Load Raw Image
ImInfo = imfinfo(sDir);
nIm = length(ImInfo);
% Loading z-stack into MATLAB, f : row image
f = cell(1,nIm);
for i = 1 : nIm
f{i} = imread(sDir,i);
end
fc = cat(3,f{:});

%% 3D segmentation
% Backgound correction
tic
BGD_i = SDc < par.Max_Bgd & SDc > par.Min_Bgd;

CC_bgd = bwconncomp(BGD_i,6);
% Compute the area of each component:
S_bdg = regionprops(CC_bgd, 'Area');
% Remove small objects:
L_bdg = labelmatrix(CC_bgd);
BW_bdg = ismember(L_bdg, find([S_bdg.Area] >= par.Bgd_Area));

SDc_corrected = SDc;
SDc_corrected(BW_bdg) = 0;

if par.show_Bgd_corr
SDc_max = max(SDc,[],3);
SDc_max_corrected = max(SDc_corrected,[],3);
figure
subplot(1,2,1), imshow(SDc_max)
title('Ranked Image (- background)')
colormap jet
colorbar('southoutside')
subplot(1,2,2), imshow(SDc_max_corrected)
title('Ranked Image (- local background)')
colormap jet
colorbar('southoutside')
hold off
end

% Segmentation
Im2 = SDc_corrected > par.Int_Th; % 3D segmentation
r = bwareaopen(Im2,par.Vol_Th,6); % Remove small objects

% LOOK for small, and less brigth objects
Im3 = SDc_corrected > par.Int_Th_small; % 3D segmentation
% Determine the connected components:
CC_small = bwconncomp(Im3,6);
% Compute the area of each component:
S_small = regionprops(CC_small, 'Area');
% Remove small objects:
L = labelmatrix(CC_small);
min_Vol = find([S_small.Area] >= par.Vol_Th);
max_vol = find([S_small.Area] < par.Vol_Th_small);
Intersect_obj = ismember(min_Vol,max_vol);

BW3 = ismember(L, min_Vol(Intersect_obj));

if blocks_processing.is_out_focus == 1
BW3(:,:,[1 : blocks_processing.idx_beg - 2, blocks_processing.idx_end + 2 : length(blocks_processing.focus)]) = 0;
BW3 = bwareaopen(BW3,par.Vol_Th,6);
end

% Combined images
r(BW3) = 1;
toc
end