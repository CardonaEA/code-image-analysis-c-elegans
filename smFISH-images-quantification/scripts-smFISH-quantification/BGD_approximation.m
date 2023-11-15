function [qs] = BGD_approximation(fc, idx_beg, idx_end, Filt_options, f)
%===== background approximation of z-stack using a gaussian filter to blur the z-stack

volSmooth1 = imgaussfilt3(fc(:,:,idx_beg + 5 : idx_end - 5),[61 61 21]); % *** ---- CHANGED ----

% FQ double gauss filter
if Filt_options.gauss2x
kernel_size.bgd_xy = Filt_options.bgd_xy;
kernel_size.bgd_z = Filt_options.bgd_z;

kernel_size.psf_xy = Filt_options.spots_xy;
kernel_size.psf_z = Filt_options.spots_z;
flag.output = Filt_options.output;

[~, volSmooth2] = img_filter_Gauss_v5(fc(:,:,idx_beg + 5 : idx_end - 5),kernel_size,flag);
else
volSmooth2 = imgaussfilt3(fc(:,:,idx_beg + 5 : idx_end - 5),[81 81 21]); % *** ---- CHANGED ----
end
% volSmooth3 = imgaussfilt3(fc,[81 81 41]);

%===== plot to select quantile to subtract background
% Plotting intensity levels of raw image
figure
nIm2 = length(idx_beg + 5 : idx_end - 5);
for j = 1 : nIm2
plot(0:0.1:1,log(quantile(double(f{j + idx_beg + 4}(:)),0:0.1:1)),'.k','HandleVisibility','off')
hold on
end
% Plotting intensity levels of first background approximation (z-stack)
for j = 1 : nIm2
pIm = volSmooth1(:,:,j);
plot(0:0.1:1,log(quantile(double(pIm(:)),0:0.1:1)),'.b','HandleVisibility','off')
hold on
end
% Plotting intensity levels of second background approximation (z-stack)
for j = 1 : nIm2
pIm = volSmooth2(:,:,j);
plot(0:0.1:1,log(quantile(double(pIm(:)),0:0.1:1)),'.r','HandleVisibility','off')
hold on
end
% clear pIm;
% Averaging previous information to show just one line
ImaQ = zeros(length(0:0.001:1),nIm2);
BkgQ1 = zeros(length(0:0.001:1),nIm2);
BkgQ2 = zeros(length(0:0.001:1),nIm2);
for j = 1 : nIm2  
ImaQ(:,j) = quantile(double(f{j + idx_beg + 4}(:)),0:0.001:1);
pIm1 = double(volSmooth1(:,:,j));
BkgQ1(:,j) = quantile(pIm1(:),0:0.001:1);
pIm2 = double(volSmooth2(:,:,j));
BkgQ2(:,j) = quantile(pIm2(:),0:0.001:1);
end
% Plotting quantile by quantile means
plot(0:0.001:1,log(mean(ImaQ,2)),'k')
plot(0:0.001:1,log(mean(BkgQ1,2)),'b')
plot(0:0.001:1,log(mean(BkgQ2,2)),'r')
% labels
xlabel('Quantile')
ylabel('Intensity')
legend('Image', 'BGD 1', 'BGD 2', 'Location', 'eastoutside')
hold off
drawnow
% clear ImaQ BkgQ1 BkgQ2;

%===== Chosen quantile, code to type it in MATLAB's command window
promptx = 'quantile [0 to 1]: ';
qs = input(promptx);
end