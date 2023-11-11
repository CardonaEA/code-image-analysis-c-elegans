%::::::::::::: condensate quantification :::::::::::::%
%====== before start quantification it is recommended to:
% make a folder with: 
% (1) MATLAB workspace obtained during segmentation. i.e.: Dil_Coor_FISH_GFP_w4_Spn4
% (2) raw smFISH image
% (3) average mRNA image (PSF of a single molecule of the mRNA to analyze)

%===== file ID indicators
files = struct; % do not modify
files.matlab_ws = '*Coor*';                   % unique file identifier for MATLAB workspace
files.FISH_img  = '*Spn4';                    % unique file identifier for smFISH image
files.mRNA_img  = 'experimental_single_mol*'; % unique file identifier for mRNA image

%======= modify below only if you need to change the microscope parameters
define_microscope_parameters = 0; % yes = 1, no = O

%===== run
% do not modify - cropping around center of average mRNA
pixels_from_xy_center = 10;
pixels_from_z_center  = 10;
files.matlab_ws = [files.matlab_ws '.mat'];
files.FISH_img  = [files.FISH_img  '.tif'];
files.mRNA_img  = [files.mRNA_img  '.tif'];
condensates_quantification_run