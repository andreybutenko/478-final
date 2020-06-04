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
                selectInput('transportation_metric',
                            label = 'Select a Method of Commuting to Work',
                            choices = list("Public Transportation", 
                                           "Drive")), width = 3
              ),
              mainPanel(
                plotlyOutput("transportation", width = "1000px"),
                plotOutput("nyc_covid"),
                plotOutput("Borough")
              )
              
            )),
    tabPanel('Housing Density', # ------------------------------------------------------
             sidebarLayout(
               sidebarPanel(
                 selectInput('select_covid_metric',
                  "Covid_Metric",
                  c("Covid_Hospitalized_Cumulative", "Covid_ICU_Cumulative", "Perc_Covid_Positive"))
               ), #closes sidebarPanel
               mainPanel(
                 plotlyOutput('viz_housing_unit'),
                 "some text here"
               ) #closes main panel
             )#closes sidebarLayout
             ), #closes tabPanel Housing Density
    tabPanel('Influenza Correlations'),
    tabPanel('Industries and Jobs',
             h1('How does the job environment affect the spread of disease?'),
             p('COVID-19 can spread quickly though a workplace. Workplaces differ across industries, and some workplaces are easier implement socially-distancing measures in than others. For this reason, it is valuable to explore the industries residents of different states are employed in to understand the relationship. In this, we will compare the proportions of industry of employment between the states with the highest COVID-19 prevalence and the states with the lowest COVID-19 prevalence.'),
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
             ),
             
             hr(),
             
             sidebarLayout(
                 sidebarPanel(
                     sliderInput('industry_rank_num_top',
                                 'Number of states with top COVID-19 prevalence to show',
                                 min = 1,
                                 max = 20,
                                 value = 5),
                     sliderInput('industry_rank_num_bot',
                                 'Number of states with lowest COVID-19 prevalence to show',
                                 min = 1,
                                 max = 30,
                                 value = 20),
                     sliderInput('industry_rank_diff_thresh',
                                 'Threshold for differences to show in table',
                                 min = 0,
                                 max = 20,
                                 step = 0.5,
                                 value = 1,
                                 post = '%'),
                     selectInput('industry_rank_split_sector',
                                 'Industries to include',
                                 choices = unique(industry_full_data$sector),
                                 selected = unique(industry_full_data$sector),
                                 selectize = T,
                                 multiple = T)
                 ),
                 mainPanel(
                     plotlyOutput('industry_rank_viz'),
                     tableOutput('industry_rank_table')
                 ),
             ),
             
             hr(),
             
             column(3, plotOutput('industry_covid19_prev_dist_viz')),
             column(12 - 3, includeMarkdown('content/tab-industries-conclusions.md'))),
    tabPanel('Conclusion',
             includeMarkdown('content/conclusions.md')),
    tabPanel('Sources',
             includeMarkdown('content/sources.md'))
))
