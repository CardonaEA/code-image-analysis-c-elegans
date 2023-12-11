function mark_images(selected_files,idx,spots_table,parameters)
%=== image data
folder = selected_files.folder;
filename = selected_files.image_files{idx};
sep = selected_files.sep;
pathfile = [folder sep filename];

ImInfo = imfinfo(pathfile);
nslices = length(ImInfo);
maxI = ImInfo.MaxSampleValue;
clear ImInfo;

%=== read z-stack
imgcell = cell(1,nslices);
for i = 1 : nslices
    imgcell{i} = imread(pathfile,i);
end
img = cat(3,imgcell{:});

%=== table from make_csv_table function
T = spots_table{idx};
%=== binary image
marks = false(size(img));

%=== make marks
[nspots,~] = size(T);
[m,n,~] = size(img);
px = parameters.pixels;

if parameters.detected_fitted
    for i = 1:nspots  
        posy = T.Y_det(i);
        posx = T.X_det(i);
        posz = T.Z_det(i);
        
        yD = posy - px : posy + px;
        xD = posx - px : posx + px;
        zD = posz - px : posz + px;
        
        xD = xD(xD>=1 & xD<=n);
        yD = yD(yD>=1 & yD<=m);
        zD = zD(zD>=1 & zD<=nslices);
        
        marks(yD,xD,zD) = 1;
    end
    save_id = 'detected_pos';
end

if parameters.detected_fitted == 0
    size_xy = parameters.size_xy;
    size_z = parameters.size_z;
    for i = 1:nspots
        posy = round(T.Pos_Y(i)/size_xy);
        posx = round(T.Pos_X(i)/size_xy);
        posz = round(T.Pos_Z(i)/size_z);
        
        yD = posy - px : posy + px;
        xD = posx - px : posx + px;
        zD = posz - px : posz + px;
        
        xD = xD(xD>=1 & xD<=n);
        yD = yD(yD>=1 & yD<=m);
        zD = zD(zD>=1 & zD<=nslices);
        
        marks(yD,xD,zD) = 1;
    end
    save_id = 'fitted_pos';
end
    
for j = 1 : nslices
    BWoutline = bwperim(marks(:,:,j));
    Segout = img(:,:,j);
    Segout(BWoutline) = maxI;
    img(:,:,j) = Segout;
end 

% save image
imwrite(img(:,:,1), [folder sep filename(1:end-4) '_SPOTS_' save_id '.tif'],'compression','none')
for k = 2 : nslices
    imwrite(img(:,:,k), [folder sep filename(1:end-4) '_SPOTS_' save_id '.tif'],'compression','none','WriteMode','append')
end
end