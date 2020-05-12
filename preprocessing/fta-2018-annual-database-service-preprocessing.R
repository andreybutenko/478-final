# FTA 2018 Annual Database Service
# Contains operating statistics reported by mode and type of service.
# Categorized by vehicles operated and vehicles available in maximum service
# by day and time period.
# https://www.transit.dot.gov/ntd/data-product/2018-annual-database-service
library(dplyr)
library(readxl)

raw_data <- read_xlsx('../data/raw/FTA - 2018 Annual Database Service.xlsx')

# Recode time period into more generic categories,
# find the number of trips and passenger miles for each agency-time period,
# and remove rows with only 0s since these indicate no data is available.

clean_data <- raw_data %>% 
  mutate(`Time Period` = recode(`Time Period`,
                                'Average Weekday - AM Peak' = 'Weekday Peak',
                                'Average Weekday - Midday' = 'Weekday Off-Peak',
                                'Average Weekday - PM Peak' = 'Weekday Peak',
                                'Average Weekday - Other' = 'Weekday Off-Peak',
                                'Average Typical Weekday' = 'Average Weekday',
                                'Average Typical Saturday' = 'Weekend',
                                'Average Typical Sunday' = 'Weekend',
                                'Annual Total' = 'Annual Total')) %>% 
  group_by(`NTD ID`,
           `Agency Name`,
           `Time Period`) %>% 
  summarize(num_trips = sum(`Unlinked Passenger Trips (UPT)`, na.rm = T),
            passenger_miles = sum(`Passenger Miles`, na.rm = T)) %>% 
  filter(!(num_trips == 0 & passenger_miles == 0))

write.csv(clean_data,
          '../data/prepped/fta-2018-annual-database-service-all.csv',
          row.names = F)
