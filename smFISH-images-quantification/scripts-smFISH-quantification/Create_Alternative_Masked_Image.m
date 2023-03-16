%% Outlines for FQ
function [Masked_Image, Filtered_Image] = Create_Alternative_Masked_Image(Raw_Image, Folder_Data, number_cells, Outlines_cells, CC, analysis_parameters, microcope_par)
imageData = Folder_Data;
Ncells = number_cells;
Tout = Outlines_cells;

% r = Mask_image;
cond = Raw_Image;
ccSTx = CC;
% DgSTx = Cond_IDs;

Analysis = analysis_parameters;
s = microcope_par;

if Analysis.FQ && Analysis.Filt.gauss2x
%% Saving settings
fold = [imageData.Folder imageData.sep];
% Filename
switch Analysis.ImageType
case 0
    fName2 = [imageData.raw(1:end-4) '_GFP_Alternative' '__outline'];
case 1
    fName2 = [imageData.raw(1:end-4) '_FISH_Alternative' '__outline'];
case 2
    fName2 = [imageData.raw(1:end-4) '_GFP_FISH_Alternative' '__outline'];
otherwise
    fName2 = [imageData.raw(1:end-4) '_Alternative' '__outline'];
end
% End filename

%% Gauss doble filter --- RAW
kernel_size.bgd_xy = Analysis.Filt.bgd_xy;
kernel_size.bgd_z = Analysis.Filt.bgd_z;

kernel_size.psf_xy = Analysis.Filt.spots_xy;
kernel_size.psf_z = Analysis.Filt.spots_z;
flag.output = Analysis.Filt.output;
tic
[img_filt_raw, ~] = img_filter_Gauss_v5(cond,kernel_size,flag);
toc
%% Raw image ---- white granules
Max_Int_raw = max(cond,[],'all');
disp(' ')
disp(['Max Intensity Raw: ',  num2str(Max_Int_raw)])

Max_Int_raw = uint16(Max_Int_raw * 3);
disp(['Max Intensity Raw in Image: ',  num2str(Max_Int_raw)])
disp(' ')
tic
% white granules
cond2 = uint16(zeros(size(cond)));
for c = 1:2:Ncells
% TxS
for i = 1: ccSTx{(c+1)/2}.NumObjects
cond(ccSTx{(c+1)/2}.PixelIdxList{i}) = Max_Int_raw;
cond2(ccSTx{(c+1)/2}.PixelIdxList{i}) = 2^16;
end
end
toc
%% Gauss doble filter --- Granules
tic
[img_filt_cond, ~] = img_filter_Gauss_v5(cond2,kernel_size,flag);
toc
disp(' ')
disp(['Filtering cntrol = 0; actual value = ',  num2str(sum(img_filt_cond(~cond2),'all'))])

%% New Filter Image
img_filt_cond(~cond2) = img_filt_raw(~cond2);

%% getting outlines and TxS
Zpos =  sprintf(['Z_POS','\t']);
CellEnd = 'CELL_END';
TxSite = cell(1,Ncells/2);

for c = 1:2:Ncells
TxSite{(c+1)/2} = cell(ccSTx{(c+1)/2}.NumObjects,1);

CellStart = sprintf(['CELL_START','\t','Cell_',num2str((c+1)/2)]);
XposC = sprintf(['X_POS','\t',sprintf('%lu\t',int16(Tout(~isnan(Tout(:,c)),c)))]);
YposC = sprintf(['Y_POS','\t',sprintf('%lu\t',int16(Tout(~isnan(Tout(:,c+1)),c+1)))]);
outlineC = sprintf('%1$s\n%2$s\n%3$s\n%4$s\n%5$s',CellStart, XposC, YposC, Zpos, CellEnd);
TxSite{(c+1)/2} = cat(1,{outlineC});
end

FQv = sprintf(['FISH-QUANT','\t','v3a']);
FQFv = sprintf(['File-version','\t','3D_v1']);
Rsp = 'RESULTS OF SPOT DETECTION PERFORMED ON 22-May-2019 ';
Comt = sprintf(['COMMENT','\t','ByMATLABscript']);
% FQi = sprintf(['IMG_Raw','\t',imageData.raw]);
FQi = sprintf(['IMG_Raw','\t','alternative_' imageData.raw]);
FQf = sprintf(['IMG_Filtered','\t','alternative_Filtered_' imageData.raw]);
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

%% Outputs
Masked_Image = cond;
Filtered_Image = img_filt_cond;

%% Save masked (alternative) images
[~, ~, nIm] = size(cond);
imwrite(cond(:,:,1), [fold 'alternative_' imageData.raw(1:end-4) '.tif'],'compression','none')
for k = 2 : nIm
imwrite(cond(:,:,k), [fold 'alternative_' imageData.raw(1:end-4) '.tif'],'compression','none','WriteMode','append')
end

imwrite(img_filt_cond(:,:,1), [fold 'alternative_Filtered_' imageData.raw(1:end-4) '.tif'],'compression','none')
for k = 2 : nIm
imwrite(img_filt_cond(:,:,k), [fold 'alternative_Filtered_' imageData.raw(1:end-4) '.tif'],'compression','none','WriteMode','append')
end

else
% FQ_sites = 'Analysis.FQ = 0';
Masked_Image = 'Analysis.FQ = 0 and/or Analysis.Filt.gauss2x = 0';
Filtered_Image = 'Analysis.FQ = 0 and/or Analysis.Filt.gauss2x = 0';
end
%%
% CC = ccSTx;
% Cond_IDs = DgSTx;
end