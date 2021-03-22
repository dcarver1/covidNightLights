###
# script to call functions for an image processing metholodolgy 
# carverd@colostate.edu
# 2021022
### 
#install.packages("psych")
library(raster)
library(dplyr)
library(sf)
library(tmap)
library(plotly)
library(psych)
library(DT)
tmap_mode("view")
# avoid scientific notation 
options(scipen=999)

baseDir<<- "D:/geoSpatialCentroid/covidNightLights"
cnt <<- sf::read_sf("D:/genericSpatialData/US/counties/tl_2017_us_county.shp")

#source functions 
source(paste0(baseDir, "/src/primaryWorkflow/pullBaseImagery.R"))
source(paste0(baseDir, "/src/primaryWorkflow/processImagesToCounty.R"))
source(paste0(baseDir, "/src/primaryWorkflow/defineLocations.R"))
source(paste0(baseDir, "/src/primaryWorkflow/generateCSV.R"))
# define locations 
features <- defineLocations()
locations<<- features[[1]]  
months1 <<- features[[2]]

## processed at the county level 
for(i in seq_along(locations$name)){
  print(i)
  ## monthly image processing 
  # create radiance and counts images 
  county <<- locations$name[i]
  t1 <- list.files(path= paste0(baseDir, "/data/correct2020imagery"), 
                      pattern = paste0(county,".tif"),full.names = TRUE, recursive = TRUE)
  # test for presence of image files 
   if(length(t1) < 10){
    prepImagery(STATEFP = locations$stateFips[i], name = locations$name[i])
  }
  
  ### pull imagery and run RMD

  rads <<- list.files(path= paste0(baseDir, "/data/correct2020imagery"), 
                      pattern = paste0(county,".tif"),
                      full.names = TRUE, recursive = TRUE)
  
  counts <<- list.files(path=paste0(baseDir, "/data/correct2020imagery"), 
                        pattern = paste0(county,"_counts.tif"),
                        full.names = TRUE, recursive = TRUE)
  
  rmarkdown::render(input =  paste0(baseDir, "/src/countySummaries/correctedDataCountsSummary.Rmd"),
                    output_file = paste0(baseDir, "/data/correct2020imagery/compiledMonthlyValues/",
                                         county,"_summary"))
  
  

  ### develop county spread sheet 
  t2 <- list.files(path= paste0(baseDir, "/data/correct2020imagery"), 
                   pattern = paste0(county,"_noNAs.csv"),full.names = TRUE,
                   recursive = TRUE)
  
  if(!file.exists(t2)){createCSV(rads = rads, months1 = months1)}
}
  