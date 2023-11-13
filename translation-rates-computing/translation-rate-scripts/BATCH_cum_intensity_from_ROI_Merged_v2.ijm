//... Modify if needed (File Identifiers)...
file_ext = "zip";// ROI file extension
activityID = "quiescent"
experimentID = "exp1"


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

mergeTable = "";

//print(list.length);
for (k=0; k<list.length; k++) {
          if (endsWith(list[k], "."+file_ext)){
             roiManager("open", dir+list[k]);
             imageName = substring(list[k], 0, lengthOf(list[k])-4);
             open(dir+imageName+".tif");
             numROIs = roiManager("count");
             print("activity	imageID	image	oocyte	area	mean	n_pixels	cum_intensity");
             for(i=0; i<numROIs;i++) {// loop through ROIs
				a = i + 1;
				roiManager("Select", i);
				getRawStatistics(nPixels, mean);
				getPixelSize(unit, pixelWidth, pixelHeight);
				print(activityID+"	"+imageName+"_"+experimentID+"	"
				+imageName+"	"
				+"oocyte_"+a+"	"
				+nPixels*pixelWidth*pixelHeight+"	"
				+mean+"	"
				+nPixels+"	"
				+nPixels*mean);
				merged = activityID+"	"+imageName+"_"+experimentID+"	"+imageName+"	"+"oocyte_"+a+"	"+nPixels*pixelWidth*pixelHeight+"	"+mean+"	"+nPixels+"	"+nPixels*mean;
				mergeTable = mergeTable+"\n"+merged;
			}
			selectWindow("Log");
			name_results = imageName+"_cum_int.txt";
			saveAs("Text", outputDir+name_results);
			selectWindow("Log");
			run("Close");
			roiManager("reset");
			selectWindow("ROI Manager"); 
			run("Close");
          }
}

print("activity	imageID	image	oocyte	area	mean	n_pixels	cum_intensity"+mergeTable);
selectWindow("Log");
name_results = activityID+"_"+experimentID+"_cum_int"+"_merged"+".txt";
saveAs("Text", outputDir+name_results);
selectWindow("Log");
run("Close");
