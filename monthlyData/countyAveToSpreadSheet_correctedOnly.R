###
# countyToSS_corrected 2020
# 20210129
# carverd@colostate.edu
###

baseDir <- "D:/geoSpatialCentroid/covidNightLights/data/correct2020imagery"

# select all images from 2020 for a specific county 
f1 <- list.files(path = baseDir,pattern = ".tif", full.names = TRUE,
                 recursive = TRUE)

# list of counties to iterate over 
locations <- c("Austin", "Brazoria", "Chambers", "Fort Bend", "Galveston",
               "Harris", "Liberty", "Montgomery", "Waller", "Robeson")

# select all images from a specific county
for(i in seq_along(locations)){
  f2 <- f1[grepl(pattern = locations[i], x = f1)]
  f3 <- f2[c(4,3,7,1,8,6,5,2,10,9)]
  t1 <- raster::raster(f3[1])
  # built the dataframe. 
  df <- data.frame(matrix(ncol = 12, nrow = t1@ncols * t1@nrows))
  names(df) <- c("jan", "feb", "mar", "arp","may", "jun", "jul", "aug","sep", "oct", "row", "col")
  df$row <- rep(x = 1:t1@nrows, t1@ncols)
  #### not sure how to pull this off at the moment. 
  df$col <- rep(1:t1@ncols, each = t1@nrows)
  for(j in seq_along(f3)){
    r1 <- raster::raster(f3[j])
    df[,j] <- raster::values(r1) 
  }
  df<- df[!is.na(df$jan), ]
  write.csv(x = df, file = paste0(baseDir,"/compiledMonthlyValues/",locations[i],"_noNAs.csv" ),
            row.names = FALSE)
}


