###
# functions for night light project. 
# carverd@colostate.edu
# 20210419
###


### run correlation between econ data and monthy averages 
### need to replace here with baseDir, add base direct to input variables 
generateCorMonth <- function(city, startMonth, endMonth, outputLoc, area){
  # Tucson (33), Phoenix (5) and Las Vegas(8)
  # select Tucson 
  # city <- c(8, 5)
  # startMonth <- 2
  # endMonth <- 4
  # dependentVar <- "emp_combined"
  # outputLoc <- "data/economicData"
  # area <-c("lasVegas","pheniox")  
  # # read in monthly data ---
  # n1 <- readr::read_csv(here("data","correct2020imagery","compiledMonthlyValues","Pima_noNAs.csv"))
  # n1$corValuePearson <- NA
  # n1$corValueSpearman <- NA
  
  # read in a template raster
  r1 <- raster::raster(here("data","correct2020imagery","janurary","Pima.tif"))
  r2 <- r1 
  d2 <- d1[d1$cityid == city,]
  d2$date <- as.Date(x = paste0(d2$year,"-",d2$month,"-",d2$day), format = "%Y-%m-%d")
  # filter to specific data range of interest
  d2 <- d2%>%
    dplyr::filter(year == 2020, month >= startMonth, month <= endMonth)
  #convert column of interest to Numeric
  d2$dv <- as.numeric(d2[,dependentVar][[1]])
  # ggplot(d2, aes(date, dv)) +
  #   geom_point() +
  #   stat_smooth()
  d3 <- d2 %>%
    dplyr::group_by(month)%>%
    dplyr::summarise(average = mean(dv, na.rm= TRUE))
  # iterate over each row and generate a correlation measure 
  for(i in seq_along(n1$janurary)){
    row <- n1$row[i]
    col <- n1$col[i]
    if(is.na(n1[i,])){
      r1[row,col] <- n1$corValuePearson[i]
      r2[row,col] <- n1$corValueSpearman[i]
    }
    t1 <- t(n1[i,c(startMonth : endMonth)])
    n1$corValuePearson[i] <- cor(t1, d3$average, method = "pearson")
    n1$corValueSpearman[i] <- cor(t1, d3$average, method = "spearman")
    row <- n1$row[i]
    col <- n1$col[i]
    print(i)
  }
  write.csv(n1, file =here(outputLoc,"monthlyDatawithCorrelations.csv"))
  raster::writeRaster(x = r1, filename = here(outputLoc, paste0(area,"person",startMonth,"_",endMonth,".tif")))
  raster::writeRaster(x = r2, filename = here(outputLoc, paste0(area,"spearmen",startMonth,"_",endMonth,".tif")))
}

### run correlations between econ data and daily averages 
generateCorDays <- function(cityIndex, location,csvPattern, econData,dependentVar, filename, baseDir ){
  ## function for daily data 
  # Tucson (33), Phoenix (5) and Las Vegas(8)
  # cityIndexs <- c(33,5,8)
  # locations <- c("Tucson", "Phoenix", "lasVegas")
  # csvPattern <- c("dailyDataSummary.csv", "sevenDay")
  # econData <- readr::read_csv(paste0(baseDir, "/data/economicData/Employment - City - Daily.csv"))
  # dependentVar <- "emp_combined" 
  # filename <- c("dailyCor_rawDaily","dailyCor_sevenDayAve")
  # baseDir <- "F:/geoSpatialCentroid/covidNightLights"
  
  files <- list.files(paste0("F:/geoSpatialCentroid/covidNightLights/data/",location,"/"), 
                      pattern = csvPattern,
                      full.names = TRUE)
  n1 <- read.csv(files)
  # filter econ data
  d2 <- econData[econData$cityid == cityIndex,]
  # convert to date4
  d2$date <- as.Date(x = paste0(d2$year,"-",d2$month,"-",d2$day), format = "%Y-%m-%d")
  #convert column of interest to Numeric
  d2$dv <- as.numeric(d2[,dependentVar][[1]])
  
  ## filter daily to range of economic indicators 
  # reformat dates to match columns in daily data
  start <- paste0("X",str_replace_all(min(d2$date), "-", ".")) 
  end <- paste0("X", str_replace_all(max(d2$date), "-", "."))
  # sIndex <- grep(pattern = start, x = names(n1))
  # eIndex <- grep(pattern = end, x = names(n1))
  ### this indexing is tricky because we are unsure of the data ranges match up. 
  ### I would need to do check between the datasets converting daily data column headers to different values... ugh 
  # for no just stick to 2020 
  sIndex <- grep(pattern = start, x = names(n1))
  eIndex <- grep(pattern = "X2020.12.31", x = names(n1))
  
  # pull uid, lat, long, and dates of interest 
  n2 <- n1%>%
    dplyr::select(UID,lat,lon,sIndex:eIndex)
  n2$corValuePearson <- NA
  n2$corValueSpearman <- NA
  
  
  econVals <- as.numeric(d2$dv)[1:(ncol(n2)-5)]
  for(i in seq_along(n2$X2020.01.14)){
    print(i)
    vals <- as.numeric(n2[i,4:(ncol(n2)-2)])
    n2$corValuePearson[i] <- cor(x = vals, y = econVals,method ="pearson",  use = "complete.obs")
    n2$corValueSpearman[i]<- cor(x = vals, y = econVals,method ="spearman",  use = "complete.obs")
  }
  write.csv(n2, file =paste0(baseDir,"/data/",location,"/econCorrelations/",filename,".csv"))
}
  