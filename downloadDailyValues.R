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
tmap_mode("plot")

### 
# Still a work in progress.... 
### 


c1 <- sf::st_read("F:/nrelD/genericSpatialData/US/county/cb_2018_us_county_5m/cb_2018_us_county_5m.shp")
View(c1)
c2 <-  c1 %>%
  dplyr::filter(STATEFP== 48)
c3 <- c2 %>%
  dplyr::filter(NAME %in% c("Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston", "Harris", "Liberty", "Montgomery", "Waller"))
qtm(c3)
View(c3)

### Read in kml summary to determine if any points are outside the spatail extent.
lCRS <-  crs("+proj=longlat +datum=WGS84 +no_defs")
h1 <- read.csv("C:/Users/danie/Downloads/usa_houston.licorr.stats.csv")
h1$lat <- h1$pt_lat
h1$long <- h1$pt_lon
h2 <- sf::st_as_sf(h1, coords = c("pt_lon", "pt_lat"), crs = lCRS)
extent(c3)

h3 <- h2[pt_lat > 28.82]


# If I point to a directory with the files within in I can get a list of features 
### 
url <- 'https://eogdata.mines.edu/wwwdata/hidden/dnb_profiles_deliver_licorr/usa_houston/csv/'
filenames = RCurl::getURL(url, ssl.verifypeer = FALSE, verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = FALSE )

install.packages("XML")
library(XML)
files <- getHTMLLinks(filenames)
write.csv(files, "F:/nrelD/geoSpatialCentroid/covidNightLights/data/filePaths/houstenCSVS.csv")

