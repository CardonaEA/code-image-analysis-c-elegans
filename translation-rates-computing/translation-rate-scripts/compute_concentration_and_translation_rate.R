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


#====
#::::::::::::::
#::: set up :::
#::::::::::::::
# experiment identifiers (do not modify)
active_worms_id    = 'active'
quiescent_worms_id = 'quiescent'
# display range - tr plot (do not modify)
min_in_y = 0.1;
max_in_y = 120;
# requited libraries
if (!require('ggplot2')) {install.packages('ggplot2', dependencies = TRUE)}
if (!require('svglite')) {install.packages('svglite', dependencies = TRUE)}
if (!require('plyr')) {install.packages('plyr', dependencies = TRUE)}
library(ggplot2)

#====
#:::::::::::::::::::::
#:: retrieve tables ::
#:::::::::::::::::::::
pattern_files = 'cum_int_merged'
file_name_out = 'cum_int_merged_experiments_merged'
root_dir = getwd()
# set wd
setwd(dirname(file.choose()))
# files
files_names = list.files(pattern = pattern_files)
# merging tables
pathname = getwd()
merged_table = c()
for (j in 1:length(files_names)){
  add_ID = c()
  table_read = read.table(paste(pathname,'/',files_names[j], sep = ''), header = T, sep = '\t', dec = '.')
  merged_table = rbind(merged_table, table_read)
}
write.csv(merged_table, file = paste(pathname, '/', file_name_out, '.csv', sep = ""),row.names = F)
# print retrieved files
print(files_names)

#====
#::::::::::::::::::::::
#:: [conc] computing ::
#::::::::::::::::::::::
#retrieve merged table
#root_dir = getwd()
#data_file = file.choose()
#cum_int_data <- read.table(data_file, dec=".", sep=",", header=TRUE)
#setwd(dirname(data_file))
cum_int_data = merged_table

# voxel size
voxel_size = voxel_size_X * voxel_size_y * voxel_size_z

# active worms
table_to_process = cum_int_data[cum_int_data$activity == active_worms_id,]
image_name = unique(table_to_process$imageID)
oocyte_table = c()

for (i in 1:length(image_name)) {
  sub_table = table_to_process[table_to_process$imageID == image_name[i],]
  # BGD ROI position
  bgd_pos = dim(sub_table)[1]
  oocyte_table_by_image = sub_table[-bgd_pos,]
  # BGD subtraction
  bgd_value = sub_table$cum_intensity[bgd_pos]/(sub_table$n_pixels[bgd_pos]*slides_SUM_projection)
  cum_int_wo_bgd = oocyte_table_by_image$cum_intensity - (oocyte_table_by_image$n_pixels*bgd_value*slides_SUM_projection)
  # concentration computing
  oocyte_vol = oocyte_table_by_image$n_pixels * slides_SUM_projection * voxel_size
  relative_conc_um3 = cum_int_wo_bgd/oocyte_vol
  # data frame
  oocyte_table_by_image = data.frame(oocyte_table_by_image, cum_int_wo_bgd,  oocyte_vol, relative_conc_um3)
  oocyte_table = rbind(oocyte_table,oocyte_table_by_image)
}
# negative productions ~= 0
oocyte_table$relative_conc_um3[oocyte_table$relative_conc_um3 < 0] <- 0
data_active_concentration = oocyte_table

# quiescent worms
table_to_process = cum_int_data[cum_int_data$activity == quiescent_worms_id,]
image_name = unique(table_to_process$imageID)
oocyte_table = c()

for (i in 1:length(image_name)) {
  sub_table = table_to_process[table_to_process$imageID == image_name[i],]
  # BGD ROI position
  bgd_pos = dim(sub_table)[1]
  oocyte_table_by_image = sub_table[-bgd_pos,]
  # BGD subtraction
  bgd_value = sub_table$cum_intensity[bgd_pos]/(sub_table$n_pixels[bgd_pos]*slides_SUM_projection)
  cum_int_wo_bgd = oocyte_table_by_image$cum_intensity - (oocyte_table_by_image$n_pixels*bgd_value*slides_SUM_projection)
  # concentration computing
  oocyte_vol = oocyte_table_by_image$n_pixels * slides_SUM_projection * voxel_size
  relative_conc_um3 = cum_int_wo_bgd/oocyte_vol
  # data frame
  oocyte_table_by_image = data.frame(oocyte_table_by_image, cum_int_wo_bgd,  oocyte_vol, relative_conc_um3)
  oocyte_table = rbind(oocyte_table,oocyte_table_by_image)
}
# negative productions ~= 0
oocyte_table$relative_conc_um3[oocyte_table$relative_conc_um3 < 0] <- 0
data_quiescent_concentration = oocyte_table

#====
# saving data
dataF = rbind(data_active_concentration, data_quiescent_concentration)
write.csv(dataF, file = "relative_concentration_table.csv", row.names = F)

#====
#::::::::::::::::::::::::
#:: summarize function ::
#::::::::::::::::::::::::
# The summarySE function was obtained from: http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

