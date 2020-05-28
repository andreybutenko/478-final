library(dplyr)
library(ggplot2)
library(tidyr)
library(plotly)
library(stringr)
library(readxl)

nyc_covid <- read.csv('./data/raw/NYC_Covid_by_ZipCode.csv', stringsAsFactors = F)

