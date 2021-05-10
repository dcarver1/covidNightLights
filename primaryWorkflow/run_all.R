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

baseDir<<- "F:/geoSpatialCentroid/covidNightLights"
cnt <<- sf::read_sf("F:/genericSpatialData/US/counties/tl_2017_us_county.shp")

#source functions
### monthly data functions
source(paste0(baseDir, "/src/primaryWorkflow/functions/pullBaseImagery.R"))
source(paste0(baseDir, "/src/primaryWorkflow/functions/processImagesToCounty.R"))
source(paste0(baseDir, "/src/primaryWorkflow/functions/defineLocations.R"))
source(paste0(baseDir, "/src/primaryWorkflow/functions/generateCSV.R"))
### daily data functions
source(paste0(baseDir, "/src/primaryWorkflow/functions/downloadDailyValues.R"))
source(paste0(baseDir, "/src/primaryWorkflow/functions/"))
source(paste0(baseDir, "/src/primaryWorkflow/functions/subsetDailyData.R"))

# define locations
## vector of character names
counties <- c("San Diego")
## vector of state fips as characters
states <- c("06")

features <- defineLocations(counties, states)
locations<<- features[[1]]
months1 <<- features[[2]]

## processed at the county level
for(i in seq_along(locations$name)){
  print(i)
  ####################
  ### monthly datasets
  ####################
  # create radiance and counts images
  county <<- locations$name[i]
  t1 <- list.files(path= paste0(baseDir, "/data/correct2020imagery"),
                      # pattern = paste0(county,".tif"),
                   full.names = TRUE, recursive = TRUE)
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

  rmarkdown::render(input =  paste0(baseDir, "/src/primaryWorkflow/summaryRMD/correctedDataCountsSummary.Rmd"),
                    output_file = paste0(baseDir, "/data/correct2020imagery/compiledMonthlyValues/",
                                         county,"_summary"))



  ### develop county spread sheet for the monthly data
  t2 <- list.files(path= paste0(baseDir, "/data/correct2020imagery"),
                   pattern = paste0(county,"_noNAs.csv"),full.names = TRUE,
                   recursive = TRUE)

  if(length(t2)==0){createCSV(rads = rads, months1 = months1)}
  ##################
  ### daily Datasets
  ##################
  # name of the file folder from which you want to download daily datasets
  # choose from options here https://eogdata.mines.edu/wwwdata/hidden/dnb_profiles_deliver_licorr/
  paths <-"usa_sandiego"
  # name of the file floder on the local pc where downloaded files are saved.
  locations <- "sanDiego"
  ## download daily datasets
  ### this can be itorated over but I don't recommend it. Locations can have up to
  ### 40,000 individual CSV files so the process takes a while to run.
  downloadFiles(path1 = paths, location = locations)
  ## compile daily datasets
  input <- paste0(baseDir, "/data/dailyData/",locations,"/",paths,".licorr.stats.csv")
  pathToFiles <- paste0(baseDir, "/data/dailyData/",locations)
  output <- paste0(baseDir, "/data/",locations)
  compileDailyData(countySHP = cnt,
    state = states[1],
    county = counties[1],
    refFile = input,
    pathToFiles = pathToFiles,
    output = output
  )
  ## generate a rolling average of the daily data
  # define the number of days the average should run over
  dayAverages < -7
  rollingAverages(fileLocation = output, dayAverages = dayAverages)
  ## grab area of interest
  upperLeft <- c()
  bottomRight <- c()

  getIndexValues(upperLeft = upperLeft, bottomRight = bottomRight,
     city = locations, pathToFolder = pathToFiles)
  ## subset daily data in to

}
