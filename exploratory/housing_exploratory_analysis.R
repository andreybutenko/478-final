# Exploratory analysis of COVID-19 and housing features by state

## Libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

## Look at COVID-19 Cases (Covid_Positive_4_4) versus the proportion of apartment
## buildings with 10+ units (out of all buildings with 5+ units)
housing_clean_data <- read.csv('../data/prepped/covid-19-housing-data-prepped.csv',
                               stringsAsFactors = F)

apartment_building_df <- housing_clean_data %>%
  mutate(
    units_10_plus_proportion = UNITS_IN_STRUCTURE_10_or_more_apartments / (UNITS_IN_STRUCTURE_10_or_more_apartments + UNITS_IN_STRUCTURE_5_to_9_apartments)
  )

building_size_vs_covid <- ggplot(data = apartment_building_df) +
  geom_point(mapping = aes(x = apartment_building_df$units_10_plus_proportion,
                           y = apartment_building_df$Covid_Positive_4_4)) +
  geom_smooth(mapping = aes(x = apartment_building_df$units_10_plus_proportion,
                            y = apartment_building_df$Covid_Positive_4_4)) +
  labs(
    title = "Proportion of Apartment Buildings with 10+ Units vs. Positive COVID-19 Tests",
    x = "Proportion of Buildings with 10+ Units (out of all buildings with 5+ units)",
    y = "Positive COVID-19 Tests (as of 4/4/2020)"
  )

## Look at COVID-19 Cases (Covid_Positive_4_4) versus the proportion of rooms with
## 1.51+ occupants (out of all rooms with 1+ occupants)

room_occupant_df <- housing_clean_data %>%
  mutate(
    rooms_1_51_plus_proportion = OCCUPANTS_PER_ROOM_1.51_Plus / (OCCUPANTS_PER_ROOM_1.51_Plus + OCCUPANTS_PER_ROOM_1.0_To_1.50)
  )

room_occupancy_vs_covid <- ggplot(data = room_occupant_df) +
  geom_point(mapping = aes(x = room_occupant_df$rooms_1_51_plus_proportion,
                           y = room_occupant_df$Covid_Positive_4_4)) +
  geom_smooth(mapping = aes(x = room_occupant_df$rooms_1_51_plus_proportion,
                           y = room_occupant_df$Covid_Positive_4_4))

  
  
