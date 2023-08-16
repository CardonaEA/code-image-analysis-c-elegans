function [nano_quantification] = nano_fitting_by_oocyte(calibration_data, experimental_data, parameter, show)
% read calibration and experimental data files
[mRNA_calibration, mRNA_experimental, image_names, oocyte_idx, number_images, number_oocytes] = read_files_nano_fitting(calibration_data, experimental_data);

% empty table to save results
image_values     = [];
col_names_image  = {};
col_names_oocyte = {};

% single molecule data
single_molecule_data  = mRNA_calibration.AMP;

% image loop
for i = 1 : number_images
    % image selection
    image_id = image_names{i};
    % oocyte loop
    for j = 1 : number_oocytes
        % oocyte selection
        oocyte_number = oocyte_idx(j);
        selected_mRNA_oocyte = mRNA_experimental(string(mRNA_experimental.Image) == image_id & mRNA_experimental.CELL_Oocyte == oocyte_number,:);
        if ~isempty(selected_mRNA_oocyte)
            % process status
            disp(['fitting: '  image_id ' --- oocyte number: ' num2str(oocyte_number) ' ...'])
            % single molecule and experimental data as imput
            experimental_data = selected_mRNA_oocyte.AMP;
            % skewed gaussina model
            [oocyte_values]  = get_skewed_fit_model(experimental_data, single_molecule_data, parameter, show);
            image_values     = [image_values, oocyte_values];
            col_names_image  = [col_names_image, image_id];
            col_names_oocyte = [col_names_oocyte, ['oocyte_' num2str(oocyte_number)]];
        end
    end
end
% merged results as table
disp('saving...')
nano_quantification = table(col_names_image', col_names_oocyte', image_values(1,:)',image_values(2,:)',image_values(3,:)',image_values(4,:)',image_values(5,:)',image_values(6,:)',image_values(7,:)',...
    'VariableNames',{'image', 'oocyte', 'PDF_SM', 'foci_SM', 'molecules_SM', 'PDF_nano', 'foci_nano', 'molecules_nano', 'detected_foci'});
writetable(nano_quantification, [calibration_data.path 'nanoclsuter_fit_results.csv'])
disp('... done')
disp(newline)
disp(['%===== Results are saved at: ' [calibration_data.path 'nanclsuter_fit_results.csv']])
if show.plots
    disp(['displaying: ' num2str(size(nano_quantification,1)*2) ' plots...'])
end
end
