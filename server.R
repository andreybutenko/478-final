#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

source('./scripts/tab-industries.R')
source('exploratory/Commuting_Analysis.R')
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$industry_split <- renderPlotly({
    get_split_proportion_industry_plot(num_rank = input$industry_split_num_rank,
                                       sector_filter = input$industry_split_sector,
                                       plot_interactive = T)
  })
  
  output$public_transportation <- renderPlot({
    # Public Transportation Plot
    
    commuter_top_public_transit <- commuter_data_rate %>% 
      top_n(5, input$mode_of_transportation) %>% 
      select(Region, input$death_pos, input$mode_of_transportation) %>% 
      mutate(Top_value = T)
    
    commuter_bot_public_transit <- commuter_data_rate %>% 
      top_n(-5, input$mode_of_transportation) %>% 
      select(Region, input$death_pos, input$mode_of_transportation)%>% 
      mutate(Top_value = F) 
    
    commuter_top_and_bot <- full_join(commuter_bot_public_transit, commuter_top_public_transit) 
    commuter_top_and_bot_final <- arrange(commuter_top_and_bot, input$death_pos)
    
    public_transportation_Viz_final <- ggplot(commuter_top_and_bot_final, aes(x = reorder(Region, input$death_pos * 100), 
                                                                  y = input$death_pos, 
                                                                  fill = input$mode_of_transportation)) +
      geom_col() + scale_fill_gradient(low="white", high="darkblue") + 
      labs(
        x = "State",
        y = "Ratio of Population with COvid-19",
        fill = "Public Transportation Commuters") + theme_dark()
    
    public_transportation_Viz_final
    
    
  })
})
