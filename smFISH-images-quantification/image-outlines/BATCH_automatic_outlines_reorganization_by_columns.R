# ::::::::::::::::::: parameters

pattern_files = 'Cells'

file_name_out = 'MOD_'

# ::::::::::::::::::: script to bin and arrange data base on file name
root.name = getwd()

# set wd
# setwd(choose.dir())
setwd(dirname(file.choose()))

# files
files_SPOTS = list.files(pattern = pattern_files)
print(files_SPOTS)

# bind tables
pathname = getwd()

for (i in 1:length(files_SPOTS)){
  # read_csv
  cytoplasm_read = read.table(paste(pathname,'/',files_SPOTS[i], sep = ''),
                              header = F, sep = ',', dec = '.')
  #cytoplasm_read = read.table(file.choose() ,header = F, sep = ',', dec = '.')
  # make it vector-like
  cytoplasm_read$V1 = as.vector(cytoplasm_read$V1)

  # find headers positions
  positions_vectors = grep("[:alnum:]",cytoplasm_read$V1)
  # define the number of cells
  number_cells = length(positions_vectors)/2
  # add the end of the atble for the las y coordinate
  positions_vectors = c(positions_vectors,length(cytoplasm_read$V1) + 1)

  # IMPORTANT - to cbind we need to have the same number of rows. predefine to the max length
  # max length
  max_length = max((positions_vectors[2:length(positions_vectors)] - positions_vectors[1:length(positions_vectors)-1]) -1)
  # empty initial data.frame
  table_oocytes = data.frame(matrix("", ncol = 0, nrow = max_length)) 

  # loop through oocytes
  for (j in 1:number_cells){
    x_coordinates = vector(mode = 'character', max_length)
    y_coordinates = vector(mode = 'character', max_length)
    
    x_values = as.numeric(cytoplasm_read$V1[seq(positions_vectors[(2*j)-1] + 1, positions_vectors[2*j] - 1)])
    y_values = as.numeric(cytoplasm_read$V1[seq(positions_vectors[2*j] + 1, positions_vectors[(2*j)+1] - 1)])
    
    x_coordinates[1 : length(x_values)] = x_values
    y_coordinates[1 : length(y_values)] = y_values
    
    #x_coordinates = as.numeric(x_coordinates)
    #y_coordinates = as.numeric(y_coordinates)
    
    oocyte = data.frame(x_coordinates, y_coordinates)
    colnames(oocyte) = c(cytoplasm_read$V1[positions_vectors[(2*j)-1]], cytoplasm_read$V1[positions_vectors[2*j]])
    
    table_oocytes = cbind(table_oocytes, oocyte)
  }

  write.csv(table_oocytes, file = paste(pathname, '/', file_name_out, files_SPOTS[i], sep = ""), row.names = F)
  
}

setwd(root.name)

