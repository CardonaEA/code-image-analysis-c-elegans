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

%% First version
% function SDi = BlockWs2(a2,Mask)
% lm = log(double(max(a2(:))));
% 
% fun1 = @(block_struct)...
%     log(double(mean2(block_struct.data)))/lm*ones(size(block_struct.data));
% 
% SD  = blockproc(double(a2),[Mask Mask],fun1);
% SD(SD < 0) = 0;
% SDi = SD;
% end

%% Second version ···· the problem was the lack of logarithm
% function SDi = BlockWs2(a2,Mask,blocks_processing,idx)
% %
% max_pixel = double(max(a2(:)));
% if max_pixel == 0
% SDi = zeros(size(a2));
% else
% if ~blocks_processing.is_out_focus 
%     lm1 = log(max_pixel);
% 
%     fun1 = @(block_struct)...
%     log(double(mean2(block_struct.data)))/lm1*ones(size(block_struct.data));
% 
%     SD = blockproc(double(a2),[Mask Mask],fun1);
%     SD(SD < 0) = 0;
%     SD(SD > 1) = 1;
%     SDi = SD;
% end
% 
% if blocks_processing.is_out_focus
%     if blocks_processing.focus(idx)
%     lm2 = log(max_pixel);
% 
%     fun2 = @(block_struct)...
%     log(double(mean2(block_struct.data)))/lm2*ones(size(block_struct.data));
% 
%     SD = blockproc(double(a2),[Mask Mask],fun2);
%     SD(SD < 0) = 0;
%     SD(SD > 1) = 1;
%     SDi = SD; 
%     end
%     
%     if ~blocks_processing.focus(idx)
%     if idx < blocks_processing.idx_beg
%     lm3 = blocks_processing.value_beg;
%     end
%     if idx > blocks_processing.idx_end
%     lm3 = blocks_processing.value_end;
%     end
% 
%     fun3 = @(block_struct)...
%     log(double(mean2(block_struct.data)))/lm3*ones(size(block_struct.data));
% 
%     SD = blockproc(double(a2),[Mask Mask],fun3);
%     SD(SD < 0) = 0;
%     SD(SD > 1) = 1;
%     SDi = SD;
%     end
% end
% 
% end
% end
%