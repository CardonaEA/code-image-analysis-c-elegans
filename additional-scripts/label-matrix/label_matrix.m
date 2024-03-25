function label_matrix(selected_files, dir_idx, img_idx, data_check)
% data info
dataI = struct;
dataI.folder = selected_files{dir_idx}.folder;
dataI.sep = selected_files{dir_idx}.sep;
dataI.seg_ws = selected_files{dir_idx}.segmentation_workspaces{img_idx};

%=== load workspace with condensates coordinates
disp('getting workspace...')
load([dataI.folder dataI.sep dataI.seg_ws], 'CC', 'Cond_IDs', 'number_cells', 'TS_i');

%=== reading raw image
if data_check
    disp('reading smFISH image...')
    % data info
    dataI.folder = selected_files{dir_idx}.folder;
    dataI.raw = selected_files{dir_idx}.smFISH_images{img_idx};
    file_path = [dataI.folder dataI.sep dataI.raw];
    % base images
    ImInfo = imfinfo(file_path);
    imgbase = uint16(zeros(unique([ImInfo.Width]),unique([ImInfo.Height]),length(ImInfo)));
    for i = 1 : length(ImInfo)
        imgbase(:,:,i) = imread(file_path,i);
    end
    clear ImInfo;
    imgzeros = uint16(zeros(size(imgbase)));
    imgones = false(size(imgbase));
else
    imgzeros = uint16(zeros(CC{1}.ImageSize));
end

% loop through cells and condensates
cell_number_total = number_cells/2;
cell_id   = cell(1,number_cells/2);
cond_id   = cell(1,number_cells/2);

for c = 1:2:number_cells
cell_number_loop  = (c+1)/2;
number_codensates = CC{(c+1)/2}.NumObjects;
disp([' - processing cell number: ' num2str(cell_number_loop) ' of ' num2str(cell_number_total) '  ->  labelling ' num2str(number_codensates) ' condensates...'])
cell_id{(c+1)/2} = cell(number_codensates,1);
cond_id{(c+1)/2} = cell(number_codensates,1);
% loop through condensates
for i = 1: number_codensates
    %disp(['processing cell: ' num2str(cell_number_loop) ' of ' num2str(cell_number_total) '  -> condensate: ' num2str(i) ' of ' num2str(number_codensates) ' ...'])
    cell_id{(c+1)/2}{i,1} = sprintf(['Cell_',num2str((c+1)/2)]);
    cond_id{(c+1)/2}{i,1} = sprintf(['cond_',num2str(i)]);
    
    obj = struct;
    % obj.x = Cond_IDs{1,(c+1)/2}(i).PixelList(:,1);
    % obj.y = Cond_IDs{1,(c+1)/2}(i).PixelList(:,2);
    % obj.z = Cond_IDs{1,(c+1)/2}(i).PixelList(:,3);
    obj.list = Cond_IDs{1,(c+1)/2}(i).PixelIdxList;
    
    imgzeros(obj.list) = uint16(i);
    if data_check
        imgbase(obj.list) = uint16(i);
        imgones(obj.list) = 1;
    end
end
end

disp('saving results...')
%=== generate table
empty_cells = cellfun(@isempty,TS_i);
info_cond = cat(1,TS_i{~empty_cells});
% id
if data_check
    filename = dataI.raw(1:end-4);
else
    filename = dataI.seg_ws(1:end-4);
end
imageid = repmat({filename},[size(info_cond,1), 1]);
% table
T = table(imageid,cat(1,cell_id{:}),cat(1,cond_id{:}),...
    info_cond(:,1),info_cond(:,2),info_cond(:,3),info_cond(:,4),...
    'VariableNames',{'imageID','Cell','condensate',...
    'volume_before_dilation','mean_intensity','cumulative_intensity','median_intensity'});
%=== save results
writetable(T, [dataI.folder dataI.sep filename '_condensate_info' '.csv'])

disp('saving images...')
dataI.Folder = dataI.folder;
if data_check
    dataI.raw = dataI.raw;
    image_save_seg(imgbase, imgones, dataI, 'labelled')
end

identifier = 'label_matrix';
imwrite(imgzeros(:,:,1), [dataI.Folder dataI.sep identifier '_' filename '.tif'],'compression','none')
for k = 2 : size(imgzeros,3)
    imwrite(imgzeros(:,:,k), [dataI.Folder dataI.sep identifier '_' filename '.tif'],'compression','none','WriteMode','append')
end
end