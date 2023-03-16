function SDi = Block_Process(Im_s,Mask_size,log_max)
fun_blocks = @(block_struct)...
log(double(mean2(block_struct.data)))/log_max*ones(size(block_struct.data));

SD = blockproc(double(Im_s),[Mask_size Mask_size],fun_blocks);
SD(SD < 0) = 0;
SD(SD > 1) = 1;
SDi = SD;