###
# download daily data values for housten area and assing county values to each point 
# 20201008
# carverd@colostat.edu 
###

library(dplyr)
library(sf)
library(tmap)
library(XML)
library(raster)
tmap_mode("view")

### 
# Still a work in progress.... 
### 

### create a visualizatoin of the extent of the daily images over houston 
# read in county data and filter to areas of interest
c1 <- sf::st_read("D:/nrelD/genericSpatialData/US/county/cb_2018_us_county_5m/cb_2018_us_county_5m.shp")
c2 <-  c1 %>%
  dplyr::filter(STATEFP== 48)
c3 <- c2 %>%
  dplyr::filter(NAME %in% c("Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston", "Harris", "Liberty", "Montgomery", "Waller"))

# crs of school of mines data
lCRS <-  crs("+proj=longlat +datum=WGS84 +no_defs")
# convert the counties data to datum of school of mines data
c3 <- st_transform(c3, lCRS)

# Read in summary csv to determine if any points are outside the spatial extent.
h1 <- read.csv("D:/nrelD/geoSpatialCentroid/covidNightLights/data/filePaths/usa_houston.licorr.stats.csv")
# SF appears the drop the lat long columns that are used to assing lat long. So I reassigned 
h1$lat <- h1$pt_lat
h1$long <- h1$pt_lon
h2 <- sf::st_as_sf(h1, coords = c("long", "lat"), crs = lCRS)

# crop the counties layers to the extent of the point objects 
c4 <- sf::st_crop(c3, y = extent(h2))
# generate a quick map with the layer overlayed 
tm_shape(c3) + 
  tm_polygons(col = "grey")+ tm_text(text = "NAME")+
  tm_shape(c4) +
  tm_polygons(col = "green", alpha = 0.2)

# determine the areas of the counties outside of and inside the extent object
tArea <- st_area(c3[-2,])
eArea <- st_area(c4)
# save that material as a dataframe
d2 <- data.frame(matrix(nrow = 8, ncol = 4))
colnames(d2) <- c("county", "total area","total area cover by daily images",
                  "percent of county")
d2$county <- c4$NAME
d2$`total area` <- tArea
d2$`total area cover by daily images` <- eArea 
d2$`percent of county` <- (d2$`total area cover by daily images`/d2$`total area`)*100
 
# I just save the image of the table to share 

