function [f, x, pdfY] = normal_gaussian_fit(toFit, pdf_step, Band_Width, pdf_start)
% f: fit
% x: vector of x points
% fitted curve

if isempty(pdf_start), pdf_start = 1; end

if isempty(pdf_step)
x = unique(toFit);
else
    if pdf_start >= 0 && pdf_start < 1
    % x = (0 : pdf_step : ceil(max(toFit)))';
    x = (floor(min(toFit)*pdf_start) : pdf_step : ceil(max(toFit)))';
    else
    % x = (min(toFit) : pdf_step : max(toFit))';
    x = (floor(min(toFit)) : pdf_step : ceil(max(toFit)))';
    end
end

pdfY = pdf(fitdist(toFit, 'kernel','BandWidth', Band_Width), x);
f = fit(x, pdfY, 'gauss1', 'Robust', 'LAR');
end
