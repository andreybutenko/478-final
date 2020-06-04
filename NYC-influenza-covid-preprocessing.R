# NYC COVID & Influenza Data Prep

library(dplyr)
library(stringr)
library(tidyverse)

raw_ny_influenza_data <- read.csv('./data/raw/Influenza_NY.csv', stringsAsFactors = F)

# Filter to most recent influenza season and NY counties in NYC, group by county
# and add up influenza cases from the recorded 2018-2019 season

ny_2018_2019_influenza_data <- raw_ny_influenza_data %>%
  filter(
    Season == "2018-2019",
    County == c("BRONX", "QUEENS", "KINGS", "RICHMOND", "NEW YORK")
  ) %>%
  group_by(County) %>%
  summarise(
    INFLUENZA_CASE_COUNT = sum(Infected)
  )

# Combining COVID-19 case counts by borough group

nyc_covid_data_counties <- nyc_covid_data %>%
  group_by(BOROUGH_GROUP) %>%
  summarise(
    TOTAL_COVID_CASES = sum(COVID_CASE_COUNT)
  )

# Renaming NYC boroughs to counties

nyc_covid_data_counties[nyc_covid_data_counties == "Manhattan"] <- "NEW YORK"
nyc_covid_data_counties[nyc_covid_data_counties == "Bronx"] <- "BRONX"
nyc_covid_data_counties[nyc_covid_data_counties == "Queens"] <- "QUEENS"
nyc_covid_data_counties[nyc_covid_data_counties == "Brooklyn"] <- "KINGS"
nyc_covid_data_counties[nyc_covid_data_counties == "Staten Island"] <- "RICHMOND"

nyc_covid_data_counties <- nyc_covid_data_counties %>%
  rename(
    County = BOROUGH_GROUP
  )

# Join NYC influenza and COVID summary dataframes

nyc_influenza_covid_df <- left_join(nyc_covid_data_counties, ny_2018_2019_influenza_data, by = "County")

write.csv(nyc_influenza_covid_df, './data/prepped/nyc_influenza_covid_df', row.names = F)
