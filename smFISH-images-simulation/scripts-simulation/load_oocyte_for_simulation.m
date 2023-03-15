function [oocyte_c_image, focus_oocyte] = load_oocyte_for_simulation(dataI)

% load oocyte for simulation
% [dataI.filename, dataI.pathname] = uigetfile({'*.tif';'*.jpg';'*.png';'*.jp2';'*.gif';'*.bmp'},'Select the image file');

dataI.nIm_FISH = length(imfinfo([dataI.pathname dataI.filename]));
f = cell(1, dataI.nIm_FISH);
for i = 1 : dataI.nIm_FISH
    f{i} = imread([dataI.pathname dataI.filename],i);
end
oocyte_c_image = cat(3,f{:});

% new focus
focus_oocyte.is_out_focus = 1;
xy_proj_oocyte = max(oocyte_c_image,[],[1 2]);
focus_oocyte.focus = double(xy_proj_oocyte(:)');
[focus_oocyte.idx_beg, focus_oocyte.idx_end] = bounds(find(focus_oocyte.focus),'all');

end


