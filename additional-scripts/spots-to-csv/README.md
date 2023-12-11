# Script to convert spot detection `.txt` files to `.csv` tables

## Before start
- Download the repository or the content of this folder.

## Requirements and set up
### Requirements:
- Tested in MATLAB v R2018b or higher
    - Required toolboxes:<br>Image Processing Toolbox<br>Statistics and Machine Learning Toolbox
### Set up:
* Copy the scripts provided (`./spots-to-csv`) to the MATLAB folder (usually located in Documents directory).

## This script performs the following analysis:
- ### Inputs:
    - **spot detection files**: `.txt` files obtained after spot detection and fitting in FISH-quant (1,2).
    - **smFISH images (optional)**: smFISH images where spots will be marked.

- ### Analysis:
    - Convert formatted `.txt` files to `.csv` tables (3).

- ### Outputs
    - `.csv` files
    - optional: smFISH images labeled with detected spots.
<br>
<br>

## User guide
### Analysis (Procedure):
1. Open MATLAB.
2. In the command window type:<br>`script_FQ_spots_to_csv`<br>and then press enter.
3. Select the folder with the **_inputs_**.

#### The default parameters of the script include:
```matlab
    ...
    %==== script to generate csv tables from FQ spots results
    % optional: mark detected spots in images

    %=== image voxel size
    pixel_size_in_x_and_y = 49;   % nanometers
    pixel_size_in_z       = 250;  % nanometers

    %=== optional: mark detected spots in images
    mark_detected_spots_in_images = 1; % yes = 1, no = 0
    detected_or_fitted_positions  = 1; % detected = 1, fitted = 0
    pixels_to_mark_from_center    = 1; % pixels from center (from detected or fitted position)

    % =====================
    % === do not modify ===
    % =====================
    % file identifiers
    image_files = '*.tif';    % any .tif file
    spots_files = '*.txt';    % any .txt file
    ...
```

#### To change this:
- Type in the command window:<br>
`edit script_FQ_spots_to_csv`<br>
- Press enter.
- Then, default values can be manually modified.

## References
1. Mueller, F., Senecal, A., Tantale, K. et al. FISH-quant: automatic counting of transcripts in 3D FISH images. Nat Methods 10, 277-278 (2013).
2. Tsanov, N., Samacoits, A., Chouaib, R. et al. smiFISH and FISH-quant - a flexible single RNA detection approach with super-resolution capability, Nucleic Acids Research 44 (22), e165 (2016).
3. Cardona et al., Self-demixing of mRNA copies buffers mRNA:mRNA and mRNA:regulator stoichiometries, Cell (2023), https://doi.org/10.1016/j.cell.2023.08.018
