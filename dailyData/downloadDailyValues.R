###
# download daily data values for housten area and assing county values to each point 
# 20201008
# carverd@colostat.edu 
###

library(dplyr)
library(XML)

### process for downloading all the files 

# set location of the base directoy 
url <- 'https://eogdata.mines.edu/wwwdata/hidden/dnb_profiles_deliver_licorr/usa_houston/csv/'
# pull specific data from the page 
filenames = RCurl::getURL(url, ssl.verifypeer = FALSE, verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = FALSE )

# pull all the links present on the page 
files <- getHTMLLinks(filenames)
# write out the name of all the file links 
write.csv(files, "D:/nrelD/geoSpatialCentroid/covidNightLights/data/filePaths/houstenCSVS.csv")

# read in data 
fileNames <- read.csv("D:/nrelD/geoSpatialCentroid/covidNightLights/data/filePaths/houstenCSVS.csv")

View(fileNames[1:100,])
f1 <- fileNames[grep(pattern = "licorr.csv", x = fileNames$x),]
f1
dim(f1)
baseDir <- "D:/nrelD/geoSpatialCentroid/covidNightLights/data/houstonDaily/"
nrow(f1)


for(i in 29052:nrow(f1)){
  print(i)
  u1 <- paste0(url, as.character(f1$x[i]))
  dest <- paste0(baseDir, as.character(f1$x[i]) )
  download.file(url = u1, destfile = dest,quiet = TRUE)
  if(i%%100 == 0){
    print("sleep")
    Sys.sleep(2)
  }
}
