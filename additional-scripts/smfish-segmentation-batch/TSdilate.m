function [TSp_fil] = TSdilate(ZerosIm, TSp)
%%
% TSp_fil = TSp;
% zeI = ZerosIm;
% zeI(TSp.list) = 1;
% 
% zeI2 = imdilate(zeI,strel('sphere',2));
% %zeI2 = imdilate(zeI,strel('cuboid',[2 2 2]));
% 
% subI = find(zeI2);
% [I, J, K] = ind2sub(size(zeI),subI);
% 
% TSp_fil.x = J;
% TSp_fil.y = I;
% TSp_fil.z = K;
% 
% TSp_fil.list = subI;
%%

TSp_fil = TSp;
zeI = ZerosIm;
zeI(TSp_fil.list) = 1;

%=== Extract image of transcription site !!! Adding some extra pixels for background
min_x = min(TSp_fil.x) - 10;
max_x = max(TSp_fil.x) + 10;
min_y = min(TSp_fil.y) - 10;
max_y = max(TSp_fil.y) + 10;
min_z = min(TSp_fil.z) - 10;
max_z = max(TSp_fil.z) + 10;

%- Make sure cropping is within image
%dim = img.dim;
[dim.Y, dim.X, dim.Z] = size(zeI);

if min_x < 1; min_x = 1; end
if max_x > dim.X; max_x = dim.X; end
if min_y < 1; min_y = 1; end
if max_y > dim.Y; max_y = dim.Y; end
if min_z < 1; min_z = 1; end
if max_z > dim.Z; max_z = dim.Z; end

img_TS_crop_xyz = zeI(min_y:max_y,min_x:max_x,min_z:max_z);

zeI2 = imdilate(img_TS_crop_xyz,strel('sphere',2));
%zeI2 = imdilate(zeI,strel('cuboid',[2 2 2]));

zeI(min_y:max_y,min_x:max_x,min_z:max_z) = zeI2;

subI = find(zeI);

[I, J, K] = ind2sub(size(zeI),subI);

TSp_fil.x = J;
TSp_fil.y = I;
TSp_fil.z = K;

TSp_fil.list = subI;

end
