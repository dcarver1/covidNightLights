20201015

Just keeping some basic method notes about how all the content comes together.


# Monthly Average Images
## downloadImages.R
Provide a list of urls for files to be downloaded.
Information is pulled and extracted to a file location

## prepFilesForLocations.R
For each monthly average image all files are crop to 10 locations and resulting images are saved.

## countryAveToSpreadSheet.R
For each location all montly images are select and values are saved as columns within a specific dataframe
output is a csv where each column is a month and all rows are specific location.


# daily values
## downloadDailyValues.R
pulls specific CSV which contain the daily radiance values for a specific location 
