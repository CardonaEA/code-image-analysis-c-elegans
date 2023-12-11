# Quantification of fluorescent reporter proteins (epifluorescence) (How to use)

## Before start
- Download the repository or the content of this folder.

## Requirements and set up
### Requirements:
- Tested in MATLAB v R2018b or higher
    - Required toolboxes:<br>Image Processing Toolbox<br>Statistics and Machine Learning Toolbox
- Additional requirements:<br>FISH-quant (1,2,#)<br># `https://bitbucket.org/muellerflorian/fish_quant/src/master/`

### Set up:
* Copy the scripts provided (`./fluorescent-reporters-quantification-epi`) to the MATLAB folder (usually located in Documents directory).
    - Note: overlapping code scripts from other quantifications do not need to be replaced.
* Install FISH-quant:
    - Go to `https://bitbucket.org/muellerflorian/fish_quant/src/master/` (1,2).
    - Click Downloads and then download the repository (1,2).
    - Unzip the file in the MATLAB folder (Documents directory) (1,2).
    - Go to `./Documents/MATLAB/FISH_quant/Documentation` (1,2).
    - Open `FISH-QUANT__Tutorials.pdf` (1,2).
    - Follow the section **1.1 Install FISH-quant for Matlab** (1,2).
<br>
<br>

## User guide
### Analysis (Procedure):
**Follow the guide (_README_ or _PDF_) "Quantification of fluorescent reporter proteins (How to use)"** provided in `~/code/code-image-analysis-c-elegans-main/fluorescent-reporters-quantification`.<br>
- Briefly and instead of the scripts provided there use the following:
1. Open MATLAB.
2. In the command window type:
    - For analysis in batch:<br>`script_analysis_granules_epi_batch`<br>and then press enter.
    - To analyze one image:<br>`script_analysis_granules_epi`<br>and then press enter.

#### The default parameters of the script include:
- Analysis in batch:
```matlab
    ...

    %==== file identifiers
    image_files    = '*.tif';
    outline_files  = 'MOD*Cells.csv';

    %==== image voxel size
    pixel_size_in_x_and_y = 0.1031746;    % micrometers
    pixel_size_in_z       = 0.5;          % micrometers

    %==== segmentation parameters
    % background removal: bigger number will remove less BGD but it will give a better approximation of it
    filter_size = 11;
    % thresholding: values are between 0 and 1, one is likely to be a pixel that corresponds to granules
    granule_threshold = 0.825; 
    % excluding small objects: objects smaller than the value will be excluded
    small_objects_size = 4; 

    ...

    % ranking parameters
    ranking_mask_size = 2; % bigger numbers will increase speed but reduce accuracy in the shape of the condensate
    components_conn   = 6;
     
    ...
```
- Analysis one image:
```matlab
    ...

    %==== file identifier
    image_name = 'w1';

    %==== image voxel size
    parameters.pixel_size.xy = 0.1031746;  % micro meters
    parameters.pixel_size.z = 0.5;         % micro meters

    %==== segmentation parameters
    % background removal: bigger number will remove less BGD but it will give a better approximation of it
    parameters.filter_size = 11;
    % thresholding: values are between 0 and 1, one is likely to be a pixel that corresponds to granules 
    parameters.threshold_granules = 0.825;
    % excluding small objects: objects smaller than the value will be excluded
    parameters.small_objects_size = 4;

    ...

    % ranking parameters
    parameters.ranking_mask_size = 2; % bigger numbers will increase speed but reduce accuracy in the sahpe of the condensate
    parameters.components_conn = 6;
     
    ...
```

#### To change this:
- Type in the command window:<br>
    - For analysis in batch:<br>`edit script_analysis_granules_epi_batch`
    - To analyze one image:<br>`edit script_analysis_granules_epi`
- Press enter.
- Then, default values can be manually modified.

## References
1. Mueller, F., Senecal, A., Tantale, K. et al. FISH-quant: automatic counting of transcripts in 3D FISH images. Nat Methods 10, 277-278 (2013).
2. Tsanov, N., Samacoits, A., Chouaib, R. et al. smiFISH and FISH-quant - a flexible single RNA detection approach with super-resolution capability, Nucleic Acids Research 44 (22), e165 (2016).
3. Cardona et al., Self-demixing of mRNA copies buffers mRNA:mRNA and mRNA:regulator stoichiometries, Cell (2023), https://doi.org/10.1016/j.cell.2023.08.018
