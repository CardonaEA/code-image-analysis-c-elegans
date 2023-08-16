function [calibration_data, experimental_data] = get_files_nano_fitting
disp(newline)
disp('select a CSV file with the calibration data (single molecule amplitudes)...')
%===== calibration data =====%
[calibration_data.file, calibration_data.path] = uigetfile({'*.csv'},'select calibration data');

disp('select a CSV file with the experimental data...')
%===== experimental data =====%
[experimental_data.file, experimental_data.path] = uigetfile({'*.csv'},'select experimental data');

disp(newline)
disp('selected files: ')
disp(['calibration data: ' calibration_data.file])
disp(['experimental data: ' experimental_data.file])
disp(newline)
end