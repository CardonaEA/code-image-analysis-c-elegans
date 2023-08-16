%==== Integration, numerical, sum of densities
% integration in real number, int
pdf_step_intg = 1; % integration step
[pdf_yData_intg, xData_intg, ~] = probability_density_fun(experimental_data, pdf_step_intg, pdf_Band_Width, pdf_start);

%==== Intg eval 
coef_nano_1st = nano_coef_fit(1:4);
intg_nano_1st = fun_SkewGaussian_cf(coef_nano_1st, xData_intg);

coef_nano_2nd = nano_coef_fit(5:8);
intg_nano_2nd = fun_SkewGaussian_cf(coef_nano_2nd, xData_intg);

%==== output
% mRNA proportions
mRNA_proportions = struct;
mRNA_proportions.density_Data = sum(pdf_yData_intg);
mRNA_proportions.density_fit  = sum(nano_fit)/(1/parameter.pdf_step);
mRNA_proportions.density_dissolved = sum(intg_nano_1st);
mRNA_proportions.density_clustered = sum(intg_nano_2nd);
mRNA_proportions.density_dissolved_clustered = sum(sum(intg_nano_1st)+ sum(intg_nano_2nd));
% disp(mRNA_proportions)

% mRNA molecules
mRNA_molecules = struct;
mRNA_molecules.SPOTS = length(experimental_data);
mRNA_molecules.dissolved = round(length(experimental_data) * mRNA_proportions.density_dissolved);
mRNA_molecules.clustered = round(length(experimental_data) * mRNA_proportions.density_clustered);
mRNA_molecules.dissolved_clustered = sum(mRNA_molecules.dissolved + mRNA_molecules.clustered);
% disp(mRNA_molecules)
