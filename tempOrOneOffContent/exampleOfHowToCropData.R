###
# example to load, clip, and write values for the night lights image 
# 
#
###

# install.packages("raster")
library(raster)
library(dplyr)

### Define the extent which you want to crop the image 
ext <- raster::extent(c(xmin, xmax, ymin, ymax)) # you will need to replace the
# text with lat long values 

# read in your images 
img <- raster::raster("path to raster")

# crop and mask the image 
r1 <- img %>%
  raster::crop(ext) %>%
  raster::mask(ext)

# write out the image file 
raster::writeRaster(r1, filename = "full path including file name and extentsion .tif")

# write out the values 
v1 <- raster::values(r1)
write.csv(v1) 

