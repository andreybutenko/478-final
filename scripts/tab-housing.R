# load libraries ------
library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)

# reference codes ------------------------------------------------------
# round((Covid_Positive_4_4 *100/ Covid_Total_Test_Results), 2)

# #https://www.census.gov/hhes/www/housing/census/histcensushsg.html ---------------------------------------------------------------------------------------------------
# df_housing_occupants1 <- read.table("../data/raw/units2000.txt", header=FALSE, fill=T, skip=3) 
# 
# df_housing_occupants1_cleaned <- df_housing_occupants1[, c(-2, -4, -6, -8, -10, -12)]
# 
# df_housing_occupants1_cleaned <- rename(df_housing_occupants1_cleaned,
#                                 "Location" = "V1",
#                                 "1-detached" = "V3",
#                                 "1-attached" = "V5",
#                                 "2-to-4" = "V7",
#                                 "5-or-more" = "V9",
#                                 "mobile-home" = "V11",
#                                 "other" = "V13"
#                                 )
# 
# View(df_housing_occupants1_cleaned)

# # https://www.census.gov/housing/census/data/crowding/crowding2000.txt ---------------------------------------------------------------------------------------------------
# df_housing_crowding <- read.table("../data/raw/crowding2000.txt", header=FALSE, fill=T, skip= 5, stringsAsFactors = F) 
# df_housing_crowding_cleaned <- rename(df_housing_crowding,
#                                         "Location" = "V1",
#                                         "All_occupied_housing_units" = "V2",
#                                         "Crowded" = "V3", #-(1.01-or-more)
#                                         "Severely_crowded" = "V5" #-(1.51-or-more)
#                                       )
# 
# #getting rid of % rows
# df_housing_crowding_cleaned <- df_housing_crowding_cleaned[, c(-4, -6)]
# 
# #convert to numbers
# # df_housing_crowding_cleaned[, c(2:4)] <- lapply(df_housing_crowding_cleaned[, c(2:4)], as.numeric)
# #as.numeric(as.character(df_housing_crowding_cleaned$All_occupied_housing_units))
# #typeof(df_housing_crowding_cleaned[1,3])
# #df_housing_crowding_cleaned$severely_crowded_percent <- df_housing_crowding_cleaned$Severely_crowded / df_housing_crowding_cleaned$All_occupied_housing_units
# #View(df_housing_crowding_cleaned)

# https://catalog.data.gov/dataset/census-planning-database-tract-housing-unit ---------------------------------------------------------------------------------------------------
# https://data.ct.gov/Government/Census-Planning-Database-Tract-Housing-Unit/ha8i-cbc7
df_housing_conneticut <- read.csv("./data/raw/Census_Planning_Database_-_Tract_-_Housing_Unit.csv", stringsAsFactors = FALSE)

# https://www.census.gov/content/dam/Census/topics/research/2020%20State%20and%20County%20PDB%20Documentation_V2.pdf ------------------------------------------------------------------
df_census_planningDB <- read.csv("./data/raw/pdb2020stcov2_us.csv", stringsAsFactors = FALSE)

colnames(df_census_planningDB)

df_census_planningDB_selected <- df_census_planningDB %>%
  select(
    State_name,
    URBANIZED_AREA_POP_CEN_2010, #Population living in a densely settled area containing 50k+ people
    URBAN_CLUSTER_POP_CEN_2010, #2.5-49k
    RURAL_POP_CEN_2010, #rural
    Tot_Population_CEN_2010, #Total population in the 2010 Census
    #Sngl_Prns_HHD_ACS_14_18, #Single Person households in the ACS
    Sngl_Prns_HHD_CEN_2010, #Single Person households in the 2010 Census
    Tot_Prns_in_HHD_CEN_2010, #Total Persons in households in the 2010 Census
    #Tot_Prns_in_HHD_ACS_14_18, #Total Persons in households in the ACS
    Tot_Housing_Units_CEN_2010,  #Total Housing Units in the 2010 Census
    Tot_Occp_Units_ACS_14_18, #for ACS
    Tot_Occp_Units_CEN_2010, #Total Occupied Housing Units in the 2010 Census
    Single_Unit_ACS_14_18, #Housing units in structures containing only 1 housing unit in the ACS
    MLT_U2_9_STRC_ACS_14_18,  #Housing units in structures containing two to nine housing units in the ACS
    MLT_U10p_ACS_14_18, #Housing units in structures containing10 or more housing units in the ACS
    Mobile_Homes_ACS_14_18 , #Mobile Homes in the ACS
    Crowd_Occp_U_ACS_14_18, #Occupied Units with more than 1.01 persons per room in the ACS
    Tot_Housing_Units_ACS_14_18
  )

