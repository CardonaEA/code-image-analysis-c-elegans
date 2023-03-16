function [MaxG, nIm, f, fc, blocks_processing, qs] = Filtering_BGD_vf2(image_Data, blocks_processing, qs, options)
%======= function for filtering - PREPROCEESING STEP
Filt_options = options;
%% Computing of in-focus slices

disp('Computing of in-focus slices...')
%==== Choosing z-stack
sDir = [image_Data.pathname image_Data.filename];
%==== Getting z-stack information
ImInfo = imfinfo(sDir);
nIm = length(ImInfo);
% BitD = ImInfo.BitDepth;
MaxG = ImInfo.MaxSampleValue;
% clear ImInfo;
%==== Loading z-stack into MATLAB, f : raw image
f = cell(1,nIm);
for i = 1 : nIm
    f{i} = imread(sDir,i);
end
fc = cat(3,f{:});
% clear sDir;
%==== determining out of focus slides
[blocks_processing, idx_beg, idx_end] = zstack_focus(blocks_processing, f, nIm);

%% background approximation of z-stack using a gaussian filter to blur the z-stack
if qs == 0
    disp('Computing background approximation...')
    disp(newline)
    [qs] = BGD_approximation(fc, idx_beg, idx_end, Filt_options, f);
end
end