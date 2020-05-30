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
    # Public Transportation Plot
    
    # sort by top public transportation rates
    commuter_top_public_transit <- commuter_data_rate %>% 
      top_n(5, input$mode_of_transportation) %>% 
      select(Region, input$death_pos, input$mode_of_transportation)
    print(commuter_top_public_transit) # test code
    
    # sort by bottom public transportation rates
    
    commuter_bot_public_transit <- commuter_data_rate %>% 
      top_n(-5, input$mode_of_transportation) %>% 
      select(Region, input$death_pos, input$mode_of_transportation)
    
    # combine information with boolean to color-sort by top and bottom
    
    commuter_top_and_bot <- full_join(commuter_bot_public_transit, commuter_top_public_transit) 
    
    public_transportation_viz <- ggplot(commuter_top_and_bot, aes(x = reorder(Region, input$death_pos), 
                                                                  y = input$death_pos, 
                                                                  fill = input$mode_of_transportation)) +
      geom_col() + scale_fill_gradient(low="white", high="darkblue") + 
      labs(
        x = "State",
        y = "Ratio of Population with COvid-19",
        fill = "Public Transportation Commuters") + theme_dark()
  })
  
  
  #--- housing
  housingInput <- reactive({
    if ( "Perc_Covid_Positive" %in% input$select_covid_metric) return(viz_housing_unit_covidpos_hov)
    if ( "Covid_Hospitalized_Cumulative_4_4" %in% input$select_covid_metric) return(viz_housing_unit_covidhos)
    if( "Covid_ICU_Cumulative_4_4" %in% input$select_covid_metric) return(viz_housing_unit_coviddeath) 
  })
  
  output$viz_housing_unit <- renderPlotly({
    housingViz = housingInput()
    print(housingViz)
  })

  # output$viz_housing_unit <- renderPlotly({
  #   viz_house_unit_covid_shiny <- ggplot(data = df_house_covid_units,
  #                                        aes(label = Region,
  #                                            x = percentages ,
  #                                            y = Covid_ICU_Cumulative_4_4,
  #                                            # y = (input$covid_metric),
  #                                            #y = Perc_Covid_Positive, #input$covid_metric,
  #                                            #color = unit,
  #                                            color = State_Density,
  #                                            text = paste("<b>Region: </b>", Region,
  #                                                         '<br><b>State Density</b>', State_Density,
  #                                                         '<br><b>Percentage of tests COVID_Positive </b>', round(Perc_Covid_Positive, 2), "%",
  #                                                         '<br><b>Percentage of unit type in Region</b>', round(percentages, 2),'%'
  #                                            ) #closes text
  #                                        ) #closes aes
  # ) + #closes ggplot
  # #geom_smooth(method="lm") +
  # geom_point() + #facet_grid(~unit) +
  # ggtitle("Housing Unit and COVID Positive Tests") +
  # xlab("Percentage of unit type (per region)")
  # 
  # viz_house_unit_covid_shiny_hover <-
  #   ggplotly(viz_house_unit_covid_shiny, tooltip="text") #include region
  # 
  # viz_house_unit_covid_shiny_hover
  # })
  
  
})


#----------Housing Density-------------------------------------------------------------------------------------
# completed vizzes 
# viz_house_crowded
# viz_house_unit_covid_hover



