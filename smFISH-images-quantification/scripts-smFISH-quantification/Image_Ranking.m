% Function for local processing 
% The following code divides filtered image into blocks specified by
% BLOCKSIZE and ranks every block based on their components mean's
% intensity compared with the brighter pixel. Min = 0, Max = 1.
function [blocks_processing, SDc, filtered_Image] = Image_Ranking(Raw_Image, image_Data, BlockSize, blocks_processing, options)
% varibles
f = Raw_Image;
nIm = image_Data.nIm;
qs = image_Data.qs;

a2 = cell(1,nIm);
SDi = cell(1,nIm);
% BlockSize = 2; % bigger block sizes give faster results *** ---- CHANGED ----

if blocks_processing.is_out_focus
idx_beg = blocks_processing.idx_beg;
idx_end = blocks_processing.idx_end;
% value_beg = f{idx_beg - 1}-quantile(double(f{idx_beg - 1}(:)),qs);
% value_end = f{idx_end + 1}-quantile(double(f{idx_end + 1}(:)),qs);
value_beg = f{idx_beg}-quantile(double(f{idx_beg}(:)),qs);
value_end = f{idx_end}-quantile(double(f{idx_end}(:)),qs);  
blocks_processing.value_beg = double(max(value_beg(:)));
blocks_processing.value_end = double(max(value_end(:)));  
end

for i = 1 : nIm
a2{i} =  f{i}-quantile(double(f{i}(:)),qs);
SDi{i} = BlockWs2(a2{i},BlockSize,blocks_processing,i);
end
% Stack containing ranked slices  
SDc = cat(3,SDi{:});
filtered_Image = cat(3,a2{:});

if options.show_zstack_jet
toGUI = SDi;
assignin('base','toGUI',toGUI);
zstacksgui
end