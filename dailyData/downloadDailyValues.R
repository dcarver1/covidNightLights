###
# download daily data values for housten area and assing county values to each point 
# 20201008
# carverd@colostat.edu 
###

library(dplyr)
library(XML)



### process for downloading all the files 
downloadFiles <- function(path1, location){
  # set location of the base directoy 
  url <- paste0('https://eogdata.mines.edu/wwwdata/hidden/dnb_profiles_deliver_licorr/',path1,'/csv/')
  # pull specific data from the page 
  filenames = RCurl::getURL(url, ssl.verifypeer = FALSE, verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = FALSE )
  
  # pull all the links present on the page 
  files <- getHTMLLinks(filenames)
  # write out the name of all the file links 
  write.csv(files, paste0("F:/geoSpatialCentroid/covidNightLights/data/filePaths/",location,"CSVS.csv"))
  
  # read in data 
  fileNames <- read.csv(paste0("F:/geoSpatialCentroid/covidNightLights/data/filePaths/",location,"CSVS.csv"))
  # select specific files 
  f1 <- fileNames[grep(pattern = "licorr.csv", x = fileNames$x),]
  
  baseDir <- paste0("F:/geoSpatialCentroid/covidNightLights/data/dailyData/",location,"/")

  for(i in 1:nrow(f1)){
    print(i)
    u1 <- paste0(url, as.character(f1$x[i]))
    dest <- paste0(baseDir, as.character(f1$x[i]) )
    download.file(url = u1, destfile = dest,quiet = TRUE)
    if(i%%100 == 0){
      print("sleep")
      Sys.sleep(2)
    }
  }
}

paths <- c("usa_phoenix", "usa_tucson")

locations <- c("phoenix", "tucson")

for(i in seq_along(paths)){
  downloadFiles(path1 = paths[i], location = locations[i])
}
