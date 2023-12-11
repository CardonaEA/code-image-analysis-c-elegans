function SDi = BlockWs2(a2,Mask,blocks_processing,idx)
%
max_pixel = double(max(a2(:)));
if max_pixel == 0
SDi = zeros(size(a2));
else
if ~blocks_processing.is_out_focus 
    lm1 = log(max_pixel);
    SDi = Block_Process(a2,Mask,lm1);
end

if blocks_processing.is_out_focus
    if blocks_processing.focus(idx)
    lm2 = log(max_pixel);
    SDi = Block_Process(a2,Mask,lm2);
    end
    
    if ~blocks_processing.focus(idx)
    if idx < blocks_processing.idx_beg
    lm3 = log(blocks_processing.value_beg);
    end
    if idx > blocks_processing.idx_end
    lm3 = log(blocks_processing.value_end);
    end
    SDi = Block_Process(a2,Mask,lm3);
    end
end

end
end