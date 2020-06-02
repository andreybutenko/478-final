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
library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

industry_full_data <- read.csv('./data/prepped/industry-covid19-full-data.csv',
                               stringsAsFactors = F)
source('exploratory/Commuting_Analysis.R')

industry_full_data <- read.csv('./data/prepped/industry-covid19-full-data.csv',
                               stringsAsFactors = F)

#df_raw_housing <- read.csv('./data/prepped/housingPlanningDBclean.csv', stringsAsFactors = F)
# df_covid <- read.csv('./data/prepped/covid-19-density-data-prepped.csv',stringsAsFactors = F)

#source('preprocessing/housing-characteristics.R')

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
                            choices = list("Drive" = 'Drive_to_work_rate',
                                           "Public Transportation" = 'Public_transportation_rate',
                                           "Walking" = 'Walk_to_work_rate')),
                
                radioButtons("death_pos", "Select a Metric",
                             c("Covid Deaths" = 'Covid_death_rate',
                               "Covid Positive Cases" = 'Covid_positive_rate')
                             )
                            
                
              ),
              mainPanel(
                plotOutput("public_transportation"),
                plotOutput("nyc_covid")
              )
              
            )),
    tabPanel('Housing Density', # ------------------------------------------------------
             sidebarLayout(
               sidebarPanel(
                 selectInput('select_covid_metric',
                  "Covid_Metric",
                  c("Covid_Hospitalized_Cumulative_4_4", "Covid_ICU_Cumulative_4_4", "Perc_Covid_Positive"))
               ), #closes sidebarPanel
               mainPanel(
                 plotlyOutput('viz_housing_unit'),
                 "some text here"
               ) #closes main panel
             )#closes sidebarLayout
             ), #closes tabPanel Housing Density
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
