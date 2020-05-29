library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(maps)
commuter_data <- read.csv('./data/prepped/covid-19-commuter-data-prepped.csv', stringsAsFactors = F)

# create rate data to use in server
commuter_data_rate <- commuter_data %>% 
  mutate(Covid_positive_rate  = Covid_Positive_4_4 / Total_Population_2010,
         Covid_death_rate = Covid_positive_rate / Total_Population_2010,
         Covid_Mortality_rate = Covid_Death_4_4 / Covid_Positive_4_4)

# joining Covid an subway data for new york

nyc_covid <- read.csv('./data/raw/NYC_Covid_by_ZipCode.csv', stringsAsFactors = F)
nyc_subway <- read.csv('./data/prepped/subway_Traffic_Data.csv', stringsAsFactors = F)

nyc_subway_clean <- nyc_subway %>% 
  select("Station..alphabetical.by.borough.",
         "X2018",
         "Borough") %>% 
  group_by(Borough) %>% 
  dplyr::summarise(total_cases = sum(X2018))
nyc_covid_clean <- nyc_covid %>% 
  select("NEIGHBORHOOD_NAME",
         "BOROUGH_GROUP",
         "COVID_CASE_RATE",
         "COVID_DEATH_RATE") %>% 
  filter(BOROUGH_GROUP != "Staten Island") %>% 
  rename("Borough"  = BOROUGH_GROUP)

nyc_covid_clean$Borough[nyc_covid_clean$Borough == "Bronx"] <- "The Bronx"


joined_data <- left_join(nyc_covid_clean, nyc_subway_clean, by = "Borough")

p <- ggplot(joined_data, aes(x = reorder(Borough, COVID_CASE_RATE), 
                             y = COVID_CASE_RATE,
                             fill = total_cases)) + geom_col() + 
  scale_fill_gradient(low="white", high="darkblue")
