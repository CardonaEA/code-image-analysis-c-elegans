function [T, Cond_IDs, CC, BP] = car1_Condensed_Analysis_by_oocyte_sphericity(image_info, seg_parameters, blocks_processing)
%--------- Getting z-stack information
raw_image = image_info.image;
image_details = imfinfo(raw_image);
nIm = length(image_details);
clear image_details;

%---------- Loading z-stack into MATLAB, f : row image
GFP_image = cell(1,nIm);
for i = 1 : nIm
 GFP_image{i} = imread(raw_image,i);
end
GFP_c_image = cat(3,GFP_image{:});

if blocks_processing.is_out_focus
    [blocks_processing] = z_boundaries_det(blocks_processing, nIm, GFP_image);
end

%---------- BGD subtraction
qs = seg_parameters.quantile;

%----------  image ranking by local proceesing
ranked_image = cell(1,nIm);
mask_size = seg_parameters.ranking_mask_size;
filtered_image = cell(1,nIm);

if blocks_processing.is_out_focus
idx_beg = blocks_processing.idx_beg;
idx_end = blocks_processing.idx_end;
% value_beg = f{idx_beg - 1}-quantile(double(f{idx_beg - 1}(:)),qs);
% value_end = f{idx_end + 1}-quantile(double(f{idx_end + 1}(:)),qs);
value_beg = GFP_image{idx_beg}-quantile(double(GFP_image{idx_beg}(:)),qs);
value_end = GFP_image{idx_end}-quantile(double(GFP_image{idx_end}(:)),qs);
blocks_processing.value_beg = double(max(value_beg(:)));
blocks_processing.value_end = double(max(value_end(:)));
end

for i = 1 : nIm
filtered_image{i} = GFP_image{i} - quantile(double(GFP_image{i}(:)), qs);
ranked_image{i} = BlockWs2(filtered_image{i}, mask_size, blocks_processing, i);
end
ranked_image_c = cat(3,ranked_image{:});

% toGUI = ranked_image;
% zstacksgui

BP = blocks_processing;

%----------  granules thresholding
%========= with BGD correction
% --- segmentation GFP
seg_parameters.old_Version = 0; % old Mlb version
[r_GFP] = granules_Segmentation_BGD_correction(ranked_image_c, seg_parameters);
% Save outlined image for condensates
disp(newline)
disp(bwconncomp(r_GFP,6))
dataI.Folder = image_info.fold; dataI.raw = image_info.name; dataI.sep = image_info.sep;
image_save_seg(GFP_c_image, r_GFP, dataI, 'GFP_mask')

%====== New mask by cells cy3
% You can put dataI_FISH, SegParameters_FISH or dataI_GFP, SegParameters_GFP
[var_Names, TS_i, Cond_IDs, CC, ~, ~] = granules_info_by_Cells_car1_analysis_sphericity(image_info, seg_parameters, r_GFP, GFP_c_image);

empty_cells = cellfun(@isempty,TS_i);
Info_TS = cat(1,TS_i{~empty_cells});

T = table(repmat({image_info.name(1:end-4)},[size(Info_TS,1),1]),...
    Info_TS(:,1),Info_TS(:,2),Info_TS(:,3),Info_TS(:,4),Info_TS(:,5),Info_TS(:,6),Info_TS(:,7),Info_TS(:,8),Info_TS(:,9),...
    'VariableNames',{'image_ID_name', var_Names{:}});

% save table
writetable(T, [image_info.fold image_info.sep image_info.name(1:end-4) '_Cond_quant' '.csv'])
end