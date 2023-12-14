function [parameters, blocks_processing, identifiers] = set_parameters_epi_analysis_normalized(filter_size, granule_threshold, small_objects_size, pixel_size_in_x_and_y, pixel_size_in_z, ranking_mask_size, components_conn, slides_out_of_focus, half_gonad, image_files, outline_files)
%==== analysis parameters
parameters        = struct;
blocks_processing = struct;
identifiers       = struct;
% segmentation
parameters.filter_size         = filter_size;
parameters.threshold_granules  = granule_threshold;
parameters.small_objects_size  = small_objects_size;
parameters.pixel_size.xy       = pixel_size_in_x_and_y;
parameters.pixel_size.z        = pixel_size_in_z;
parameters.voxel_size          = pixel_size_in_x_and_y * pixel_size_in_x_and_y * pixel_size_in_z;
parameters.ranking_mask_size   = ranking_mask_size;
parameters.components_conn     = components_conn;
% blocks processing
blocks_processing.is_out_focus = slides_out_of_focus;
blocks_processing.is_half      = half_gonad;
% file IDs
identifiers.GFP                = image_files;
identifiers.ROIs               = outline_files;
end