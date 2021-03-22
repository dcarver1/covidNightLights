###
# Census poverty track for houton area 
# 20210226
# carverd@colostate.edu
### 

library(sf)
library(tidycensus)
library(dplyr)
library(raster)
library(tmap)
options(tigris_use_cache = TRUE)

# tidycensus::census_api_key("c0c9861c82c1359ad491851b6671422a28635c09", install = TRUE)

# pull counties for texas, get county fips 
cont <- sf::st_read("F:/genericSpatialData/US/counties/tl_2017_us_county.shp")
tex <- cont[cont$STATEFP == 48, ]
countyName <- c("Robeson", "Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston",
                "Harris", "Liberty", "Montgomery", "Waller")
tex <- tex[tex$NAME %in% countyName, ]
# use county fips to pull census tracks 
View(tex)

# select poverty level 
ct <- tidycensus::load_variables(year = 2015, dataset = "acs5")
write.csv(ct,file = "F:/geoSpatialCentroid/covidNightLights/data/houstonPoverty/censusVariables.csv")
# headers within the ACS data
areas <- get_acs(geography = "tract",
                 variables = "B01002_001",
                 state = "Texas",
                 county = c("Harris County"),
                 geometry = TRUE)
names(areas) <- c("GEOID","NAME","median_age", "est_medianAge","moe","geometry")
val2 <- get_acs(geography = "tract",
                variables = "B17001_002",
                state = "Texas",
                county = c("Harris County"))
names(val2) <- c("GEOID","NAME","income_poverty", "est_ totalInPoverty","moe_2")
feats <- dplyr::left_join(x = areas, y = val2[,c(1,3:5)], by = "GEOID")

qtm(feats)
# load images 
r07 <- raster::raster("F:/geoSpatialCentroid/covidNightLights/data/houstonPoverty/data/houston/diffs/dnb-daily_20210207_-95.400_29.700_2000x2000.tiff")
r16 <- raster::raster("F:/geoSpatialCentroid/covidNightLights/data/houstonPoverty/data/houston/diffs/dnb-daily_20210216_-95.400_29.700_2000x2000.tiff")
r19 <- raster::raster("F:/geoSpatialCentroid/covidNightLights/data/houstonPoverty/data/houston/diffs/dnb-daily_20210219_-95.400_29.700_2000x2000.tiff")
# difference images 
r07_16 <- r07-r16
r07_19  <- r07-r19


feats$aveRadience07<- NA
feats$aveRadience16<- NA
feats$aveRadience19<- NA

# loop over areas crop mask raster then calculate mean 
for(i in seq_along(feats$GEOID)){
  print(i)
  # R07
  r2 <- r07 %>%
    raster::crop(y = feats[i,])%>%
    raster::mask(mask = feats[i,])
  feats$aveRadience07[i] <- mean(raster::values(r2), na.rm = TRUE)
  # R16
  r2 <- r16 %>%
    raster::crop(y = feats[i,])%>%
    raster::mask(mask = feats[i,])
  feats$aveRadience16[i] <- mean(raster::values(r2), na.rm = TRUE)
  # R19
  r2 <- r19 %>%
    raster::crop(y = feats[i,])%>%
    raster::mask(mask = feats[i,])
  feats$aveRadience19[i] <- mean(raster::values(r2), na.rm = TRUE)
}
for(i in seq_along(feats$GEOID)){
  feats$diff_07_16[i] <- 100 * ( (feats$aveRadience16[i] - feats$aveRadience07[i])/feats$aveRadience07[i])
  feats$diff_07_19[i] <- 100 * (( feats$aveRadience19[i] - feats$aveRadience07[i])/feats$aveRadience07[i])
  
}

tmap_mode("view")
m1 <- tmap::tm_shape(feats) +
  tm_polygons(col = "estimate_2",popup.vars	= c("estimate_2",
                                                "aveRadience07"
                                                ,"aveRadience16",
                                                "aveRadience19",
                                                "diff_07_16",
                                                "diff_07_19") )
m2 <- tmap::tm_shape(feats)+
  tm_polygons(col = "diff_07_16",breaks = c(-100,0,100),
              palette = "Paired", 
              popup.vars	= c("estimate_2",
                             "aveRadience07"
                             ,"aveRadience16",
                             "aveRadience19",
                             "diff_07_16",
                             "diff_07_19"))
m3 <- tmap::tm_shape(feats)+
  tm_polygons(col = "diff_07_19",breaks = c(-100,0,100),
              palette = "Paired",
              popup.vars	= c("estimate_2",
                             "aveRadience07"
                             ,"aveRadience16",
                             "aveRadience19",
                             "diff_07_16",
                             "diff_07_19"))

tmap_arrange(m1, m2,m3, sync = TRUE)

View(feats)
dat <- as.data.frame(feats)
dat <- dat[,c(1:4,6,7,10:14)]
write.csv(dat,file="F:/geoSpatialCentroid/covidNightLights/data/houstonPoverty/censusTractData_lights_poverty.csv")
