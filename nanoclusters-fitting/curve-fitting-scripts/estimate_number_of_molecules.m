%==== estimate number of molecules
[~, idx_p] = max(sk_ndist_fit);
peak_SM = xData(idx_p);

mRNA_molecules_est = struct;
mRNA_molecules_est.peak = peak_SM;

if show.plots
    figure
    plot(xData_nano/peak_SM, pdf_yData_nano*length(yData_nano), '.k')
    hold on
    plot(xData_nano/peak_SM, nano_fit*length(yData_nano), '.b')
    plot(xData_intg/peak_SM, intg_nano_1st*length(yData_nano), '.r')
    plot(xData_intg/peak_SM, intg_nano_2nd*length(yData_nano), '.m')
    hold off
    xlim([0 show.display_range])
    legend({'data', 'skewed gaussian model fit','Dissolved', 'Clustered'}, 'Location', 'NorthEast');
    xlabel('molecules per foci')
    ylabel('foci count')
end

% mRNA_molecules_est.isequal_data = [sum(experimental_data - yData_nano)...
%     min(experimental_data - yData_nano)...
%     max(experimental_data - yData_nano)...
%     mean(experimental_data) - mean(yData_nano)];
% 
% mRNA_molecules_est.isequal_dim = [length(experimental_data)...
%     sum(pdf_yData_intg*length(yData_nano))];
% 
% mRNA_molecules_est.sol_cond = [sum(intg_nano_1st*length(yData_nano)) +...
%     sum(intg_nano_2nd*length(yData_nano))];

mRNA_molecules_est.dissolved_est = round(sum((xData_intg/peak_SM).*(intg_nano_1st*length(yData_nano))));
mRNA_molecules_est.clustered_est = round(sum((xData_intg/peak_SM).*(intg_nano_2nd*length(yData_nano))));
mRNA_molecules_est.total_est = round(mRNA_molecules_est.dissolved_est + mRNA_molecules_est.clustered_est);
mRNA_molecules_est.total_actual = round(sum(yData_nano/peak_SM));
% disp(mRNA_molecules_est)
