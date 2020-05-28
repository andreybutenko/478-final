library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)

industry_full_data <- read.csv('./data/prepped/industry-covid19-full-data.csv',
                               stringsAsFactors = F)

# Create a plot that compares the jobs by industry distribution in the top
# `num_rank` states and bottom `num_rank` states by COVID-19 prevalence through
# bar plots faceted by highest/lowest prevalence.
get_split_proportion_industry_plot <- function(df = industry_full_data,
                                               num_rank = 5,
                                               state_col = 'state',
                                               employment_sector_col = 'sector',
                                               num_employment_col = 'employment',
                                               prop_employment_col = 'prop_employment',
                                               perc_employment_col = 'perc_employment',
                                               prevalence_col = 'prevalence',
                                               prevalence_rank_col = 'prevalence_rank',
                                               plot_interactive = F) {
  df <- df %>% 
    rename(state = state_col,
           sector = employment_sector_col,
           num_employment = num_employment_col,
           prop_employment = prop_employment_col,
           perc_employment = perc_employment,
           prevalence = prevalence_col,
           prevalence_rank = prevalence_rank_col)
  
  res_plot <- df %>%
    filter(prevalence_rank %in% c(1:num_rank, (51 - num_rank):50)) %>%
    mutate(rank = ifelse(prevalence_rank <= 5, 'Highest Prevalence', 'Lowest Prevalence')) %>%
    ggplot(aes(y = state,
               x = prop_employment,
               fill = sector,
               text = paste0('<b>', sector, ' in ', state, '</b>\n',
                             'Jobs in industry: ', num_employment, '\n',
                             'Proportion of people in industry: ', perc_employment))) +
    geom_bar(position = 'fill',
             stat = 'identity') +
    labs(title = 'Proportion of jobs by industry per state',
         subtitle = 'Comparing states with highest and lowest COVID-19 prevalence',
         x = 'Proportion of jobs in industry',
         y = 'State') +
    facet_wrap(~rank,
               scales = "free_y")
  
  if(plot_interactive) {
    return(ggplotly(res_plot,
                    tooltip = c('text')))
  }
  
  res_plot
}

get_split_proportion_industry_plot(num_rank = 3, plot_interactive = F)


