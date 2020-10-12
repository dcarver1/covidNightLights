###
# develop method for generateing monthly comparision between night light images 
# 20201001
# carverd@colostate.edu
###
#install.packages("tmap")
library(sf)
library(raster)
library(dplyr)
library(tmap)
tmap_mode("plot")
baseDir <- "D:/nrelD/geoSpatialCentroid/covidNightLights/data/"

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


### 
# read in county data 
cnt <- sf::read_sf("D:/nrelD/genericSpatialData/US/counties/tl_2017_us_county.shp")

### adapt this for robeson and housten area 

# robeson conty 
robe <- cnt %>%
  dplyr::filter(STATEFP == 37) %>%
  dplyr::filter(COUNTYFP == 155)

# housten counties 
hsn <- cnt %>%
  dplyr::filter(STATEFP == 48) %>%
  dplyr::filter(NAME %in% c("Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston",
                            "Harris", "Liberty", "Montgomery", "Waller"))

# full list of all locations 
locs <- rbind(hsn, robe)

# list of all months 
m <- c("janurary", "feburary", "march", "april", "may", "june", "july", "august", "october",
       "september","november", "december")
# counties of interest for writing out content. 
locations <- c("Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston",
       "Harris", "Liberty", "Montgomery", "Waller", "Robeson")

# pull all images for a specific year
images <- pullfiles(baseDir, year = 2018)

### check downloads on 2016 - missing Jan and Feb I'm redownloading them now. 


# for every month write out images for each county 
for(i in m){
  # select image base on month in the file path 
  file <- images[grep(pattern = i, x = images)]
  if(length(file) == 0){
    print("no images for this month")
  }else{
    # read in the file 
    im <- raster::raster(x = file)
    print(i)
    # crop, mask, and write out image for each of th eten counties of interest. 
  for( j in locations){
      print(j)
    # pull shp of specific location 
      l2 <- locs[locs$NAME == j, ]
      # crop and mask data
      r1 <- im %>%
        raster::crop(l2) %>%
        raster::mask(l2)
      #subset just pulls specific file base path 
      if(file.exists(paste0(substr(file, 1, 55),i, "/",j,".tif" ))){
        print("done")
      }else{
        raster::writeRaster(x = r1, 
                            filename = paste0(substr(file, 1, 55),i, "/",j,".tif" ),
                            overwrite=TRUE)
      }
    }
  }
}


