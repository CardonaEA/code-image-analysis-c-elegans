# Label connected components (objects) in images

## Before start
- Download the repository or the content of this folder.

### Set up:
* Copy the scripts provided here to the MATLAB folder (usually located in Documents directory).
    - Note: overlapping code scripts from other quantifications do not need to be replaced.

## This script performs the following analysis:
- ### Inputs: (Folders with)
    - **matlab workspace files**: `"Dil_coor_..." .mat` files obtained during segmentation.
        - more info about segmentation can be found at:<br>`./smFISH-images-quantification/How to use - quantification of smFISH images.pdf`<br>`./smFISH-images-quantification/README.md`
    - **smFISH images (optional)**: smFISH images where objects will be labeled.

- ### Analysis:
    - Generates a label matrix: label objects in images using data in `"Dil_coor_..." .mat` files obtained during segmentation.

- ### Outputs:
    - `.tif` image files with label matrix.
    - `.csv` files with object information.
        - labels in image correspond to the condensate number in the `.csv` file.
    - optional: if raw images are provided, `.tif` image files with objects labeled are returned.
<br>
<br>

## User guide
### Analysis (Procedure):
1. Open MATLAB.
2. In the command window type:<br>`generate_label_matrix_batch`<br>and then press enter.
3. Select a folder with the **_inputs_**.
    - this script allows to consecutively select a new folder until **_cancel_** is pressed.

#### The default parameters of the script include:
```matlab
    %::::::::::::::::::: generate label matrix batch :::::::::::::::::::%
    % (1) folders should contain: 
    %  - MATLAB workspaces obtained in segmentation ("Dil_Coor..." .mat)
    % (2) optional: 
    %  - raw smFISH images

    %=== file identifiers
    matlab_files_segmentation = '*Coor*';   % file identifier for MATLAB workspaces
    image_files_smFISH        = 'w*smFISH'; % file identifier for smFISH images (optional)

    ...
```

#### To change this:
- Type in the command window:<br>
`edit generate_label_matrix_batch`<br>
- Press enter.
- Then, default values can be manually modified.
