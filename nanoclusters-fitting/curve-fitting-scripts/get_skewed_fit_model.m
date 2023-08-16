function [oocyte_values] = get_skewed_fit_model(experimental_data, single_molecule_data, parameter, show)
% curve fittig
curve_fitting_mRNA

% curve integration
integration_dissolved_clustered_mRNA_proportions

% number of molecules estimation
estimate_number_of_molecules

% data for table
oocyte_values = [mRNA_proportions.density_dissolved;...
    mRNA_molecules.dissolved;...
    mRNA_molecules_est.dissolved_est;...
    mRNA_proportions.density_clustered;...
    mRNA_molecules.clustered;...
    mRNA_molecules_est.clustered_est;...
    mRNA_molecules.SPOTS];
end