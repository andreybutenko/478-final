library(dplyr)
library(ggplot2)
library(tidyr)
library(readxl)
library(maps)
commuter_data <- read.csv('../data/prepped/covid-19-commuter-data-prepped.csv', stringsAsFactors = F)

# create rate data
commuter_data <- commuter_data %>% 
  mutate(Covid_positive_rate  = Covid_Positive_4_4 / Total_Population_2010,
         Covid_death_rate = Covid_positive_rate / Total_Population_2010,
         Covid_Mortality_rate = Covid_Death_4_4 / Covid_Positive_4_4)

# sort by top public transportation rates
commuter_top_public_transit <- commuter_data %>% 
  top_n(5, Public_transportation_rate) %>% 
  select(Region, Covid_positive_rate, Public_transportation_rate) %>% 
  mutate(Top_value = T)

# sort by bottom public transportation rates
commuter_bot_public_transit <- commuter_data %>% 
  top_n(-5, Public_transportation_rate) %>% 
  select(Region, Covid_positive_rate, Public_transportation_rate)%>% 
  mutate(Top_value = F) 
# combine information with boolean to color-sort by top and bottom
commuter_top_and_bot <- full_join(commuter_bot_public_transit, commuter_top_public_transit) 
commuter_top_and_bot <- arrange(commuter_top_and_bot, Covid_positive_rate)

public_transportation_Viz <- ggplot(commuter_top_and_bot, aes(x = reorder(Region, Covid_positive_rate * 100), 
                                                              y = Covid_positive_rate, 
                                                              fill = Public_transportation_rate)) +
                                  geom_col() + scale_fill_gradient(low="white", high="darkblue") + 
                              labs(x = "State",
                                   y = "Rate of Population with COvid-19") + theme_dark()


