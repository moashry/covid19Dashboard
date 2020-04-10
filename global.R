# ---- Loading libraries ----

library(shiny)
library(plotly)
library("readxl")
library("shiny")
library("shinydashboard")
library("tidyverse")
library("leaflet")
library("plotly")
library("DT")
library("fs")
library("wbstats")
library("rvest")
library("htmltools")


source("utils/utils.R", local = T)
source("utils/crawler.R", local = T)

downloadGithubData <- function() {
  download.file(
    url      = "https://github.com/CSSEGISandData/COVID-19/archive/master.zip",
    destfile = "data/covid19_data.zip"
  )
  
  data_path <- "COVID-19-master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"
  unzip(
    zipfile   = "data/covid19_data.zip",
    files     = paste0(data_path, c("confirmed_global.csv", "deaths_global.csv", "recovered_global.csv")),
    exdir     = "data",
    junkpaths = T
  )
}


updateData <- function() {
  # Download data from Johns Hopkins (https://github.com/CSSEGISandData/COVID-19) if the data is older than 0.5h
  if (!dir_exists("data")) {
    dir.create('data')
    downloadGithubData()
    data_worldmeter <- enrich_data_worldmeter()
  } else if ((!file.exists("data/covid19_data.zip")) || (as.double(Sys.time() - file_info("data/covid19_data.zip")$change_time, units = "hours") > 0.5)) {
    downloadGithubData()
    data_worldmeter <- enrich_data_worldmeter()
  }
}

updateData_first <- function() {
  # Download data from Johns Hopkins (https://github.com/CSSEGISandData/COVID-19) if the data is older than 0.5h
  if (!dir_exists("data")) {
    dir.create('data')
    downloadGithubData()
  } else if ((!file.exists("data/covid19_data.zip")) || (as.double(Sys.time() - file_info("data/covid19_data.zip")$change_time, units = "hours") > 0.5)) {
    downloadGithubData()
  }
}

# Update with start of app
updateData_first()

# TODO: Still throws a warning but works for now
data_confirmed <- read_csv("data/time_series_covid19_confirmed_global.csv")
data_deaths  <- read_csv("data/time_series_covid19_deaths_global.csv")
data_recovered <- read_csv("data/time_series_covid19_recovered_global.csv")

# Get latest data
current_date <- as.Date(names(data_confirmed)[ncol(data_confirmed)], format = "%m/%d/%y")
changed_date <- file_info("data/covid19_data.zip")$change_time

# Get evolution data by country
data_confirmed_sub <- data_confirmed %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_confirmed)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("confirmed" = sum(value, na.rm = T))

data_recovered_sub <- data_recovered %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_recovered)) %>%
  group_by(`Province/State`, `Country/Region`, date) %>%
  summarise("recovered" = sum(value, na.rm = T))
# No provinance for Canada 
data_recovered_sub[data_recovered_sub$`Country/Region`=="Canada",]$`Province/State` <- replace_na(data_recovered_sub[data_recovered_sub$`Country/Region`=="Canada",]$`Province/State`,"Alberta")

data_deaths_sub <- data_deaths %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_deaths)) %>%
  group_by(`Province/State`, `Country/Region`, date) %>%
  summarise("deaths" = sum(value, na.rm = T))

data_evolution <- data_confirmed_sub %>%
  left_join(data_recovered_sub) %>%
  left_join(data_deaths_sub) %>%
  ungroup() %>%
  mutate(date = as.Date(date, "%m/%d/%y")) %>%
  arrange(date) %>%
  group_by(`Province/State`, `Country/Region`, Lat, Long) %>%
  mutate(
    recovered = replace_na(recovered, 0),
    active = confirmed - recovered - deaths
  ) %>%
  pivot_longer(names_to = "var", cols = c(confirmed, recovered, deaths, active)) %>%
  ungroup()

# No provinance for Canada 
data_evolution$value[is.na(data_evolution$value)] <-  0

# Calculating new cases
data_evolution <- data_evolution %>%
  group_by(`Province/State`, `Country/Region`) %>%
  mutate(value_new = value - lag(value, 4, default = 0)) %>%
  ungroup()

rm(data_confirmed, data_confirmed_sub, data_recovered, data_recovered_sub, data_deaths_sub, data_deaths)

# ---- Download population data ----
p <- read_csv("data/extra_data/population_un.csv")

c_in_pop <- c(
  "Bolivia (Plurinational State of)",
  "Myanmar",
  "Brunei Darussalam", 
  "Democratic Republic of the Congo", 
  "Congo", 
  "Iran (Islamic Republic of)",
  "Côte d'Ivoire",
  "Republic of Korea",
  "Lao People's Democratic Republic",
  "Republic of Moldova", 
  "Syrian Arab Republic",
  "Viet Nam",
  "United Republic of Tanzania",
  "State of Palestine", 
  "Russian Federation",
  "United States of America", 
  "Venezuela (Bolivarian Republic of)")

c_in_data <- c(
  "Bolivia",
  "Burma",
  "Brunei", 
  "Congo (Kinshasa)", 
  "Congo (Brazzaville)", 
  "Iran",
  "Cote d'Ivoire",
  "Korea, South",
  "Laos",
  "Moldova",
  "Syria",
  "Vietnam",
  "Tanzania",
  "West Bank and Gaza", 
  "Russia", 
  "US", 
  "Venezuela")
p[which(p$country %in% c_in_pop), "country"] <- c_in_data

# Data from wikipedia
empty_dc <- data.frame(
  country    = c("Kosovo","Diamond Princess","MS Zaandam","Cruise Ship", "Guadeloupe", "Guernsey", "Holy See", "Jersey", "Martinique", "Reunion", "Taiwan*"),
  numeric = (1:11),
  population = c(1831000,2600,1164,3700, 395700, 63026, 800, 106800, 376480, 859959, 23780452)
)

p <- bind_rows(p, empty_dc)


data_evolution <- data_evolution %>%
  left_join(p, by = c("Country/Region" = "country"))

rm(p, c_in_data, c_in_pop, empty_dc)


write.csv(data_evolution, file = "data/daily_data.csv")


data_atDate <- function(inputDate) {
  data_evolution[which(data_evolution$date == inputDate),] %>%
    distinct() %>%
    pivot_wider(id_cols = c("Province/State", "Country/Region", "date", "Lat", "Long", "population"), names_from = var, values_from = value )%>%
    filter(confirmed > 0 |
             recovered > 0 |
             deaths > 0 |
             active > 0)
}

data_worldmeter <- enrich_data_worldmeter()
data_evolution_latest <- data_atDate(max(data_evolution$date))

top5_countries <- data_evolution %>%
  filter(var == "confirmed", date == current_date) %>%
  group_by(`Country/Region`) %>%
  summarise(value = sum(value, na.rm = T)) %>%
  arrange(desc(value)) %>%
  top_n(5) %>%
  select(`Country/Region`) %>%
  pull()
