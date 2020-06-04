library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)

nyc_influenza_covid_data <- read.csv('./data/prepped/nyc_influenza_covid_df', stringsAsFactors = F)

# Reshape dataframe

nyc_flu_covid_reshaped <- nyc_influenza_covid_data %>%
  gather(
    key = "Illness",
    value = "Case Count",
    -County
  ) 

# Bar plot of 2018-2019 influenza season cases by NYC county vs. COVID-19 cases by county

influenza_v_covid_barplot <- ggplot(data = nyc_flu_covid_reshaped,
                                    aes(fill = nyc_flu_covid_reshaped$Illness, 
                                        x = nyc_flu_covid_reshaped$County, 
                                        y = nyc_flu_covid_reshaped$`Case Count`)) +
  geom_bar(position="dodge", stat="identity") +
  labs(
    title = "Comparing Influenza (2018-2019) and COVID-19 by NYC County",
    x = "NYC County",
    y = "Case Count"
  ) +
  theme(
    axis.text.x = element_text(angle = 45)
  ) +
  scale_fill_discrete(
    name = "Illness",
    labels = c("Influenza (2018-2019)", "COVID-19")
  )

# Scatterplot of influenza cases in NYC counties vs. covid cases in NYC counties
