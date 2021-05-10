###
# render markdown summary for specific counties
# carverd@colostate.edu 
# 20210426 
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

locations <- c("San Diego", "Brazoria", "Chambers", "Fort Bend", "Galveston",
               "Harris", "Liberty", "Montgomery", "Waller", "Robeson")


months1 <<- c("janurary", "feburary", "march", "april", "may", "june", "july", 
            "august", "september", "october")
for(i in locations){
  county <<- i
  
  rads <<- list.files(path="F:/geoSpatialCentroid/covidNightLights/data/correct2020imagery", 
                     pattern = paste0(i,".tif"),full.names = TRUE, recursive = TRUE)
  counts <<- list.files(path="F:/geoSpatialCentroid/covidNightLights/data/correct2020imagery", 
                       pattern = paste0(i,"_obs.tif"),full.names = TRUE, recursive = TRUE)
  rmarkdown::render(input =  "F:/geoSpatialCentroid/covidNightLights/src/countySummaries/correctedDataCountsSummary.Rmd",
                    output_file = paste0("F:/geoSpatialCentroid/covidNightLights/data/correct2020imagery/compiledMonthlyValues/", county,"_summary"))
  }

```