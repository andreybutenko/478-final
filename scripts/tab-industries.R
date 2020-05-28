library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)

# Load and set up COVID-19 cases by state dataset ##############################

industry_covid19_cases <- read.csv('./data/raw/NYT - COVID-19 Cases by State by Time.csv',
                                   stringsAsFactors = F) %>% 
  filter(date == '2020-05-26',
         !(state %in% c('District of Columbia', 'Guam', 'Northern Mariana Islands', 'Puerto Rico', 'Virgin Islands')))

# Load and set up industry employment by state dataset #########################

industry_employment <- read.csv('./data/prepped/bea-2018-employment-counts-by-category-by-state.csv',
                                stringsAsFactors = F)
colnames(industry_employment) <- c('fips', 'state', 'code', 'sector', 'employment')

industry_employment_aggregate <- industry_employment %>% 
  group_by(fips) %>% 
  summarize(total_employment = sum(employment))

industry_employment <- industry_employment %>% 
  left_join(industry_employment_aggregate, by = 'fips') %>% 
  mutate(prop_employment = employment / total_employment,
         perc_employment = paste0(round(prop_employment * 100, 2), '%')) %>% 
  select(-total_employment)

