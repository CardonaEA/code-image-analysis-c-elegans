%::::::::::::: preprocessing of smFISH images :::::::::::::%
%% Pre-processing and filtering
clear image_Data
image_Data.root = cd;
image_Data.ImageType = 1; % if FISH  = 1, if GFP = 0
clear blocks_processing
blocks_processing.is_out_focus = 1; % if out of focus slides
qs = 0.9; % Initial value for filtering, 0 if it's unknown

%% BGD Filtering
% if FQ double gauss filter is used
clear Filt_options
Filt_options.gauss2x = 1;
Filt_options.bgd_xy = 5;
Filt_options.bgd_z = 5;
Filt_options.spots_xy = 0;
Filt_options.spots_z = 0;
Filt_options.output = 0;

% filtering
disp(newline)
disp('select the image you want to pre-process...')
[image_Data.filename, image_Data.pathname] = uigetfile({'*.tif';'*.jpg';'*.png';'*.jp2';'*.gif';'*.bmp'},'Select the image file');
[image_Data.Max_Gray, image_Data.nIm, Raw_Image, Raw_Image_c, blocks_processing, image_Data.qs] = Filtering_BGD_vf2(image_Data, blocks_processing, qs, Filt_options);

%% Image blocks proceesing ----- LOCAL PROCESSING
disp(newline)
disp('local processing (it could take time depending on PC specs)...')
Blocks_Size = 2;
clear options
options.show_zstack_jet = 1;
options.save_WS = 1;
tic
[blocks_processing, SDc, filtered_Image] = Image_Ranking(Raw_Image, image_Data, Blocks_Size, blocks_processing, options);
toc
%% WorkSpace saving
% S = r;
disp(newline)
disp('saving MATLAB workspace...')
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