function generate_plots_cummulative_distributions(show, xData, pdf_yData, sk_ndist_fit, xData_nano, pdf_yData_nano, nano_fit, nano_coef_fit)
%==== Plots for nano fit
figure
hold on

% sm distribution
plot(xData, pdf_yData, '--k')
plot(xData, sk_ndist_fit, '--b')
showed_legend = {'SM distribution', 'SM distribution fit'};

% Data and fit
plot(xData_nano, pdf_yData_nano, '.k')
plot(xData_nano, nano_fit, '.b')
showed_legend = [showed_legend{:}, {'data', 'Gaussian fit'}];

% 1st fit and 2nd fit
coef_nano_1st = nano_coef_fit(1:4);
fit_nano_1st = fun_SkewGaussian_cf(coef_nano_1st, xData_nano);
plot(xData_nano, fit_nano_1st, '.r')

coef_nano_2nd = nano_coef_fit(5:8);
fit_nano_2nd = fun_SkewGaussian_cf(coef_nano_2nd, xData_nano);
plot(xData_nano, fit_nano_2nd, '.m')
showed_legend = [showed_legend{:}, {'Dissolved', 'Clustered'}];

% skewed position peak
[~, idx_p] = max(fit_nano_1st);
peak_skewd = xData_nano(idx_p);
xline(peak_skewd, '--r', 'LineWidth', 1.5, 'label', {num2str(peak_skewd)}, 'LabelHorizontalAlignment', 'center');
peak_sm = peak_skewd;

[~, idx_p] = max(fit_nano_2nd);
peak_skewd = xData_nano(idx_p);
xline(peak_skewd, '--m', 'LineWidth', 1.5, 'label', {num2str(peak_skewd)}, 'LabelHorizontalAlignment', 'center');
showed_legend = [showed_legend{:}, {'peak dissolved', 'peak clustered'}];

grid on
hold off
xlim([0 show.display_range * peak_sm])
legend(showed_legend, 'Location', 'NorthEast');
xlabel('foci intensity (AMP)')
ylabel('kernel density')
end
