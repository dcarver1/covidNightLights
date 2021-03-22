###
# create monthly images for a location 
# 20210222
# carverd@colostate.edu
###

prepImagery <- function(STATEFP, name){
  # county of interest 
  c1 <- cnt %>%
    dplyr::filter(NAME == name)
  c1 <- c1[c1$STATEFP == STATEFP, ] %>%
    sf::st_transform(crs = "+proj=longlat +datum=WGS84 +no_defs")
  
  ## working with corrected images 
  images <- pullCorrectedFiles(baseDir)
  
  # for every month write out images for each county 
  for(i in seq_along(months1$number)){
    # select image base on month in the file path 
    m <- paste0("_2020",months1$number[i],"01")
    ct <- images$counts[grepl(pattern = m, x = images$counts)]
    ra <- images$rads[grepl(pattern = m, x = images$rads)]
    if(length(ct) == 0){
      print("no images for this month")
      }else{
      # read in the file 
      rast <- c(raster::raster(x = ct), raster::raster(x = ra))
      # crop, mask, and write out image for each of th eten counties of interest. 
      n <- 1
      for( j in rast){
        print(j)
        r1 <- j %>%
          raster::crop(c1) %>%
          raster::mask(c1)
        #subset just pulls specific file base path
        if(n ==1 ){
          raster::writeRaster(x = r1, 
          filename = paste0(baseDir,"/data/correct2020imagery/",months1$name[i],
            "/",c1$NAME,"_counts.tif" ),
                              overwrite=TRUE)
          n= n+1
        }else{
          raster::writeRaster(x = r1, 
            filename = paste0(baseDir,"/data/correct2020imagery/",months1$name[i],
              "/",c1$NAME,".tif" ),
              overwrite=TRUE)
        }
      }
      }
  }
}

