% set parameters
image_file.paramaters_analysis =  parameters;

% load folder information
[selected_files] = get_files_epi_analysis(image_file);

% load image
image_Data.pathname = selected_files.folder;
image_Data.filename = selected_files.GFP_image;
disp(newline)
disp('reading image...')
[image_Data.Max_Gray, image_Data.nIm, Raw_Image, Raw_Image_c] = read_image_epi(image_Data);
disp('...done')

% filtering
disp(newline)
disp('filtering image...')
kernel_size.bgd_xy = parameters.filter_size;
kernel_size.bgd_z = parameters.filter_size;
kernel_size.psf_xy = 0;
kernel_size.psf_z = 0;
flag.output = 0;
[img_filt_raw, ~] = img_filter_Gauss_v5(Raw_Image_c,kernel_size,flag);
disp('...done')

% image blocks processing
disp(newline)
disp('ranking image...')
disp('this migth take time depending on PC specs and image size...')
Blocks_Size = parameters.ranking_mask_size;
clear options
options.show_zstack_jet = 1;
options.save_WS = 1;
blocks_processing.is_out_focus = 0; % if out-of-focus slides
image_Data.qs = 0; % initial value for filtering, 0 if it's unknown
[blocks_processing, SDc, ~] = Image_Ranking_epi(img_filt_raw, image_Data, Blocks_Size, blocks_processing, options);
disp('...done')

% thresholding
disp(newline)
disp('segmenting image...')
segmented_image = SDc > parameters.threshold_granules;
segmented_image_open = bwareaopen(segmented_image,parameters.small_objects_size,parameters.components_conn); % remove small objects

dataI.Folder = image_Data.pathname; dataI.raw = image_Data.filename; dataI.sep = filesep;
image_save_seg(Raw_Image_c, segmented_image_open, dataI, 'GFP_mask_')

selected_objects = bwconncomp(segmented_image_open,parameters.components_conn);
image_file.objects_info = selected_objects;
disp('...done')

% granules data
disp(newline)
disp('extracting granules info...')
selected_files.outline = selected_files.cell_outlines;
[var_Names, TS_i, Cond_IDs, CC, number_cells, Outlines_Cells, ROI_area] = granules_info_epi(selected_files, parameters, segmented_image_open, Raw_Image_c);
disp('...done')

% save table
disp(newline)
disp('saving granules info...')
empty_cells = cellfun(@isempty,TS_i);
Info_TS = cat(1,TS_i{~empty_cells});

if isempty(Info_TS)
    T = table([],[],[],[],[],[],'VariableNames', {'image_ID_name', var_Names{:}});
else
    T = table(repmat({selected_files.GFP_image(1:end-4)},[size(Info_TS,1),1]),...
        Info_TS(:,1),Info_TS(:,2),Info_TS(:,3),Info_TS(:,4),Info_TS(:,5),...
        'VariableNames', {'image_ID_name', var_Names{:}});
end
writetable(T,[selected_files.folder selected_files.sep 'condensates_quantification_' selected_files.GFP_image(1:end-4) '.csv'])

% cd(selected_files.Folder)
% save(['mat_analysis_' selected_files.GFP_image(1:end-4) '.mat'],'var_Names', 'TS_i', 'Cond_IDs', 'CC', 'number_cells', 'Outlines_Cells', 'image_file', 'SDc', 'ROI_area')
% cd(selected_files.root)
% disp('...done')

disp(newline)
disp('saving ROI info...')
disp(['objects in image: ' num2str(image_file.objects_info.NumObjects)])
disp(['objects analyzed: ' num2str(size(T,1))])
disp(newline)
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
imgID = repmat({selected_files.GFP_image(1:end-4)},[n_outlines,1]);
T2 = table(imgID, RIO_analyzed, ROI_volume_um3, ngranules, ngpervolume);
writetable(T2,[selected_files.folder selected_files.sep 'ROI_info_' selected_files.GFP_image(1:end-4) '.csv'])
disp(newline)
disp(T2)
disp(newline)
disp('... done')