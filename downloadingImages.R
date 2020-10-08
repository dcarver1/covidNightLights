###
# download monthly averages from the school of mines data repository for North America
# 20201008
# carverd@colostate.edu
###

# base directory 
baseDir <- "F:/nrelD/geoSpatialCentroid/covidNightLights/data"


### 
# This structure is pretty clunky. The end date on the file is associate with when the feature was up loaded. There was no way to predict this so I had
# to pull the full url from all file locations. 
# It's all very redudent but I don't expect to have to do this multiple times 

# files structure on the back end is 
# baseDir / year / month
# this needs to be created inorder for the paths here to work. 

downloadImages <- function(baseDir, year, month, url){
  # defines the location files will be saved too 
  dest <- paste0(baseDir, "/", year ,"/", month )
  # generate a temp file to store the downloaded object
  temp1 <- tempfile()
  # download the file and hold it in memory as a temp file 
  download.file(url = url, destfile = temp1)
  print("file downloaded")
  # unzip the .tgz file and save the output images
  untar(tarfile = temp1, exdir = dest)
  print("file extracted")
  # delete the temp1 file. 
  unlink(temp1)
}

## I had the 2020 data already downloaded but I wrote this in for completeness. 
f2020 <- c(
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//202003/vcmcfg/SVDNB_npp_20200301-20200331_75N180W_vcmcfg_v10_c202007042300.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//202002/vcmcfg/SVDNB_npp_20200201-20200229_75N180W_vcmcfg_v10_c202003021200.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//202001/vcmcfg/SVDNB_npp_20200101-20200131_75N180W_vcmcfg_v10_c202002111500.tgz"
)
names <- c("march", "feburary", "janurary")


for(i in 1:length(f2020)){
  downloadImages(baseDir = baseDir, year = "2020", month = names[i], url = f2020[i])
}


## needed to redefine names for subsequestion months. 
# months used to define the file folder. 
names <- c("december", "november", "october", "september", "august", "july", "june", "may","april","march", "feburary","janurary")



# list of files to download 
f2019 <- c(
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201912/vcmcfg/SVDNB_npp_20191201-20191231_75N180W_vcmcfg_v10_c202001140900.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201911/vcmcfg/SVDNB_npp_20191101-20191130_75N180W_vcmcfg_v10_c201912131600.tgz",
  "already downloaded",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201910/vcmcfg/SVDNB_npp_20191001-20191031_75N180W_vcmcfg_v10_c201911061400.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201909/vcmcfg/SVDNB_npp_20190901-20190930_75N180W_vcmcfg_v10_c201910062300.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201908/vcmcfg/SVDNB_npp_20190801-20190831_75N180W_vcmcfg_v10_c201909051300.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201907/vcmcfg/SVDNB_npp_20190701-20190731_75N180W_vcmcfg_v10_c201908090900.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201906/vcmcfg/SVDNB_npp_20190601-20190630_75N180W_vcmcfg_v10_c201907091100.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201905/vcmcfg/SVDNB_npp_20190501-20190531_75N180W_vcmcfg_v10_c201906130930.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201904/vcmcfg/SVDNB_npp_20190401-20190430_75N180W_vcmcfg_v10_c201905191000.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201902/vcmcfg/SVDNB_npp_20190201-20190228_75N180W_vcmcfg_v10_c201903110900.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201901/vcmcfg/SVDNB_npp_20190101-20190131_75N180W_vcmcfg_v10_c201905201300.tgz"
  )

# just used a for loop not a function for the other years. 
for(i in 1:length(f2019)){
  print(i)
  dest <- paste0(baseDir, "/2019/", names[i] )
  temp1 <- tempfile()
  download.file(url = f2019[i], destfile = temp1)
  print("file downloaded")
  untar(tarfile = temp1, exdir = dest)
  print("file extracted")
  unlink(temp1)
}



