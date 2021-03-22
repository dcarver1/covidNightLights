###
# pull census data for the counties of interest and attached values to the 
# carverd@colostate.edu 
# 20210104
###
install.packages("tidycensus")
library(tidycensus)
library(tidyverse)
options(tigris_use_cache = TRUE)

census_api_key("YOUR API KEY GOES HERE")

#counties of interest
counties <- c("Harris", "Fort Bend", "Galveston")
t1 <- tidycensus::load_variables(year = 2015, dataset = "acs5")
View(t1)
# pull spatial data for counties if interest 
### actually do not need to loop over counties but can provice a list of features. 
areas <- get_acs(geography = "block group",
                 variables = c(medianAge = "B01002_001",totalPopulation = "B00001_001", number0fHouses = "B00002_001"),
              state = "Texas",
              county = c("Harris County", "Fort Bend County", "Galveston County"),
              geometry = TRUE)
write.csv(areas,file = "D:/temp/F/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/censusData/initialPull.csv")





# pull in the night light locational data 
d1 <- read.csv("D:/temp/F/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/referenceGird/usa_houston.licorr.stats(1).csv")

d2 <- sf::st_read("D:/temp/F/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/referenceGird/usa_houston.licorr.stats(1).csv",
                  , options=c("X_POSSIBLE_NAMES=pt_lon","Y_POSSIBLE_NAMES=pt_lat"))
d2 <- st_set_crs(x = d2, value ='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
#convert census data to wgs1984
a2 <- st_transform(x = areas, crs = st_crs(d2))

# extract the geoid for the all points 
d3 <- st_intersection(d2, a2)
#filter to get a list of unique point ids and geomid 
d4 <- d3 %>%
  dplyr::select(ptid, GEOID)%>%
  dplyr::distinct(.keep_all = TRUE)
write.csv(d4, "D:/temp/F/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/censusData/connectionForIDS.csv")
