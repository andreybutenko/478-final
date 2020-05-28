library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)

# Load and set up COVID-19 cases by state dataset ##############################
# New York Times: https://github.com/nytimes/covid-19-data

industry_covid19_cases <- read.csv('./data/raw/NYT - COVID-19 Cases by State by Time.csv',
                                   stringsAsFactors = F) %>% 
  filter(date == '2020-05-26',
         !(state %in% c('District of Columbia', 'Guam', 'Northern Mariana Islands', 'Puerto Rico', 'Virgin Islands')))

write.csv(industry_covid19_cases, './data/prepped/nyt-covid19-cases-latest-statesonly.csv', row.names = F)

# Load and set up population by state dataset ##################################
# U.S. Census Bureau: https://www.census.gov/data/datasets/time-series/demo/popest/2010s-state-total.html

industry_population <- read.csv('./data/raw/Census - Population 2019.csv',
                                stringsAsFactors = F)
colnames(industry_population) <- c('state', 'population')
industry_population <- industry_population %>% 
  mutate(state = str_replace_all(state, '\\.', ''),
         population = as.numeric(str_replace_all(population, ',', ''))) %>% 
  filter(state != '',
         state != 'District of Columbia')

write.csv(industry_population, './data/prepped/census-population-2019.csv', row.names = F)

# Load and set up industry employment by state dataset #########################
# U.S. Bureau of Economic Analysis: https://www.bea.gov/data/employment/employment-county-metro-and-other-areas

industry_employment <- read.csv('./data/prepped/bea-2018-employment-counts-by-category-by-state.csv',
                                stringsAsFactors = F)
colnames(industry_employment) <- c('fips', 'state', 'code', 'sector', 'employment')
industry_employment <- industry_employment %>% 
  filter(!(state %in% c('New England', 'Mideast', 'Southeast', 'Southwest', 'Rocky Mountain')))

industry_employment_aggregate <- industry_employment %>% 
  group_by(fips) %>% 
  summarize(total_employment = sum(employment))

industry_employment <- industry_employment %>% 
  left_join(industry_employment_aggregate, by = 'fips') %>% 
  mutate(prop_employment = employment / total_employment,
         perc_employment = paste0(round(prop_employment * 100, 2), '%')) %>% 
  select(-total_employment)

write.csv(industry_employment, './data/prepped/bea-employment-2018.csv', row.names = F)

# Add COVID-19 prevalence data #################################################

industry_covid19_cases <- industry_covid19_cases %>% 
  left_join(industry_population, by = 'state') %>% 
  mutate(prevalence = cases / population)

industry_full_data <- industry_employment %>% 
  left_join(industry_covid19_cases, by = 'state') %>% 
  rename(fips_long = fips.x,
         fips_short = fips.y) %>% 
  select(fips_short, fips_long, everything())

# Add COVID-19 prevalence rank #################################################

industry_full_data_arranged <- industry_full_data %>% 
  arrange(desc(prevalence))

rank_df <- data.frame(
  state = unique(industry_full_data_arranged$state),
  rank = 1:length(unique(industry_full_data_arranged$state)),
  stringsAsFactors = F
)

industry_full_data <- industry_full_data %>% 
  left_join(rank_df, by = 'state') %>% 
  rename(prevalence_rank = rank)

write.csv(industry_full_data, './data/prepped/industry-covid19-full-data.csv', row.names = F)
