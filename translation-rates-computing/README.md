# Quantification of relative translation rates (How to use)

## Before start
- Download the repository or the content of this folder.

### Requirements:
- Fiji (ImageJ)
- R
- Optional: RStudio

## Descriptions
### This quantification pipeline is divided into 3 parts:
- 1st part: data preparation before quantification.
- 2nd part: manual delimitation of oocyte outlines (**R**egions **O**f **I**nterest - **ROIs**).
- 3rd part: computing of cumulative intensities.
- 4th part: calculation of relative concentrations and translation rates.

## User guide
### 1st part: data preparation before quantification
#### Image projections
1. Make SUM projections of z-stacks and save them as `.tif` image files. Example images are provided (see **Data provided** section below).
    - **Important**: use always the same number of z-planes when making SUM projections.
    - SUM projections can be done in Fiji (ImageJ): Image > Stacks > Z Project… > Projection type > Sum Slices

### 2nd part: manual delimitation of oocyte outlines (**R**egions **O**f **I**nterest - **ROIs**).
Example ROIs are provided (see **Data provided** section below).
#### Manual delimitation of ROIs
1. Open Fiji (ImageJ).
2. Open _RIO Manager_.
    - Analyze > Tools > RIO Manger…
3. Open the image you want to analyze.
4. Use the “`polygon selections`” tool to manually draw outlines that delimit the oocytes.
    - Each **oocyte outline** can be treated as an individual **ROI**.
    - Each ROI can be saved by clicking on the “`Add [t]`” button located in the _RIO Manager_ window.
    - Make sure ROIs are added in a consistent manner. ROIs are numbered in order of addition (from upper to bottom in the _RIO Manager_ window)

#### Manual delimitation of background ROI
5. Add a ROI in a region that represents the background.
    - **It has to be added as the last ROI** of the image.
    - Shape can be as simple as a rectangle.
    - It can be drawn in a region of no protein expression.

#### Save ROIs
6. Once all ROIs, both oocytes and the background, are added, select them and save them as a “`.zip`” file. **Important:** name the file with the same name as the image where the ROIs are coming from.

### Data provided (location: `./example-images`)
The example data provided with this guide contain:
- **SUM projected images** of C. elegans gonads with a SPN-4:GFP reporter protein.
- **"`.zip`" files with ROIs** including oocytes and background.

The example data provided with this guide is organized as follows:
- "_active_exp1_": SPN-4:GFP expression in active oocytes, experiment # 1.
- "_active_exp2_": SPN-4:GFP expression in active oocytes, experiment # 2.
- "_quiescent_exp1_": SPN-4:GFP expression in quiescent oocytes, experiment # 1.
- "_quiescent_exp2_": SPN-4:GFP expression in quiescent oocytes, experiment # 2.

Raw data can be downloaded from: https://doi.org/10.17632/5jt3m3twsh.1, location: SPN-4-GFP > SPN4-GFP_translation_rates.7z<br>See also **Reference** # 1.

### 3rd part: computing of cumulative intensities
#### Pre-analysis
1. Unzip compressed example data (see above). Four folders will be generated:
    - "_active_exp1_"
    - "_active_exp2_"
    - "_quiescent_exp1_"
    - "_quiescent_exp2_"

Each folder contains SUM projected images and ROIs.

#### Analysis
2. Open Fiji (ImageJ).
3. Using Fiji, open the script `BATCH_cum_intensity_from_ROI_Merged_v2.ijm` (location: `./translation-rate-scripts`).
4. Modify experiment identifiers.<br>For example to analyze data in "_active_exp1_" folder:
```java
    //... Modify if needed (File Identifiers)...
    file_ext = "zip";// ROI file extension
    activityID = "active"
    experimentID = "exp1"
```
5. Click in Run and then select the folder where to compute cumulative intensities.<br> In this case "_active_exp1_".
6. Wait until all images are analyzed and then close the images.
7. Repeat **4**, **5** and **6** for the remaining 3 folders.<br>

<br>

- to analyze data in "_active_exp2_" folder
```java
    //... Modify if needed (File Identifiers)...
    file_ext = "zip";// ROI file extension
    activityID = "active"
    experimentID = "exp1"
```
- to analyze data in "_quiescent_exp1_" folder
```java
    //... Modify if needed (File Identifiers)...
    file_ext = "zip";// ROI file extension
    activityID = "quiescent"
    experimentID = "exp1"
```
- to analyze data in "_quiescent_exp2_" folder
```java
    //... Modify if needed (File Identifiers)...
    file_ext = "zip";// ROI file extension
    activityID = "quiescent"
    experimentID = "exp2"
```

