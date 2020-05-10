# INFO 478 Final Project Proposal

**Team Members:** Andrey Butenko, Briana Lincoln, Shivank Mistry, Peach Saengcharoentrakul

## Directory Structure

- `/`: Root directory contains our Shiny app and all subdirectories.
- `data/`: All data files.
  - `data/raw/`: All raw data files. For example, a .csv or .xlsx file directly from our source would go here.
  - `data/semiprepped/`: All semi-prepped data files. For example, if you have converted an Excel spreadsheet to a .csv file without any additional cleaning or standardization, it would go here.
  - `data/prepped/`: All prepped data files. These should be clean, standardized, and ready for data analysis.
- `exploratory/`: Code for the exploratory data analysis assignment.
- `preprocessing/`: Code to clean, convert, or standardize data to make it prepped.
- `scripts/`: Helper files or code for the Shiny app.

## Project Description

### Purpose

To understand how the built environment affects the transmission of disease.

### Previous Research

- How subway seating affected COVID-19 transmission (https://www.nber.org/papers/w27021)
  - This study argues that the principal device of transmission for COVID-19 was the New York City subway system. In a city defined by its commuter culture and public transportation infrastructure, the issue of shared space with the public may have been a leading factor in the rapid spread of this transmissible disease.
- Public transport and airborne transmission (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6280530/)
  - This study examined how public transportation usage links to the spread of airborne infections. Electronic ticket data was used to infer routes, a model was used to assess transmission, and this was analyzed alongside public health data to conclude that there is a link between public transit usage and disease transmission in London.
- The impact of the built environment on health behaviours and disease transmission in social systems (https://royalsocietypublishing.org/doi/full/10.1098/rstb.2017.0245)
  - This study analyzes specific cases in human populations where the built environment affected the prevention and containment of transmissible disease. By compiling several case studies, this paper hopes to highlight the importance of the built environment in public health.
- Understanding Infectious Disease Transmission in Urban Built Environments
  (https://www.ncbi.nlm.nih.gov/books/NBK507339/) - This resource describes the process of disease transmission through airborne routes, close-contact routes, and fomite routes (contaminated surfaces). They used this understanding and cell phone data to find how malaria spread in Kenya, and make conclusions about how the design of urban centers affects transmission.

### Datasets

- Compiled resources for environmental health dataset (https://www.cdc.gov/nceh/data.htm)
  - These resources include datasets from the NCEH, CDC, EPA, Department of Labor, and others. These resources include data about different
- 2018 Annual Public Transit Database Service (https://www.transit.dot.gov/ntd/data-product/2018-annual-database-service)
  - The Federal Transit Administration, part of the US Department of Transportation, collects information about the number of vehicles, service times, ridership, etc. for every public transit agency. This will be useful in assessing how public transit, part of the urban environment, affects the transmission of disease.
- US COVID-19 Compiled Dataset with Risk Factors (including transportation and housing characteristics) (https://www.kaggle.com/jtourkis/covid19-us-major-city-density-data)
  - This is an aggregated dataset on COVID-19. Aside from COVID-19 statistics, it also includes data on other risk factors such as housing structure and means of work transportation data, which is relevant to our research questions. Takes data from CDC, the Census, and a few other sources (all of the original sources are listed in the dataset).
- U.S. Department of Housing and Urban Development Promise Zones (https://hudgis-hud.opendata.arcgis.com/datasets/promise-zones)
  - Promise Zones are high poverty communities where the federal government partners with local leaders to increase economic activity, improve educational opportunities, leverage private investment, reduce violent crime, enhance public health and address other priorities identified by the community.

### Target Audience

City officials (including city planners and public health officials) who seek to understand what public facilities should be opened and closed during an epidemic, and how cities should be designed to better control the spread of epidemics in the future.

### Specific Questions:

- How does public transportation infrastructure affect disease transmission?
  - For example, compare New York City and Los Angeles – large cities with very different modes of transportation – in terms of how many people get sick during epidemics.
- How does the density of public parks and recreational facilities affect disease transmission?
  - How does disease transmission affect elderly individuals differently based on whether they live in a high-density location (tending to live in common facilities) or a low-density location (tending to live with family)?
- How did usage of hotels as either quarantine or de-intensification facilities for homeless populations affect the transmission of COVID-19?
  - May not be feasible, as there’s generally insufficient data about public health in homeless populations.

## Technical Description

### Format

Shiny App

### Anticipated Data Challenges / Major Challenges:

- These datasets could be huge, making Shiny run slowly. It will be important for us to subset our datasets to only include the relevant data for any particular visualization.
- With COVID-19 data collections, different states, counties, and cities have different standards for counting cases and collecting information. When comparing cities or joining multiple datasets, we will need to account for these irregularities.
- It may be challenging to find quantitative datasets about qualitative features like built environment, culture around elderlycare, etc.

### Technical Skills Needed

- Working with geographic data in R.
- Cleaning, wrangling, and working with irregular datasets.
- Overcoming version control anxiety.

## Project Setup

GitHub repo: https://github.com/andreybutenko/478-final
