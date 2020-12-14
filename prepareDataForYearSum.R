###
# generate yearly summary of the night lights data 
# 20201201
# carverd@colostate.edu
###
library(dplyr)
library(raster)
library(sf)
library(mean)

baseDir <- "F:/nrelD/geoSpatialCentroid/covidNightLights/data"

# data is store by year, month, locality. List files then filter for a specific locality or year of interest 
# base data 
nlcd <- raster::raster("D:/generalSpatialData/CONUS/NLCD_2016_Land_Cover_L48_20190424/NLCD_2016_Land_Cover_L48_20190424.img")
cnt <- sf::read_sf("F:/nrelD/genericSpatialData/US/counties/tl_2017_us_county.shp")
stateFIP <- c(37, rep(48,9), 32)
countyName <- c("Robeson",
                "Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston",
                "Harris", "Liberty", "Montgomery", "Waller", 
                "Clark")
listOfCnt <- data.frame(matrix(data = c(stateFIP, countyName) , ncol = 2) )
colnames(listOfCnt) <- c("FIP", "name")


yearlyAve <- function(baseDir, year, county){
  
}
year <- 2016
county <- "Austin"
# working with 2016 for the time being 
files <- list.files(path = paste0(baseDir, "/2016"), pattern = ".tif",recursive = TRUE, full.names = TRUE)

# filter to county of interest 
cont <- sort(files[grep(pattern = "Austin", x = files)])
# since this is sort by month alphabetically, I'll index to the order I want. 
cOrd <- cont[c(5,4,8,1,9,7,6,2,12,11,10,3)]
# create a raster stack of the features 
s1 <- raster::stack(lapply(cOrd, raster::raster))
# generate some yearly averages 
m1 <<- raster::calc(x = s1, fun = mean)
if(!file.exists(paste0(baseDir,"/", year,"/yearlyAverages/mean/",county,".tif"))){
  writeRaster(m1, filename = paste0(baseDir,"/", year,"/yearlyAverages/mean/",county,".tif"))
}
me1 <<- raster::calc(x = s1, fun = median)
if(!file.exists(paste0(baseDir,"/", year,"/yearlyAverages/median/",county,".tif"))){
  writeRaster(me1, filename = paste0(baseDir,"/", year,"/yearlyAverages/median/",county,".tif"))
}
std <<- raster::calc(x = s1, fun = sd)
if(!file.exists(paste0(baseDir,"/", year,"/yearlyAverages/standardDevation/",county,".tif"))){
  writeRaster(std, filename = paste0(baseDir,"/", year,"/yearlyAverages/standardDevation/",county,".tif"))
}
range <<- raster::calc(x = s1, fun = function(x){max(x)-min(x)})
if(!file.exists(paste0(baseDir,"/", year,"/yearlyAverages/range/",county,".tif"))){
  writeRaster(std, filename = paste0(baseDir,"/", year,"/yearlyAverages/range/",county,".tif"))
}
# Call a rmd doc 