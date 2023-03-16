//... Modify if needed (File Identifiers)...
file_ext = "zip";// ROI file extesion



//... DO NOT MODIFY (outlines extraction)..
print("\\Clear");
selectWindow("Log");
run("Close");

roiManager("reset");
selectWindow("ROI Manager"); 
run("Close");

dir = getDirectory( "Choose the Directory" ); 
list = getFileList( dir ); 
outputDir = dir;


//print(list.length);
for (k=0; k<list.length; k++) {
          if (endsWith(list[k], "."+file_ext)){
//             print(list[k]);
//             print(substring(list[k], 0, lengthOf(list[k])-4)+".tif");
             roiManager("open", dir+list[k]);
             imageName = substring(list[k], 0, lengthOf(list[k])-4);
             open(dir+imageName+".tif");
             roiManager("show all");
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
			saveFileName = imageName+"_Cells.csv";
			saveAs("Text", outputDir+saveFileName);
			selectWindow("Log");
			run("Close");
			roiManager("reset");
			selectWindow("ROI Manager"); 
			run("Close");
          }
      }
