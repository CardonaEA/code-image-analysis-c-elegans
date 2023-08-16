%==== parameters
pdf_step = parameter.pdf_step ;
pdf_Band_Width = parameter.pdf_Band_Width;
pdf_start = parameter.pdf_start;
peak_fixed = parameter.peak_fixed;

%==== Probability density funtion from kernel distribution
data_to_fit = single_molecule_data;
[pdf_yData, xData, yData] = probability_density_fun(data_to_fit, pdf_step, pdf_Band_Width, pdf_start);

%==== Gauss function (Matlab) vs normal distribution fit
% % curve fitting
% [fit_data, x_data, y_data_pdf] = normal_gaussian_fit(data_to_fit, pdf_step, pdf_Band_Width, pdf_start);

% % curve fitting LSQCURVEFIT
% [ndist_fit, coef_fit, coef_init] = nomral_distribution_fit(pdf_yData, xData, yData);

%===== skewed normal distribution
% curve fitting LSQCURVEFIT
[sk_ndist_fit, sk_coef_fit, sk_coef_init] = skew_nomral_distribution_fit(pdf_yData, xData, yData);

%==== fits comparisons (not used in batch)
% % show.ndist_fits = 1;
% generate_plots_normal_distributions

%==== fit sum of skewed gausin model ~ nanoclusters fitting
data_to_fit_nano = experimental_data;
[pdf_yData_nano, xData_nano, yData_nano] = probability_density_fun(data_to_fit_nano, pdf_step, pdf_Band_Width, pdf_start);

% fitting
% peak_fixed = [];
% peak_fixed = 1;
[nano_fit, nano_coef_fit, nano_coef_init] = fit_nanoclusters_model(pdf_yData_nano,...
    xData_nano, yData_nano, sk_coef_fit, peak_fixed);

% % show.distributions = 1;
if show.plots
    generate_plots_cummulative_distributions(show, xData, pdf_yData, sk_ndist_fit, xData_nano, pdf_yData_nano, nano_fit, nano_coef_fit)
end
