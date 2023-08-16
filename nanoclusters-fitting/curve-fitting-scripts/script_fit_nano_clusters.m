% ==== parameters for fitting
parameter  = struct; % don't modify
show       = struct; % don't modify

% sampling
parameter.pdf_step       = 0.5; % step for pdf evaluation from min : pdf_step : max(data)
parameter.pdf_Band_Width = 40;  % kernel band width
parameter.peak_fixed     = 1;   % fixed peak at boundary calibration (Yes=1, No=0)
parameter.pdf_start      = 0;   % starting pdf from 0

% show plots of fitted data
show.plots           = 0; % Yes=1, No=0
show.display_range   = 5; % display range: number of molecules

% ==== RUN
% select calibration and experimental data files
[calibration_data, experimental_data] = get_files_nano_fitting;

% nanoclusters fitting
[nano_quantification] = nano_fitting_by_oocyte(calibration_data, experimental_data, parameter, show);
