function [model_oocyte_vol, number_mRNAs_to_place, positions_in_oocyte, pos_mRNAs] = calculate_mRNA_random_positions_replacement(pixel_size, oocyte_c_image, concentration_desired, replicates_simulation, replacement_flag)

% voxel size
volxel_size = (pixel_size.xy/1000) * (pixel_size.xy/1000) * (pixel_size.z/1000);
% volume oocyte to model in
model_oocyte_vol = sum(oocyte_c_image, 'all') * volxel_size;
% number of mRNAs to place
number_mRNAs_to_place = round(concentration_desired * model_oocyte_vol, 0);


%============== random mRNA positions
% oocyte positions
positions_in_oocyte = find(oocyte_c_image);

% how many different concentration
concentrations_to_simulate = length(number_mRNAs_to_place);
replicates_simulation = replicates_simulation - 1;

pos_mRNAs = cell(concentrations_to_simulate, replicates_simulation);

for i = 1 : concentrations_to_simulate
    disp(newline)
    disp(['... concentration ' num2str(i) ' of ' num2str(concentrations_to_simulate)])
    rng('default');
    % positions of mRNAs
    pos_mRNAs{i,1} = randsample(positions_in_oocyte, number_mRNAs_to_place(i), replacement_flag);
    
    for j = 1 : replicates_simulation
        pos_mRNAs{i, j + 1} = randsample(positions_in_oocyte, number_mRNAs_to_place(i), replacement_flag);
        disp(['... replicating...  ' num2str(j + 1)])
    end   
end

end