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
                                 value = 5)
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