# View(df_census_planningDB_selected)

df_census_planningDB_cleaned <- df_census_planningDB_selected %>%
  group_by(State_name) %>%
  summarise_each(funs(sum(., na.rm = TRUE)))

# View(df_census_planningDB_cleaned)

# #saving
# write.csv(df_census_planningDB_cleaned, '../data/prepped/housingPlanningDB_cleaned.csv', row.names = F)
# View(df_census_planningDB_cleaned)

# load housing data ------------------------------------------------------
# ==================================================================================================
# ==================================================================================================
# ==================================================================================================
# ==================================================================================================
# ==================================================================================================
# ==================================================================================================
# ==================================================================================================
# ==================================================================================================
# df_raw_housing <- read.csv('./data/prepped/housingPlanningDBclean.csv', stringsAsFactors = F)

df_raw_housing <- df_census_planningDB_cleaned

#remove puerto rico
df_raw_housing <- df_raw_housing[-40, ] 

#rename column
df_raw_housing <- df_raw_housing %>%
  rename(
    Region = State_name
  ) 

# load covid data ------------------------------------------------------
df_covid <- read.csv('./data/prepped/covid-19-density-data-prepped.csv',
                               stringsAsFactors = F)

# join covid and housing datasets -------------------------------- 
df_covid_housing <- left_join(df_raw_housing, df_covid, by="Region")


# to percentages for the first part  ---------------------------------------
df_house_covid_perc <- df_covid_housing %>%
  mutate(
    Perc_Single_Unit = (Single_Unit_ACS_14_18 * 100 / Tot_Housing_Units_ACS_14_18),
    Perc_2to9_Unit = (MLT_U2_9_STRC_ACS_14_18 * 100/ Tot_Housing_Units_ACS_14_18),
    Perc_10_Unit = (MLT_U10p_ACS_14_18 * 100/ Tot_Housing_Units_ACS_14_18),
    Perc_Crowded = (Crowd_Occp_U_ACS_14_18 * 100/ Tot_Occp_Units_ACS_14_18),
    Perc_Covid_Positive = (Covid_Positive_4_4 * 100/ Covid_Total_Test_Results),
    Perc_Covid_Deaths = (Covid_Death_4_4 * 100 / Covid_Total_Test_Results)
  )

# ----
df_house_covid_units <- df_house_covid_perc %>%
  select(Region, State_Density, Perc_Covid_Deaths, Covid_Hospitalized_Cumulative_4_4, Covid_ICU_Cumulative_4_4, Perc_Single_Unit, Perc_2to9_Unit, Perc_10_Unit, Perc_Crowded, Perc_Covid_Positive) %>%
  gather(key = unit, value = percentages, Perc_Single_Unit:Perc_10_Unit)


# viz -------------------------------------------------------------------
viz_house_unit_covid <- ggplot(data = df_house_covid_units,
       aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
           x = percentages , 
           y = Perc_Covid_Positive, 
           #color = unit,
           color = State_Density,
           text = paste("<b>Region: </b>", Region,
                        '<br><b>State Density</b>', State_Density,
                        '<br><b>Percentage of tests COVID_Positive </b>', round(Perc_Covid_Positive, 2), "%",
                        '<br><b>Percentage of unit type in Region</b>', round(percentages, 2),'%'
                      ) #closes text
           ) #closes aes
       ) + #closes ggplot
  geom_smooth(method="lm") +
  geom_point() + facet_grid(~unit) +
  ggtitle("Housing Units and COVID Positive Tests") +
  xlab("Percentage of unit type in region") +
  ylab("Percentage of COVID Positive Tests")

viz_house_unit_covid_hover <- 
  ggplotly(viz_house_unit_covid, tooltip="text") #include region

# viz_house_unit_covid_hover

#problems: reordering, can't get geom_smooth

# view data ------------------------------------------------------
# View(df_covid)
# View(df_raw_housing)
# View(df_covid_housing)
# View(df_house_covid_perc)
View(df_house_covid_units)

##### bar graph viz
df_house_covid_perc_10 <- df_house_covid_perc %>%
  arrange(-Perc_Covid_Positive) %>%
  top_n(10)

viz_house_unit_bar <- ggplot(data = df_house_covid_perc_10,
                             aes(x = reorder(Region, Perc_10_Unit), y = Perc_10_Unit, fill = Perc_Covid_Positive)) + 
  geom_bar(stat = "identity") + ggtitle("Region, percentage unit and Covid Tests") +xlab("Region") + ylab("Percentage_10_unit")
  
