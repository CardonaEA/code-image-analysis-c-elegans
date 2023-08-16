function [pdf_yData, xData, yData] = probability_density_fun(data_to_fit, pdf_step, pdf_Band_Width, pdf_start)
%==== PDF
% .... data to fit
yData = data_to_fit; % experimental amplitudes or intensities

% .... generate pdf function, density funtion
if isempty(pdf_start), pdf_start = 1; end

if pdf_start >= 0 && pdf_start < 1
    % xData = (0 : pdf_step: ceil(max(yData)))'; % intensities or amplitudes to evaulate
    xData = (floor(min(yData)*pdf_start) : pdf_step : ceil(max(yData)))'; % intensities or amplitudes to evaluate
else
    xData = (floor(min(yData)) : pdf_step : ceil(max(yData)))'; % intendities or amplitudes where to evaluate
end

% pd object
pd_object = fitdist(yData, 'kernel','BandWidth', pdf_Band_Width);

% probbility density function
pdf_yData = pdf(pd_object, xData);
end
