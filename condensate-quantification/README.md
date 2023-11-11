# Condensate quantification - mRNA molecules within condensates (How to use)

## Before start
- Download the repository or the content of this folder.
- For Github downloads: example smFISH image (large file) is provided as '`.tif.txt`'. A link to download the image is within the text file.
    - https://doi.org/10.17632/8jvrnztdvc.1 (location: `smFISH images quantification > example_image`).
    - https://doi.org/10.17632/8jvrnztdvc.2 (location: `condensate quantification > example-data`).
    - This guide uses the smiFISH image from the folder: `./code-image-analysis-c-elegans/smFISH-images-quantification/example-image`.

- **Important**: this script uses results from **_smFISH images quantification_** (`./code-image-analysis-c-elegans/smFISH-images-quantification`).
- **Important**: an average PSF of experimental single mRNA molecules is required.

## Requirements and set up
### Requirements:
- Tested in MATLAB v R2018b or higher
    - Required toolboxes:<br>Image Processing Toolbox<br>Statistics and Machine Learning Toolbox
- Additional requirements:<br>FISH-quant (1,2,#)<br># `https://bitbucket.org/muellerflorian/fish_quant/src/master/`

### Set up:
* Copy the scripts provided (`./condensate-quantification-scripts`) to the MATLAB folder (usually located in Documents directory).
* Install FISH-quant:
    - Go to `https://bitbucket.org/muellerflorian/fish_quant/src/master/` (1,2).
    - Click Downloads and then download the repository (1,2).
    - Unzip the file in the MATLAB folder (Documents directory) (1,2).
    - Go to `./Documents/MATLAB/FISH_quant/Documentation` (1,2).
    - Open `FISH-QUANT__Tutorials.pdf` (1,2).
    - Follow the section **1.1 Install FISH-quant for Matlab** (1,2).

## This script performs the following analysis:
- ### Inputs:
    - **MATLAB workspace with condensate coordinates**: `.mat` file obtained after **_smFISH images quantification_**.
    - **smFISH image**: smFISH image used to run **_smFISH images quantification_**.
    - **Average PSF of experimental single mRNA molecules**: it can be obtained as described previously (1,2).

- ### Analysis:
    - Estimation of the number of mRNA molecules within condensates segmented in **_smFISH images quantification_**.<br>Estimates are computed by integrated intensity and cumulative intensity (3).

- ### Outputs
    - `.csv` table file with columns:
    ```matlab
    "imageID": image name
    "Cell": oocyte
    "condensate": condensate index
    "SigmaXY": estimated sigma in x and y of condensate
    "SigmaZ": estimated sigma in z of condensate
    "Amplitud" estimated amplitude of condensate
    "BGD": estimated background of condensate
    "MaxI": maximum intensity of condensate
    "volume_dil": volume of condensate after morphological dilation
    "volume": volume of condensate
    "mean_intensity": average intensity of condensate
    "cumulative_intensity": cumulative intensity of condensate
    "median_intensity": median intensity of condensate
    "n_molecules_intg": number of mRNA molecules within condensate, calculated by integrated intensity
    "n_molecules_cum": number of mRNA molecules within condensate, calculated by cumulative intensity
    "n_molecules_cum_ctrl": number of mRNA molecules within condensate, calculated by cumulative intensity (computing control)
    ```
<br>

## User guide
### Data provided
Location: `./example-data`
- **MATLAB workspace with condensate coordinates**: `./example-data/Dil_Coor_FISH_GFP_w4_Spn4.mat`.
- **smFISH image**: `./example-data/w4_Spn4.tif`.
- **Average PSF of experimental single mRNA molecules**: `./example-data/experimental_single_mol_PSF_8x6_mRNA_AVG_ns.tif`.

### Analysis (Procedure):
#### Pre-analysis
1. Make a folder with the **_inputs_** (as in `./example-data`).
    - *Dil_**Coor**_FISH_GFP_w4_Spn4.mat*
    - *w4_**Spn4**.tif*
    - ***experimental_single_mol**_PSF_8x6_mRNA_AVG_ns.tif*
2. The script will look for the key words in **bold** to identify each input. This can be modified as shown below.

#### Analysis
3. Open MATLAB.
4. In the command window type:<br>`condensates_quantification_script`<br>and then press enter.
5. Select the folder with the **_inputs_** (as in `./example-data`).

#### The default parameters of the script include:
```matlab
    ...
    
    %===== file ID indicators
    files = struct; % do not modify
    files.matlab_ws = '*Coor*';                   % unique file identifier for MATLAB workspace
    files.FISH_img  = '*Spn4';                    % unique file identifier for smFISH image
    files.mRNA_img  = 'experimental_single_mol*'; % unique file identifier for mRNA image

    %======= modify below only if you need to change the microscope parameters
    define_microscope_parameters = 0; % yes = 1, no = O
    
    ...
```
if `define_microscope_parameters = 1`, the script will ask for microscope parameters in the command window.

#### To change this:
- Type in the command window:<br>
`edit condensates_quantification_script`<br>
- Press enter.
- Then, default values can be manually modified (lines # 9 to # 15).

## Outputs:
### Provided output examples:
The quantification results, for the example data provided in this tutorial, are included (location: `./quantification-example-data`).

## References
1. Mueller, F., Senecal, A., Tantale, K. et al. FISH-quant: automatic counting of transcripts in 3D FISH images. Nat Methods 10, 277-278 (2013).
2. Tsanov, N., Samacoits, A., Chouaib, R. et al. smiFISH and FISH-quant - a flexible single RNA detection approach with super-resolution capability, Nucleic Acids Research 44 (22), e165 (2016).
3. Cardona et al., Self-demixing of mRNA copies buffers mRNA:mRNA and mRNA:regulator stoichiometries, Cell (2023), https://doi.org/10.1016/j.cell.2023.08.018
