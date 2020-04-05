
library(shiny)
library(plotly)
library("readxl")

  

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {

  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  
  # source("Utils/global.R", local = T)

  data <- reactive({
    my_data <- read_excel("Data/data.xlsx")
    data_country <- my_data[my_data$countriesAndTerritories==input$countryList,]
    data_country <- data_country[order(data_country$dateRep),]
    return(data_country)
  })

data_daily_cases <- reactive({
    data <- read_csv("Data/daily_data.csv")
    data <- as.data.frame(data)
    data <- data[data$'Country/Region'==input$countryList,]
    data <- data[data$var=="confirmed",]
    return(data)
  })


 data_cumulative_cases <- reactive({
    confirmed <- read_csv("Data/time_series_covid19_confirmed_global.csv")
    confirmed <- confirmed[confirmed$`Country/Region`==input$countryList,]
    confirmed_sub <- confirmed %>%
      pivot_longer(names_to = "date", cols = 5:ncol(confirmed)) %>%
      group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
      summarise("Confirmed" = sum(value, na.rm = T))
    confirmed_sub <- as.data.frame(confirmed_sub)
    confirmed_sub$date <- as.Date(confirmed_sub$date, "%m/%d/%y")
    confirmed_sub <- confirmed_sub[order(confirmed_sub$date),]
    return(confirmed_sub)
  })

  data_recovered <- reactive({
    recovered <- read_csv("Data/time_series_covid19_recovered_global.csv")
    recovered <- recovered[recovered$`Country/Region`==input$countryList,]
    recovered_sub <- recovered %>%
      pivot_longer(names_to = "date", cols = 5:ncol(recovered)) %>%
      group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
      summarise("Recovered" = sum(value, na.rm = T))
    return(recovered_sub[recovered_sub$date==max(recovered_sub$date),]$Recovered)
    })
  
  data_deaths <- reactive({
    deaths <- read_csv("Data/time_series_covid19_deaths_global.csv")
    deaths <- deaths[deaths$`Country/Region`==input$countryList,]
    deaths_sub <- deaths %>%
      pivot_longer(names_to = "date", cols = 5:ncol(deaths)) %>%
      group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
      summarise("Deaths" = sum(value, na.rm = T))
    return(deaths_sub[deaths_sub$date==max(deaths_sub$date),]$Deaths)
    })

  data_confirmed <- reactive({
    confirmed <- read_csv("Data/time_series_covid19_confirmed_global.csv")
    confirmed <- confirmed[confirmed$`Country/Region`==input$countryList,]
    confirmed_sub <- confirmed %>%
      pivot_longer(names_to = "date", cols = 5:ncol(confirmed)) %>%
      group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
      summarise("Confirmed" = sum(value, na.rm = T))
    return(confirmed_sub[confirmed_sub$date==max(confirmed_sub$date),]$Confirmed)
    })

  output$dailyCases <- renderPlotly({
    plot_ly(
    data_daily_cases(),
    x     = ~date,
    y     = ~value_new,
    type  = 'bar',
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Cases"),
      xaxis = list(title = "Date")
    )
  })

  output$cumulativeCases <- renderPlotly({
    plot_ly(
    data_cumulative_cases(),
    x     = data_cumulative_cases()$date,
    y     = data_cumulative_cases()$Confirmed,
    type  = 'scatter',
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Cases"),
      xaxis = list(title = "Date")
    )
  })
  
  output$totalCases <- renderValueBox({
    valueBox(
      sum(data_confirmed()), 
      "Total Cases", 
      color = "orange", 
      icon = icon("fas fa-hospital"),
      width="10%"
    )
  })
   
  output$totalDeaths <- renderValueBox({
    valueBox(
      sum(data_deaths()), 
      "Total Deaths", 
      color="red", 
      icon = icon("fas fa-sad-tear"),
      width="10%"
    )
  })

output$totalRecovered <- renderValueBox({
    valueBox(
      sum(data_recovered()), 
      "Total Recovered", 
      color="green", 
      icon = icon("fas fa-heart"),
      width="10%"
    )
  })

output$totalActive<- renderValueBox({
    valueBox(
      (sum(data_confirmed())-sum(data_recovered())-sum(data_deaths())), 
      "Total Active", 
      color="yellow", 
      icon = icon("fas fa-procedures"),
      width="10%"
    )
  })

})