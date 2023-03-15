% ============= RANDOM positioning of smiFISH Avg mRNA image

% load oocyte for simulation
disp(newline)
disp('select a binary image where simulation will be run...')
[dataI.filename, dataI.pathname] = uigetfile({'*.tif';'*.jpg';'*.png';'*.jp2';'*.gif';'*.bmp'},'Select the image file');
[oocyte_c_image, focus_oocyte] = load_oocyte_for_simulation(dataI);

% load mRNA image
% disp(newline)
% disp('select the experimental average PSF image...')
% [data_mRNA.filename, data_mRNA.pathname] = uigetfile({'*.tif';'*.jpg';'*.png';'*.jp2';'*.gif';'*.bmp'},'Select the image file');
% [avg_mRNA_c_image] = load_mRNA_for_simulation(data_mRNA);
% min(avg_mRNA_c_image,[],'all') % mean BGD 36.3545

% load mRNA image repository
disp(newline)
disp('select the mRNA image repository...')
[repository_mRNA.filename, repository_mRNA.pathname] = uigetfile({'*.mat'},'Select the repository file');
load([repository_mRNA.pathname repository_mRNA.filename])


% ============== number of mRNAs to place
[model_oocyte_vol, number_mRNAs_to_place, positions_in_oocyte, random_mRNA_positions] = calculate_mRNA_random_positions_replacement(pixel_size, oocyte_c_image, concentration_desired, replicates_simulation, false);
[model_oocyte_vol_r, number_mRNAs_to_place_r, positions_in_oocyte_r, random_mRNA_positions_r] = calculate_mRNA_random_positions_replacement(pixel_size, oocyte_c_image, concentration_desired, replicates_simulation, true);


% ============== choose from repository
% repository = repository_mRNA_det_5_pix_wo_BGD; % version 1
repository = repository_mRNA_det_5_pix; % version 1
% [random_repository_positions] = choose_mRNA_random_from_repository_replacement(repository, number_mRNAs_to_place, replicates_simulation, false);
[random_repository_positions, repository] = choose_mRNA_random_from_repository_replacement(repository, number_mRNAs_to_place, replicates_simulation, true);


% ================== smiFISH synthetic images

% image_size for ramdom positions
[model_image_size.y, model_image_size.x, model_image_size.z] = size(oocyte_c_image);

% info for loop
[concentrations, img_replicates] = size(random_mRNA_positions);

% mRNA to place in the simulated images
% mRNA_image_to_place_wo_BGD = mRNA_image_to_place - BGD_max;

[dim.Y, dim.X, dim.Z] = size(repository{1,1});
dim_mRNA = ([dim.Y dim.X dim.Z] - 1)/2;
dim.ymin = dim_mRNA(1); dim.ymax = dim_mRNA(1);
dim.xmin = dim_mRNA(2); dim.xmax = dim_mRNA(2);
dim.zmin = dim_mRNA(3); dim.zmax = dim_mRNA(3);

% image where to place mRNAs
% BGD_max = uint16(41); % version 1
BGD_max = uint16(additional_BGD_to_substract_mRNA); % version 2
BGD_image = BGD_max * uint16(ones(model_image_size.y, model_image_size.x, model_image_size.z));
% false image
false_image = false([model_image_size.y model_image_size.x model_image_size.z]);
PSF_to_susbtract = additional_BGD_to_substract_mRNA;


for k = 1 : concentrations
    for j = 1 : img_replicates
        
        % get positions
        clear pos_mRNAs
        pos_mRNAs.list = random_mRNA_positions_r{k,j};
        pos_mRNAs.imgs = random_repository_positions{k,j};
        
%  v1 % [image_mRNAs_3D_sum, removed_mRNAs_sum] = generate_syn_image_simulation_from_repository(pos_mRNAs, model_image_size, BGD_image, positions_in_oocyte, false_image, k, j, dim, repository, BGD_max);
        [image_mRNAs_3D_sum, removed_mRNAs_sum] = generate_syn_image_simulation_from_repository_v2(pos_mRNAs, model_image_size, BGD_image, positions_in_oocyte, false_image, k, j, dim, repository, BGD_max, PSF_to_susbtract);
        
        % some info
        mRNAs_placed = number_mRNAs_to_place(k) - removed_mRNAs_sum;
        concentration_reached = mRNAs_placed/model_oocyte_vol;
        disp(newline)
        disp(['mRNAs_desired: ' num2str(number_mRNAs_to_place(k)) ' - mRNA placed: ' num2str(mRNAs_placed)])
        disp(['concentration_desired: ' num2str(concentration_desired(k)) ' - achieved: ' num2str(concentration_reached)])
        %save image
        imwrite(image_mRNAs_3D_sum(:,:,1), [dataI.pathname 'syn_sum_mRNA_app1_' num2str(mRNAs_placed) '_conc_' num2str(k) '_rep_' num2str(j) '_' dataI.filename(1:end-4) '.tif'],'compression','none')
        for n = 2 : size(image_mRNAs_3D_sum,3)
            imwrite(image_mRNAs_3D_sum(:,:,n),[dataI.pathname 'syn_sum_mRNA_app1_' num2str(mRNAs_placed) '_conc_' num2str(k) '_rep_' num2str(j) '_' dataI.filename(1:end-4) '.tif'],'compression','none','WriteMode','append')
        end
    end
end