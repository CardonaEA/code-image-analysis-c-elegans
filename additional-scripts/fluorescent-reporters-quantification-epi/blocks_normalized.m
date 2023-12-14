function blocks_plane = blocks_normalized(img_plane, mask, ref_int)
max_pixel = double(max(img_plane(:)));
if max_pixel == 0
    blocks_plane = zeros(size(img_plane));
else
    max_ref_int = log(ref_int);
    blocks_plane = Block_Process(img_plane, mask, max_ref_int);
end
end