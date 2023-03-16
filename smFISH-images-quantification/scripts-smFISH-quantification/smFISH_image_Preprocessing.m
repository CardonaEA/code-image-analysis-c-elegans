%% Pre-processing and filtering
clear image_Data
image_Data.root = cd;
image_Data.ImageType = smFISH_channel; % if FISH  = 1, if GFP = 0
clear blocks_processing
blocks_processing.is_out_focus = is_stack_out_of_focus; % if out of focus slides
qs = quantile_BGD_subtraction; % Initial value for filtering, 0 if it's unknown

%% BGD Filtering
% if FQ double gauss filter is used
clear Filt_options
Filt_options.gauss2x = different_BGD_approximations;
Filt_options.bgd_xy = 5;
Filt_options.bgd_z = 5;
Filt_options.spots_xy = 0;
Filt_options.spots_z = 0;
Filt_options.output = 0;

% filtering
disp(newline)
if smFISH_channel == 1; disp('select smFISH image...'); end
if smFISH_channel == 0; disp('select GFP image...'); end
[image_Data.filename, image_Data.pathname] = uigetfile({'*.tif';'*.jpg';'*.png';'*.jp2';'*.gif';'*.bmp'},'Select the image file');
[image_Data.Max_Gray, image_Data.nIm, Raw_Image, Raw_Image_c, blocks_processing, image_Data.qs] = Filtering_BGD_vf2(image_Data, blocks_processing, qs, Filt_options);

%% Local processing for Image ranking
disp(newline)
disp('Image ranking: local processing (this might take a while depending on PC specs)...')
Blocks_Size = block_size_for_image_ranking;
clear options
options.show_zstack_jet = 1;
options.save_WS = 1;
tic
[blocks_processing, SDc, filtered_Image] = Image_Ranking(Raw_Image, image_Data, Blocks_Size, blocks_processing, options);
toc
%% MATLAB Workspace saving
% S = r;
if options.save_WS
cd(image_Data.pathname)
fName = regexprep(image_Data.filename,'[-=]','_');
fName = regexprep(fName,'[^a-zA-z_0-9]','');
if image_Data.ImageType
save(['WS_' fName(1:end-3) '_FISH' '.mat'],'SDc','image_Data','blocks_processing','Filt_options')
elseif ~image_Data.ImageType
save(['WS_' fName(1:end-3) '_GFP' '.mat'],'SDc','image_Data','blocks_processing','Filt_options')
end
cd(image_Data.root)
end