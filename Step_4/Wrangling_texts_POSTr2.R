library(data.table)
library(dplyr)
library(ggplot2)
library(RColorBrewer)


mypath = "/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/Step_4/Test_analysis/Final_output091121/filtered_15lines/POSTr"
setwd(mypath)

list_of_files_POST <- list.files(path = mypath, recursive = TRUE, pattern = "\\.txt$", full.names = FALSE)
DT_POST <- rbindlist(sapply(list_of_files_POST, fread, simplify = FALSE), use.names = TRUE, idcol = "Filename")

DT_POST2 <- DT_POST[,1:2]

for(file in unique(DT_POST2$Filename)){
  temp_rows <- subset(DT_POST2, Filename == file)
  temp_DT <- data.table(Filename = file)
  temp_DT[, "Column_1" := temp_rows$V1[1]]
  temp_DT[, "Column_2" := temp_rows$V1[2]]
  temp_DT[, "Column_3" := temp_rows$V1[3]]
  temp_DT[, "Column_4" := temp_rows$V1[4]]
  temp_DT[, "Column_5" := temp_rows$V1[5]]
  temp_DT[, "Column_6" := temp_rows$V1[6]]
  temp_DT[, "Column_7" := temp_rows$V1[7]]
  temp_DT[, "Column_8" := temp_rows$V1[8]]
  temp_DT[, "Column_9" := temp_rows$V1[9]]
  temp_DT[, "Column_10" := temp_rows$V1[10]]
  temp_DT[, "Column_11" := temp_rows$V1[11]]
  temp_DT[, "Column_12" := temp_rows$V1[12]]
  temp_DT[, "Column_13" := temp_rows$V1[13]]
  temp_DT[, "Column_14" := temp_rows$V1[14]]
  temp_DT[, "Column_15" := temp_rows$V1[15]]
  if(file == unique(DT_POST2$Filename)[1]){
    output <- temp_DT
  } else {
    output <- rbind(output, temp_DT)
  }
}





# CLEANUP -----------------------------------------------------------------


#rev order of columns
DT_POSTrev <- output[,c(1,16:2)]



DT_POSTrev[ , Column_15 := ifelse(grepl("r", Column_15), gsub(pattern = "r", "", Column_15), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_15))]
DT_POSTrev[ , Column_14 := ifelse(grepl("r", Column_14), gsub(pattern = "r", "", Column_14), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_14))]
DT_POSTrev[ , Column_13 := ifelse(grepl("r", Column_13), gsub(pattern = "r", "", Column_13), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_13))]
DT_POSTrev[ , Column_12 := ifelse(grepl("r", Column_12), gsub(pattern = "r", "", Column_12), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_12))]
DT_POSTrev[ , Column_11 := ifelse(grepl("r", Column_11), gsub(pattern = "r", "", Column_11), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_11))]
DT_POSTrev[ , Column_10 := ifelse(grepl("r", Column_10), gsub(pattern = "r", "", Column_10), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_10))]
DT_POSTrev[ , Column_9 := ifelse(grepl("r", Column_9), gsub(pattern = "r", "", Column_9), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_9))]
DT_POSTrev[ , Column_8 := ifelse(grepl("r", Column_8), gsub(pattern = "r", "", Column_8), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_8))]
DT_POSTrev[ , Column_7 := ifelse(grepl("r", Column_7), gsub(pattern = "r", "", Column_7), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_7))]
DT_POSTrev[ , Column_6 := ifelse(grepl("r", Column_6), gsub(pattern = "r", "", Column_6), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_6))]
DT_POSTrev[ , Column_5 := ifelse(grepl("r", Column_5), gsub(pattern = "r", "", Column_5), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_5))]
DT_POSTrev[ , Column_4 := ifelse(grepl("r", Column_4), gsub(pattern = "r", "", Column_4), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_4))]
DT_POSTrev[ , Column_3 := ifelse(grepl("r", Column_3), gsub(pattern = "r", "", Column_3), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_3))]
DT_POSTrev[ , Column_2 := ifelse(grepl("r", Column_2), gsub(pattern = "r", "", Column_2), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_2))]
DT_POSTrev[ , Column_1 := ifelse(grepl("r", Column_1), gsub(pattern = "r", "", Column_1), gsub(pattern = "(M_[0-9]+)(.*)", replacement = "\\1r\\2", Column_1))]


#Following selects the columns from my datatable which I want to keep
POST_clean <- DT_POSTrev[,c(1, 2:15)]


#Rename columns

old <- c("Column_15", "Column_14", "Column_13", "Column_12", "Column_11", "Column_10", "Column_9", "Column_8", "Column_7", "Column_6", "Column_5", "Column_4", "Column_3", "Column_2")
new <- c("M1", "M2", "M3", "M4", "M5", "M6", "M7", "M8", "M9", "M10", "M11", "M12", "M13", "M14")

setnames(POST_clean, old, new)


# Combining PRE and POSTr DTs ---------------------------------------------

PRE <- readRDS(file = "PRE.Rds")

totalDT <- rbind(PRE, POST_clean)



# Quantification of module populations ------------------------------------


#get count of each each mod_id in each position (M1, M2 etc.) with 'table' function. Creates a list of lists which contain tables
mysummary <- lapply(totalDT, table)

#rid of first list which only contains names
M_tables <- mysummary[2:15]



#turn list of lists into dataframe. fill = TRUE allows for lists of different lengths - fills in NA for missing data
newdt <- rbindlist(lapply(M_tables, function(x) as.data.frame.list(x)), fill=TRUE)

#reorder columns
col_order <- c("M_1", "M_1r", "M_2", "M_2r", "M_3", "M_3r", "M_4", "M_4r", "M_5", "M_5r", "M_6", "M_6r", "M_7", "M_7r", "M_8", "M_8r", "M_9", "M_9r", "M_10", "M_10r", "M_11", "M_11r", "M_12", "M_12r", "M_13", "M_13r", "M_14", "M_14r")
newdt2 <- newdt[,..col_order]

#display proportions instead of count using apply function. '1' refers to margin - in this case applies function to rows. 
newdt4 <-as.data.table(apply(newdt2, 1, function(x){x/sum(x, na.rm = TRUE)}))

#set name of each column in data table 
modules <- c("mod1", "mod2", "mod3", "mod4", "mod5", "mod6", "mod7", "mod8", "mod9", "mod10", "mod11", "mod12", "mod13", "mod14")
setnames(newdt4, modules)

#melt data such that transformed from wide to long, from 14 to 2 columns
newdt4_long <- melt(newdt4)

#add column specifying which mod_id each row corresponds to
newdt4_long[, "mod_id" := rep(col_order, times = (nrow(newdt4_long)/28))]


#lock in factor level of order of mod_id such that ggplot doesn't reorder legend
legend <- factor(newdt4_long$mod_id, levels = col_order)


#colour
coul1 <- colorRampPalette(c("darkred", "yellow", "darkgreen"))(28)

#plot long format of data table 
t <- ggplot(newdt4_long, aes(x=variable, y=value)) + geom_col(aes(fill = legend)) + scale_fill_manual(values = coul1)





  