f2018 <- c(
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201812/vcmcfg/SVDNB_npp_20181201-20181231_75N180W_vcmcfg_v10_c201902122100.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201811/vcmcfg/SVDNB_npp_20181101-20181130_75N180W_vcmcfg_v10_c201812081230.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201810/vcmcfg/SVDNB_npp_20181001-20181031_75N180W_vcmcfg_v10_c201811131000.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201809/vcmcfg/SVDNB_npp_20180901-20180930_75N180W_vcmcfg_v10_c201810250900.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201808/vcmcfg/SVDNB_npp_20180801-20180831_75N180W_vcmcfg_v10_c201809070900.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201807/vcmcfg/SVDNB_npp_20180701-20180731_75N180W_vcmcfg_v10_c201812111300.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201806/vcmcfg/SVDNB_npp_20180601-20180630_75N180W_vcmcfg_v10_c201904251200.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201805/vcmcfg/SVDNB_npp_20180501-20180531_75N180W_vcmcfg_v10_c201806061100.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201804/vcmcfg/SVDNB_npp_20180401-20180430_75N180W_vcmcfg_v10_c201805021400.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201803/vcmcfg/SVDNB_npp_20180301-20180331_75N180W_vcmcfg_v10_c201804022005.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201802/vcmcfg/SVDNB_npp_20180201-20180228_75N180W_vcmcfg_v10_c201803012000.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201801/vcmcfg/SVDNB_npp_20180101-20180131_75N180W_vcmcfg_v10_c201805221252.tgz"
)
for(i in 1:length(f2018)){
  print(i)
  dest <- paste0(baseDir, "/2018/", names[i] )
  temp1 <- tempfile()
  download.file(url = f2018[i], destfile = temp1)
  print("file downloaded")
  untar(tarfile = temp1, exdir = dest)
  print("file extracted")
  unlink(temp1)
}


  f2017 <- c( 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201712/vcmcfg/SVDNB_npp_20171201-20171231_75N180W_vcmcfg_v10_c201801021747.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201711/vcmcfg/SVDNB_npp_20171101-20171130_75N180W_vcmcfg_v10_c201712040930.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201710/vcmcfg/SVDNB_npp_20171001-20171031_75N180W_vcmcfg_v10_c201711021230.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201709/vcmcfg/SVDNB_npp_20170901-20170930_75N180W_vcmcfg_v10_c201710041620.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201708/vcmcfg/SVDNB_npp_20170801-20170831_75N180W_vcmcfg_v10_c201709051000.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201707/vcmcfg/SVDNB_npp_20170701-20170731_75N180W_vcmcfg_v10_c201708061230.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201706/vcmcfg/SVDNB_npp_20170601-20170630_75N180W_vcmcfg_v10_c201707021700.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201705/vcmcfg/SVDNB_npp_20170501-20170531_75N180W_vcmcfg_v10_c201706021500.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201704/vcmcfg/SVDNB_npp_20170401-20170430_75N180W_vcmcfg_v10_c201705011300.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201703/vcmcfg/SVDNB_npp_20170301-20170331_75N180W_vcmcfg_v10_c201705020851.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201702/vcmcfg/SVDNB_npp_20170201-20170228_75N180W_vcmcfg_v10_c201703012030.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201701/vcmcfg/SVDNB_npp_20170101-20170131_75N180W_vcmcfg_v10_c201702241223.tgz"
)
  for(i in 1:length(f2017)){
    print(i)
    dest <- paste0(baseDir, "/2017/", names[i] )
    temp1 <- tempfile()
    download.file(url = f2017[i], destfile = temp1)
    print("file downloaded")
    untar(tarfile = temp1, exdir = dest)
    print("file extracted")
    unlink(temp1)
  }
  
  
  
f2016 <- c(
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201612/vcmcfg/SVDNB_npp_20161201-20161231_75N180W_vcmcfg_v10_c201701271136.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201611/vcmcfg/SVDNB_npp_20161101-20161130_75N180W_vcmcfg_v10_c201612191231.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201610/vcmcfg/SVDNB_npp_20161001-20161031_75N180W_vcmcfg_v10_c201612011122.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201609/vcmcfg/SVDNB_npp_20160901-20160930_75N180W_vcmcfg_v10_c201610280941.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201608/vcmcfg/SVDNB_npp_20160801-20160831_75N180W_vcmcfg_v10_c201610041107.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201607/vcmcfg/SVDNB_npp_20160701-20160731_75N180W_vcmcfg_v10_c201609121310.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201606/vcmcfg/SVDNB_npp_20160601-20160630_75N180W_vcmcfg_v10_c201608101832.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201605/vcmcfg/SVDNB_npp_20160501-20160531_75N180W_vcmcfg_v10_c201606281430.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201604/vcmcfg/SVDNB_npp_20160401-20160430_75N180W_vcmcfg_v10_c201606140957.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201603/vcmcfg/SVDNB_npp_20160301-20160331_75N180W_vcmcfg_v10_c201604191144.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201602/vcmcfg/SVDNB_npp_20160201-20160229_75N180W_vcmcfg_v10_c201603152010.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201601/vcmcfg/SVDNB_npp_20160101-20160131_75N180W_vcmcfg_v10_c201603132032.tgz"
)
for(i in 1:length(f2016)){
  print(i)
  dest <- paste0(baseDir, "/2016/", names[i] )
  temp1 <- tempfile()
  download.file(url = f2016[i], destfile = temp1)
  print("file downloaded")
  untar(tarfile = temp1, exdir = dest)
  print("file extracted")
  unlink(temp1)
}

