function [var_Names, TS, Cond_IDs, CC, Ncells, Tout] = segmentation_by_cell(Folder_Data, seg_parameters, r, FISH_Image)
% structures
imageData = Folder_Data;
par = seg_parameters;

% assing ID by cell
fc = FISH_Image;
S = r;

% load cell outlines
Tout = table2array(readtable([imageData.Folder imageData.sep imageData.outline]));
[Rcells, Ncells] = size(Tout);
Tout2 = NaN([Rcells Ncells]);

% loop through cells
ccSTx = cell(1,Ncells/2);
DgSTx = cell(1,Ncells/2);
var_Names = {'volume','mean_int','cumulative_int','median_int'};
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

Oo = roipoly(max(S,[],3),x_coordinate,y_coordinate);
% Oo = roipoly(max(S,[],3),Tout(~isnan(Tout(:,c)),c),Tout(~isnan(Tout(:,c+1)),c+1));

Tout2(1:length(x_coordinate),c) = x_coordinate';
Tout2(1:length(y_coordinate),c+1) = y_coordinate';

Sa = bwareaopen(logical(Oo.*S),par.Vol_Th,par.conn_comp);
ccS = bwconncomp(Sa,par.conn_comp);
ccSTx{(c+1)/2} = ccS;
% getting properties
DgS = regionprops(ccS,'Area','Centroid','PixelIdxList','PixelList');
DgSTx{(c+1)/2} = DgS;
% intensities
meanInt = zeros(ccS.NumObjects,1);
cumInt = zeros(ccS.NumObjects,1);
medianInt = zeros(ccS.NumObjects,1);

intensities = double(fc(:));
for i = 1: ccS.NumObjects
    meanInt(i) = mean(intensities(ccS.PixelIdxList{i}));
    cumInt(i) = sum(intensities(ccS.PixelIdxList{i}));
    medianInt(i) = median(intensities(ccS.PixelIdxList{i}));
end
% allocating data
TS{(c+1)/2} = [[DgS.Area]', meanInt, cumInt, medianInt];

% rm
S(Sa) = 0;
end

Tout = Tout2;
CC = ccSTx;
Cond_IDs = DgSTx;
end