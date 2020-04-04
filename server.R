
library(shiny)
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
    my_data <- read_excel("data.xlsx")
    data_country <- my_data[my_data$countriesAndTerritories==input$country,]
    data_country <- data_country[order(data_country$dateRep),]
    return(data_country)
  })
  

  output$plot <- renderPlot({
    x <- data()$dateRep
    y <- data()$cases
    plot(x,y,type="l")
  })

  output$plot2 <- renderPlot({
    x <- data()$dateRep
    y <- data()$cases
    plot(x,cumsum(y),type="l")
  })
   
})