f2015 <- c(
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201512/vcmcfg/SVDNB_npp_20151201-20151231_75N180W_vcmcfg_v10_c201601251413.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201511/vcmcfg/SVDNB_npp_20151101-20151130_75N180W_vcmcfg_v10_c201512121648.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201510/vcmcfg/SVDNB_npp_20151001-20151031_75N180W_vcmcfg_v10_c201511181404.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201509/vcmcfg/SVDNB_npp_20150901-20150930_75N180W_vcmcfg_v10_c201511121210.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201508/vcmcfg/SVDNB_npp_20150801-20150831_75N180W_vcmcfg_v10_c201509301759.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201507/vcmcfg/SVDNB_npp_20150701-20150731_75N180W_vcmcfg_v10_c201509151839.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201506/vcmcfg/SVDNB_npp_20150601-20150630_75N180W_vcmcfg_v10_c201508141522.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201505/vcmcfg/SVDNB_npp_20150501-20150531_75N180W_vcmcfg_v10_c201506161325.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201504/vcmcfg/SVDNB_npp_20150401-20150430_75N180W_vcmcfg_v10_c201506011707.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201503/vcmcfg/SVDNB_npp_20150301-20150331_75N180W_vcmcfg_v10_c201505191916.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201502/vcmcfg/SVDNB_npp_20150201-20150228_75N180W_vcmcfg_v10_c201504281504.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201501/vcmcfg/SVDNB_npp_20150101-20150131_75N180W_vcmcfg_v10_c201505111709.tgz"
)
for(i in 1:length(f2015)){
  print(i)
  dest <- paste0(baseDir, "/2015/", names[i] )
  temp1 <- tempfile()
  download.file(url = f2015[i], destfile = temp1)
  print("file downloaded")
  untar(tarfile = temp1, exdir = dest)
  print("file extracted")
  unlink(temp1)
}

f2014 <- c(
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201412/vcmcfg/SVDNB_npp_20141201-20141231_75N180W_vcmcfg_v10_c201502231125.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201411/vcmcfg/SVDNB_npp_20141101-20141130_75N180W_vcmcfg_v10_c201502231455.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201410/vcmcfg/SVDNB_npp_20141001-20141031_75N180W_vcmcfg_v10_c201502231115.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201409/vcmcfg/SVDNB_npp_20140901-20140930_75N180W_vcmcfg_v10_c201502251400.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201408/vcmcfg/SVDNB_npp_20140801-20140831_75N180W_vcmcfg_v10_c201508131459.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201407/vcmcfg/SVDNB_npp_20140701-20140731_75N180W_vcmcfg_v10_c201506231100.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201406/vcmcfg/SVDNB_npp_20140601-20140630_75N180W_vcmcfg_v10_c201502121156.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201405/vcmcfg/SVDNB_npp_20140501-20140531_75N180W_vcmcfg_v10_c201502061154.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201404/vcmcfg/SVDNB_npp_20140401-20140430_75N180W_vcmcfg_v10_c201507201613.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201403/vcmcfg/SVDNB_npp_20140301-20140331_75N180W_vcmcfg_v10_c201506121552.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201402/vcmcfg/SVDNB_npp_20140201-20140228_75N180W_vcmcfg_v10_c201507201052.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201401/vcmcfg/SVDNB_npp_20140101-20140131_75N180W_vcmcfg_v10_c201506171538.tgz"
)
for(i in 1:length(f2014)){
  print(i)
  dest <- paste0(baseDir, "/2014/", names[i] )
  temp1 <- tempfile()
  download.file(url = f2014[i], destfile = temp1)
  print("file downloaded")
  untar(tarfile = temp1, exdir = dest)
  print("file extracted")
  unlink(temp1)
}

