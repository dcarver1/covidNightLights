###
# Prep new monthly averages 
# 20210129
# carverd@colostate.edu 
###
library(sf)
library(raster)
library(dplyr)
library(tmap)
tmap_mode("plot")
baseDir <- "D:/nrelD/geoSpatialCentroid/covidNightLights/data/"


### 
# read in county data 
cnt <- sf::read_sf("D:/genericSpatialData/US/counties/tl_2017_us_county.shp")

# robeson conty 
robe <- cnt %>%
  dplyr::filter(STATEFP == 37) %>%
  dplyr::filter(COUNTYFP == 155)

# housten counties 
hsn <- cnt %>%
  dplyr::filter(STATEFP == 48) %>%
  dplyr::filter(NAME %in% c("Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston",
                            "Harris", "Liberty", "Montgomery", "Waller"))
View(hsn)
# full list of all locations 
locs <- rbind(hsn, robe)
#reproject to wgs1984 
cnt <- sf::st_transform(x = locs, crs = "+proj=longlat +datum=WGS84 +no_defs")

# list of all months 
m <- c("janurary", "feburary", "march", "april", "may", "june", "july", 
       "august", "september", "october")
# counties of interest for writing out content. 
locations <- c("Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston",
               "Harris", "Liberty", "Montgomery", "Waller", "Robeson")


# pull in files - Average radiance 
# r1 <- sort(list.files(path = "D:/geoSpatialCentroid/covidNightLights/data/correct2020imagery/conus_city_lights/masked_avg_radiance",
#                  full.names = TRUE)) 
# number of images 
r1 <- sort(list.files(path = "D:/geoSpatialCentroid/covidNightLights/data/correct2020imagery/conus_city_lights/cf_cvg",
                 full.names = TRUE))

# create folders 
loc <- "D:/geoSpatialCentroid/covidNightLights/data/correct2020imagery/"
# for(i in m){
#   dir.create(paste0(loc, i) )
# }


### 
## loop over months 
for(i in seq_along(m)){
  print(m[i])
  # read in a raster  
  r2 <- raster::raster(r1[i])
  ## loop over locations 
  for(j in seq_along(locations)){
    print(locations[j])
    # select county of interest 
    l2 <- cnt[cnt$NAME == locations[j],]
    # clip and mask 
    r3 <- r2 %>%
      raster::crop(l2)%>%
      raster::mask(l2)
    # write out the feature to a specific file location 
    raster::writeRaster(x = r3, 
                        filename = paste0(loc, m[i],"/",locations[j],"_obs.tif"),
                        overwrite = TRUE)
  }
}


