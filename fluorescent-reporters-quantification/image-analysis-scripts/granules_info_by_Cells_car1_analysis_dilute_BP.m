function [TS, Ncells, Tout] = granules_info_by_Cells_car1_analysis_dilute_BP(Folder_Data, img_stack, CC, img_ID, BP)
%% Structures
imageData = Folder_Data;
% Analysis = anaysis_parameters;
%% assing ID by cell
fc = img_stack;
S = double(img_stack);
n_slides = size(fc,3);
% Load cell outlines
Tout = table2array(readtable(imageData.outlines));
[~, Ncells] = size(Tout);
%% Loop through cells
TS = zeros(Ncells/2,8);

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

Sa = double(Oo).*S;

cRowS = double(fc(:));
ccS.NumObjects = CC{img_ID}{(c+1)/2}.NumObjects;
CumInRow = zeros(ccS.NumObjects,1);
CumVolRow = zeros(ccS.NumObjects,1);

for i = 1: ccS.NumObjects
    CumInRow(i) = sum(cRowS(CC{img_ID}{(c+1)/2}.PixelIdxList{i}));
    CumVolRow(i) = length(CC{img_ID}{(c+1)/2}.PixelIdxList{i});
end

if ~BP{img_ID}.is_out_focus
    ROI_Oo_voxels = sum(Oo,'all')*n_slides;

    TS((c+1)/2,1) = img_ID;
    TS((c+1)/2,2) = (c+1)/2;
    TS((c+1)/2,3) = sum(Sa,'all');
    TS((c+1)/2,4) = sum(CumInRow);
    TS((c+1)/2,5) = sum(Sa,'all') - sum(CumInRow);
    TS((c+1)/2,6) = ROI_Oo_voxels;
    TS((c+1)/2,7) = sum(CumVolRow);
    TS((c+1)/2,8) = ROI_Oo_voxels - sum(CumVolRow);
end

if BP{img_ID}.is_out_focus
    
    min_slide = BP{img_ID}.idx_beg - 1;
    if min_slide < 1; min_slide = 1; end
    max_slide = BP{img_ID}.idx_end + 1;
    if max_slide > n_slides; max_slide = n_slides; end
    
    n_slides_BP = max_slide - min_slide + 1;
        
    ROI_Oo_voxels = sum(Oo,'all')*n_slides_BP;
    disp([min_slide max_slide n_slides_BP])

    TS((c+1)/2,1) = img_ID; %'img'
    TS((c+1)/2,2) = (c+1)/2; %'cell'
    TS((c+1)/2,3) = sum(Sa(:,:,min_slide:max_slide),'all'); %'CAR1_total'
    TS((c+1)/2,4) = sum(CumInRow); %'CAR1_cond'
    TS((c+1)/2,5) = sum(Sa(:,:,min_slide:max_slide),'all') - sum(CumInRow); %'CAR_dil'
    TS((c+1)/2,6) = ROI_Oo_voxels; %'vol_cell'
    TS((c+1)/2,7) = sum(CumVolRow); %'vol_cond'
    TS((c+1)/2,8) = ROI_Oo_voxels - sum(CumVolRow); %'vol_dil'
end

end
end