f2013 <- c(
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201312/vcmcfg/SVDNB_npp_20131201-20131231_75N180W_vcmcfg_v10_c201605131341.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201311/vcmcfg/SVDNB_npp_20131101-20131130_75N180W_vcmcfg_v10_c201605131332.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201310/vcmcfg/SVDNB_npp_20131001-20131031_75N180W_vcmcfg_v10_c201605131331.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201309/vcmcfg/SVDNB_npp_20130901-20130930_75N180W_vcmcfg_v10_c201605131325.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201308/vcmcfg/SVDNB_npp_20130801-20130831_75N180W_vcmcfg_v10_c201605131312.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201307/vcmcfg/SVDNB_npp_20130701-20130731_75N180W_vcmcfg_v10_c201605131305.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201306/vcmcfg/SVDNB_npp_20130601-20130630_75N180W_vcmcfg_v10_c201605131304.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201305/vcmcfg/SVDNB_npp_20130501-20130531_75N180W_vcmcfg_v10_c201605131256.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201304/vcmcfg/SVDNB_npp_20130401-20130430_75N180W_vcmcfg_v10_c201605131251.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201303/vcmcfg/SVDNB_npp_20130301-20130331_75N180W_vcmcfg_v10_c201605131250.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201302/vcmcfg/SVDNB_npp_20130201-20130228_75N180W_vcmcfg_v10_c201605131247.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201301/vcmcfg/SVDNB_npp_20130101-20130131_75N180W_vcmcfg_v10_c201605121529.tgz"
)

for(i in 1:length(f2013)){
  print(i)
  dest <- paste0(baseDir, "/2013/", names[i] )
  temp1 <- tempfile()
  download.file(url = f2013[i], destfile = temp1)
  print("file downloaded")
  untar(tarfile = temp1, exdir = dest)
  print("file extracted")
  unlink(temp1)
}


f2012 <- c(
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201212/vcmcfg/SVDNB_npp_20121201-20121231_75N180W_vcmcfg_v10_c201601041440.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201211/vcmcfg/SVDNB_npp_20121101-20121130_75N180W_vcmcfg_v10_c201601270845.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201210/vcmcfg/SVDNB_npp_20121001-20121031_75N180W_vcmcfg_v10_c201602051401.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201209/vcmcfg/SVDNB_npp_20120901-20120930_75N180W_vcmcfg_v10_c201602090953.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201208/vcmcfg/SVDNB_npp_20120801-20120831_75N180W_vcmcfg_v10_c201602121348.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201207/vcmcfg/SVDNB_npp_20120701-20120731_75N180W_vcmcfg_v10_c201605121509.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201206/vcmcfg/SVDNB_npp_20120601-20120630_75N180W_vcmcfg_v10_c201605121459.tgz", 
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201205/vcmcfg/SVDNB_npp_20120501-20120531_75N180W_vcmcfg_v10_c201605121458.tgz",
  "https://eogdata.mines.edu/wwwdata/viirs_products/dnb_composites/v10//201204/vcmcfg/SVDNB_npp_20120401-20120430_75N180W_vcmcfg_v10_c201605121456.tgz"
)

for(i in 1:length(f2012)){
  print(i)
  dest <- paste0(baseDir, "/2012/", names[i] )
  temp1 <- tempfile()
  download.file(url = f2012[i], destfile = temp1)
  print("file downloaded")
  untar(tarfile = temp1, exdir = dest)
  print("file extracted")
  unlink(temp1)
}


###
# If I point to a directory with the files within in I can get a list of features 
### 
url <- 'https://eogdata.mines.edu/wwwdata/hidden/dnb_profiles_deliver_licorr/usa_houston/csv/'
filenames = RCurl::getURL(url, ssl.verifypeer = FALSE, verbose=TRUE,ftp.use.epsv=TRUE, dirlistonly = FALSE )

install.packages("XML")
library(XML)
files <- getHTMLLinks(filenames)
write.csv(files, "F:/nrelD/geoSpatialCentroid/covidNightLights/data/filePaths/houstenCSVS.csv")

