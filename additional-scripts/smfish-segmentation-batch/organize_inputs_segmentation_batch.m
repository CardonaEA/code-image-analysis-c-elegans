function [identifiers, pixel_size, acquisition, options, filter_options] = organize_inputs_segmentation_batch(...
    image_files_smFISH, matlab_files_smFISH, image_files_GFP, matlab_files_GFP, outline_files,...
    pixel_size_in_x_and_y, pixel_size_in_z,...
    emission, excitation, numerical_aperture, refractive_index, type_microscope,...
    normalized_intensity_threshold_GFP, normalized_intensity_threshold_smFISH, volume_threshold_in_pixels, dilate_granules,...
    FQ_outline, removed_granules_outline,...
    save_mat_file_with_segmentation, save_segmented_images, show_local_bgd_removal,...
    kernel_bgd_xy, kernel_bgd_z, kernel_snr_xy, kernel_snr_z)
%=== structures
identifiers       = struct;
pixel_size        = struct;
acquisition       = struct;
options           = struct;
filter_options    = struct;

%=== file dentifiers
identifiers.smFISH     = image_files_smFISH;
identifiers.smFISH_mat = matlab_files_smFISH;
identifiers.GFP        = image_files_GFP;
identifiers.GFP_mat    = matlab_files_GFP;
identifiers.outlines   = outline_files;

%=== microscope parameters
pixel_size.xy = pixel_size_in_x_and_y;
pixel_size.z  = pixel_size_in_z;

%=== acquisition parameters
acquisition.Em    = emission;
acquisition.Ex    = excitation;
acquisition.NA    = numerical_aperture;
acquisition.RI    = refractive_index;
acquisition.type  = type_microscope;
acquisition.Pixel = pixel_size;

%=== segmentation options
options.Int_Threshold_GFP  = normalized_intensity_threshold_GFP;
options.Int_Threshold_FISH = normalized_intensity_threshold_smFISH;
options.Volume_Threshold   = volume_threshold_in_pixels;
options.Dilate_Granule     = dilate_granules;

%=== outline options
options.FQ_outline       = FQ_outline;
options.Exclude_Granules = removed_granules_outline;

%=== output options
options.save_coordinates  = save_mat_file_with_segmentation;
options.save_segmentation = save_segmented_images;
options.show_bgd_rm       = show_local_bgd_removal;

%=== alternative masking
filter_options.gauss2x  = 1;
filter_options.bgd_xy   = kernel_bgd_xy;
filter_options.bgd_z    = kernel_bgd_z;
filter_options.spots_xy = kernel_snr_xy;
filter_options.spots_z  = kernel_snr_z;
filter_options.output   = 0;
options.filter          = filter_options;
end