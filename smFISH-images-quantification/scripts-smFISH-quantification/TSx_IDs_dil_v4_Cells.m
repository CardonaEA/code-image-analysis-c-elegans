function [var_Names, TS, Cond_IDs, CC, Ncells, Tout] = TSx_IDs_dil_v4_Cells(Folder_Data, seg_parameters, r, FISH_Image)
%% Structures
imageData = Folder_Data;
par = seg_parameters;
% Analysis = anaysis_parameters;
%% assing ID by cell
fc = FISH_Image;
S = r;
% Load cell outlines
Tout = table2array(readtable([imageData.Folder imageData.sep imageData.outline]));
[Rcells, Ncells] = size(Tout);
Tout2 = NaN([Rcells Ncells]);
%% Loop through cells
ccSTx = cell(1,Ncells/2);
DgSTx = cell(1,Ncells/2);

% Loop
var_Names = {'Volume','MeanRowInt','CumRowInt','MedianRowInt'};
TS = cell(Ncells/2,1);

for c = 1:2:Ncells
x_coordinate = Tout(:,c);
y_coordinate = Tout(:,c+1);

x_coordinate = cellfun(@str2num, x_coordinate, 'UniformOutput',false);
y_coordinate = cellfun(@str2num, y_coordinate, 'UniformOutput',false);

x_coordinate = [x_coordinate{:}];
y_coordinate = [y_coordinate{:}];

Oo = roipoly(max(S,[],3),x_coordinate,y_coordinate);
% Oo = roipoly(max(S,[],3),Tout(~isnan(Tout(:,c)),c),Tout(~isnan(Tout(:,c+1)),c+1));

Tout2(1:length(x_coordinate),c) = x_coordinate';
Tout2(1:length(y_coordinate),c+1) = y_coordinate';

if par.old_Version
    for i = 1 : nIm
        Sa(:,:,i) = logical(Oo.*S(:,:,i));
    end
    Sa = bwareaopen(Sa,par.Vol_Th,6);
else
    Sa = bwareaopen(logical(Oo.*S),par.Vol_Th,6);
end

ccS = bwconncomp(Sa,6);
ccSTx{(c+1)/2} = ccS;
% Getting properties
DgS = regionprops(ccS,'Area','Centroid','PixelIdxList','PixelList');
DgSTx{(c+1)/2} = DgS;
%% Intensities
IntRowS = zeros(ccS.NumObjects,1);
CumInRow = zeros(ccS.NumObjects,1);
MedianInRow = zeros(ccS.NumObjects,1);

cRowS = double(fc(:));
for i = 1: ccS.NumObjects
    IntRowS(i) = mean(cRowS(ccS.PixelIdxList{i}));
    CumInRow(i) = sum(cRowS(ccS.PixelIdxList{i}));
    MedianInRow(i) = median(cRowS(ccS.PixelIdxList{i}));
end
%% Saving results, ALL THE INFO IS IN cc, Dg, IntRow AND IntFil variables
TS{(c+1)/2} = [[DgS.Area]', IntRowS, CumInRow, MedianInRow];

if par.old_Version
    S = logical(S - Sa);
else
    S(Sa) = 0;  
end
end

Tout = Tout2;
CC = ccSTx;
Cond_IDs = DgSTx;
end