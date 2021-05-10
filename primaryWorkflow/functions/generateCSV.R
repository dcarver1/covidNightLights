###
# Generate the spreadsheet with data from the county 
# 20210222
# carverd@colostate.edu 
###

createCSV <- function(rads,months1 ){
  # read in a temp feature 
  t1 <- raster::raster(rads[1])
  
  # built the dataframe. 
  df <- data.frame(matrix(ncol = length(months1$name), nrow = t1@ncols * t1@nrows))
  names(df) <- c(months1$name)
  
  # assign values to each column of the dataframe 
  for(j in names(df)){
    # select the raster from the correct month 
    r1 <- rads[grepl(pattern = j, x = rads)]
    r1 <- raster::raster(r1)
    df[,j] <- raster::getValues(r1) 
  }
  # generate a index for the rows and columns 
  df$row <- rep(x = 1:t1@nrows, each = t1@ncols)
  df$col <- rep(1:t1@ncols, t1@nrows)
  # drop all na values 
  df<- df[!is.na(df$jan), ]
  # write the output 
  write.csv(x = df, file = paste0(baseDir,"/data/correct2020imagery/compiledMonthlyValues/",county,"_noNAs.csv" ),
            row.names = FALSE)
}
