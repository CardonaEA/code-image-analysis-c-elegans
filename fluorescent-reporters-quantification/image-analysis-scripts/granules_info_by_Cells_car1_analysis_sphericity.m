function [var_Names, TS, Cond_IDs, CC, Ncells, Tout] = granules_info_by_Cells_car1_analysis_sphericity(Folder_Data, seg_parameters, r, img_stack)
%% Structures
imageData = Folder_Data;
par = seg_parameters;
% Analysis = anaysis_parameters;
%% assing ID by cell
fc = img_stack;
S = r;
% Load cell outlines
Tout = table2array(readtable(imageData.outlines));
[~, Ncells] = size(Tout);
%% Loop through cells
% [~, ~, nIm] = size(S); % Z dim
ccSTx = cell(1,Ncells/2);
DgSTx = cell(1,Ncells/2);

% Loop
var_Names = {'Cell','granule','Surface_Area','Volume','sphericity','MeanInt','CumInt','MedianInt','Volume_um3'};
TS = cell(Ncells/2,1);

for c = 1:2:Ncells
x_coordinate = Tout(:,c);
y_coordinate = Tout(:,c+1);

x_coordinate = cellfun(@str2num, x_coordinate, 'UniformOutput',false);
y_coordinate = cellfun(@str2num, y_coordinate, 'UniformOutput',false);

x_coordinate = [x_coordinate{:}];
y_coordinate = [y_coordinate{:}];

Oo = roipoly(max(S,[],3),x_coordinate,y_coordinate);

if par.old_Version
    for i = 1 : nIm
        Sa(:,:,i) = logical(Oo.*S(:,:,i));
    end
    Sa = bwareaopen(Sa,par.small_objects_size,par.components_conn);
else
    Sa = bwareaopen(logical(Oo.*S),par.small_objects_size,par.components_conn);
end

ccS = bwconncomp(Sa,par.components_conn);
ccSTx{(c+1)/2} = ccS;
% Getting properties
DgS = regionprops3(ccS,'SurfaceArea','Volume','VoxelIdxList','VoxelList');
DgSTx{(c+1)/2} = DgS;
%% Intensities
CellRowS = zeros(ccS.NumObjects,1);
granuleRowS = zeros(ccS.NumObjects,1);
IntRowS = zeros(ccS.NumObjects,1);
CumInRow = zeros(ccS.NumObjects,1);
MedianInRow = zeros(ccS.NumObjects,1);

cRowS = double(fc(:));
for i = 1: ccS.NumObjects
    CellRowS(i) = (c+1)/2;
    granuleRowS(i) = i;
    IntRowS(i) = mean(cRowS(ccS.PixelIdxList{i}));
    CumInRow(i) = sum(cRowS(ccS.PixelIdxList{i}));
    MedianInRow(i) = median(cRowS(ccS.PixelIdxList{i}));
end
%% Results
TS{(c+1)/2} = [CellRowS, granuleRowS, DgS.SurfaceArea, DgS.Volume,...
    (power(36*pi*power(DgS.Volume,2),1/3)) ./ (DgS.SurfaceArea),...
    IntRowS, CumInRow, MedianInRow,...
    par.voxel_size*DgS.Volume];

if par.old_Version
    S = logical(S - Sa);
else
    S(Sa) = 0;  
end
end
CC = ccSTx;
Cond_IDs = DgSTx;
end