###
# generate single document of all daily measure of night light radience 
# 20201211 
# carverd@colostate.edu 
###
library(dplyr)
library(sf)
library(sp)
library(tmap)
library(raster)
# read in county data 
con <- sf::st_read("F:/nrelD/genericSpatialData/US/counties/tl_2017_us_county.shp") %>%
  sf::st_transform(crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

cOfIn <- c("Harris", "Fort Bend", "Galveston")
# exclude harris as it already exists 
cOfIn <- cOfIn[3:3]
for(i in cOfIn){
  cName <- i
  # filter county to county of interest 
  county <- con %>%
    dplyr::filter(STATEFP == 48 & NAME == as.character(cName))
  
  ## determine locations that are present within county county 
  # this is the average for all locations, us it to determine locations within the county 
  d2 <- read.csv("F:/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/referenceGird/usa_houston.licorr.stats(1).csv")
  
  # convert to a spatial object. 
  coords <- d2[,c("pt_lon", "pt_lat")]
  sp1 <- sp::SpatialPointsDataFrame(coords = coords, data = d2)
  sp1@proj4string <- crs("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
  sp2 <- st_as_sf(sp1)
  sp2$incounty <-  as.integer(st_intersects(sp2, county))
  
  ## points of interest 
  t3 <- sp2 %>%
    dplyr::filter(!is.na(incounty))
  ids <- unique(t3$ptid)
  
  # select values of interest, build dataframe using dates, bind_rows to dataframe with all possible dates. 
  dates <- seq(as.Date("2012/04/01"), to = as.Date("2020/12/31"), by = "day")
  # create empty dataframe 
  df <- data.frame(matrix(nrow = 0, ncol = 3200))
  colnames(df) <- c("UID", "lat","lon", as.character(dates))
  
  # list all files of interest 
  files <- list.files("F:/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily", full.names = TRUE)
  ### loop over ids and select locations of interest  
  for(i in ids){
    print(i)
    f2 <- files[grep(pattern = paste0("_",i,"."), x = files, fixed = TRUE)]
    #condition to test for logical(0) objects for when I define a point to be in the county but school of mines did not
    if(length(f2) > 0){
      dt <- read.csv(f2)
      dt1 <- dt %>%
        dplyr::select(ptid, pt_lat, pt_lon, rade9_dnb_licorr, midscan)
      dt1$date <- substr(x = dt1$midscan, start = 1, stop = 10)
      ### so there are multiple occasions there two obsevations occur on the same day. I'll need to account for this
      # in a meaningful way in the future but for now I'm just going to drop the second observation 
      dt2 <- dt1[!duplicated(x = dt1$date), ]
      #transpose the radiance data and construct a dataframe 
      t1 <- as.data.frame(t(dt2[,4]))
      # set column names to equal date of image capture 
      colnames(t1) <- dt2$date
      # add some index information 
      t1$UID <- dt2$ptid[1]
      t1$lat <- dt2$pt_lat[1]
      t1$lon <- dt2$pt_lon[1]
      # bind the data from a specific location to the list of potential dates 
      df <- dplyr::bind_rows(df, t1)
    }
  }
  #export full CSV
  write.csv(x = df, 
            file = paste0("F:/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/",cName, "CountyDailySummary.csv"))
  # export harvey
  write.csv(x = df[,c(1:3, 1891:2043)], 
            file = paste0("F:/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/",cName, "CountyDailySummary_Harvey.csv"))
  # export 2020
  write.csv(x = df[,c(1:3,2835:3200)], 
            file = paste0("F:/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/",cName, "CountyDailySummary_2020.csv"))
            
}


t1 <- read.csv("F:/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/harrisCountyDailySummary.csv")





