#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

industry_full_data <- read.csv('./data/prepped/industry-covid19-full-data.csv',
                               stringsAsFactors = F)
source('exploratory/Commuting_Analysis.R')

# Define UI for application that draws a histogram
shinyUI(navbarPage(
    'COVID-19 Transmission in Built Environments',
    
    tabPanel('Introduction',
             includeMarkdown('content/intro.md')),
    tabPanel('Transportation',
            sidebarLayout(
              sidebarPanel(
                selectInput('mode_of_transportation',
                            'Select a Mode of Transportation',
                            choices = list("Drive" = "Drive_to_work_rate",
                                           "Public Transportation" = "Public_transportation_rate",
                                           "Walking" = "Walk_to_work_rate"),
                            selected = "Public_transportation_rate"),
                
                radioButtons("death_pos", "Select a Metric",
                             c("Covid Deaths" = "Covid_Mortality_rate",
                               "Covid Positive Cases" = "Covid_positive_rate"),
                             selected = "Covid_positive_rate")
                            
                
              ),
              mainPanel(
                
              )
              
            )),
    tabPanel('Housing Density'),
    tabPanel('Influenza Correlations'),
    tabPanel('Industries and Jobs',
             sidebarLayout(
                 sidebarPanel(
                     sliderInput('industry_split_num_rank',
                                 'Number of top states to show',
                                 min = 1,
                                 max = 20,
                                 value = 5),
                     selectInput('industry_split_sector',
                                 'Industries to include',
                                 choices = unique(industry_full_data$sector),
                                 selected = unique(industry_full_data$sector),
                                 selectize = T,
                                 multiple = T)
                 ),
                 mainPanel(
                     plotlyOutput('industry_split',
                                  height="60vh")
                 )
             )),
    tabPanel('Conclusion',
             includeMarkdown('content/conclusions.md')),
    tabPanel('Sources',
             includeMarkdown('content/sources.md'))
))
