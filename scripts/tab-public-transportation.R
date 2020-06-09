library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(maps)
library(remotes)
library(stringr)
# install_version("zipcode", '1.0')
library(zipcode)
commuter_data <- read.csv('./data/prepped/covid-19-commuter-data-prepped.csv', stringsAsFactors = F)

# create rate data to be used with all vizualizations
commuter_data_rate <- commuter_data %>% 
  mutate(Covid_positive_rate  = Covid_Positive_4_4 / Total_Population_2010,
         Covid_death_rate = Covid_positive_rate / Total_Population_2010,
         Covid_Mortality_rate = Covid_Death_4_4 / Covid_Positive_4_4)

# sort by top public transportation rates
#
#
# his block of code wrangles the data for select inputs
commuter_top_public_transit <- commuter_data_rate %>% 
  top_n(5, Public_transportation_rate) %>% 
  select(Region, Covid_positive_rate, Public_transportation_rate) %>% 
  mutate(Top_value = T)
# sort by bottom public transportation rates
commuter_bot_public_transit <- commuter_data_rate %>% 
  top_n(-5, Public_transportation_rate) %>% 
  select(Region, Covid_positive_rate, Public_transportation_rate)%>% 
  mutate(Top_value = F) 
# combine information with boolean to color-sort by top and bottom
commuter_top_and_bot <- full_join(commuter_bot_public_transit, commuter_top_public_transit) 
commuter_top_and_bot <- arrange(commuter_top_and_bot, Covid_positive_rate)

public_transportation_viz <- ggplot(commuter_top_and_bot, aes(x = reorder(Region, Covid_positive_rate * 100), 
                                                              y = Covid_positive_rate, 
                                                              fill = Public_transportation_rate)) +
  geom_col() + scale_fill_gradient(low="white", high="darkblue") + 
  labs(
    title = 'COVID-19 Prevalence vs Public Transit Usage by State',
    x = "State",
    y = "Ratio of Population with COVID-19",
    fill = "Ratio of Public Trans.") + theme_dark()







# create Drive visualization
#
#
# The block wrangles the data and creates the viz for driving to work!
commuter_top_drive <- commuter_data_rate %>% 
  top_n(5, Drive_to_work_rate) %>% 
  select(Region, Covid_positive_rate, Drive_to_work_rate) 
# sort by bottom drive rates
commuter_bot_drive <- commuter_data_rate %>% 
  top_n(-5, Drive_to_work_rate) %>% 
  select(Region, Covid_positive_rate, Drive_to_work_rate)
# combine information with boolean to color-sort by top and bottom
commuter_top_and_bot_drive <- full_join(commuter_bot_drive, commuter_top_drive) 
commuter_top_and_bot_drive <- arrange(commuter_top_and_bot_drive, Covid_positive_rate)

drive_viz <- ggplot(commuter_top_and_bot_drive, aes(x = reorder(Region, Covid_positive_rate * 100), 
                                                              y = Covid_positive_rate, 
                                                              fill = Drive_to_work_rate)) +
  geom_col() + scale_fill_gradient(low="white", high="darkblue") + 
  labs(
    title = 'COVID-19 Prevalence vs Commuting by Care by State',
    x = "State",
    y = "Ratio of Population with COVID-19",
    fill = "Ratio of Driving") + theme_dark()





# joining Covid an subway data for new york
# 
#
# This block of code connects the boroughs to covid spread in NYC
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
  rename("Borough"  = BOROUGH_GROUP) %>% 
  group_by(Borough) %>% 
  dplyr::summarise(covid_pos_rate = mean(COVID_CASE_RATE))

nyc_covid_clean$Borough[nyc_covid_clean$Borough == "Bronx"] <- "The Bronx"


joined_data <- left_join(nyc_covid_clean, nyc_subway_clean, by = "Borough")

borough_graph <- ggplot(joined_data, aes(x = reorder(Borough, covid_pos_rate), 
                             y = covid_pos_rate,
                             fill = total_cases)) + geom_col() + 
  scale_fill_gradient(low="white", high="darkblue") + labs(
    title = 'COVID-19 Prevalence and Subway Traffic by NYC Borough',
    x = "New York City Boroughs",
    y = "Covid Cases per 100,000",
    fill = "Subway Traffic"
  )









# Zipcode data joining with maps
#
#
# This block of code maps out the zipcode 
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

nyc_stat_loc <- read.csv('./data/prepped/nyc_station_location.csv', stringsAsFactors = F)
nyc_mapping <- ggplot(nyc_zip_merge, aes(longitude, latitude)) +
  geom_polygon(data = nyc_map, aes(x=long,y=lat, group = group),color='gray',fill=NA,alpha=.5) + 
  geom_point(aes(color = COVID_CASE_RATE), size = 10, alpha=.8) + scale_color_gradient(low="white", high="orange") +
  xlim(-74.3,-73.7)+ylim(40.4,40.9) +
  geom_point(data = nyc_stat_loc, aes(x=long, y=lat), color='darkblue', alpha=.3, size=3) +
  labs(title = 'COVID-19 Cases and Subway Stations in NYC',
       subtitle = 'Blue dots are subway stations',
       fill = 'COVID-19 Case Rate',
       x = 'Longitude',
       y = 'Latitude')


