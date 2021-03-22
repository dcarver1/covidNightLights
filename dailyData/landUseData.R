###
# connect land use land cover data to observation
# carverd@colostate.edu
# 20210125 
###

library(dplyr)
library(sf)
library(tmap)
tmap::tmap_mode("view")

baseDir <- "F:/geoSpatialCentroid/covidNightLights"

# load in datasets 
rg <- sf::st_read(paste0(baseDir, "/data/houstonDaily/referenceGird/usa_houston.licorr.stats.csv"), 
                  options=c("X_POSSIBLE_NAMES=pt_lon","Y_POSSIBLE_NAMES=pt_lat"))
# qtm(rg[1:1000,])

### three layers, TAZ is traffic zone , census block and hexagons 
d1 <- sf::st_read(paste0(baseDir, "/data/h-gacData/RGF_GIS_Data.gdb/RGF_GIS_Data.gdb"))
# View(d1[1:1000, ])
### probably one layer... 
sp1 <- sf::st_read(paste0(baseDir, "/data/h-gacData/Land_Use_GIS_Data.gdb/Land_Use_GIS_Data.gdb"))
#View(sp1[1:1000,])


# define CRS for rg and reproject to match data from houston 
rg1 <- sf::st_set_crs(x = rg, 
                 value ='+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
# qtm(rg1[1:1000,])
rg2 <- sf::st_transform(x = rg1,crs = st_crs(d1))

# Simplfy the data associate with the point features 
rg2 <- rg2[,c(2:4)]


### TAZ Traffice zone, smaller then census block 
# perform and intersect between land use and points 
st <- sf::st_intersection(x = rg2, y= d1)
#View(st)
# select features of interest
st1 <- st[,c(1:3,5)]
# write out the data 
write.csv(x = st1, file = paste0(baseDir,"/data/houstonDaily/landUseH-GAC/connectionForIds.csv" ))
# write out housing data 
write.csv(x = d1, file = paste0(baseDir,"/data/houstonDaily/landUseH-GAC/housingData.csv" ))


### Land use data 
# convert to dataframe and drop geom feature
df2 <- as.data.frame(sp1)
df2 <- df2[,c(1:18)]
write.csv(x = df2, file = paste0(baseDir,"/data/houstonDaily/landUseH-GAC/landUseDataFromDF.csv"))

# join on smaller feature 
sp2 <- sp1[,1]
sp2$geomType <- st_geometry_type(st_geometry(sp2))

# this was really slow 
t1 <- sp2 %>%
  dplyr::group_by(geomType) %>%
  dplyr::summarise(count = n())
# selecting only multiple 
t2 <- sp2[sp2$geomType == "MULTIPOLYGON",]


## write out as shp to help with project error
sf::st_write(obj = sp2, 
             "F:/geoSpatialCentroid/covidNightLights/data/h-gacData/Land_Use_GIS_Data.gdb/shp/landUse.shp" )
## read in the feature
s1 <- st_read("F:/geoSpatialCentroid/covidNightLights/data/h-gacData/Land_Use_GIS_Data.gdb/shp/landUse.shp")
# check the feature types 
unique(st_geometry_type(st_geometry(sp2)))
# if they are not all multipolygons try 
xx = st_cast(sp2,  "MULTIPOLYGON")

### attempt join 
st2 <- sf::st_intersection(x = rg2, y = t2)
st3 <- as.data.frame(st2)
st3 <- st3[,-c()]

### these are not working... 
# try using a for loop over the lat long data to determine where the issue is occurring. Could manually
# define if needed. 


### need to identify geomentrt types and drop all features that are not polygons

