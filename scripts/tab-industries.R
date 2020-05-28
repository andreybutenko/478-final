library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)

industry_full_data <- read.csv('./data/prepped/industry-covid19-full-data.csv',
                               stringsAsFactors = F)

get_split_proportion_industry_plot <- function(df = industry_full_data,
                                               state_col = 'state',
                                               employment_sector_col = 'sector',
                                               prop_employment_col = 'prop_employment',
                                               perc_employment_col = 'perc_employment',
                                               prevalence_col = 'prevalence') {
  df <- df %>% 
    rename(state = state_col,
           sector = employment_sector_col,
           prop_employment = prop_employment_col,
           perc_employment = perc_employment,
           prevalence = prevalence_col) %>% 
    arrange(desc(prevalence))
  
  rank_df <- data.frame(
    state = unique(df$state),
    rank = length(unique(df$state)),
    stringsAsFactors = F
  )
  
  rank_df
}

get_split_proportion_industry_plot()


