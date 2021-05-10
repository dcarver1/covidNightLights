###
# Prep new monthly averages using the corrected 2020 imagery 
# 20210129
# carverd@colostate.edu 
###
library(sf)
library(raster)
library(dplyr)
library(tmap)
tmap_mode("plot")
baseDir <- "F:/geoSpatialCentroid/covidNightLights"

source(paste0(baseDir, "/src/primaryWorkflow/defineLocations.R"))

# define locations
## vector of character names 
counties <- c("San Diego")
## vector of state fips as characters 
states <- c("06")

features <- defineLocations(counties, states)
locations<- features[[1]]  
months1 <- features[[2]]

# read in county data 
cnt <- sf::read_sf("F:/genericSpatialData/US/counties/tl_2017_us_county.shp")

generateCountyImagery(locations = locations,
                      months1 = months1,
                      cnt = cnt ,
                      baseDir = baseDir)

generateCountyImagery <- function(locations, months1,cnt, baseDir){
  #reproject to wgs1984 
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
# r1 <- sort(list.files(path = "F: /geoSpatialCentroid/covidNightLights/data/correct2020imagery/conus_city_lights/masked_avg_radiance",
#                  full.names = TRUE)) 

# create folders 
loc <- "F: /geoSpatialCentroid/covidNightLights/data/correct2020imagery/"
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


