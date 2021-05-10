###
# develop spatial data reference datasets for covid night lights datasets
# carverd@colostate.edu
# 20210421
### 
library(tidycensus)
library(raster)
library(sp)
library(sf)
# reference material 
## census tracts data
## list of counties the data is from 
## list of states the data is from 


# convert a raster for a location to points
r1 <- raster::raster("F:/geoSpatialCentroid/covidNightLights/data/correct2020imagery/april/Clark.tif")
# filter points to 
p1 <-as.data.frame(raster::rasterToPoints(r1))
p2 <- p1[p1$Clark != 0 , ]
sp1 <- sp::SpatialPointsDataFrame(coords = p2[,1:2], data = p2)

## block group -- probably only need this can tract can be derived. 
population <- get_acs(geography = "block group",
                      variables = "B01003_001",
                      state = "Nevada",
                      county = "Clark",
                      geometry = TRUE)
## reproject census data

## tract 
pTract <- get_acs(geography = "tract",
                  variables = "B01003_001",
                  state = "Nevada",
                  county = "Clark",
                  geometry = TRUE)
## test intersectiong between points and block groups 
sp2 <- raster::intersect(sp1, population, keep = TRUE)
