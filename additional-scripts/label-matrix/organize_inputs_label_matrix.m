function [identifiers] = organize_inputs_label_matrix(matlab_files_segmentation, image_files_smFISH)
%=== structures
identifiers = struct;
%=== file dentifiers
identifiers.segmentation = matlab_files_segmentation;
identifiers.smFISH       = image_files_smFISH;
end