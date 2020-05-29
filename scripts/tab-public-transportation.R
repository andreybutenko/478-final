library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(maps)
commuter_data <- read.csv('./data/prepped/covid-19-commuter-data-prepped.csv', stringsAsFactors = F)

# create rate data
commuter_data <- commuter_data %>% 
  mutate(Covid_positive_rate  = Covid_Positive_4_4 / Total_Population_2010,
         Covid_death_rate = Covid_positive_rate / Total_Population_2010,
         Covid_Mortality_rate = Covid_Death_4_4 / Covid_Positive_4_4) %>% 
  rename(region = Region)

usa_map <- map_data('state')

map_commuter_join <- left_join(usa_map, commuter_data, by = "region")

p <- ggplot(data = map_commuter_join, aes(x = long, 
                                          y = lat, 
                                          group = group, 
                                          color = "white") + 
  geom_polygon()

  