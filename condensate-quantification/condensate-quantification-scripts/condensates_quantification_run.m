%===== retrieving dir and files for analysis
[dataI] = get_files_condensates_quantification(cd, files);

%===== load workspace with condensates coordinates
load([dataI.folder dataI.sep dataI.ws], 'CC', 'Cond_IDs', 'number_cells', 'TS_i', 'var_Names', 's');

%===== if new microscope parameters are required
if define_microscope_parameters
    [s] = define_new_microscope_parameters;
end

%===== fitting average mRNA 
flags = struct;
flags.mRNA_flag   = 1; % fit average mRNA image
flags.bound       = 1; % default parameter 
flags.condensates = 0; % fit condensate
flags.show_fits   = 1; % show fits

crop = struct;
crop.xy_pix = pixels_from_xy_center;
crop.z_pix  = pixels_from_z_center;

%===== integrated intensity average PSF
[mRNA_values, result_mRNA, integrated_int_mRNA] = integrated_intensity(flags, s, crop, [], dataI);
single_BGD = double(result_mRNA.maxI) - result_mRNA.bgd;
subs = mRNA_values.mRNA_i - result_mRNA.bgd; 
sum_single_BGD = sum(subs(subs >= 0));

%===== integrated intensity condensates
% base images
file_path = [dataI.folder dataI.sep dataI.raw];
ImInfo = imfinfo(file_path);
imgbase = uint16(zeros(unique([ImInfo.Width]),unique([ImInfo.Height]),length(ImInfo)));
for i = 1 : length(ImInfo)
    imgbase(:,:,i) = imread(file_path,i);
end
clear ImInfo;
% add bgd of an average image
imgbgd = round(result_mRNA.bgd)*ones(size(imgbase));

% condensate fitting - size not restricted
flags = struct;
flags.mRNA_flag   = 0; % fit average mRNA image
flags.bound       = 1; % default parameter 
flags.condensates = 1; % fit condensate
flags.show_fits   = 0; % show fits
flags.centerMass  = 0;
flags.padding     = 1;
crop = [];

% cell arrays
sigmaXY   = cell(1,number_cells/2);
sigmaZ    = cell(1,number_cells/2);
amplitude = cell(1,number_cells/2);
bgd       = cell(1,number_cells/2);
max_int   = cell(1,number_cells/2);
mol_intg  = cell(1,number_cells/2);
cell_id   = cell(1,number_cells/2);
cond_id   = cell(1,number_cells/2);
% additional cell arrays
mol_cum      = cell(1,number_cells/2);
mol_cum_ctrl = cell(1,number_cells/2);
volume_dil   = cell(1,number_cells/2);

% loop through cells and condensates
for c = 1:2:number_cells
cell_number_loop  = (c+1)/2;
cell_number_total = number_cells/2;
number_codensates = CC{(c+1)/2}.NumObjects;
disp(newline)
disp(['%=== PROCESSING CELL NUMBER: ' num2str(cell_number_loop) '===%'])
disp(newline)
sigmaXY{(c+1)/2} = zeros(number_codensates,1);
sigmaZ{(c+1)/2} = zeros(number_codensates,1);
amplitude{(c+1)/2} = zeros(number_codensates,1);
bgd{(c+1)/2} = zeros(number_codensates,1);
max_int{(c+1)/2} = zeros(number_codensates,1);
mol_intg{(c+1)/2} = zeros(number_codensates,1);
cell_id{(c+1)/2} = cell(number_codensates,1);
cond_id{(c+1)/2} = cell(number_codensates,1);
mol_cum{(c+1)/2} = zeros(number_codensates,1);
mol_cum_ctrl{(c+1)/2} = zeros(number_codensates,1);
volume_dil{(c+1)/2} = zeros(number_codensates,1);
% loop through condensates
for i = 1: number_codensates
    disp(['processing cell: ' num2str(cell_number_loop) ' of ' num2str(cell_number_total) '  -> condensate: ' num2str(i) ' of ' num2str(number_codensates) ' ...'])
    cell_id{(c+1)/2}{i,1} = sprintf(['Cell_',num2str((c+1)/2)]);
    cond_id{(c+1)/2}{i,1} = sprintf(['cond_',num2str(i)]);
    
    obj = struct;
    obj.x = Cond_IDs{1,(c+1)/2}(i).PixelList(:,1);
    obj.y = Cond_IDs{1,(c+1)/2}(i).PixelList(:,2);
    obj.z = Cond_IDs{1,(c+1)/2}(i).PixelList(:,3);
    obj.centroid_x = Cond_IDs{1,(c+1)/2}(i).Centroid(1);
    obj.centroid_y = Cond_IDs{1,(c+1)/2}(i).Centroid(2);
    obj.centroid_z = Cond_IDs{1,(c+1)/2}(i).Centroid(3);
    obj.list = Cond_IDs{1,(c+1)/2}(i).PixelIdxList;

    % integrated intensity condensate
    [condensates_val, result_TS, integrated_int_TS] = integrated_intensity(flags, s, crop, obj, dataI);
    
    sigmaXY{(c+1)/2}(i,1) = result_TS.sigmaX;
    sigmaZ{(c+1)/2}(i,1) = result_TS.sigmaZ;
    amplitude{(c+1)/2}(i,1) = result_TS.amp;
    bgd{(c+1)/2}(i,1) = result_TS.bgd;
    max_int{(c+1)/2}(i,1) = result_TS.maxI;
    mol_intg{(c+1)/2}(i,1) = integrated_int_TS/integrated_int_mRNA;
    
    % calculations
    subs_d = condensates_val.dilate - result_mRNA.bgd;
    subs_d_sum = sum(subs_d(subs_d >= 0));
    mol_cum{(c+1)/2}(i,1) = subs_d_sum/sum_single_BGD;
    % ctrl
    subs_e = condensates_val.exact - result_mRNA.bgd;
    subs_e_sum = sum(subs_e(subs_e >= 0));
    mol_cum_ctrl{(c+1)/2}(i,1) = subs_e_sum/sum_single_BGD;
    % volume dil
    volume_dil{(c+1)/2}(i,1) = length(condensates_val.dilate);   
end
end
disp('...Done')

%==== generate table
empty_cells = cellfun(@isempty,TS_i);
info_cond = cat(1,TS_i{~empty_cells});
% id
filename = dataI.raw(1:end-4);
imageid = repmat({filename},[size(info_cond,1), 1]);
% table
T = table(imageid,cat(1,cell_id{:}),cat(1,cond_id{:}),cat(1,sigmaXY{:}),cat(1,sigmaZ{:}),...
    cat(1,amplitude{:}),cat(1,bgd{:}),cat(1,max_int{:}),...
    cat(1,volume_dil{:}),...
    info_cond(:,1),info_cond(:,2),info_cond(:,3),info_cond(:,4),...
    cat(1,mol_intg{:}),cat(1,mol_cum{:}),cat(1,mol_cum_ctrl{:}),...
    'VariableNames',{'imageID','Cell','condensate','SigmaXY','SigmaZ',...
    'Amplitud','BGD','MaxI',...
    'volume_dil','volume','mean_intensity','cumulative_intensity','median_intensity',...
    'n_molecules_intg','n_molecules_cum','n_molecules_cum_ctrl'});
%==== save results
writetable(T, [dataI.folder dataI.sep filename '_condensate_quantification' '.csv'])