#====
#:::::::::::::::::
#:: [conc] plot ::
#:::::::::::::::::
data_plot = summarySE(data = dataF, measurevar = "relative_conc_um3", groupvars = c("oocyte","activity"))
ggplot(data = data_plot, aes(x=oocyte, y=relative_conc_um3, group = activity, fill = activity)) +
  geom_ribbon(aes(x = oocyte, ymin= relative_conc_um3 - ci, ymax= relative_conc_um3 + ci), alpha = 0.3) +
  geom_line() +
  ylab('conc [int/um3] +- ci') +
  geom_point(shape = 21, size = 3) +
  scale_x_discrete(limits = rev(unique(data_plot$oocyte))) +
  theme(panel.background = element_rect(fill = "transparent", colour = NA),  
        plot.background = element_rect(fill = "transparent", colour = NA),
        panel.border = element_rect(fill = F),
        panel.grid =  element_line(colour = 'transparent'),
        legend.background = element_rect(fill = "transparent", colour = NA))
ggsave("relative_concentration.svg", device = 'svg', dpi = 300, width = 6, height = 4, units = 'in', bg = "transparent")

#====
#:::::::::::::::::::::::::::::::::
#:: translation rates computing ::
#:::::::::::::::::::::::::::::::::
# active worms
data_conc = data_active_concentration
image_name = unique(data_conc$imageID)
delta_table = c()
ovulation_rate = ovulation_rate_active

for (i in 1:length(image_name)) {
  protein_conc = data_conc$relative_conc_um3[data_conc$imageID == image_name[i]]
  delta_protein_conc = protein_conc[1:length(protein_conc) - 1] - protein_conc[2:length(protein_conc)]
  sub_table = data.frame('oocyte' = paste('oocyte_', seq(1:length(delta_protein_conc)),sep =""), 
                         'rate' = delta_protein_conc/ovulation_rate, 
                         'activity' = rep(active_worms_id,length(delta_protein_conc)))
  delta_table = rbind(delta_table, sub_table)
}

# quiescent worms
data_conc = data_quiescent_concentration
image_name = unique(data_conc$imageID)
#delta_table = c()
ovulation_rate = ovulation_rate_quiescent

for (i in 1:length(image_name)) {
  protein_conc = data_conc$relative_conc_um3[data_conc$imageID == image_name[i]]
  delta_protein_conc = protein_conc[1:length(protein_conc) - 1] - protein_conc[2:length(protein_conc)]
  sub_table = data.frame('oocyte' = paste('oocyte_', seq(1:length(delta_protein_conc)),sep =""), 
                         'rate' = delta_protein_conc/ovulation_rate, 
                         'activity' = rep(quiescent_worms_id,length(delta_protein_conc)))
  delta_table = rbind(delta_table, sub_table)
}

#====
# saving data
write.csv(delta_table, file = "translation_rates_table.csv", row.names = F)
plot_deltas = summarySE(data = delta_table, measurevar = "rate", groupvars = c("oocyte","activity"))
plot_deltas = data.frame(plot_deltas, "ci_lwr" = plot_deltas$rate - plot_deltas$ci, "ci_upr" = plot_deltas$rate + plot_deltas$ci)
write.csv(plot_deltas, file = "summary_translation_rates.csv", row.names = F)

#====
#::::::::::::::::::::::::::::::::
#:: translation rates plotting ::
#::::::::::::::::::::::::::::::::
# negative productions to zero to display to -inf (just visualization)
plot_deltas$ci_lwr[plot_deltas$ci_lwr < 0] <- 0

ggplot(data = plot_deltas, aes(x = oocyte, y = rate, group = activity, fill = activity)) +
  geom_ribbon(aes(x = oocyte, ymin= ci_lwr, ymax= ci_upr), alpha = 0.4) +
  geom_line() +
  geom_point(shape = 21, size = 3) +
  scale_y_continuous(trans = "log10") +
  scale_x_discrete(limits = rev(unique(plot_deltas$oocyte))) +
  ylab('rate [int/um3/min] +- ci') +
  theme(panel.background = element_rect(fill = "transparent", colour = NA),  
        plot.background = element_rect(fill = "transparent", colour = NA),
        panel.border = element_rect(fill = F),
        panel.grid =  element_line(colour = 'transparent'),
        legend.background = element_rect(fill = "transparent", colour = NA))
ggsave("translation_rates.svg", device = 'svg', dpi = 300, width = 5, height = 3.5, units = 'in', bg = "transparent")

ggplot(data = plot_deltas, aes(x = oocyte, y = rate, group = activity, fill = activity)) +
  geom_ribbon(aes(x = oocyte, ymin= ci_lwr, ymax= ci_upr), alpha = 0.4) +
  geom_line() +
  geom_point(shape = 21, size = 3) +
  scale_y_continuous(trans = "log10", limits = c(min_in_y,max_in_y)) +
  scale_x_discrete(limits = rev(unique(plot_deltas$oocyte))) +
  ylab('rate [int/um3/min] +- ci') +
  theme(panel.background = element_rect(fill = "transparent", colour = NA),  
        plot.background = element_rect(fill = "transparent", colour = NA),
        panel.border = element_rect(fill = F),
        panel.grid =  element_line(colour = 'transparent'),
        legend.background = element_rect(fill = "transparent", colour = NA))
ggsave("translation_rates_displayed_0p1to100.svg", device = 'svg', dpi = 300, width = 5, height = 3.5, units = 'in', bg = "transparent")

# set wd
setwd(root_dir)
