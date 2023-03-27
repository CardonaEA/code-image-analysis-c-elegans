function [r] = granules_Segmentation_BGD_correction(SDc, seg_parameters)
%===== Structures
par = seg_parameters;

%===== Backgound correction
tic
BGD_i = SDc < par.Max_Bgd & SDc > par.Min_Bgd;

CC_bgd = bwconncomp(BGD_i,par.components_conn);
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
Im2 = SDc_corrected > par.threshold_granules_BGD_corrected; % 3D segmentation
r = bwareaopen(Im2,par.small_objects_size,par.components_conn); % Remove small objects
toc
end