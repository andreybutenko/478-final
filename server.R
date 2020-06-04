#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# library(dplyr)
# library(ggplot2)
# library(tidyr)
# library(plotly)

source('./scripts/tab-industries.R')
source('./scripts/tab-public-transportation.R')
source('./scripts/tab-housing.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$industry_split <- renderPlotly({
    get_split_proportion_industry_plot(num_rank = input$industry_split_num_rank,
                                       sector_filter = input$industry_split_sector,
                                       plot_interactive = T)
  })
  
  output$public_transportation <- renderPlot({
    # try out what was done for housing
  })
  output$nyc_covid <- renderPlot({
    p
  })
  
  
  #--- housing
  housingInput <- reactive({
    if ( "Perc_Covid_Positive" %in% input$select_covid_metric) return(viz_housing_unit_covidpos_hov)
    if ( "Covid_Hospitalized_Cumulative" %in% input$select_covid_metric) return(viz_housing_unit_covidhos)
    if( "Covid_ICU_Cumulative" %in% input$select_covid_metric) return(viz_housing_unit_coviddeath) 
  })
  
  output$viz_housing_unit <- renderPlotly({
    housingViz = housingInput()
    print(housingViz)
  })
  
})


#----------Housing Density-------------------------------------------------------------------------------------
# completed vizzes 
# viz_house_crowded
# viz_house_unit_covid_hover



