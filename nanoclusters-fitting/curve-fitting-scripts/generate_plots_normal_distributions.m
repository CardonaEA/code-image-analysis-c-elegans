%% PLOTS
if show.ndist_fits
figure

%% ========== Gauss fit MATLAB
subplot(1,3,1)
h = plot(fit_data,x_data,y_data_pdf);
h(1).Color = 'k';
h(2).Color = [0 0.3 1];
h(2).Marker = 'o';
h(2).MarkerSize = 2;
% add peak
xline(fit_data.b1, '--r', 'LineWidth', 1.5, 'label', {num2str(fit_data.b1)});
% h = plot(fit_data.b1 : 0.5 : fit_data.b1 + fit_data.c1, repmat(max(y_data_pdf)/2,length(fit_data.b1 : 0.5 : fit_data.b1 + fit_data.c1)), '--r', 'LineWidth', 1);
% Label axes
grid on
legend('data', 'Gaussian fit', 'b1 centroid', 'Location', 'NorthEast' );
xlabel Intensity
ylabel Density

%% ========== normal distribution fit
subplot(1,3,2)
plot(xData, pdf_yData, '.k')
hold on
% xline(coef_init.centroid, '--k', 'LineWidth', 1.5);
% plot(coef_init.centroid : 0.5 : coef_init.centroid + coef_init.sd, repmat(max(pdf_yData)/2,length(coef_init.centroid : 0.5 : coef_init.centroid + coef_init.sd)), '--k', 'LineWidth', 1)

plot(xData, ndist_fit, '.b')
% add estimates
xline(coef_fit(2), '--r', 'LineWidth', 1.5, 'label', {num2str(coef_fit(2))});
plot(coef_fit(2) : 0.5 : coef_fit(2) + coef_fit(3), repmat(max(ndist_fit)/2,length(coef_fit(2) : 0.5 : coef_fit(2) + coef_fit(3))), '--r', 'LineWidth', 1)
% Label axes
grid on
legend('data', 'n dist fit', 'centroid', 'sd', 'Location', 'NorthEast' );
xlabel Intensity
ylabel Density

%% ========== skew normal distribution fit
subplot(1,3,3)
plot(xData, pdf_yData, '.k')
hold on

plot(xData, sk_ndist_fit, '.b')
% position peak
[~, idx_p] = max(sk_ndist_fit);
peak_skewd = xData(idx_p);
xline(peak_skewd, '--r', 'LineWidth', 1.5, 'label', {num2str(peak_skewd)});
% add estimates
xline(sk_coef_fit(2), '--b', 'LineWidth', 1.5);
plot(sk_coef_fit(2) : 0.5 : sk_coef_fit(2) + sk_coef_fit(3), repmat(max(sk_ndist_fit)/2,length(sk_coef_fit(2) : 0.5 : sk_coef_fit(2) + sk_coef_fit(3))), '--b', 'LineWidth', 1)

% Label axes
grid on
legend('data', 'sk n dist fit', 'centroid data',...
    'centroid', 'sd', 'Location', 'NorthEast' );
xlabel Intensity
ylabel Density
end