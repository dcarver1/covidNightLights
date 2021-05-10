###
# Set input locations and time frame 
# 20210222
# carverd@colostate.edu
###

# locations of interest 
# c("Clark", "Pima", "Maricopa", "Pinal"
# c("32", "04","04", "04")

defineLocations <- function(counties, states){
  locations <- data.frame(
    counties,
    states, stringsAsFactors = FALSE ) 
  colnames(locations) <- c("name", "stateFips")
  
  months1 <- data.frame(
    c("janurary", "feburary", "march", "april", "may", "june", "july", 
      "august", "september", "october"),
    c("01","02","03","04","05","06","07","08","09","10"),
    stringsAsFactors = FALSE)
  colnames(months1) <- c("name", "number")
  return(list(locations, months1))
}

