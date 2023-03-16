# read_csv
cytoplasm_read = read.table(file.choose() ,header = F, sep = ',', dec = '.')
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

# save 
write.csv(table_oocytes, file = 'modified_table.csv', row.names = F)

