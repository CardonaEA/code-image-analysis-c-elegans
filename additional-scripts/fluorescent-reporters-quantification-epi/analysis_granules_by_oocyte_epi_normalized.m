function [T, T2, Cond_IDs, CC] = analysis_granules_by_oocyte_epi_normalized(image_info, parameters, ref_int)
%==== load z-stack
image_Data.pathname = image_info.folder;
image_Data.filename = image_info.name;
disp(newline)
disp('reading image...')
[~, image_Data.nIm, ~, raw_image_cat] = read_image_epi(image_Data);
disp('...done')

%==== filtering
disp(newline)
disp('filtering image...')
kernel_size = struct;
kernel_size.bgd_xy = parameters.filter_size;
kernel_size.bgd_z = parameters.filter_size;
kernel_size.psf_xy = 0;
kernel_size.psf_z = 0;
flag.output = 0;
[filtered_image, ~] = img_filter_Gauss_v5(raw_image_cat, kernel_size, flag);
disp('...done')

%=====  image ranking
disp(newline)
disp('ranking image...')
disp('this migth take time depending on PC specs and image size...')
ranked_image = cell(1,image_Data.nIm);
mask_size = parameters.ranking_mask_size;

for i = 1 : image_Data.nIm
    ranked_image{i} = blocks_normalized(filtered_image(:,:,i), mask_size, ref_int);
end
ranked_image_cat = cat(3,ranked_image{:});
disp('...done')
% display normalized z-stack
% toGUI = ranked_image;
% assignin('base','toGUI',toGUI);
% zstacksgui

%===== image segmentation
disp(newline)
%===== with local BGD removal
% disp('segmenting image (with local BGD removal)...')
% parameters.threshold_granules_BGD_corrected = parameters.threshold_granules;
% parameters.Max_Bgd = parameters.threshold_granules_BGD_corrected + 0.0125;
% parameters.Min_Bgd = 0;
% parameters.Bgd_Area = 5000;
% parameters.show_Bgd_corr = 1;
% [segmented_image] = granules_Segmentation_BGD_correction(ranked_image_cat, parameters);
%===== without local BGD removal
disp('segmenting image...')
presegmented_image = ranked_image_cat > parameters.threshold_granules;
segmented_image = bwareaopen(presegmented_image,parameters.small_objects_size,parameters.components_conn); % remove small objects
% save outlined condensate image
dataI.Folder = image_Data.pathname; dataI.raw = image_Data.filename; dataI.sep = filesep;
image_save_seg(raw_image_cat, segmented_image, dataI, 'GFP_mask_')
% connected components
selected_objects = bwconncomp(segmented_image,parameters.components_conn);
disp('...done')

%====== granules data
disp(newline)
disp('extracting granules info...')
[var_Names, TS_i, Cond_IDs, CC, number_cells, ~, ROI_area] = granules_info_epi_batch(image_info, parameters, segmented_image, raw_image_cat);
disp('...done')

%====== table results
disp(newline)
disp('saving granules info...')
empty_cells = cellfun(@isempty,TS_i);
Info_TS = cat(1,TS_i{~empty_cells});

if isempty(Info_TS)
    T = table([],[],[],[],[],[],[],[],[],[],'VariableNames', {'image_ID_name', var_Names{:}});
else
    T = table(repmat({image_info.name(1:end-4)},[size(Info_TS,1),1]),...
        Info_TS(:,1),Info_TS(:,2),Info_TS(:,3),Info_TS(:,4),Info_TS(:,5),Info_TS(:,6),Info_TS(:,7),Info_TS(:,8),Info_TS(:,9),...
        'VariableNames',{'image_ID_name', var_Names{:}});
end
% save table
writetable(T, [image_info.folder image_info.sep image_info.name(1:end-4) '_condensate_quantification' '.csv'])
disp('...done')

%====== table ROIs summary
disp(newline)
disp('saving ROI info...')
disp(['objects in image: ' num2str(selected_objects.NumObjects)])
disp(['objects analyzed: ' num2str(size(T,1))])
RIO_analyzed = (((1:2:number_cells) + 1)/2)';
n_outlines = length(RIO_analyzed);
ngranules = zeros(n_outlines,1);
for k = 1:n_outlines
    ng = size(T(T.Cell == RIO_analyzed(k),:),1);
    if ng
        ngranules(k) = ng;
    end
end
ROI_volume_um3 =  ROI_area * parameters.pixel_size.xy * parameters.pixel_size.xy * parameters.pixel_size.z;
ngpervolume = ngranules ./ ROI_volume_um3;
imgID = repmat({image_info.name(1:end-4)},[n_outlines,1]);
T2 = table(imgID, RIO_analyzed, ROI_volume_um3, ngranules, ngpervolume);
writetable(T2, [image_info.folder image_info.sep 'ROI_info_' image_info.name(1:end-4) '.csv'])
disp(newline)
disp(T2)
disp(newline)
disp('... done')
end