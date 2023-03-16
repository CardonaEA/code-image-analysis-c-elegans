function [blocks_processing, idx_beg, idx_end] = zstack_focus(blocks_processing, f, nIm)
%==== determining out of focus slides
if blocks_processing.is_out_focus
a_q = zeros(1,nIm);
for i = 1 : nIm
a_q(i) = quantile(double(f{i}(:)),0.9);
end
% derivate and plots 
d_v = gradient(a_q);
figure, plot(a_q, '.b')
hold on
plot(gradient(a_q), '.r')
[v_beg, idx_beg] = max(d_v);
[v_end, idx_end] = min(d_v);
plot(idx_end,v_end,'ok')
plot(idx_beg,v_beg,'ok')
plot(idx_end,a_q(idx_end),'ok')
plot(idx_beg,a_q(idx_beg),'ok')
xlabel('z-position')
ylabel('Intensity')
legend('90th percentile', 'derivate (gradient)', 'z-boundaries', 'Location', 'eastoutside')
hold off
% new blocks_processing structure
focus_idx = zeros(1,nIm);
focus_idx(idx_beg : idx_end) = 1;
blocks_processing.focus = focus_idx;
% blocks_processing.value_beg = a_q(idx_beg);
% blocks_processing.value_end = a_q(idx_end);
blocks_processing.idx_beg = idx_beg;
blocks_processing.idx_end = idx_end;
else
blocks_processing.is_out_focus = 0;
idx_beg = - 4;
idx_end = nIm + 5;
end
end