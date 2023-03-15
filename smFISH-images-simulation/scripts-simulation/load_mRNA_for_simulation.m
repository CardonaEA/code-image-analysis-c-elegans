function [avg_mRNA_c_image] = load_mRNA_for_simulation(data_mRNA)

% load mRNA image
% [data_mRNA.filename, data_mRNA.pathname] = uigetfile({'*.tif';'*.jpg';'*.png';'*.jp2';'*.gif';'*.bmp'},'Select the image file');

data_mRNA.nIm_FISH = length(imfinfo([data_mRNA.pathname data_mRNA.filename]));
f_mRNA = cell(1, data_mRNA.nIm_FISH);
for i = 1 : data_mRNA.nIm_FISH
    f_mRNA{i} = imread([data_mRNA.pathname data_mRNA.filename],i);
end
avg_mRNA_c_image = cat(3,f_mRNA{:});

end