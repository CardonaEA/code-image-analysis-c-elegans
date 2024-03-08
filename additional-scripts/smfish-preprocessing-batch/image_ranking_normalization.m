function [blocks_processing, SDc, img_mean, img_median, img_mode] = image_ranking_normalization(Raw_Image, image_Data, BlockSize, blocks_processing, options)
f = Raw_Image;
nIm = image_Data.nIm;
qs = image_Data.qs;
a2 = cell(1,nIm);
SDi = cell(1,nIm);

if blocks_processing.is_out_focus
    idx_beg = blocks_processing.idx_beg;
    idx_end = blocks_processing.idx_end;
    value_beg = f{idx_beg}-quantile(double(f{idx_beg}(:)),qs);
    value_end = f{idx_end}-quantile(double(f{idx_end}(:)),qs);  
    blocks_processing.value_beg = double(max(value_beg(:)));
    blocks_processing.value_end = double(max(value_end(:)));  
end

for i = 1 : nIm
    a2{i} =  f{i}-quantile(double(f{i}(:)),qs);
    SDi{i} = BlockWs2(a2{i},BlockSize,blocks_processing,i);
end
% ranked stacks  
SDc = cat(3,SDi{:});
filtered_image = cat(3,a2{:});

if options.show_zstack_jet
    toGUI = SDi;
    assignin('base','toGUI',toGUI);
    zstacksgui
end

%=== for normalization
if blocks_processing.is_out_focus
    filtered_image = filtered_image(:,:,idx_beg:idx_end);
end
% values
imgI = max(filtered_image, [], [1 2]);
img_mean = double(mean(imgI));
img_median = double(median(imgI));
img_mode = double(mode(imgI));
end