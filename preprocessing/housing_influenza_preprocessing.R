# Exploring influenza vs COVID-19 trends

## Libraries

library(dplyr)
library(tidyr)

## Downloading original dataset
og_covid_dataset <- read.csv('../data/raw/Kaggle - US COVID-19 Risk Factors Assessment Data.csv',
                       stringsAsFactors = F)

## Pre-processing for influenza and data
influenza_clean_data <- og_covid_dataset %>%
  select(
    REGION,
    Area,
    CENSUS_2010_TOTAL_POPULATION,
    CENSUS_2010_STATE_DENSITY,
    X2020_STATE_DENSITY,
    Covid_Positive_4_4,
    Covid_Pending_4_4,
    Covid_Death_4_4,
    Covid_Score_4_4,
    FLUVIEW_TOTAL_INFLUENZA_DEATHS_Season_2018,
    FLUVIEW_TOTAL_PNEUMONIA_DEATHS_Season_2018,
    Fluview_US_FLU_Hospitalization_Rate_Asthma,
    Fluview_US_FLU_Hospitalization_Rate_Lung_Disease,
    Fluview_US_FLU_Hospitalization_Rate_Heart_Disease,
    Fluview_US_FLU_Hospitalization_Rate_Metabolic_Disorders,
    Fluview_US_FLU_Hospitalization_Rate_Obesity,
    Fluview_US_FLU_Hospitalization_Rate_Kidney_Disease,
    Kaiser_Beds_per_1000_Population,
    Kaiser_CHC_Service_Delivery_Sites,
    Kaiser_Total_CHCs,
    Kaiser_Total_Hospital_Beds
  )

write.csv(influenza_clean_data, '../data/prepped/covid-19-influenza-data-prepped.csv')

## Pre-processing for household data
housing_clean_data <- og_covid_dataset %>%
  select(
    REGION,
    Area,
    CENSUS_2010_TOTAL_POPULATION,
    CENSUS_2010_STATE_DENSITY,
    X2020_STATE_DENSITY,
    Covid_Positive_4_4,
    Covid_Pending_4_4,
    Covid_Death_4_4,
    Covid_Score_4_4,
    HOUSEHOLD_UNITS,
    UNITS_IN_STRUCTURE_5_to_9_apartments,
    UNITS_IN_STRUCTURE_10_or_more_apartments,
    OCCUPANTS_PER_ROOM_1.0_To_1.50,
    OCCUPANTS_PER_ROOM_1.51_Plus,
    FAMILY_HOUSEHOLDS_Householder_65_Plus,
    NONFAMILY_Householder_Living_Alone_65_Plus,
    Kaiser_Beds_per_1000_Population,
    Kaiser_CHC_Service_Delivery_Sites,
    Kaiser_Total_CHCs,
    Kaiser_Total_Hospital_Beds
  )

write.csv(housing_clean_data, '../data/prepped/covid-19-housing-data-prepped.csv')
