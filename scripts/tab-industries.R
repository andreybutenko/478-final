library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)

industry_full_data <- read.csv('./data/prepped/industry-covid19-full-data.csv',
                               stringsAsFactors = F)

industry_prop_to_perc <- function(x) {
  paste0(round(x * 100, 2), '%')
}

# Create a plot that compares the jobs by industry distribution in the top
# `num_rank` states and bottom `num_rank` states by COVID-19 prevalence through
# bar plots faceted by highest/lowest prevalence.
get_split_proportion_industry_plot <- function(df = industry_full_data,
                                               num_rank = 5,
                                               sector_filter = unique(industry_full_data$sector),
                                               plot_interactive = F) {
  res_plot <- df %>%
    filter(prevalence_rank %in% c(1:num_rank, (51 - num_rank):50),
           sector %in% sector_filter) %>%
    mutate(rank = ifelse(prevalence_rank <= num_rank, 'Highest Prevalence', 'Lowest Prevalence')) %>%
    ggplot(aes(y = state,
               x = prop_employment,
               fill = sector,
               text = paste0('<b>', sector, ' in ', state, '</b>\n',
                             'Jobs in industry: ', employment, '\n',
                             'Proportion of people in industry: ', perc_employment))) +
    geom_bar(position = 'fill',
             stat = 'identity') +
    labs(title = 'Proportion of jobs by industry per states of highest and lowest COVID-19 prevalence',
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


# Create a dataframe that reflects the average jobs by industry distribution
# across the top `num_top_rank` states for COVID-19 prevalence and across bottom
# `num_bot_rank` states for COVID-19 prevalence in particular sectors.
get_rank_proportion_industry_df <- function(df = industry_full_data,
                                            num_top_rank = 5,
                                            num_bot_rank = 20,
                                            sector_filter = unique(industry_full_data$sector)) {
  df <- df %>% filter(sector %in% sector_filter,
                      prevalence_rank %in% c(1:num_top_rank, (51 - num_bot_rank):50)) %>%
    mutate(rank = ifelse(prevalence_rank <= num_top_rank,
                         paste('Top', num_top_rank, 'Highest Prevalence States'),
                         paste('Bottom', num_bot_rank, 'Lowest Prevalence States')))
  
  total_employment_df <- df %>% 
    group_by(rank) %>% 
    summarize(total_employment = sum(as.numeric(employment)))
  
  industry_employment_df <- df %>% 
    group_by(rank, sector) %>% 
    summarize(employment = sum(employment))
  
  left_join(industry_employment_df, total_employment_df, by = 'rank') %>% 
    mutate(prop_employment = employment / total_employment,
           perc_employment = paste0(round(prop_employment * 100, 2), '%'))
}

# Create a plot that compares the average jobs by industry distribution across
# the top `num_top_rank` states for COVID-19 prevalence and across bottom
# `num_bot_rank` states for COVID-19 prevalence.
get_rank_proportion_industry_plot <- function(df,
                                              plot_interactive = F) {
  res_plot <- df %>%
    ggplot(aes(y = rank,
               x = prop_employment,
               fill = sector,
               text = paste0('<b>', sector, ' in ', rank, '</b>\n',
                             'Jobs in industry: ', employment, '\n',
                             'Proportion of people in industry across selected industries: ', perc_employment))) +
    geom_bar(position = 'fill',
             stat = 'identity') +
    labs(title = 'Average proportion of jobs by industry across states with highest and lowest COVID-19 prevalence',
         subtitle = 'Comparing states with highest and lowest COVID-19 prevalence',
         x = 'Proportion of jobs in industry',
         y = 'State')
  
  if(plot_interactive) {
    return(ggplotly(res_plot,
                    tooltip = c('text')))
  }
  
  res_plot
}

# Create a table that compares the average jobs by industry distribution between
# the top `num_top_rank` states for COVID-19 prevalence and the bottom
# `num_bot_rank` states for COVID-19 prevalence, with a `diff_threshold`
# to specify the minimum difference in job sector proportion required to display.
get_rank_proportion_industry_diff_table <- function(df,
                                                    diff_threshold = 0.01) {
  df <- df %>% 
    select(sector, rank, prop_employment) %>% 
    pivot_wider(names_from = rank,
                values_from = prop_employment)
  df[, 'diff'] <- df[, 2] - df[, 3]
  
  df %>%
    filter(abs(diff) > diff_threshold) %>%
    mutate_if(is.numeric, industry_prop_to_perc) %>%
    arrange(desc(diff)) %>%
    rename(Industry = sector,
           Difference = diff)
}
