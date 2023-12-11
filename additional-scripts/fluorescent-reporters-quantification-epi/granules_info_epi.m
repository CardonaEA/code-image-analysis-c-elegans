function [var_Names, TS, Cond_IDs, CC, Ncells, Tout, oo_area] = granules_info_epi(Folder_Data, seg_parameters, r, img_stack)
%=== structures
imageData = Folder_Data;
par = seg_parameters;
% images
fc = img_stack;
nslices = size(fc,3);
S = r;
%==== load cell outlines
Tout = table2array(readtable([imageData.folder imageData.sep imageData.outline]));
[~, Ncells] = size(Tout);
%=== loop through cells
ccSTx = cell(1,Ncells/2);
DgSTx = cell(1,Ncells/2);
oo_area = zeros(Ncells/2,1);

%=== loop
var_Names = {'Cell','Volume','MeanInt','CumInt','MedianInt'};
TS = cell(Ncells/2,1);

% matlab < 2020a compatibility
matComp = iscell(Tout);

for c = 1:2:Ncells
x_coordinate = Tout(:,c);
y_coordinate = Tout(:,c+1);

if matComp 
    x_coordinate = cellfun(@str2num, x_coordinate, 'UniformOutput',false);
    y_coordinate = cellfun(@str2num, y_coordinate, 'UniformOutput',false);

    x_coordinate = [x_coordinate{:}];
    y_coordinate = [y_coordinate{:}];
else
    x_coordinate = x_coordinate(~isnan(x_coordinate));
    y_coordinate = y_coordinate(~isnan(y_coordinate));
end

Oo = roipoly(S(:,:,1),x_coordinate,y_coordinate);
oo_area((c+1)/2) = sum(Oo,'all')*nslices;
Sa = bwareaopen(logical(Oo.*S),par.small_objects_size,par.components_conn);

ccS = bwconncomp(Sa,par.components_conn);
ccSTx{(c+1)/2} = ccS;
% getting properties
DgS = regionprops(ccS,'Area','Centroid','PixelIdxList','PixelList');
DgSTx{(c+1)/2} = DgS;
% intensities
cell_idx = zeros(ccS.NumObjects,1);
rawInt = zeros(ccS.NumObjects,1);
cumInt = zeros(ccS.NumObjects,1);
medianInt = zeros(ccS.NumObjects,1);

img = double(fc(:));
for i = 1: ccS.NumObjects
    cell_idx(i) = (c+1)/2;
    rawInt(i) = mean(img(ccS.PixelIdxList{i}));
    cumInt(i) = sum(img(ccS.PixelIdxList{i}));
    medianInt(i) = median(img(ccS.PixelIdxList{i}));
end
%==== results
TS{(c+1)/2} = [cell_idx, [DgS.Area]', rawInt, cumInt, medianInt];
% remove for next cycle
S(Sa) = 0;
end
CC = ccSTx;
Cond_IDs = DgSTx;
end