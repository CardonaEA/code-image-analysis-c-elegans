%=== smFISH preprocessing

%=== file identifiers
image_files_smFISH = 'w*smFISH';
image_files_GFP    = 'w*GFP';

%=== description of the stack
% There are two possibilities: 
% = 1 if stack has beginning and ending frames out of focus (whole gonad)
% = 0 if stack is in focus (usually a z-section within the gonad)
is_stack_out_of_focus = 1;

% Parameters
quantile_BGD_subtraction = 0.9; % quantile to subtract BGD value (initial filtering)



% =====================
% === do not modify ===
% =====================
% image ranking parameters
ranking_mask_size = 2; % bigger numbers will increase speed but reduce accuracy in the shape of the condensate
components_conn   = 6;

% file identifiers
image_files_smFISH = [image_files_smFISH '.tif'];
image_files_GFP    = [image_files_GFP '.tif'];

% run
smFISH_image_preprocessing_batch