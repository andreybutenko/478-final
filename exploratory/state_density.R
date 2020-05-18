library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

density_data_original <- read.csv('../data/prepped/covid-19-density-data-prepped.csv', stringsAsFactors = F)
density_data <- density_data_original #for manip

# how many people are being tested
# density_data = density_data[-33, ] #removes new york
# density_data = density_data[-9, ] #removes DC

# plot density vs covid testing
density_viz <- ggplot(data = density_data,
       aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
           x = State_Density, 
           y = Covid_Total_Test_Results,
           colour = Covid_Positive_4_4,
           #fill = Covid_Positive
           text = paste("<b>Region: </b>", Region,
                        '<br><b>State Density (people per square mile) </b>', State_Density, 
                        '<br><b>Covid Total Test Results: </b>', Covid_Total_Test_Results,
                        '<br><b>Covid Positive Tests: </b>', Covid_Positive_4_4)
           )) +
  geom_point() +
  labs(x = "State Density (people per square mile)",
       y = "Total number of tests",
       colour = "Covid positive tests") +
  ggtitle("State density and total number of COVID-19 tests")

# with hoverover
density_viz_hover <- ggplotly(density_viz, tooltip="text") #how to include region

#final data
density_viz_hover

#NY and DC were removed as you wouldn't be able to see the rest of the data

#route two; percentages
density_viz_percent <- ggplot(data = density_data,
                      aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
                          x = State_Density, 
                          y = (Covid_Positive_4_4 / Covid_Total_Test_Results),
                          # colour = Covid_Positive_4_4,
                          #fill = Covid_Positive
                          text = paste("<b>Region: </b>", Region,
                                       '<br><b>State Density (people per square mile): </b>', State_Density, 
                                       '<br>Percentage of tests positive: </b>', round((Covid_Positive_4_4 *100/ Covid_Total_Test_Results), 2), '%'
                                       # '<br><b>Covid Total Test Results: </b>', Covid_Total_Test_Results,
                                       # '<br><b>Covid Positive Tests: </b>', Covid_Positive_4_4
                                       )
                      )) +
  geom_point() +
  labs(x = "State Density (people per square mile)",
       y = "% of COVID-19 tests positive") +
  ggtitle("State density and percentage of positive COVID-19 tests")

# with hoverover
density_viz_percent_hover <- ggplotly(density_viz_percent, tooltip="text") #how to include region


#with both; percentage in hover over
density_viz_perc <- ggplot(data = density_data,
                      aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
                          x = State_Density, 
                          y = Covid_Total_Test_Results,
                          colour = Covid_Positive_4_4,
                          #fill = Covid_Positive
                          text = paste("<b>Region: </b>", Region,
                                       '<br><b>State Density (people per square mile): </b>', State_Density, 
                                       '<br><b>Covid Total Test Results: </b>', Covid_Total_Test_Results,
                                       '<br><b>Covid Positive Tests: </b>', Covid_Positive_4_4,
                                       '<br><b>Percentage of tests positive: </b>', round((Covid_Positive_4_4 *100/ Covid_Total_Test_Results), 2), '%')
                      )) +
  geom_point() +
  labs(x = "State Density (people per square mile)",
       y = "Total number of tests",
       colour = "Covid positive tests") +
  ggtitle("State density and total number of COVID-19 tests")

# with hoverover
density_viz_perc_hover <- ggplotly(density_viz_perc, tooltip="text") #how to include region
density_viz_perc_hover

#--- now for ages
#route two; percentages
density_viz_age <- ggplot(data = density_data,
                              aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
                                  x = (Census_Population_Over_60/CENSUS_2010_TOTAL_POPULATION), 
                                  y = (Covid_Positive_4_4 / Covid_Total_Test_Results),
                                  colour = Covid_Death_4_4,
                                  #fill = Covid_Positive
                                  text = paste("<b>Region: </b>", Region,
                                               '<br><b>Percentage of people over sixty: </b>', round((Census_Population_Over_60*100/CENSUS_2010_TOTAL_POPULATION), 2), '%', 
                                               '<br>Percentage of tests positive: </b>', round((Covid_Positive_4_4 *100/ Covid_Total_Test_Results), 2), '%'
                                               # '<br><b>Covid Total Test Results: </b>', Covid_Total_Test_Results,
                                               # '<br><b>Covid Positive Tests: </b>', Covid_Positive_4_4
                                  )
                              )) +
  geom_point() +
  labs(x = "% Of Population Over 60",
       y = "% COVID Positive Tests",
       colour = "Number of COVID Deaths") +
  ggtitle("% Population Over 60 versus % COVID-19 tests positive")

# with hoverover
density_viz_age_hover <- ggplotly(density_viz_age, tooltip="text") #how to include region


density_viz_age_hover
