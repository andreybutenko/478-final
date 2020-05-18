library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

density_data_original <- read.csv('../data/prepped/covid-19-density-data-prepped.csv', stringsAsFactors = F)
density_data <- density_data_original #for manip

# how many people are being tested
density_data = density_data[-33, ] #removes new york
density_data = density_data[-9, ] #removes DC

# plot density vs covid testing
density_viz <- ggplot(data = density_data,
       aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
           x = State_Density, 
           y = Covid_Total_Test_Results,
           colour = Covid_Positive_4_4,
           #fill = Covid_Positive
           text = paste("<b>Region: </b>", Region,
                        '<br><b>State Density: </b>', State_Density, 
                        '<br><b>Covid Total Test Results: </b>', Covid_Total_Test_Results,
                        '<br><b>Covid Positive Tests: </b>', Covid_Positive_4_4)
           )) +
  geom_point() +
  labs(x = "Density",
       y = "Total number of tests",
       colour = "Covid positive tests") +
  ggtitle("State density and total number of COVID-19 tests")

# with hoverover
density_viz_hover <- ggplotly(density_viz, tooltip="text") #how to include region

#final data
density_viz_hover



#NY and DC were removed as you wouldn't be able to see the rest of the data