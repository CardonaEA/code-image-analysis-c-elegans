function [pos_mRNAs, repository_filtered] = choose_mRNA_random_from_repository_replacement(repository, number_mRNAs_to_place, replicates_simulation, replacement_flag)

% size of repository
%repository = repository_mRNA_det_5_pix_wo_BGD;

empty_cells = cellfun(@isempty,repository);
repository_filtered = repository(~empty_cells);

%============== random mRNA positions
% repository size
number_of_mRNAs_repository = length(repository_filtered);

% how many different concentration
concentrations_to_simulate = length(number_mRNAs_to_place);

replicates_simulation = replicates_simulation - 1;

pos_mRNAs = cell(concentrations_to_simulate, replicates_simulation);

for i = 1 : concentrations_to_simulate
    disp(newline)
    disp(['... chosing mRNAs - iteration ' num2str(i) ' of ' num2str(concentrations_to_simulate)])
    rng('default');
    % positions of mRNAs
    pos_mRNAs{i,1} = randsample(number_of_mRNAs_repository, number_mRNAs_to_place(i), replacement_flag);
    
    for j = 1 : replicates_simulation
        pos_mRNAs{i, j + 1} = randsample(number_of_mRNAs_repository, number_mRNAs_to_place(i), replacement_flag);
        disp(['... replicating...  ' num2str(j + 1)])
    end   
end

end