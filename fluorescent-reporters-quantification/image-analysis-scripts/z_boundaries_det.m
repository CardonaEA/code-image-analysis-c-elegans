function [blocks_processing] = z_boundaries_det(blocks_processing, nIm, f)

if blocks_processing.is_half
    nIm_bckup = nIm;
    nIm = nIm + 1;
    f{nIm} = uint16(zeros(size(f{1})));
end
    
% Out of focus slides
if blocks_processing.is_out_focus
    a_q = zeros(1,nIm);
    % a_q25 = zeros(1,nIm);
    for i = 1 : nIm
        a_q(i) = quantile(double(f{i}(:)),0.9);
        % a_q25(i) = quantile(double(f{i}(:)),0.25);
    end
    % derivate and plots 
    d_v = gradient(a_q);
    [v_beg, idx_beg] = max(d_v);
    [v_end, idx_end] = min(d_v);
    
    if blocks_processing.is_half
        nIm = nIm_bckup;
        a_q = a_q(1:nIm);
        
        d_v = d_v(1:nIm);
        idx_end = idx_end - 1;
        v_end = d_v(idx_end);
        disp(idx_end)
    end
        
    % quantile   
    figure, plot(a_q, '.b')
    hold on
    % gradient
    plot(d_v, '.r')
    % min and max (z boundaries)
    plot(idx_end,v_end,'ok')
    plot(idx_beg,v_beg,'ok')
    plot(idx_end,a_q(idx_end),'ok')
    plot(idx_beg,a_q(idx_beg),'ok')
    hold off
    % new blocks_processing structure
    focus_idx = zeros(1,nIm);
    focus_idx(idx_beg : idx_end) = 1;
    blocks_processing.focus = focus_idx;
    % blocks_processing.value_beg = a_q(idx_beg);
    % blocks_processing.value_end = a_q(idx_end);
    blocks_processing.idx_beg = idx_beg;
    blocks_processing.idx_end = idx_end;
end
end