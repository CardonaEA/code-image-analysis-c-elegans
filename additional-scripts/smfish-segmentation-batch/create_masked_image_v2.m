function [Masked_Image] = create_masked_image_v2(Raw_Image, Folder_Data, number_cells, Outlines_cells, CC, analysis_parameters, microcope_par)
imageData = Folder_Data;
Ncells = number_cells;
Tout = Outlines_cells;
cond = Raw_Image;
ccSTx = CC;
Analysis = analysis_parameters;
s = microcope_par;

if Analysis.NoGranules
    disp('generating outline and saving masked image...')
    fold = [imageData.Folder imageData.sep];
    % filename
    switch Analysis.ImageType
        case 0
            fName2 = [imageData.raw(1:end-4) '_GFP_NoGranules' '__outline'];
        case 1
            fName2 = [imageData.raw(1:end-4) '_FISH_NoGranules' '__outline'];
        case 2
            fName2 = [imageData.raw(1:end-4) '_GFP_FISH_NoGranules' '__outline'];
        otherwise
            fName2 = [imageData.raw(1:end-4) '_NoGranules' '__outline'];
    end
    % end filename
    % make outlines and TxS
    Zpos =  sprintf(['Z_POS','\t']);
    CellEnd = 'CELL_END';
    TxSite = cell(1,Ncells/2);
    
    for c = 1:2:Ncells
        TxSite{(c+1)/2} = cell(ccSTx{(c+1)/2}.NumObjects,1);
        CellStart = sprintf(['CELL_START','\t','Cell_',num2str((c+1)/2)]);
        XposC = sprintf(['X_POS','\t',sprintf('%lu\t',int16(Tout(~isnan(Tout(:,c)),c)))]);
        YposC = sprintf(['Y_POS','\t',sprintf('%lu\t',int16(Tout(~isnan(Tout(:,c+1)),c+1)))]);
        outlineC = sprintf('%1$s\n%2$s\n%3$s\n%4$s\n%5$s',CellStart, XposC, YposC, Zpos, CellEnd);
        
        %=== TxS
        for i = 1: ccSTx{(c+1)/2}.NumObjects
            cond(ccSTx{(c+1)/2}.PixelIdxList{i}) = 0;
        end
        TxSite{(c+1)/2} = cat(1,{outlineC});
    end
    FQv = sprintf(['FISH-QUANT','\t','v3a']);
    FQFv = sprintf(['File-version','\t','3D_v1']);
    Rsp = 'RESULTS OF SPOT DETECTION PERFORMED ON 22-May-2019 ';
    Comt = sprintf(['COMMENT','\t','ByMATLABscript']);
    FQi = sprintf(['IMG_Raw','\t','Masked_' imageData.raw]);
    FQf = sprintf(['IMG_Filtered','\t']);
    FQd = sprintf(['IMG_DAPI','\t']);
    FQts = sprintf(['IMG_TS_label','\t']);
    FQfs = sprintf(['FILE_settings','\t']);
    FQp = sprintf(['PARAMETERS','\t']);
    FQp1 = sprintf(['Pix-XY','\t','Pix-Z','\t','RI','\t','Ex','\t','Em','\t','NA','\t','Type']);
    FQp2 = sprintf([num2str(s.Pixel.xy),'\t',num2str(s.Pixel.z),'\t',num2str(s.RI),'\t',num2str(s.Ex),'\t',num2str(s.Em),'\t',num2str(s.NA),'\t',s.type]);
    HeaderC = sprintf('%1$s\n%2$s\n%3$s\n%4$s\n%5$s\n%6$s\n%7$s\n%8$s\n%9$s\n%10$s\n%11$s\n%12$s',FQv, FQFv, Rsp, Comt, FQi, FQf, FQd, FQts, FQfs, FQp, FQp1, FQp2);
    Tc = cat(1,{HeaderC},TxSite{:});
    Tf = cell2table(Tc);
    writetable(Tf,[fold fName2 '.txt'],'FileType','text','Delimiter','tab','WriteVariableNames',false,'QuoteStrings',false)
    Masked_Image = cond;
    
    %=== save masked image
    [~, ~, nIm] = size(cond);
    imwrite(cond(:,:,1), [fold 'Masked_' imageData.raw(1:end-4) '.tif'],'compression','none')
    for k = 2 : nIm
        imwrite(cond(:,:,k),[fold 'Masked_' imageData.raw(1:end-4) '.tif'],'compression','none','WriteMode','append')
    end
else
    Masked_Image = 'Analysis.NoGranules = 0';
end
end