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

# Define UI for application that draws a histogram
shinyUI(navbarPage(
    'COVID-19 Transmission in Built Environments',
    
    tabPanel('Introduction',
             includeMarkdown('content/intro.md')),
    tabPanel('Transportation'),
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
             
             includeMarkdown('content/tab-industries-conclusions.md')),
    tabPanel('Conclusion',
             includeMarkdown('content/conclusions.md')),
    tabPanel('Sources',
             includeMarkdown('content/sources.md'))
))