8. For each folder, you will obtain:
    - `.txt` file per image with cumulative intensities.
    - `.txt` file with all results **_merged_**, named "`..._cum_int_merged.txt`".

### 4th part: calculation of relative concentrations and translation rates.
#### Pre-analysis
1. Make a folder with the four **_merged_** files (as in `./quantification-results/merged-files`).
    - _`active_exp1_cum_int_merged.txt`_
    - _`active_exp2_cum_int_merged.txt`_
    - _`quiescent_exp1_cum_int_merged.txt`_
    - _`quiescent_exp2_cum_int_merged.txt`_

#### Analysis
2. Open R or RStudio.
3. open the script `compute_concentration_and_translation_rate.r` (location: `./translation-rate-scripts`).
4. Run the script, then select any file within the folder made in step 1 (**_Pre-analysis, 4th part_**).

#### The default parameters of `compute_concentration_and_translation_rate.r` script include:
```r
    #====Translation rates computing

    # number of slides used for SUM projections - **has to be the same for all images**
    slides_SUM_projection = 11

    # voxel size in micrometers
    voxel_size_X = 0.0670922
    voxel_size_y = 0.0670922
    voxel_size_z = 0.5

    # ovulation rates per minute
    ovulation_rate_active    = 25
    ovulation_rate_quiescent = 600

    ...
```

The following parameters can also be modified if different `activityID` labels are used (step 3, **_Analysis, 3rd part_**):
```r
    ...

    #====
    #::::::::::::::
    #::: set up :::
    #::::::::::::::
    # experiment identifiers (do not modify)
    active_worms_id    = 'active'
    quiescent_worms_id = 'quiescent'

    ...
```

## Outputs
### Provided output examples:
The quantification results, for the example data provided in this tutorial, are also included here (location: `./quantification-results/computed-conc-translation-rates`).<br>
#### Table outputs:
- _`cum_int_merged_experiments_merged.csv`_
- _`relative_concentration_table.csv`_
- _`translation_rates_table.csv`_
- _`summary_translation_rates.csv`_
#### plot outputs:
- _`relative_concentration.svg`_
- _`translation_rates.csv`_
- _`translation_rates_displayed_0p1to100.svg`_

The last plot output (_`translation_rates_displayed_0p1to100.svg`_) is displayed from 0.1 to 100. The following parameters can also be modified to change this range:
```r
    ...

    #====
    #::::::::::::::
    #::: set up :::
    #::::::::::::::
    
    ...

    # display range - tr plot (do not modify)
    min_in_y = 0.1;
    max_in_y = 120;
        
    ...
```

## How calculations are performed from SUM projections
Please see STAR Methods of Cardona _et al_. Cell (2023) (1). Briefly, "Protein production rates, computed in Fluorescence units per µm3 per minute, were derived from relative concentrations (in relative fluorescence units per µm3)... The relative concentration (rC) was computed from cumulative z-projections (sum of slices) of 3D z-stacks as follows:

rC = (mean_I_outline * px_outline - BGD * vx_oocyte) / (V_vx * vx_oocyte)<br>
rC = ∑(I_oocyte-BGD) / V_oocyte

mean_I_outline represents the mean fluorescence intensity of the z-projected oocyte (outline), px_outline is the number of pixels in the outline, vx_oocyte is the number of voxels in the oocyte given by N_stacks * px_outline where N_stacks is the number of slices. V_vx represents the voxel volume in µm3. The estimated mean background was calculated as BGD = (mean_I_BGD * px_BGD) / vx_BGD, or mean_I_BGD /  N_stacks, where mean_I_BGD is the mean fluorescence intensity of the z-projected BGD representative region (outline_BGD), px_BGD is the number of pixels in the outline_BGD, and vx_BGD is the number of voxels given by N_stacks * px_BGD.

From the difference in relative concentration (ΔrC) between staged oocytes separated by the ovulation time, we computed the relative protein production rates (rPR = ΔrC / ovulation time)". (1)

## References
1. Cardona et al., Self-demixing of mRNA copies buffers mRNA:mRNA and mRNA:regulator stoichiometries, Cell (2023), https://doi.org/10.1016/j.cell.2023.08.018
