###
# Select index values for a given city
# 20210503
# carverd@colostate.edu 
###
library(raster)
library(dplyr)
upperLeft <- c(36.12615543669652, -115.18000460553624)
bottomRight <- c(36.101609759809065, -115.16421175924945)
city <- "lasVegas"
pathToFolder <- "D:/geoSpatialCentroid/covidNightLights/data/dailyData"


getIndexValues <- function(upperLeft, bottomRight, city,pathToFolder){
  ## upperLeft = vector with the lat, long of upper left corner
  ## bottomRight = vector with the lat long of lower left corner
  ## city = "lasVegas
  ## pathToFolder = "D:/geoSpatialCentroid/covidNightLights/data/dailyData"
  #read in index dataset
  files <- list.files(paste0(pathToFolder,"/",city),
                      full.names = TRUE,
                      pattern = ".csv")
  d1 <- read.csv(files[grepl(pattern = "licorr.stats", x = files)]) # making assumation here about the csv in the datafolder
  d1 <- d1[,2:4]
  #filter on lat
  d2 <- d1 %>%
    filter(pt_lat <= upperLeft[1] & pt_lat >= bottomRight[1])
  #filter on long 
  d3 <- d2 %>%
    filter(pt_lon >= upperLeft[2] & pt_lon <= bottomRight[2])
  # return all index values 
  return(unique(d3$ptid))
}


upperLeft <- list(c(36.12615543669652, -115.18000460553624),
               c(33.46588882768351, -112.08255584469504))
bottomRight <- list(c(36.101609759809065, -115.16421175924945),
                c(33.43682251860561, -112.06519808703612))
pathToFolder <- c("D:/geoSpatialCentroid/covidNightLights/data/lasVegas",
                  "D:/geoSpatialCentroid/covidNightLights/data/Phoenix")
city <- c("lasVegas", "ph")
data <- list()
for(i in seq_along(pathToFolder)){
  d1 <- getIndexValues(upperLeft = upperLeft[[i]],
                         bottomRight = bottomRight[[i]],
                         pathToFolder = pathToFolder[i], 
                       city = city[i])
  data[[i]]<- d1 
}

