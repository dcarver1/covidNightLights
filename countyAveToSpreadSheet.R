###
# generate dataset for all monthly averages
# 20201012 
# carverd@colostate.edu
### 

### function for generating monthly data summaries 
monthlyVals <- function(baseDir, nrows, ncols, totalValues, county){
  df <- data.frame(matrix(nrow = totalValues, ncol = 96))
  
  # create empty dataframe 
  # clause for 2012 and 2020 due to incomplete months 
  m <- c("april", "may", "june", "july", "august","september", "october","november", "december",
         rep(x = c("janurary", "feburary", "march", "april", "may", "june", "july", "august", "september","october",
                   "november", "december"), 7), 
         "janurary", "feburary", "march")
  
  n1 <- c(rep("_2012", 9),rep("_2013", 12), rep("_2014", 12),rep("_2015", 12),rep("_2016", 12),
          rep("_2017", 12),rep("_2018", 12),rep("_2019", 12),rep("_2020", 3))
  n2 <- paste0(m, n1)
  names(df) <- n2
  df$rowNumber <- rep(1:nrows, each = ncols)
  df$colNumber <- rep(1:ncols,nrows)
  
  # for each year 
  for( y in 2012:2020){
    # read in images
    files <- list.files(paste0(baseDir,as.character(y)), 
                        pattern = county, recursive = TRUE, full.names = TRUE)
    if(y == 2012){
      print(y)
      files <- files[c(1, 6, 5, 4, 2, 9, 8, 7, 3)]
      rs <- raster::stack(x = files)
      n <- 1 
      for(i in grep(as.character(y), names(df))){
        df[,i] <- raster::getValues(rs[[n]])
        n = n+1
      }
    }
    if(y == 2020){
      print(y)
      files <- files[c(2,1,3)]
      rs <- raster::stack(x = files)
      n <- 1 
      for(i in grep(as.character(y), names(df))){
        df[,i] <- raster::getValues(rs[[n]])
        n = n+1
      }
    }
    if(y %in% 2013:2019){
      print(y)
      # need to order the files or apply names -- this should be consitent across all
      # file locations, but it's worth double checking
      files <- files[c(5, 4, 8, 1, 9, 7, 6, 2, 12, 11, 10, 3)]
      rs <- raster::stack(x = files)
      n <- 1 
      for(i in grep(as.character(y), names(df))){
        df[,i] <- raster::getValues(rs[[n]])
        n = n+1
      }
    }
  }
  df2 <- df[complete.cases(df), ]
  write.csv(x = df2, file = paste0(paste0(baseDir, "monthlySummaries/", county, ".csv")))
}

# county of interest 
baseDir <- "D:/nrelD/geoSpatialCentroid/covidNightLights/data/"

# pull specific county names 
names <- images <- list.files(path = "D:/nrelD/geoSpatialCentroid/covidNightLights/data/2012/april")
names <- names[c(1:9,12)]
names <- sub('\\.tif$', '', names)
# pull full paths to all images 
images <- list.files(path = "D:/nrelD/geoSpatialCentroid/covidNightLights/data/2012/april", full.names = TRUE)
  

# generate a summary for all locations of interest 
for(i in names){
  print(i)
  im <- raster::raster(images[grep(pattern = i, x = images)])
  monthlyVals(baseDir, nrows = im@nrows, ncols = im@ncols, totalValues = im@ncols * im@nrows,
              county = i)
}
  