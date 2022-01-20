library(data.table)

#set working directory. Change Station ID/file name as necessary
dir_add <- "C:/Users/Maria/Documents/AAFC/get_weather/"
file_name <- "10800/daily"
setwd(paste(dir_add, file_name, sep=""))

#read EC csv weather file
dat <- read.csv(file = "compiled_data.txt", header=TRUE, sep=";")

#~~~~~~~~~~~FORMAT csv file~~~~~~~~~~~~~~~~~~~~~~~~~~~
#select station name, date, min and max temp, and total precip columns
dat_2 <- subset(dat, select = c(3, 5, 6, 7, 8, 10, 12, 24))

#remove months not in season (season = may - oct)
weather_data <- dat_2[!(dat_2$Month==1 | dat_2$Month==2 | dat_2$Month==3 | dat_2$Month==4 | dat_2$Month==11 | dat_2$Month==12),]

#save file
write.csv(weather_data, file="weather_data.csv")


#~~~~~~~~~~~~~~FIND MISSING DATA~~~~~~~~~~~~~~~~~~~~~~

#check how many individual missing data points and how many missing in a row
#total missing data points
missing_data_precip <- sum(is.na(weather_data$Total.Precip..mm.))
missing_data_maxtemp <- sum(is.na(weather_data$Max.Temp..Â.C.))
missing_data_mintemp <- sum(is.na(weather_data$Min.Temp..Â.C.))



#find ranges of missing data

missing_data <- data.frame('Missing Precip Start'= integer(),'Missing Precip Data Count'=integer(), 'Missing Max Temp Data Start'=integer(), 'Missing Max Temp Data Count'=integer(),'Missing Min Temp Data Start'=integer(), 'Missing Min Temp Data Count'=integer())

#Find missing precip data-----------------------------------------
missing_data_count <- 0 #number of NAs
start_date <- 0 #start of consecutive NAs in column
first_instance <- T
counter <- 1 # counter for retrieving date at row in for loop
counter_2 <- 1 # counter for appending to missing_data rows

for(i in weather_data$Total.Precip..mm.){
  if(is.na(i)){
    if(first_instance == T){
      #start date of first instance of missing value range
      start_date <- weather_data$Date.Time[counter]
      first_instance <- F
      
    }
    missing_data_count <- missing_data_count + 1
  } else {
    if(!(counter==1)){
      if(is.na(weather_data$Total.Precip..mm.[counter-1])){
        missing_data[counter_2,1] <- start_date
        missing_data[counter_2,2] <- missing_data_count
        counter_2 <- counter_2 + 1
      }
    }
    #reset missing data count and first instance bool
    missing_data_count <- 0
    first_instance = T
  }
  counter <- counter + 1
}
if(!(missing_data_count == 0)){
  missing_data[counter_2,1] <- start_date
  missing_data[counter_2,2] <- missing_data_count
}

#Find missing Max temp data-----------------------------------------
missing_data_count <- 0 #number of NAs
start_date <- 0 #start of consecutive NAs in column
first_instance <- T
counter <- 1 # counter for retrieving date at row in for loop
counter_2 <- 1 # counter for appending to missing_data rows


for(i in weather_data$Max.Temp..Â.C.){
  if(is.na(i)){
    if(first_instance == T){
      #start date of first instance of missing value range
      start_date <- weather_data$Date.Time[counter]
      first_instance <- F
      
    }
    missing_data_count <- missing_data_count + 1
  } else {
    if(!(counter==1)){
      if(is.na(weather_data$Max.Temp..Â.C.[counter-1])){
        missing_data[counter_2,3] <- start_date
        missing_data[counter_2,4] <- missing_data_count
        counter_2 <- counter_2 + 1
      }
    }
    #reset missing data count and first instance bool
    missing_data_count <- 0
    first_instance = T
  }
  counter <- counter + 1
}
if(!(missing_data_count == 0)){
  missing_data[counter_2,3] <- start_date
  missing_data[counter_2,4] <- missing_data_count
}

#Find missing Min temp data-----------------------------------------
missing_data_count <- 0 #number of NAs
start_date <- 0 #start of consecutive NAs in column
first_instance <- T
counter <- 1 # counter for retrieving date at row in for loop
counter_2 <- 1 # counter for appending to missing_data rows


for(i in weather_data$Min.Temp..Â.C.){
  if(is.na(i)){
    if(first_instance == T){
      #start date of first instance of missing value range
      start_date <- weather_data$Date.Time[counter]
      first_instance <- F
      
    }
    missing_data_count <- missing_data_count + 1
  } else {
    if(!(counter==1)){
      if(is.na(weather_data$Min.Temp..Â.C.[counter-1])){
        missing_data[counter_2,5] <- start_date
        missing_data[counter_2,6] <- missing_data_count
        counter_2 <- counter_2 + 1
      }
    }
    #reset missing data count and first instance bool
    missing_data_count <- 0
    first_instance = T
  }
  counter <- counter + 1
}
if(!(missing_data_count == 0)){
  missing_data[counter_2,5] <- start_date
  missing_data[counter_2,6] <- missing_data_count
}

#write to file
file_name <- paste("missing_data_",weather_data$Station.Name[1],".csv", sep="")
write.csv(missing_data, file=file_name)

#print percent data missing
total_days <- nrow(weather_data)
percent_missing_precip <- (missing_data_precip /total_days)*100
percent_missing_maxtemp <- (missing_data_maxtemp/total_days)*100
percent_missing_mintemp <- (missing_data_mintemp/total_days)*100

cat(sprintf("%s%% of precip data is missing \n", percent_missing_precip))
cat(sprintf("%s%% of max temp data is missing \n", percent_missing_maxtemp))
cat(sprintf("%s%% of min temp data is missing \n", percent_missing_mintemp))
