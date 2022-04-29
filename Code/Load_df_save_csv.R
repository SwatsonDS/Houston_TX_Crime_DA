# Loading required packages
install.packages("tidyverse")
library(tidyverse)
library(readxl) #package required to load data from excel
install.packages("lubricate") #install if needing to convert datetime
library(lubricate) 
install.packages("janitor") # install pkg to clean data frame
library(janitor)

#Check working directory
getwd()

#Set working directory to file location or map from main folder
#setwd("/cloud/project")

#Load raw monthly data files and clean column names (Fix column names, remove spaces, and capitals)
jan <- read_excel("/cloud/project/2018/jan18.xls") %>% clean_names()
feb <- read_excel("/cloud/project/2018/feb18.xls") %>% clean_names()
mar <- read_excel("/cloud/project/2018/mar18.xls") %>% clean_names()
apr <- read_excel("/cloud/project/2018/apr18.xls") %>% clean_names()
may <- read_excel("/cloud/project/2018/may18.xls") %>% clean_names()
jun <- read_excel("/cloud/project/2018/06-2018.NIBRS_Public_Data_Group_A&B.xlsx",
                  skip = 11,trim_ws = TRUE) %>% clean_names()
jul <- read_excel("/cloud/project/2018/07-2018.NIBRS_Public_Data_Group_A&B.xlsx",
                  skip = 11,trim_ws = TRUE) %>% clean_names()
aug <- read_excel("/cloud/project/2018/08-2018.NIBRS_Public_Data_Group_A&B.xlsx",
                  skip = 11,trim_ws = TRUE) %>% clean_names()
sep <- read_excel("/cloud/project/2018/09-2018.NIBRS_Public_Data_Group_A&B.xlsx",
                  skip = 11,trim_ws = TRUE) %>% clean_names()
oct <- read_excel("/cloud/project/2018/10-2018.NIBRS_Public_Data_Group_A&B.xlsx",
                  skip = 11,trim_ws = TRUE) %>% clean_names()
nov <- read_excel("/cloud/project/2018/11-2018.NIBRS_Public_Data_Group_A&B.xlsx",
                  skip = 11,trim_ws = TRUE) %>% clean_names()
dec <- read_excel("/cloud/project/2018/12-2018.NIBRS_Public_Data_Group_A&B.xlsx",
                  skip = 11,trim_ws = TRUE) %>% clean_names()

#return name of each data frame loaded into the environment
names_of_dataframes <- ls.str(mode = "list")

for (x in names_of_dataframes){
  print(x)
}

#If additional data cleaning required

#Date column format is different (char) from rest of data (POSIxct)
#Convert character 'Date' column to POSIxct column type
#format corresponds to data before conversion
may$date <- as.POSIXct(may$date, format= "%m/%d/%Y")
jun$date <- as.POSIXct(jun$date, format= "%m/%d/%Y")
jul$date <- as.POSIXct(jul$date, format= "%m/%d/%Y")
aug$date <- as.POSIXct(aug$date, format= "%m/%d/%Y")
sep$date <- as.POSIXct(sep$date, format= "%m/%d/%Y")
oct$date <- as.POSIXct(oct$date, format= "%m/%d/%Y")
nov$date <- as.POSIXct(nov$date, format= "%m/%d/%Y")
dec$date <- as.POSIXct(dec$date, format= "%m/%d/%Y")

#Rename columns if required
apr <- apr %>% 
  rename(offenses = number_offenses)

#Combine all data files into one file
crime_2018_1 <- bind_rows(jan,feb,mar,apr,may)
crime_2018_2 <- bind_rows(jun,jul,aug,sep,oct,nov,dec)
crime_2018 <- bind_rows(crime_2018_1,crime_2018_2)

#Combine all data files into one file
crime_2014 <- bind_rows(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec)

#Save combined dataframe into a csv file
write_csv(crime_2018, "/cloud/project/crime_2018.csv", col_names = TRUE)

#Remove datasets to free up memory
rm(jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec,crime_2014)
gc()

#Clean up yearly file
crime_2010 <- read_csv("/cloud/project/crime_2010.csv") %>% clean_names()

crime_2018_2 <- crime_2018_2 %>% 
  rename(date = occurrence_date) %>% 
  rename(hour = occurrence_hour) %>% 
  rename(offense_type = nibrs_description)

rename(offenses = offense_count) %>% 
  
crime_2018_2 <- crime_2018_2 %>% 
  rename(type = street_type)
 
#Remove columns that are not needed
crime_2018_2 <- subset(crime_2018_2,select = -c(x2,x4,x6,x11,x13,x14,x16))

write_csv(crime_2010, "/cloud/project/crime_2010_v2.csv", col_names = TRUE)

for (x in names_of_dataframes){
  rm(x)
  gc()
}

rm(names_of_dataframes)
gc()
