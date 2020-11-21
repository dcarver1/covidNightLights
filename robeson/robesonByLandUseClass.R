###
# summarize county data for single month in robeson based on NLCD land cover 
# carverd@colostate.edu 
# 20201106
###

library(raster)
library(dplyr)
library(sf)
library(tmap)
tmap_mode("plot")
baseDir <- "F:/nrelD/geoSpatialCentroid/covidNightLights/data/"

# function for pulling specific files 
pullfiles <- function(baseDir, year){
  # pull all image for north america for a specific year 
  files <- list.files(paste0(baseDir, year),
                      full.names = TRUE, recursive = TRUE)
  # filter by type of  image 
  f2 <- files[grep(pattern = "avg_rade", x = files)]
  # filter files for continents and type of 
  na <- f2[grep(pattern = "75N180W", f2)]
  return(na)
}
# pull all images for a specific year
images <- pullfiles(baseDir, year = 2018)
images
im <- raster::raster(images[11])


# read in county data 
cnt <- sf::read_sf("F:/nrelD/genericSpatialData/US/counties/tl_2017_us_county.shp")
#reproject to wgs1984 
cnt <- sf::st_transform(x = cnt, crs = im@crs)

# robeson conty 
robe <- cnt %>%
  dplyr::filter(STATEFP == 37) %>%
  dplyr::filter(COUNTYFP == 155)

# crop and mask night light image to county 
im2 <- im %>%
  raster::crop(robe) %>%
  raster::mask(robe)
qtm(im2)


# read in NLCD data 
n <- raster::raster("D:/generalSpatialData/CONUS/NLCD_2016_Land_Cover_L48_20190424/NLCD_2016_Land_Cover_L48_20190424.img")
# transform robe to clip raster down 
robe2 <-  sf::st_transform(x = robe, crs = n@crs)
# cut down the size of the feature 
n1 <- n %>%
  raster::crop(robe2)%>%
  raster::mask(robe2)
# reproject the smaller feature to match nightlights projection
n2 <- raster::projectRaster(from = n1, crs = crs(im2), method = "ngb")
# resample the data to match cell size 
n3 <- raster::resample(x = n2, y = im2, method = "ngb")
# duplicate for resample 
n4 <- n3 
# keeping only developed areas https://www.mrlc.gov/data/legends/national-land-cover-database-2016-nlcd2016-legend
n4[n4 %in% c(90, 42, 82, 52, 41, 71,95, 24, 11, 81, 43)] <- NA

### may want to reclassifly per lond cover class. 

# just try a direct comparison for now 
n5 <- n4
n5[n5 %in% c(21, 22, 23)] <- 1
developedArea <- n5 * im2
mean <- mean(values(developedArea), na.rm = TRUE)
mean
len1 <- length(values(developedArea)[!is.na(values(developedArea))])
len1

#all values 
mean1 <- mean(values(im2), na.rm = TRUE)
len12 <- length(values(im2)[!is.na(values(im2))])
mean1
len12

# values above -1 
im3 <- im2
im3[im3 <= 1 ] <- NA
mean2 <- mean(values(im3), na.rm = TRUE)
len2 <- length(values(im3)[!is.na(values(im3))])
len2 

# all values 
mean3 <- mean(values(im2), na.rm = TRUE)
mean3
len3 <- length(values(im2)[!is.na(values(im2))])
len3

# values above 5 
im4 <- im2 
im4[im4 < 5] <- NA
mean4 <- mean(values(im4), na.rm = TRUE)
mean4
len4 <- length(values(im4)[!is.na(values(im4))])
len4



