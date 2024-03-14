function [FQ_sites, CC, Cond_IDs] = create_outlines_FQ_v3(Folder_Data, number_cells, Outlines_cells, mask_image, CC, Cond_IDs, analysis_parameters, microcope_par)
imageData = Folder_Data;
Ncells = number_cells;
Tout = Outlines_cells;
img_dim = size(mask_image);
ccSTx = CC;
DgSTx = Cond_IDs;
Analysis = analysis_parameters;
s = microcope_par;

if Analysis.FQ
    disp('generating FQ outline...')
    fold = [imageData.Folder imageData.sep];
    % filename
    switch Analysis.ImageType
        case 0
            fName2 = [imageData.raw(1:end-4) '_GFP' '__outline'];
        case 1
            fName2 = [imageData.raw(1:end-4) '_FISH' '__outline'];
        case 2
            fName2 = [imageData.raw(1:end-4) '_GFP_FISH' '__outline'];
        otherwise
            fName2 = [imageData.raw(1:end-4) '__outline'];
    end
    % end filename
    % make outlines and TxS
    Zpos =  sprintf(['Z_POS','\t']);
    TxEdnd = 'TxSite_END';
    CellEnd = 'CELL_END';
    TxSite = cell(1,Ncells/2);
    TxSite_FQ = cell(1,Ncells/2);
    
    cell_number_total = Ncells/2;
    for c = 1:2:Ncells
        cell_number_loop = (c+1)/2;
        %cell_number_total = Ncells/2;
        number_codensates = ccSTx{(c+1)/2}.NumObjects;
        %disp(newline)
        %disp(['%=== PROCESSING CELL NUMBER: ' num2str(cell_number_loop) '===%'])
        disp([' - processing cell number: ' num2str(cell_number_loop) ' of ' num2str(cell_number_total) '  ->  projecting ' num2str(number_codensates) ' condensates (TSs)...'])
        % disp(newline)
        
        cond = false(img_dim);
        TxSite{(c+1)/2} = cell(ccSTx{(c+1)/2}.NumObjects,1);
        TxSite_FQ{(c+1)/2} = cell(ccSTx{(c+1)/2}.NumObjects,2);
        CellStart = sprintf(['CELL_START','\t','Cell_',num2str((c+1)/2)]);
        XposC = sprintf(['X_POS','\t',sprintf('%lu\t',int16(Tout(~isnan(Tout(:,c)),c)))]);
        YposC = sprintf(['Y_POS','\t',sprintf('%lu\t',int16(Tout(~isnan(Tout(:,c+1)),c+1)))]);
        outlineC = sprintf('%1$s\n%2$s\n%3$s\n%4$s\n%5$s',CellStart, XposC, YposC, Zpos, CellEnd);
        
        %=== TxS
        for i = 1: ccSTx{(c+1)/2}.NumObjects
            %disp(['processing cell: ' num2str(cell_number_loop) ' of ' num2str(cell_number_total) '  -> condensate: ' num2str(i) ' of ' num2str(number_codensates) ' ...'])
            cond(ccSTx{(c+1)/2}.PixelIdxList{i}) = 1;
            mPg2c = max(cond,[],3);
            ccFc = bwconncomp(mPg2c,8);
            statsc = regionprops(ccFc,'ConvexHull');
            cond(ccSTx{(c+1)/2}.PixelIdxList{i}) = 0;
            TxSite_FQ{(c+1)/2}{i,1} = statsc.ConvexHull(:,1);
            TxSite_FQ{(c+1)/2}{i,2} = statsc.ConvexHull(:,2);
            TxStart = sprintf(['TxSite_START','\t','TS_',num2str(i)]);
            Xpos = sprintf(['X_POS','\t',sprintf('%lu\t',int16(statsc.ConvexHull(:,1))),'END']);
            Ypos = sprintf(['Y_POS','\t',sprintf('%lu\t',int16(statsc.ConvexHull(:,2))),'END']);
            TxSite{(c+1)/2}{i,1} = sprintf('%1$s\n%2$s\n%3$s\n%4$s\n%5$s',TxStart, Xpos, Ypos, Zpos, TxEdnd);
        end
        TxSite{(c+1)/2} = cat(1,{outlineC},TxSite{(c+1)/2}{:,1});
    end
    FQv = sprintf(['FISH-QUANT','\t','v3a']);
    FQFv = sprintf(['File-version','\t','3D_v1']);
    Rsp = 'RESULTS OF SPOT DETECTION PERFORMED ON 22-May-2019 ';
    Comt = sprintf(['COMMENT','\t','ByMATLABscript']);
    FQi = sprintf(['IMG_Raw','\t',imageData.raw]);
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
    FQ_sites = TxSite_FQ;
else
    FQ_sites = 'Analysis.FQ = 0';
end
CC = ccSTx;
Cond_IDs = DgSTx;
end