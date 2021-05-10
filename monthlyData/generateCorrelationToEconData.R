###
# correlation testing between employmeent and night lights data(monthly )
# carverd@colostate.edu
# 20210329
### 
# install.packages("here")
library(raster)
library(tidyverse)
library(tmap)
library(here)
tmap_mode("view")

baseDir <- "F:/geoSpatialCentroid/covidNightLights"

# filter economic data to the 
d1 <- readr::read_csv(paste0(baseDir, "/data/economicData/Employment - City - Daily.csv"))

source(file = paste0(baseDir, "/src/primaryWorkflow/functions.R"))

## function for daily data 
# Tucson (33), Phoenix (5) and Las Vegas(8)
cityIndexs <- c(33,5,8)
locations <- c("Tucson", "Phoenix", "lasVegas")
csvPattern <- c("dailyDataSummary.csv", "sevenDay")
econData <- readr::read_csv(paste0(baseDir, "/data/economicData/Employment - City - Daily.csv"))
dependentVar <- "emp_combined" 
filename <- c("dailyCor_rawDaily","dailyCor_sevenDayAve")

for(i in 1:3){
  print(i)
  for(j in 1:2){
    print(j)
    generateCorDays(cityIndex = cityIndexs[i], 
                    location = locations[i],
                    csvPattern = csvPattern[j],
                    econData = econData,
                    dependentVar = dependentVar,
                    filename = filename[j],
                    baseDir = baseDir)
  }
}
r1 <- read.csv("F:/geoSpatialCentroid/covidNightLights/data/Tucson/Pima_dailyDataSummary.csv")
r2 <- read.csv("F:/geoSpatialCentroid/covidNightLights/data/Phoenix/sevenDayAverages.csv")
generateCorDays <- function(cityIndex, location,csvPattern, econData,dependentVar, filename ){
  
  files <- list.files(paste0("F:/geoSpatialCentroid/covidNightLights/data/",location,"/"), 
                      pattern = csvPattern,
                      full.names = TRUE)
  n1 <- read.csv(files)
  # filter econ data
  d2 <- econData[econData$cityid == cityIndex,]
  # convert to date4
  d2$date <- as.Date(x = paste0(d2$year,"-",d2$month,"-",d2$day), format = "%Y-%m-%d")
  #convert column of interest to Numeric
  d2$dv <- as.numeric(d2[,dependentVar][[1]])

  ## filter daily to range of economic indicators 
  # reformat dates to match columns in daily data
  start <- paste0("X",str_replace_all(min(d2$date), "-", ".")) 
  end <- paste0("X", str_replace_all(max(d2$date), "-", "."))
  # sIndex <- grep(pattern = start, x = names(n1))
  # eIndex <- grep(pattern = end, x = names(n1))
  ### this indexing is tricky because we are unsure of the data ranges match up. 
  ### I would need to do check between the datasets converting daily data column headers to different values... ugh 
  # for no just stick to 2020 
  sIndex <- grep(pattern = start, x = names(n1))
  eIndex <- grep(pattern = "X2020.12.31", x = names(n1))

  # pull uid, lat, long, and dates of interest 
  n2 <- n1[,c(1:3,sIndex:eIndex)]
  n2$corValuePearson <- NA
  n2$corValueSpearman <- NA


  econVals <- as.numeric(d2$dv)[1:(ncol(n2)-5)]
  for(i in seq_along(n2$X2020.01.14)){
    print(i)
    vals <- as.numeric(n2[i,4:(ncol(n2)-2)])
    n2$corValuePearson[i] <- cor(x = vals, y = econVals,method ="pearson",  use = "complete.obs")
    n2$corValueSpearman[i]<- cor(x = vals, y = econVals,method ="spearman",  use = "complete.obs")
  }
  write.csv(n2, file =paste0(baseDir,"/data/",location,"/econCorrelations/",filename,".csv"))
}


# Tucson (33), Phoenix (5) and Las Vegas(8)
# select Tucson 

city <- c(8, 5)
startMonth <- 2
endMonth <- 4
dependentVar <- "emp_combined"
outputLoc <- "data/economicData"
area <-c("lasVegas","pheniox")  
# read in monthly data ---
n1 <- readr::read_csv(here("data","correct2020imagery","compiledMonthlyValues","Pima_noNAs.csv"))
n1$corValuePearson <- NA
n1$corValueSpearman <- NA
# read in a template raster
r1 <- raster::raster(here("data","correct2020imagery","janurary","Pima.tif"))
r2 <- r1 

for(i in seq_along(city)){
  print(i)
  generateCor(city = city[i], startMonth = startMonth,  endMonth = endMonth,
              outputLoc = outputLoc, area = area[i])
}


## function for daily data 
city <- 33
  #generateCorDays <- 
  d2 <- d1[d1$cityid == city,]
d2$date <- as.Date(x = paste0(d2$year,"-",d2$month,"-",d2$day), format = "%Y-%m-%d")
# filter to specific data range of interest
# d2 <- d2%>%
#   dplyr::filter(year == 2020, month >= startMonth, month <= endMonth)
#convert column of interest to Numeric
d2$dv <- as.numeric(d2[,"emp_combined"][[1]])

# iterate over each row and generate a correlation measure 
for(i in seq_along(n1$janurary)){
  row <- n1$row[i]
  col <- n1$col[i]
  if(is.na(n1[i,])){
    r1[row,col] <- n1$corValuePearson[i]
    r2[row,col] <- n1$corValueSpearman[i]
  }
  t1 <- t(n1[i,c(startMonth : endMonth)])
  n1$corValuePearson[i] <- cor(t1, d3$average, method = "pearson")
  n1$corValueSpearman[i] <- cor(t1, d3$average, method = "spearman")
  row <- n1$row[i]
  col <- n1$col[i]
  print(i)
}
write.csv(n1, file =here(outputLoc,"monthlyDatawithCorrelations.csv"))
raster::writeRaster(x = r1, filename = here(outputLoc, paste0(area,"person",startMonth,"_",endMonth,".tif")))
raster::writeRaster(x = r2, filename = here(outputLoc, paste0(area,"spearmen",startMonth,"_",endMonth,".tif")))
