###
# Defines parameters for the county summary datasets 
# carverd@colostate.edu
# 20201113 
###

library(raster)
library(dplyr)
library(sf)
library(tmap)
# define base directory 
baseDir <- "F:/nrelD/geoSpatialCentroid/covidNightLights/"

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



# base data 
nlcd <- raster::raster("D:/generalSpatialData/CONUS/NLCD_2016_Land_Cover_L48_20190424/NLCD_2016_Land_Cover_L48_20190424.img")
cnt <- sf::read_sf("F:/nrelD/genericSpatialData/US/counties/tl_2017_us_county.shp")
stateFIP <- c(37, rep(48,9))
countyName <- c("Robeson", "Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston",
                "Harris", "Liberty", "Montgomery", "Waller")
listOfCnt <- data.frame(matrix(data = c(stateFIP, countyName) , ncol = 2) )
colnames(listOfCnt) <- c("FIP", "name")
# pull all images for a specific year
images <- pullfiles(paste0(baseDir,"data/"), year = 2018)
# october 2018 is our example data 
month <- "october2018"
im <- raster::raster(images[11]) 
# read in global population data 
popdata <- raster::raster("F:/nrelD/genericSpatialData/world/globalHumanSettlement/GHS_POP_E2015_GLOBE_R2019A_54009_250_V1_0/GHS_POP_E2015_GLOBE_R2019A_54009_250_V1_0.tif")

for(i in seq_along(listOfCnt$name)){
  cName <- as.character(listOfCnt$name[i])
  # select correct county 
  county <<-  cnt %>%
    dplyr::filter(STATEFP == listOfCnt$FIP[i])%>%
    dplyr::filter(NAME == cName)
  # mask and crop night lights image for county 
  rad <<- im %>%
    raster::crop(county) %>%
    raster::mask(county)
  # reproject copy of county feature 
  county2 <- sf::st_transform(x = county, crs = nlcd@crs)

  # mask and crop nlcd for county 
  lc <- nlcd %>%
    raster::crop(county2) %>%
    raster::mask(county2)
  # reproject nlcd layer 
  lc2 <- raster::projectRaster(from = lc, crs = rad@crs, method = "ngb")
  m <- c(10,12, 1, 20,24, 2,  30, 31, 3, 40,43,4,  50,52, 5, 70,74, 6, 
         80,82, 7,  89,95,8 )
  lc2 <<- raster::reclassify(x = lc2, rcl = m )
  # mask and crop global population data 
  county2 <- sf::st_transform(x = county, crs = popdata@crs)
  pop1 <- popdata %>%
    raster::crop(county2) %>%
    raster::mask(county2)
  pop2 <<- raster::projectRaster(from = pop1, crs = rad@crs, method = "bilinear")
  
  ### from here we should be able to run the summary html 

   try(rmarkdown::render(paste0(baseDir, "/src/countySummaries/generateCountySummary.Rmd"),  # file 2
                            output_file =  paste("SummaryReport_", cName,"_", month, ".html", sep=''), 
                           output_dir = paste0(baseDir,"/data/monthlySummaries")))
}
