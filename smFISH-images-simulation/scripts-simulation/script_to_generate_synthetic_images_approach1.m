% =========== script to generate synthetic images (Approach # 1)

% ============ voxel size of images
pixel_size = struct;
pixel_size.xy = 49;
pixel_size.z = 250;


%============= expected concentrations in mol/um3
% concentration_desired = [0.05];
concentration_desired = [0.01  0.025:0.025:0.1   0.25:0.25:1  1.25:0.25:5];
% number of replicates by concentration
replicates_simulation = 3;
% reduce PSF
additional_BGD_to_substract_mRNA = 31;


% ========= RUN
generate_simulated_smiFISH_images_from_repository_app1