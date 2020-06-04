#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

source('./scripts/tab-industries.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$industry_split <- renderPlotly({
    get_split_proportion_industry_plot(num_rank = input$industry_split_num_rank,
                                       sector_filter = input$industry_split_sector,
                                       plot_interactive = T)
  })
  
  industry_rank_proportion_df <- reactive({
    get_rank_proportion_industry_df(df = industry_full_data,
                                    num_top_rank = input$industry_rank_num_top,
                                    num_bot_rank = input$industry_rank_num_bot,
                                    sector_filter = input$industry_rank_split_sector)
  })
  
  output$industry_rank_viz <- renderPlotly({
    industry_rank_proportion_df() %>% 
      get_rank_proportion_industry_plot(plot_interactive = T)
  })
  
  output$industry_rank_table <- renderTable({
    industry_rank_proportion_df() %>% 
      get_rank_proportion_industry_diff_table(diff_threshold = input$industry_rank_diff_thresh / 100)
  })
})
