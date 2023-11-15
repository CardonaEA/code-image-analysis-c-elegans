%%  ----------------- smFISH preprocessing
% Description of the stack
% There are two possibilities: 
% = 1 if stack has beginning and ending frames out of focus (whole gonad)
% = 0 if stack is in focus (usually a z-section within the gonad)
is_stack_out_of_focus = 1; % 
smFISH_channel = 0; % type of image: if FISH  = 1, if GFP = 0

% Parameters
quantile_BGD_subtraction = 0.9; % quantile to subtract BGD value (initial filtering), 0 if it's unknown
% if quantile_BGD_subtraction = 0, two BGD approximations are computed:
different_BGD_approximations = 0; % 1 for different functions, 0 for same function with different mask sizes  

% image ranking
block_size_for_image_ranking = 2; % faster results with larger values like 4, 8, 16; but less detail

% run
smFISH_image_Preprocessing