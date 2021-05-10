###
# generate 7 day averages from the daily data
# carverd@colostate.edu
# 20210409
###

library(dplyr)

## list all folders
#dir1 <- list.dirs("F:/geoSpatialCentroid/covidNightLights/data",recursive = FALSE )
## pull specific city locations of interest
#dir2 <- dir1[c(19,22,23)]
#
#t1 <- read.csv("F:/geoSpatialCentroid/covidNightLights/data/lasVegas/Clark_dailyDataSummary.csv")
#View(t1) 
#d1 <- t1
rollingAverages <- function(fileLocation, dayAverages){
  # determine the rolling average value
  days <- floor(dayAverages/2)
  # grab file of interest
  files <- list.files(fileLocation)
  csv <- files[grepl(pattern = ".csv", x = files)]
  d1 <- read.csv(paste0(fileLocation[k], "/", csv))
  d2 <- d1
  d2[,5:ncol(d2)] <- NA
  for(j in (4+days):(ncol(d1)-4)){
    vals <-d1[ ,c((j-days):(j+days))]
    d2[ ,j] <- abs(rowMeans(vals,na.rm = TRUE))
  }
  write.csv(x = d2, file = paste0(fileLocation[k],"/sevenDayAverages.csv"))
}
### original Attempt
#for(k in 1:length(dir2)){
#  files <- list.files(dir2[k])
#  csv <- files[grepl(pattern = ".csv", x = files)]
#  d1 <- read.csv(paste0(dir2[k], "/", csv))
#  d2 <- d1
#  d2[,5:ncol(d2)] <- NA
#  # for each columns
#  for(j in 8:(ncol(d1)-4)){
#    vals <-d1[ ,c((j-3):(j+3))]
#    d2[ ,j] <- abs(rowMeans(vals,na.rm = TRUE))
#  }
#  # write.csv(x = d2, file = paste0(dir2[k],"/sevenDayAverages.csv"))
#}
