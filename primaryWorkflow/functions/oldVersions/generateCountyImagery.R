###
# Prep new monthly averages using the corrected 2020 imagery 
# 20210129
# carverd@colostate.edu 
###

generateCountyImagery <- function(locations, months1,cnt, baseDir){
  # locations : feature one of defineLocations output  
  # months1 : feature two of defineLocations output
  # cnt : "F:/genericSpatialData/US/counties/tl_2017_us_county.shp")
  # baseDir : "F:/geoSpatialCentroid/covidNightLights"
  library(sf)
  library(raster)
  library(dplyr)
  # reproject to wgs1984 
  cnt <- sf::st_transform(x = cnt, crs = "+proj=longlat +datum=WGS84 +no_defs")
  
  # number of images, Relying on sort for the indexing this could be improved. 
  r1 <- sort(list.files(path = paste0(baseDir, "/data/correct2020imagery/conus_city_lights/cf_cvg"),
                        full.names = TRUE))
  # pull in files - Average radiance 
  r2 <- sort(list.files(path = paste0(baseDir, "/data/correct2020imagery/conus_city_lights/masked_avg_radiance"),
                   full.names = TRUE)) 
  
  # point to output folder
  loc <- paste0(baseDir,"/data/correct2020imagery/")
  
  for(i in seq_along(locations$name)){
    # select county of interest 
    l1 <-   cnt[cnt$STATEFP == locations$stateFips[i], ]
    l2 <- l1[l1$NAME == locations$name[i],]
    
    ## loop over months 
    for(j in seq_along(months1$name)){
      print(months1$name[j])
      # create month directory 
      
      ### counts 
      # clip and mask 
      r3 <- raster::raster(r1[j]) %>%
        raster::crop(l2)%>%
        raster::mask(l2)
      # write out the feature to a specific file location 
      raster::writeRaster(x = r3, 
                            filename = paste0(baseDir, "/data/correct2020imagery/",months1$name[j],"/",locations$name[i],"_counts.tif"),
                            overwrite = TRUE)
      ### radience 
      # clip and mask 
      r4 <- raster::raster(r2[j]) %>%
        raster::crop(l2)%>%
        raster::mask(l2)
      # write out the feature to a specific file location 
      raster::writeRaster(x = r4, 
                          filename = paste0(baseDir, "/data/correct2020imagery/",months1$name[j],"/",locations$name[i],".tif"),
                          overwrite = TRUE)
    }
  }
}
