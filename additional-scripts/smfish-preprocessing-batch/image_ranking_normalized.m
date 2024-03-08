function [SDc] = image_ranking_normalized(Raw_Image, image_Data, BlockSize, options, ref_int)
f = Raw_Image;
nIm = image_Data.nIm;
qs = image_Data.qs;
SDi = cell(1,nIm);

for i = 1 : nIm
    filtered_slice =  f{i}-quantile(double(f{i}(:)),qs);
    SDi{i} = blocks_normalized(filtered_slice, BlockSize, ref_int);
end
% ranked stacks  
SDc = cat(3,SDi{:});
%filtered_image = cat(3,a2{:});

if options.show_zstack_jet
    toGUI = SDi;
    assignin('base','toGUI',toGUI);
    zstacksgui
end
end