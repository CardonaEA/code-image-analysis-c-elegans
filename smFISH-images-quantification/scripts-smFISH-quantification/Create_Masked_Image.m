%% Outlines for FQ
function [Masked_Image] = Create_Masked_Image(Raw_Image, Folder_Data, number_cells, Outlines_cells, CC, analysis_parameters, microcope_par)
imageData = Folder_Data;
Ncells = number_cells;
Tout = Outlines_cells;

% r = Mask_image;
cond = Raw_Image;
ccSTx = CC;
% DgSTx = Cond_IDs;

% par = seg_parameters; % not used
Analysis = analysis_parameters;
s = microcope_par;

if Analysis.FQ && Analysis.NoGranules
%% Saving settings
fold = [imageData.Folder imageData.sep];
% Filename
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
% End filename
%% getting outlines and TxS
Zpos =  sprintf(['Z_POS','\t']);
% TxEdnd = 'TxSite_END';
CellEnd = 'CELL_END';
TxSite = cell(1,Ncells/2);
% TxSite_FQ = cell(1,Ncells/2); % NEW

for c = 1:2:Ncells
% cond = false(size(r));
TxSite{(c+1)/2} = cell(ccSTx{(c+1)/2}.NumObjects,1);
% TxSite_FQ{(c+1)/2} = cell(ccSTx{(c+1)/2}.NumObjects,2); %NEW

CellStart = sprintf(['CELL_START','\t','Cell_',num2str((c+1)/2)]);
XposC = sprintf(['X_POS','\t',sprintf('%lu\t',int16(Tout(~isnan(Tout(:,c)),c)))]);
YposC = sprintf(['Y_POS','\t',sprintf('%lu\t',int16(Tout(~isnan(Tout(:,c+1)),c+1)))]);
outlineC = sprintf('%1$s\n%2$s\n%3$s\n%4$s\n%5$s',CellStart, XposC, YposC, Zpos, CellEnd);

%%
% if par.dilate 
% img_TS_large = zeros(size(fc));
% end
%% TxS
for i = 1: ccSTx{(c+1)/2}.NumObjects
%     if par.dilate    
%     TSp = struct;
%     
%     TSp.x = DgSTx{(c+1)/2}(i).PixelList(:,1);
%     TSp.y = DgSTx{(c+1)/2}(i).PixelList(:,2);
%     TSp.z = DgSTx{(c+1)/2}(i).PixelList(:,3);
%     TSp.list = DgSTx{(c+1)/2}(i).PixelIdxList;
% 
%     [pos_TS] = TSdilate(img_TS_large, TSp);
%     
% %     DgSTx{(c+1)/2}(i).PixelList(:,1) = pos_TS.x;
% %     DgSTx{(c+1)/2}(i).PixelList(:,2) = pos_TS.y;
% %     DgSTx{(c+1)/2}(i).PixelList(:,3) = pos_TS.z;
%     DgSTx{(c+1)/2}(i).PixelIdxList =  pos_TS.list;
%     DgSTx{(c+1)/2}(i).PixelList = [pos_TS.x pos_TS.y pos_TS.z];
%     
%     ccSTx{(c+1)/2}.PixelIdxList{i} =  pos_TS.list;
%     end
    
%     cond(ccSTx{(c+1)/2}.PixelIdxList{i}) = 1;
%     mPg2c = max(cond,[],3);
%     ccFc = bwconncomp(mPg2c,8);
%     statsc = regionprops(ccFc,'ConvexHull');
    cond(ccSTx{(c+1)/2}.PixelIdxList{i}) = 0;
%     
%     TxSite_FQ{(c+1)/2}{i,1} = statsc.ConvexHull(:,1);
%     TxSite_FQ{(c+1)/2}{i,2} = statsc.ConvexHull(:,2);
% 
%     TxStart = sprintf(['TxSite_START','\t','TS_',num2str(i)]);
%     Xpos = sprintf(['X_POS','\t',sprintf('%lu\t',int16(statsc.ConvexHull(:,1))),'END']);
%     Ypos = sprintf(['Y_POS','\t',sprintf('%lu\t',int16(statsc.ConvexHull(:,2))),'END']);
%     TxSite{(c+1)/2}{i,1} = sprintf('%1$s\n%2$s\n%3$s\n%4$s\n%5$s',TxStart, Xpos, Ypos, Zpos, TxEdnd);
end
% TxSite{(c+1)/2} = cat(1,{outlineC},TxSite{(c+1)/2}{:,1});
TxSite{(c+1)/2} = cat(1,{outlineC});
end
FQv = sprintf(['FISH-QUANT','\t','v3a']);
FQFv = sprintf(['File-version','\t','3D_v1']);
Rsp = 'RESULTS OF SPOT DETECTION PERFORMED ON 22-May-2019 ';
Comt = sprintf(['COMMENT','\t','ByMATLABscript']);
% FQi = sprintf(['IMG_Raw','\t',imageData.raw]);
FQi = sprintf(['IMG_Raw','\t','Masked_' imageData.raw]);
FQf = sprintf(['IMG_Filtered','\t']);
FQd = sprintf(['IMG_DAPI','\t']);
FQts = sprintf(['IMG_TS_label','\t']);
FQfs = sprintf(['FILE_settings','\t']);
FQp = sprintf(['PARAMETERS','\t']);
FQp1 = sprintf(['Pix-XY','\t','Pix-Z','\t','RI','\t','Ex','\t','Em','\t','NA','\t','Type']);
%FQp2 = sprintf(['43','\t','185','\t','1.518','\t','650','\t','669','\t','1.4','\t','confocal']);
FQp2 = sprintf([num2str(s.Pixel.xy),'\t',num2str(s.Pixel.z),'\t',num2str(s.RI),'\t',num2str(s.Ex),'\t',num2str(s.Em),'\t',num2str(s.NA),'\t',s.type]);
HeaderC = sprintf('%1$s\n%2$s\n%3$s\n%4$s\n%5$s\n%6$s\n%7$s\n%8$s\n%9$s\n%10$s\n%11$s\n%12$s',FQv, FQFv, Rsp, Comt, FQi, FQf, FQd, FQts, FQfs, FQp, FQp1, FQp2);
Tc = cat(1,{HeaderC},TxSite{:});
% Tc = cat(1,TxSite{:});
Tf = cell2table(Tc);
writetable(Tf,[fold fName2 '.txt'],'FileType','text','Delimiter','tab','WriteVariableNames',false,'QuoteStrings',false)
% FQ_sites = TxSite_FQ;
Masked_Image = cond;

%% Save masked image
[~, ~, nIm] = size(cond);
imwrite(cond(:,:,1), [fold 'Masked_' imageData.raw(1:end-4) '.tif'],'compression','none')
for k = 2 : nIm
imwrite(cond(:,:,k),[fold 'Masked_' imageData.raw(1:end-4) '.tif'],'compression','none','WriteMode','append')
end
else
% FQ_sites = 'Analysis.FQ = 0';
Masked_Image = 'Analysis.FQ = 0 and/or Analysis.NoGranules = 0';
end
%%
% CC = ccSTx;
% Cond_IDs = DgSTx;
end