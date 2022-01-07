library(data.table)

#set current directory
mypath = "/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/Step_4/Test_analysis/Final_output091121/filtered_15lines/PRE"
setwd(mypath)

#create list of files 
list_of_files <- list.files(path = mypath, recursive = FALSE, pattern = "\\.txt$", full.names = FALSE)

#add what's in the files to a single dataframe
DT <- rbindlist(sapply(list_of_files, fread, simplify = FALSE), use.names = TRUE, idcol = "Filename")

#create new dataframe with only the first two columns. This gets rid of column w/ scores for each module.
DTnew <- DT[,1:2]


for(file in unique(DTnew$Filename)){
  temp_rows <- subset(DTnew, Filename == file)
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
  if(file == unique(DTnew$Filename)[1]){
    output <- temp_DT
  } else {
    output <- rbind(output, temp_DT)
  }
}


PRE_clean <- output[,c(1, 3:16)]

old <- c("Column_2", "Column_3", "Column_4", "Column_5", "Column_6", "Column_7", "Column_8", "Column_9", "Column_10", "Column_11", "Column_12", "Column_13", "Column_14", "Column_15")
new <- c("M1", "M2", "M3", "M4", "M5", "M6", "M7", "M8", "M9", "M10", "M11", "M12", "M13", "M14")

setnames(PRE_clean, old, new)


saveRDS(PRE_clean, file = "/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/Step_4/Test_analysis/Final_output091121/filtered_15lines/POSTr/PRE.Rds")

