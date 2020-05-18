library(dplyr)
library(ggplot2)

case_dist.risk_factors <- read.csv('../data/raw/Kaggle - US COVID-19 Risk Factors Assessment Data.csv',
                         stringsAsFactors = F)

case_dist.get_labelled_fivenum <- function(x) {
  data.frame(
    Metric = c('Minimum', 'Lower Quartile', 'Median', 'Upper Quartile', 'Maximum'),
    Value = fivenum(x),
    stringsAsFactors = F
  )
}

case_dist.data <- case_dist.risk_factors %>% 
  select(REGION,
         Area,
         CENSUS_2010_TOTAL_POPULATION,
         Covid_Positive_4_4,
         Covid_Total_Test_Results) %>% 
  rename(state = REGION,
         region = Area,
         population = CENSUS_2010_TOTAL_POPULATION,
         positives = Covid_Positive_4_4,
         tests = Covid_Total_Test_Results) %>% 
  filter(state != 'District of Columbia') %>% 
  mutate(positive_rate = positives / tests,
         positive_per_capita = positives / population)

case_dist.region_data <- case_dist.data %>% 
  group_by(region) %>% 
  summarize(population = sum(population),
            positives = sum(positives),
            tests = sum(tests)) %>% 
  mutate(positive_rate = positives / tests,
         positive_per_capita = positives / population)

# Distribution of positive COVID-19 testing rates by state
case_dist.hist_positive_rate <- ggplot(case_dist.data, aes(x = positive_rate)) +
  geom_histogram(binwidth = 0.05) +
  scale_x_continuous(breaks = seq(from = 0,
                                  to = max(case_dist.data$positive_rate),
                                  by = 0.05)) +
  labs(title = 'Distribution of Positive COVID-19 Testing Rates by State',
       subtitle = 'What proportion of tests are positive for COVID-19?',
       x = 'Positive COVID-19 Testing Rate',
       y = 'Count of States')

# Distribution of positive COVID-19 testing rates by region
case_dist.box_positive_rate <- case_dist.data %>% 
  ggplot(aes(x = positive_rate,
             y = region)) +
  geom_boxplot() +
  labs(title = 'Distribution of Positive COVID-19 Testing Rates by Region',
       subtitle = 'What proportion of tests are positive for COVID-19?',
       x = 'Positive COVID-19 Testing Rate',
       y = 'Region')

# Descriptive summary stats  of positive COVID-19 testing rates
case_dist.stat_positive_rate <- case_dist.get_labelled_fivenum(case_dist.data$positive_rate)

# Distribution of positive COVID-19 tests per capita by state
case_dist.hist_positives <- ggplot(case_dist.data, aes(x = positive_per_capita)) +
  geom_histogram(binwidth = 0.001) +
  scale_x_continuous(breaks = seq(from = 0,
                                  to = max(case_dist.data$positive_per_capita),
                                  by = 0.001)) +
  labs(title = 'Distribution of Positive COVID-19 Tests per Capita by State',
       subtitle = 'What proportion of the population test positive for COVID-19?',
       x = 'Positive COVID-19 Tests per Capita',
       y = 'Count of States')


# Distribution of positive COVID-19 tests per capita by state
case_dist.box_positives <- case_dist.data %>% 
  ggplot(aes(x = positive_per_capita,
             y = region)) +
  geom_boxplot() +
  labs(title = 'Distribution of Positive COVID-19 Tests per Capita by Region',
       subtitle = 'What proportion of the population test positive for COVID-19?',
       x = 'Positive COVID-19 Tests per Capita',
       y = 'Region')

# Descriptive summary stats  of positive COVID-19 tests
case_dist.stat_positives <- case_dist.get_labelled_fivenum(case_dist.data$positive_per_capita)
