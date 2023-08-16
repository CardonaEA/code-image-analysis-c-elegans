function [mRNA_calibration, mRNA_experimental, image_names, oocyte_idx, number_images, number_oocytes] = read_files_nano_fitting(calibration_data, experimental_data)
% read data
mRNA_calibration  = readtable([calibration_data.path calibration_data.file]);
mRNA_experimental = readtable([experimental_data.path experimental_data.file]);

% loop oocytes
image_names = unique(mRNA_experimental.Image, 'stable');
oocyte_idx  = unique(mRNA_experimental.CELL_Oocyte, 'stable');

% data sizes
number_images  = length(image_names);
number_oocytes = length(oocyte_idx);

% disp
disp(newline)
disp('images to analyze:')
disp(image_names)
end

