###
# generate yearly summary of the night lights data 
# 20201201
# carverd@colostate.edu
###
library(raster)
library(dplyr)
library(sf)
library(tmap)
library(plotly)
library(psych)
library(DT)
# tmap_mode("view")

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
# define county name
cName <- county$NAME[1]
  
# working with 2016 for the time being 
files <- list.files(path = paste0(baseDir, "/",year), pattern = ".tif",recursive = TRUE, full.names = TRUE)
# filter to county of interest 
cont <- sort(files[grep(pattern = cName, x = files)])
# drop any yearly data
if(length(cont) >12){
  cont <- cont[-grep(pattern = "yearly", cont)]
}
# since this is sort by month alphabetically, I'll index to the order I want. 
cOrd <- cont[c(5,4,8,1,9,7,6,2,12,11,10,3)]
# create a raster stack of the features 
s1 <- raster::stack(lapply(cOrd, raster::raster))

# reproject copy of county feature 
county2 <- sf::st_transform(x = county, crs = nlcd@crs)
# mask and crop nlcd for county 
lc <- nlcd %>%
  raster::crop(county2) %>%
  raster::mask(county2)
# reproject nlcd layer 
lc2 <- raster::projectRaster(from = lc, to = s1, crs = s1@crs, method = "ngb")
# for some reason a 0 value is being picked up... this is not part on the NLCD and I'm reclassifying it. This fixes the misclass of the pallette
lc2[lc2[] ==0 ]<- NA
m <- c(10,12, 1, 20,24, 2,  30, 31, 3, 40,43,4,  50,52, 5, 70,74, 6, 
       80,82, 7,  89,95,8 )
lc2 <- raster::reclassify(x = lc2, rcl = m )
return(c(s1,lc2))
}





for(i in seq_along(listOfCnt$FIP)){
  # select correct county 
  county <<-  cnt %>%
    dplyr::filter(STATEFP == listOfCnt$FIP[i])%>%
    dplyr::filter(NAME == listOfCnt$name[i])
  cName <- county$NAME
  # reproject copy of county feature 
  features <- yearlyAve(baseDir = baseDir, year = 2016, county = county)
  s1 <<- features[[1]]
  lc2 <<- features[[2]]
  
  
  # generate some yearly averages 

  if(!file.exists(paste0(baseDir,"/", year,"/yearlyAverages/mean/",cName[1],".tif"))){
    # putting this inside conditional statement for speed 
    m1 <<- raster::calc(x = s1, fun = mean)
    writeRaster(m1, filename = paste0(baseDir,"/", year,"/yearlyAverages/mean/",cName,".tif"))
  }
  me1 <<- raster::calc(x = s1, fun = median) %>%
    raster::crop(county) %>%
    raster::mask(county)
  if(!file.exists(paste0(baseDir,"/", year,"/yearlyAverages/median/",cName,".tif"))){
    writeRaster(me1, filename = paste0(baseDir,"/", year,"/yearlyAverages/median/",cName,".tif"))
  }
  if(!file.exists(paste0(baseDir,"/", year,"/yearlyAverages/standardDevation/",cName,".tif"))){
    std <<- raster::calc(x = s1, fun = sd)
    writeRaster(std, filename = paste0(baseDir,"/", year,"/yearlyAverages/standardDevation/",cName,".tif"))
  }
  if(!file.exists(paste0(baseDir,"/", year,"/yearlyAverages/range/",cName,".tif"))){
    range1 <<- raster::calc(x = s1, fun = function(x){max(x)-min(x)}, rm.na = TRUE)
    writeRaster(range1, filename = paste0(baseDir,"/", year,"/yearlyAverages/range/",cName,".tif"))
  }
  # Call a rmd doc 
  try(rmarkdown::render("F:/nrelD/geoSpatialCentroid/covidNightLights/src/yearlySummaries/generateCountyYearlySummary.Rmd",  # file 2
                        output_file =  paste("YearlySummaryReport_", cName,"_", ".html", sep=''), 
                        output_dir = paste0(baseDir,"/yearlySummaries")))
  
}
