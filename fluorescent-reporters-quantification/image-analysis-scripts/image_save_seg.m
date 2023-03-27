function image_save_seg(image_reference, mask, dataI, identifier)
% outlines
f_image = image_reference;
image_mask = mask;
for i = 1 : size(f_image,3)
BWoutline = bwperim(image_mask(:,:,i));
Segout = f_image(:,:,i);
Segout(BWoutline) = 65535;
f_image(:,:,i) = Segout;
end 

% image saving
imwrite(f_image(:,:,1), [dataI.Folder dataI.sep identifier '_' dataI.raw(1:end-4) '.tif'],'compression','none')
for k = 2 : size(f_image,3)
imwrite(f_image(:,:,k), [dataI.Folder dataI.sep identifier '_' dataI.raw(1:end-4) '.tif'],'compression','none','WriteMode','append')
end
end