#View(df_house_covid_perc)
# viz_house_unit_bar

# test <- ggplot(data = df_house_covid_perc,
#                aes(x = Perc_10_Unit, y = Perc_Covid_Positive)
#                ) + geom_point()
# test


# second visualisation but for crowding ------------------------------------------------------
#The percentage of ACS occupied housing units that have more than 1.01 persons per room
viz_house_crowded <- ggplot(data = df_house_covid_units,
       aes(x = Perc_Crowded, y = Perc_Covid_Positive)
       ) + geom_point() +
  ggtitle("Housing units that are crowded compared to COVID positive tests") +
  xlab("Percentage of occupied housing units that are crowded") +
  ylab("Percentage of Covid Positive Tests") + geom_smooth()

# viz_house_crowded


#----- final visualisations
# viz_house_crowded
#

# viz_house_unit_covid_hover
# Analysis -----
# Single units are more common
# 2-9 and 10 c=occupants per unit is uncommon
# seems to be no relationship between the housing unit and covid-positive tests

# Limitations -----
# data too granular, hard to tell state_density
# old housing data from 2010; latest one. makes it hard to compare
# can't tell how spread out the units are and the common facilities that are shared

# viz_house_unit_bar
# Region, covid-positive tests and percentage of 10 units


#====== =REACTIVE

viz_housing_unit_covidpos <- ggplot(data = df_house_covid_units,
                               aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
                                   x = percentages , 
                                   y = Perc_Covid_Positive, 
                                   #color = unit,
                                   color = State_Density,
                                   text = paste("<b>Region: </b>", Region,
                                                '<br><b>State Density</b>', State_Density,
                                                '<br><b>Percentage of tests COVID_Positive </b>', round(Perc_Covid_Positive, 2), "%",
                                                '<br><b>Percentage of unit type in Region</b>', round(percentages, 2),'%'
                                   ) #closes text
                               ) #closes aes
) + #closes ggplot
  #geom_smooth(method="lm") +
  geom_point() + facet_grid(~unit) +
  ggtitle("Housing Units and COVID Positive Tests") +
  xlab("Percentage of unit type in region") +
  ylab("Percentage of COVID Positive Tests")

viz_housing_unit_covidpos_hov <- 
  ggplotly(viz_housing_unit_covidpos, tooltip="text") #include region

# === TWO
viz_housing_unit_covidhos <- ggplot(data = df_house_covid_units,
                                    aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
                                        x = percentages , 
                                        y = Covid_Hospitalized_Cumulative_4_4, 
                                        #color = unit,
                                        color = State_Density,
                                        text = paste("<b>Region: </b>", Region,
                                                     '<br><b>State Density</b>', State_Density,
                                                     '<br><b>Percentage of tests COVID_Positive </b>', round(Perc_Covid_Positive, 2), "%",
                                                     '<br><b>Percentage of unit type in Region</b>', round(percentages, 2),'%'
                                        ) #closes text
                                    ) #closes aes
) + #closes ggplot
  #geom_smooth(method="lm") +
  geom_point() + facet_grid(~unit) +
  ggtitle("Housing Units and COVID Positive Tests") +
  xlab("Percentage of unit type in region") +
  ylab("Number of COVID Hospitalizations")

viz_housing_unit_covidhos_hov <- 
  ggplotly(viz_housing_unit_covidhos, tooltip="text") #include region

#=== three
# === TWO
viz_housing_unit_coviddeath <- ggplot(data = df_house_covid_units,
                                    aes(label = Region, #if text, no title; https://stackoverflow.com/questions/36325154/how-to-choose-variable-to-display-in-tooltip-when-using-ggplotly
                                        x = percentages , 
                                        y = Perc_Covid_Deaths, 
                                        #color = unit,
                                        color = State_Density,
                                        text = paste("<b>Region: </b>", Region,
                                                     '<br><b>State Density</b>', State_Density,
                                                     '<br><b>Percentage of tests COVID_Positive </b>', round(Perc_Covid_Positive, 2), "%",
                                                     '<br><b>Percentage of unit type in Region</b>', round(percentages, 2),'%'
                                        ) #closes text
                                    ) #closes aes
) + #closes ggplot
  #geom_smooth(method="lm") +
  geom_point() + facet_grid(~unit) +
  ggtitle("Housing Units and COVID Positive Tests") +
  xlab("Percentage of unit type in region") +
  ylab("Percentage of COVID Deaths")

viz_housing_unit_coviddeath_hov <- 
  ggplotly(viz_housing_unit_coviddeath, tooltip="text") #include region
