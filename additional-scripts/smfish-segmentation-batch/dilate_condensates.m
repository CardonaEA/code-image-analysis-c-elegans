function [CC, Cond_IDs] = dilate_condensates(number_cells, mask_image, CC, Cond_IDs)
ncells = number_cells;
img_dim = size(mask_image);
ccSTx = CC;
DgSTx = Cond_IDs;

cell_number_total = ncells/2;
for c = 1:2:ncells
    cell_number_loop = (c+1)/2;
    number_codensates = ccSTx{(c+1)/2}.NumObjects;
    disp([' - processing cell number: ' num2str(cell_number_loop) ' of ' num2str(cell_number_total) '  ->  dilating ' num2str(number_codensates) ' condensates...'])
 
    img_TS_large = zeros(img_dim);
    for i = 1: ccSTx{(c+1)/2}.NumObjects
        %disp(['processing cell: ' num2str(cell_number_loop) ' of ' num2str(cell_number_total) '  -> condensate: ' num2str(i) ' of ' num2str(number_codensates) ' ...'])   
        TSp = struct;
        TSp.x = DgSTx{(c+1)/2}(i).PixelList(:,1);
        TSp.y = DgSTx{(c+1)/2}(i).PixelList(:,2);
        TSp.z = DgSTx{(c+1)/2}(i).PixelList(:,3);
        TSp.list = DgSTx{(c+1)/2}(i).PixelIdxList;    
        [pos_TS] = TSdilate(img_TS_large, TSp);
        DgSTx{(c+1)/2}(i).PixelIdxList =  pos_TS.list;
        DgSTx{(c+1)/2}(i).PixelList = [pos_TS.x pos_TS.y pos_TS.z];
        ccSTx{(c+1)/2}.PixelIdxList{i} =  pos_TS.list;  
    end
end
CC = ccSTx;
Cond_IDs = DgSTx;
end