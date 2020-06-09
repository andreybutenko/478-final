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
    theme = 'styles.css',
    'COVID-19 Transmission in Built Environments',
    
    tabPanel('Introduction',
             column(3),
             column(12 - (2 * 3),
                    includeMarkdown('content/intro.md'))),
    tabPanel('Transportation',
             h1("How Does Public Transportation Impact the Spread of COVID-19?"),
             p("People often rely on public transportation to get to work and have access to essential services. In a global pandemic, public
               transportation helped essential workers get to work, but it may also have impacted the transmission of COVID-19.In this
               analysis, we will explore how the build public transportation systems impact the transmission and rate of COVID-19. At
               both the state and city levels, we will explore how different public transportation infrastructures impact COVID-19 Spread."),
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
                plotOutput("Borough"),
                includeMarkdown('content/tab-transportation-conclusions.md')
              )
              
            )),
    tabPanel('Housing Density', # ------------------------------------------------------
             h1("How does housing structure environment affect the spread of disease?"),
             span("We consider how living conditions can affect the spread of COVID-19 by taking a look at the housing structure. We take a look at whether the number of units within an apartment or condo can affect the transmission of COVID-19, assuming that the more units there are the more chances there are for individuals to infect one another. We use the cumulative number of COVID hospitalizations, percentage of COVID deaths, and percentage of COVID tests that came out positive as measures of how severely a state is affected by COVID. We use the dataset from the Planning Database, which combines data from the 2010 census and the 2014-2018 American Community Survey data. Here is a link to the"),
             a("documentation of the Planning Database ", href="https://www.census.gov/content/dam/Census/topics/research/2020%20State%20and%20County%20PDB%20Documentation_V2.pdf"),
             p(),
             sidebarLayout(
               sidebarPanel(
                 selectInput('select_covid_metric',
                  "Covid Metric",
                  c("Cumulative hospitalizations due to COVID-19", "Percentage of deaths due to COVID", "Percentage of COVID tests that were positive")) #Covid_ICU_Cumulative
               ), #closes sidebarPanel
               mainPanel(
                 plotlyOutput('viz_housing_unit'),
                 div("The number of hospitalizations due to COVID, the percentages of deaths due to COVID, and the percentage of COVID tests that came out positive, plotted against the percentage of unit type (either a single unit, 2-9 units, or 10 units) in each region (state) does not seem to show any correlation. We also added in the state density to see if states that are denser are more likely to be more severely affected by COVID given COVID is transmitted via human to human interactions."),
                 p(),
                 div("New York was removed from the graph hospitalizations chart as the number of hospitalizations in New York were significantly higher (26,383 deaths) and deemed an anomaly (for the purposes of a better visualisation). A lot of the data were also missing for COVID hospitalizations across different states."),
                 p(),
                 div("Across all states, the percentage of single units is higher than the percentage of housing structures that have 2 to 9 units or 10 or more units. This is evident in how the data points are concentrated on the right side of the graph for the percentage single unit facet, while the percentage of houses with 2 to 9 units, or 10 or more units are more concentrated on the left hand side. "),
                 p(),
                 div("We must mention that the housing data is based on the 2010 census, and a lot of changes to the housing structure may have occurred since then. It was the most recent data that was available. We are also unable to tell how spread out the units are from one another, as well as the common facilities that are shared between the different house units; these are important factors in the analysis of how housing structure may affect the transmission of COVID-19 given that more shared facilities means individuals are more likely to interact with one another"),
                 hr(),
                 plotlyOutput('viz_housing_crowded'),
                 div("Comparing the percentage of COVID tests that turned out positive to the percentage of occupied housing that were crowded, we see that there seems to be no correlation between the two variables."),
                 p(),
                 div("")
               ) #closes main panel
             )#closes sidebarLayout
             ), #closes tabPanel Housing Density
    tabPanel('Influenza Correlations',
             h1('How does the volume of COVID-19 cases compare to that of seasonal influenza (2017-2018) in different parts of New York City?'),
             p('Places like New York City are vast, meaning that one can observe a diverse range of built environments accross its bouroughs. We thought that it would be interesting to compare early COVID-19 case counts to influenza case counts from the 2017-2018 season in different parts of NYC in order to help us think about how and why transmission rates might differ between different environments of a single city.'),
             plotOutput('influenza_covid_scatterplot'),
             hr(),
             h2('Contribution to COVID-19 and influenza cases by borough'),
             tableOutput('influenza_covid_table'),
             includeMarkdown('content/tab-influenza-conclusions.md')),
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
             column(3),
             column(12 - (2 * 3),
                    includeMarkdown('content/conclusions.md'))),
    tabPanel('About',
             includeHTML('content/about.html'),
             tags$div(includeMarkdown('content/sources.md'),
                      class = 'about-section about-sources'))
))
