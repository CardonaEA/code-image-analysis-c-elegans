function [T] = car1_Condensed_Analysis_by_oocyte_dilute_BP(image_info, CC, img_ID, flags, BP)
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

%====== New mask by cells cy3
% You can put dataI_FISH, SegParameters_FISH or dataI_GFP, SegParameters_GFP
[TS_i, ~, ~] = granules_info_by_Cells_car1_analysis_dilute_BP(image_info, GFP_c_image, CC, img_ID, BP);

if flags.Gauss
    volSmooth1 = imgaussfilt3(GFP_c_image,[41 41 11]);
    filtered_image = GFP_c_image - volSmooth1;
    [TS_filt, ~, ~] = granules_info_by_Cells_car1_analysis_dilute_BP(image_info, filtered_image, CC, img_ID, BP);
    
    Info_TS = [TS_i TS_filt];
    T = table(repmat({image_info.name(1:end-4)},[size(Info_TS,1),1]),...
        Info_TS(:,1),Info_TS(:,2),Info_TS(:,3),Info_TS(:,4),Info_TS(:,5),Info_TS(:,6),Info_TS(:,7),Info_TS(:,8),...
        Info_TS(:,9),Info_TS(:,10),Info_TS(:,11),Info_TS(:,12),Info_TS(:,13),Info_TS(:,14),Info_TS(:,15),Info_TS(:,16),...
        'VariableNames',{'image_ID_name','img','cell','CAR1_total','CAR1_cond','CAR_dil','vol_cell','vol_cond','vol_dil',...
        'img_filt','cell_filt','CAR1_total_filt','CAR1_cond_filt','CAR_dil_filt','vol_cell_filt','vol_cond_filt','vol_dil_filt'});
    % save table
    writetable(T, [image_info.fold image_info.sep image_info.name(1:end-4) '_GFP_local_levels_quant_filt' '.csv'])
else
    Info_TS = TS_i;
    T = table(repmat({image_info.name(1:end-4)},[size(Info_TS,1),1]),...
        Info_TS(:,1),Info_TS(:,2),Info_TS(:,3),Info_TS(:,4),Info_TS(:,5),Info_TS(:,6),Info_TS(:,7),Info_TS(:,8),...
        'VariableNames',{'image_ID_name','img','cell','CAR1_total','CAR1_cond','CAR_dil','vol_cell','vol_cond','vol_dil'});
    % save table
    writetable(T, [image_info.fold image_info.sep image_info.name(1:end-4) '_GFP_local_levels_quant' '.csv'])
end
end