%==== script to generate csv tables from FQ spots results
% optional: mark detected spots in images

%=== image voxel size
pixel_size_in_x_and_y = 49;   % nanometers
pixel_size_in_z       = 250;  % nanometers

%=== optional: mark detected spots in images
mark_detected_spots_in_images = 1; % yes = 1, no = 0
detected_or_fitted_positions  = 1; % detected = 1, fitted = 0
pixels_to_mark_from_center    = 1; % pixels from center (from detected or fitted position)

% =====================
% === do not modify ===
% =====================
% file identifiers
image_files = '*.tif';    % any .tif file
spots_files = '*.txt';    % any .txt file

%=== run
spots2csv
