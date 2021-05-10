###
# function for selecting daily data for a specific location and date range
# carverd@colostate.edu
# 20210324
###
library(sf)
subsetDailyData <- function(dailyData, locationSHP, startDate, endDate, output, map){
  # dailyData = full path to daily data summary document
  # locationSHP = full path to shape of aoi
  # startDate = character string of year-month-day format
  # endDate = character string of year-month-day format
  # output = path and name of output file as .csv
  # map = binary for map output


  #create spatial features for index and location
  ## read in shape
  sp1 <- sf::st_read(locationSHP)
  sp1 <- sp1[1,] ### this might cause in issue in some cases>>
  ## create a sf object from
  d1 <- read.csv(dailyData)
  d2 <- d1[,2:4]
  sp2 <- sf::st_as_sf(d2, coords = c("lon", "lat"))%>%
    sf::st_set_crs( value = sf::st_crs(sp1))

  # test relationship between features
  sp3 <- sf::st_intersection(sp1, sp2)
  ## pull all unique locations
  uid <- sp3$UID
  ### visualization of the relationship
  m1 <- tm_shape(sp1)+
    tm_polygons()+
    tm_shape(sp2)+
    tm_dots()

  # filter the summary data by position and data range
  ##sequence along date range
  t1 <- seq.Date(from = as.Date(startDate),to = as.Date(endDate), "day")
  ## change string to match columns
  t <- str_replace_all(t1,pattern = "-", replacement = "." )
  t <- paste0("X",t)

  ## select dates and areas base on uid
  d3 <- d1 %>%
    dplyr::filter(UID %in% uid)%>%
    dplyr::select(UID ,lat, ,lon,t)
  write.csv(d3, file = output )
  if(map == TRUE){
    return(m1)
  }
}



