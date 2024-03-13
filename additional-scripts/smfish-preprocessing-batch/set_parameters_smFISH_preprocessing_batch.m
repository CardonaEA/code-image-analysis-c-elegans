function [parameters, blocks_processing, identifiers] = set_parameters_smFISH_preprocessing_batch(image_files_smFISH, image_files_GFP, is_stack_out_of_focus, quantile_BGD_subtraction, ranking_mask_size)
%=== parameters
parameters        = struct;
blocks_processing = struct;
identifiers       = struct;
% segmentation
if quantile_BGD_subtraction <= 0 || quantile_BGD_subtraction >= 1
    parameters.quantile        = 0.8;
    disp(newline)
    disp('%== quantile_BGD_subtraction cannot be <= 0 or >= 1, instead 0.8 will be used. ==%')
else
    parameters.quantile        = quantile_BGD_subtraction;
end
parameters.ranking_mask_size   = ranking_mask_size;
% blocks processing
blocks_processing.is_out_focus = is_stack_out_of_focus;
% file IDs
identifiers.smFISH             = image_files_smFISH;
identifiers.GFP                = image_files_GFP;
end