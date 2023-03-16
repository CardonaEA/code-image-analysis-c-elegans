% Version 1 does not include size-based background correction-subtraction
% Version 1 does not include segmentation of less bright objects
function [r] = granules_Segmentation_BGD_correction(SDc, seg_parameters)
% function [r] = granules_Segmentation_BGD_correction(SDc, seg_parameters, blocks_processing)
%% Structures
par = seg_parameters;
%% 3D segmentation
% --- Version 1
% Im2 = SDc > par.Int_Th; % 3D segmentation
% if par.isfog2
%     BW2 = bwareaopen(Im2,par.Vol_Yh,6); % Remove small objects
%     r = imclose(BW2,strel('disk',3)); % fill gaps inside granules
% else
%     r = bwareaopen(Im2,par.Vol_Yh,6); % Remove small objects
% end
% --- end Version 1

%% --- Version 2
% Backgound correction
tic
BGD_i = SDc < par.Max_Bgd & SDc > par.Min_Bgd;

CC_bgd = bwconncomp(BGD_i,par.components_conn);
% Compute the area of each component:
S_bdg = regionprops(CC_bgd, 'Area');
% Remove small objects:
L_bdg = labelmatrix(CC_bgd);
% min_Vol = find([S_bdg.Area] >= SegParameters.Vol_Yh);
% max_vol = find([S_bdg.Area] < 200);
% Intersect_obj = ismember(min_Vol,max_vol);

% BW_bdg = ismember(L_bdg, find([S_bdg.Area] == max([S_bdg.Area])));
% BW_bdg = ismember(L_bdg, find([S_bdg.Area] >= 5000));
BW_bdg = ismember(L_bdg, find([S_bdg.Area] >= par.Bgd_Area));
% BW2 = ismember(L, min_Vol(Intersect_obj));

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
Im2 = SDc_corrected > par.threshold_granules_BGD_corrected; % 3D segmentation
if par.isfog2
    BW2 = bwareaopen(Im2,par.small_objects_size,par.components_conn); % Remove small objects
    r = imclose(BW2,strel('disk',3)); % fill gaps inside granules
else
    r = bwareaopen(Im2,par.small_objects_size,par.components_conn); % Remove small objects
end

% % LOOK for small, and less brigth objects
% Im3 = SDc_corrected > par.Int_Th_small; % 3D segmentation
% % Determine the connected components:
% CC_small = bwconncomp(Im3,6);
% % Compute the area of each component:
% S_small = regionprops(CC_small, 'Area');
% % Remove small objects:
% L = labelmatrix(CC_small);
% min_Vol = find([S_small.Area] >= par.Vol_Yh);
% max_vol = find([S_small.Area] < par.Vol_Yh_small);
% Intersect_obj = ismember(min_Vol,max_vol);
% 
% % BW2 = ismember(L, find([S.Area] >= P));
% BW3 = ismember(L, min_Vol(Intersect_obj));
% 
% if blocks_processing.is_out_focus == 1
% BW3(:,:,[1 : blocks_processing.idx_beg - 2, blocks_processing.idx_end + 2 : length(blocks_processing.focus)]) = 0;
% BW3 = bwareaopen(BW3,par.Vol_Yh,6);
% end
% 
% % Combined images
% r(BW3) = 1;
toc
%% -- End version 2
end