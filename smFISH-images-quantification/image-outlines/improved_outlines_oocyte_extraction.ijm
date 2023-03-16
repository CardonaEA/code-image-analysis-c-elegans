//... Modify if needed (File Identifiers)...
name_base = "Image_name";
file_ext = "zip";



//... DO NOT MODIFY (outlines extraction)...
roiManager("reset");
selectWindow("ROI Manager"); 
run("Close");

dir = getDirectory( "Choose the Directory" ); 
list = getFileList( dir ); 
outputDir = dir;

nameI = name_base+".tif";
nameR = name_base+"."+file_ext;
nameO2 = name_base+"_Cells.csv";

open(dir+nameI);
roiManager("open", dir+nameR);

numROIs = roiManager("count");
for(i=0; i<numROIs;i++) {// loop through ROIs
	roiManager("Select", i);
	getSelectionCoordinates(x, y);//if the ROI is a multipoint ROIs x and y are arrays
	print("X_coodinate_cell_"+i);
	for (j=0; j<x.length; j++) {
		print(x[j]);
	}
    print("y_coodinate_cell_"+i);
     for (j=0; j<y.length; j++) {
		print(y[j]);
	}
}
selectWindow("Log");
saveAs("Text", outputDir+nameO2);
selectWindow("Log");
run("Close");
