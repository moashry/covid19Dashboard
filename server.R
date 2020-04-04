
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
  data <- reactive({
    my_data <- read_excel("Data/data.xlsx")
    data_country <- my_data[my_data$countriesAndTerritories==input$country,]
    data_country <- data_country[order(data_country$dateRep),]
    return(data_country)
  })
  

  output$plot <- renderPlotly({
    plot_ly(
    data(),
    x     = data()$dateRep,
    y     = data()$cases,
    type  = 'scatter',
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Cases"),
      xaxis = list(title = "Date")
    )
  })

  output$plot2 <- renderPlotly({
    plot_ly(
    data(),
    x     = data()$dateRep,
    y     = cumsum(data()$cases),
    type  = 'scatter',
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Cases"),
      xaxis = list(title = "Date")
    )
  })
   
})