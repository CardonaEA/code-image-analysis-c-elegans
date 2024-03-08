function image_ranking_batch_normalized(image_Data, parameters, ref_int)
% preprocessing
filt_options.gauss2x = 0;
blocks_processing.is_out_focus = 0;
[image_Data.Max_Gray, image_Data.nIm, Raw_Image, ~, blocks_processing, image_Data.qs] = Filtering_BGD_vf2(image_Data, blocks_processing, parameters.quantile, filt_options);

% local processing and image ranking
disp('ranking image... this migth take time depending on PC specs and image size...')
options = struct;
options.show_zstack_jet = 0;
[SDc] = image_ranking_normalized(Raw_Image, image_Data, parameters.ranking_mask_size, options, ref_int);

%== save MATLAB Workspace
disp('saving matlab workspace...')
cd(image_Data.pathname)
save(['WS_' image_Data.filename(1:end-4) '_' image_Data.ImageType '.mat'],'SDc','image_Data','blocks_processing')
cd(image_Data.root)
end