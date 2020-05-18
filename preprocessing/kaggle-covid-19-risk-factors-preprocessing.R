# US COVID-19 Risk Factors Assessment Data
# Dataset of COVID-19 risk factors by state.
# https://www.kaggle.com/jtourkis/covid19-us-major-city-density-data/data#

raw_data <- read.csv('../data/raw/Kaggle - US COVID-19 Risk Factors Assessment Data.csv',
                     stringsAsFactors = F)

# TODO: Preprocessing based on what we want to explore in the risk factors data.
library(dplyr)
# processing data for commuter and-Covid related information
commuter_clean_data <- raw_data %>% 
  select(REGION, 
         Area, 
         Covid_Positive_4_4,
         Covid_Death_4_4, 
         CENSUS_2010_TOTAL_POPULATION,
         COMMUTE_Census_Worker_Drive_To_Work_Rate,
         COMMUTE_Census_Worker_Carpool_To_Work_Rate,
         COMMUTE_Census_Worker_Public_Transportation_Rate,
         COMMUTE_Census_Worker_Walk_Rate,
         COMMUTE_Census_Worker_Taxicab_Motorcycle_Bicycle_Other_Rate,
         COMMUTE_Census_Work_At_Home_Rate) %>% 
  rename(Region = REGION, 
          Total_Population_2010 = CENSUS_2010_TOTAL_POPULATION,
          Drive_to_work_rate = COMMUTE_Census_Worker_Drive_To_Work_Rate,
          Carpool_to_work_rate = COMMUTE_Census_Worker_Carpool_To_Work_Rate,
          Public_transportation_rate = COMMUTE_Census_Worker_Public_Transportation_Rate,
          Walk_to_work_rate = COMMUTE_Census_Worker_Walk_Rate,
          Other_commuter_rate = COMMUTE_Census_Worker_Taxicab_Motorcycle_Bicycle_Other_Rate,
          work_from_home_rate = COMMUTE_Census_Work_At_Home_Rate)
write.csv(commuter_clean_data,
          '../data/prepped/covid-19-commuter-data-prepped.csv',
          row.names = F)

View(raw_data)
colnames(raw_data)

density_clean_data <- raw_data %>%
  select(REGION,
         X2020_STATE_DENSITY,
         CENSUS_2010_TOTAL_POPULATION
         Census_Population_Over_60,
         Covid_Positive_4_4,
         Covid_Death_4_4,
         Covid_Hospitalized_Cumulative_4_4,
         Covid_ICU_Cumulative_4_4,
         Covid_Total_Test_Results
         ) %>%
  rename(Region = REGION,
         State_Density = X2020_STATE_DENSITY)
write.csv(density_clean_data,
          '../data/prepped/covid-19-density-data-prepped.csv',
          row.names = F)
