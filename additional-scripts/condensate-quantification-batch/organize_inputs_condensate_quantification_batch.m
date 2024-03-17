function [identifiers, crop, par_microscope] = organize_inputs_condensate_quantification_batch(...
    mRNA_image_per_folder,...
    matlab_files_segmentation, image_files_smFISH, average_mRNA_image,...
    pixels_from_xy_center, pixels_from_z_center,...
    define_microscope_parameters)
%=== structures
identifiers       = struct;
crop              = struct;

%=== file dentifiers
identifiers.mRNA_in_folder = mRNA_image_per_folder;
identifiers.segmentation   = matlab_files_segmentation;
identifiers.smFISH         = image_files_smFISH;
% experimental PSF
if mRNA_image_per_folder
    identifiers.mRNA       = average_mRNA_image;
else
    disp(newline)
    disp('%== select a .tif image:')
    disp('%== average mRNA image - experimental PSF of single molecules ...')
    [identifiers.mRNA_filename, identifiers.mRNA_path] = uigetfile({'*.tif'},'select average mRNA image');
end

%=== crop parameters
crop.xy_pix = pixels_from_xy_center;
crop.z_pix  = pixels_from_z_center;

%=== if new microscope parameters are required
if define_microscope_parameters
    [par_microscope] = define_new_microscope_parameters;
    par_microscope.input = 1;
else
    par_microscope = struct;
    par_microscope.input = 0;
end
end