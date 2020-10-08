###
# develop method for generateing monthly comparision between night light images 
# 20201001
# carverd@colostate.edu
###

library(sf)
library(raster)
library(dplyr)
library(tmap)
tmap_mode("plot")
baseDir <- "F:/nrelD/geoSpatialCentroid/covidNightLights/data/2020"

### 
# read in data 
extents <- sf::read_sf("F:/nrelD/geoSpatialCentroid/covidNightLights/data/fromGEE/extentLocations.shp")

naExtents <- extents[c(2,3,4),]
inExtents <- extents[1,]
qtm(naExtents[1,])

# for a list in rasters
files <- list.files("F:/nrelD/geoSpatialCentroid/covidNightLights/data/2020" , full.names = TRUE, recursive = TRUE)
# filter by type of  image 
f2 <- files[grep(pattern = "avg_rade", x = files)]
# filter files for continents and type of 
na <- f2[grep(pattern = "75N180W", f2)]
india <- f2[grep(pattern = "75N060E", f2)]

m <- c("janurary", "Feburary", "March")
a <- c("houston", "santaRosa", "bakkenOilField")
for(i in 1:length(na)){
  r <- raster::raster(na[i])
  r1 <- raster::crop(r , naExtents[1,])
  raster::writeRaster(x = r1, filename = paste0(baseDir, "/", m[i], "/",a[1],".tif" ))
  r1 <- raster::crop(r , naExtents[2,])
  raster::writeRaster(x = r1, filename = paste0(baseDir, "/", m[i], "/",a[2],".tif" ))
  r1 <- raster::crop(r , naExtents[3,])
  raster::writeRaster(x = r1, filename = paste0(baseDir, "/", m[i], "/",a[3],".tif" ))
  print(m[i])
}

### india 
for(i in 1:length(india)){
  r <- raster::raster(india[i])
  r1 <- raster::crop(r , inExtents[1,])
  raster::writeRaster(x = r1, filename = paste0(baseDir, "/", m[i], "/dhaka.tif" ))
}


