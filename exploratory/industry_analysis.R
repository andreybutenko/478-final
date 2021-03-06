library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)

industry.risk_factors <- read.csv('../data/raw/Kaggle - US COVID-19 Risk Factors Assessment Data.csv',
                                  stringsAsFactors = F)

industry.prop_to_perc <- function(x) {
  paste0(round(x * 100, 2), '%')
}

industry.data <- industry.risk_factors %>% 
  select(REGION,
         Area,
         CENSUS_2010_TOTAL_POPULATION,
         Covid_Positive_4_4,
         Covid_Total_Test_Results,
         starts_with('INDUSTRY_')) %>% 
  rename(state = REGION,
         region = Area,
         population = CENSUS_2010_TOTAL_POPULATION,
         positives = Covid_Positive_4_4,
         tests = Covid_Total_Test_Results) %>% 
  filter(state != 'District of Columbia') %>% 
  pivot_longer(cols = starts_with('INDUSTRY_'),
               names_to = 'industry',
               values_to = 'industry_num',
               names_prefix = 'INDUSTRY_') %>% 
  mutate(industry = str_replace_all(industry, '_', ' '),
         industry_rate = industry_num / population,
         industry_rate_friendly = industry.prop_to_perc(industry_rate),
         prevalence = positives / population) %>% 
  arrange(-prevalence) %>% 
  mutate(rank = rep(1:50, each = 13))

industry.compare_by_facet <- industry.data %>% 
  filter(rank %in% c(1:5, 45:50)) %>% 
  mutate(rank = ifelse(rank <= 5, 'Highest Prevalence', 'Lowest Prevalence')) %>% 
  ggplot(aes(y = state,
             x = industry_num,
             fill = industry,
             text = paste0('<b>', industry, ' in ', state, '</b>\n',
                           'Jobs in industry: ', industry_num, '\n',
                           'Proportion of people in industry: ', industry_rate_friendly))) +
  geom_bar(position = 'fill',
           stat = 'identity') +
  labs(title = 'Proportion of jobs by industry per state',
       subtitle = 'Comparing states with highest and lowest COVID-19 prevalence',
       x = 'Proportion of jobs in industry',
       y = 'State') +
  facet_wrap(~rank,
             scales = "free_y")

industry.compare_by_facet_interactive <- ggplotly(industry.compare_by_facet,
                                                  tooltip = c('text'))

industry.compare_by_average <- industry.data %>% 
  filter(rank %in% c(1:5, 31:50)) %>% 
  mutate(rank = ifelse(rank <= 5, 'Top 5 Highest Prevalence States', 'Top 20 Lowest Prevalence States')) %>% 
  group_by(rank, industry) %>% 
  summarize(industry_rate = mean(industry_rate)) %>% 
  mutate(industry_rate_friendly = industry.prop_to_perc(industry_rate)) %>% 
  ggplot(aes(y = rank,
             x = industry_rate,
             fill = industry,
             text = paste0('Mean proportion of people in ', industry, ': ', industry_rate_friendly))) +
  geom_bar(position = 'fill',
           stat = 'identity') +
  labs(title = 'Proportion of jobs by industry per state',
       subtitle = 'Comparing states with highest and lowest COVID-19 prevalence',
       x = 'Proportion of jobs in industry',
       y = 'State Category')

industry.compare_by_average_interactive <- ggplotly(industry.compare_by_average,
                                                    tooltip = c('text'))

industry.compare_by_table <- industry.data %>% 
  filter(rank %in% c(1:5, 31:50)) %>% 
  mutate(rank = ifelse(rank <= 5, 'Top 5 Highest Prevalence States', 'Top 20 Lowest Prevalence States')) %>% 
  group_by(rank, industry) %>% 
  summarize(industry_rate = mean(industry_rate)) %>%
  pivot_wider(names_from = rank,
              values_from = industry_rate) %>% 
  mutate(diff = `Top 20 Lowest Prevalence States` - `Top 5 Highest Prevalence States`) %>% 
  filter(abs(diff) > 0.01) %>% 
  mutate_if(is.numeric, industry.prop_to_perc) %>% 
  arrange(desc(diff)) %>% 
  rename(Industry = industry,
         Difference = diff)

