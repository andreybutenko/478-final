library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(maps)
library(remotes)
# install_version("zipcode", '1.0')
library(zipcode)
commuter_data <- read.csv('./data/prepped/covid-19-commuter-data-prepped.csv', stringsAsFactors = F)

# create rate data to use in server
commuter_data_rate <- commuter_data %>% 
  mutate(Covid_positive_rate  = Covid_Positive_4_4 / Total_Population_2010,
         Covid_death_rate = Covid_positive_rate / Total_Population_2010,
         Covid_Mortality_rate = Covid_Death_4_4 / Covid_Positive_4_4)

# joining Covid an subway data for new york
# ---------------------------------------------------------------------------------------
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

# Zipcode data joining with maps
data("zipcode")
nyc_zip_covid <- nyc_covid %>% 
  select(MODIFIED_ZCTA, 
         NEIGHBORHOOD_NAME,
         COVID_CASE_RATE,
         COVID_DEATH_RATE,
         BOROUGH_GROUP) %>% 
  rename('zip' = MODIFIED_ZCTA)
zipcode_clean <- zipcode %>% 
  transform(zip = as.numeric(zip))

nyc_zip_merge <- left_join(nyc_zip_covid, zipcode_clean, by = "zip")

nyc_map <- map_data('state')


p <- ggplot(nyc_zip_merge, aes(longitude, latitude)) +
  geom_polygon(data = nyc_map, aes(x=long,y=lat, group = group),color='gray',fill=NA,alpha=.5) + 
  geom_point(aes(color = COVID_CASE_RATE)) +
  xlim(-74.3,-73.7)+ylim(40.4,40.9)


