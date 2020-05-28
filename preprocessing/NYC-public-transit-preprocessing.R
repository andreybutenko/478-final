library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)
library(readxl)

# load raw data
nyc_subway_loc <- read.csv('./data/raw/NYC_Subway_Station_Location.csv', stringsAsFactors = F)

nyc_subway_traffic <- read_excel('./data/raw/MTA_SubwayTraffic.xlsx')
  
nyc_covid <- read.csv('./data/raw/NYC_Covid_by_ZipCode.csv', stringsAsFactors = F)

# clean traffic volume data
subway_traffic_clean <- nyc_subway_traffic %>% 
  mutate(na = is.na(`2018`)) %>% 
  filter(na == F)

write.csv(nyc_covid, './data/prepped/nyc_covid_data', row.names = F)
write.csv(subway_traffic_clean, './data/prepped/subway_Traffic_Data.csv', row.names = F)

