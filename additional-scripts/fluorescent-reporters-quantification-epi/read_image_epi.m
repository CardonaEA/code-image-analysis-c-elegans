function [MaxG, nIm, f, fc] = read_image_epi(image_Data)
image_path = [image_Data.pathname filesep image_Data.filename];
% getting z-stack information
ImInfo = imfinfo(image_path);
nIm = length(ImInfo);
% BitD = ImInfo.BitDepth;
MaxG = ImInfo.MaxSampleValue;
% MinG = ImInfo.MinSampleValue;
% loading z-stack into MATLAB
f = cell(1,nIm);
for i = 1 : nIm
    f{i} = imread(image_path,i);
end
fc = cat(3,f{:});
end