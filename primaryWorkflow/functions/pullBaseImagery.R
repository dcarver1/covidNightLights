###
# function for pulling specific files 
# 20210222
# carverd@colostate.edu 
### 

# function for pulling specific files 
pullfiles <- function(baseDir, year){
  # pull all image for north america for a specific year 
  files <- list.files(paste0(baseDir, year),
                      full.names = TRUE, recursive = TRUE)
  # filter by type of  image 
  f2 <- files[grep(pattern = "avg_rade", x = files)]
  # filter files for continents and type of 
  na <- f2[grep(pattern = "75N180W", f2)]
  return(na)
}

pullCorrectedFiles <- function(baseDir){
  counts <- list.files(paste0(baseDir, "/data/correct2020imagery/conus_city_lights/cf_cvg"),
                      full.names = TRUE, recursive = TRUE)
  rads <- list.files(paste0(baseDir, "/data/correct2020imagery/conus_city_lights/masked_avg_radiance"),
                     full.names = TRUE, recursive = TRUE)
  df <- data.frame(counts, rads , stringsAsFactors = FALSE)
  return(df)
}
