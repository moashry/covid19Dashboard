  output$dailyConfirmedCases <- renderPlotly({
    plot_ly(
    get_data_country(input$countryList,"confirmed"),
    x     = ~date,
    y     = ~value_new,
    type  = 'bar',
    color = I("orange"),
    mode  = 'bar') %>%
    layout(
      yaxis = list(title = "# Confirmed Cases"),
      xaxis = list(title = "Date")
    )
  })

  output$cumulativeConfirmedCases <- renderPlotly({
    plot_ly(
    get_data_country(input$countryList,"confirmed"),
    x     = ~date,
    y     = ~value,
    type  = 'scatter',
    color = I("orange"),
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Confirmed Cases"),
      xaxis = list(title = "Date")
    )
  })

  output$dailyDeathsCases <- renderPlotly({
    plot_ly(
    get_data_country(input$countryList,"deaths"),
    x     = ~date,
    y     = ~value_new,
    color = I("red"),
    type  = 'bar',
    mode  = 'bar') %>%
    layout(
      yaxis = list(title = "# Deaths Cases"),
      xaxis = list(title = "Date")
    )
  })

  output$cumulativeDeathsCases <- renderPlotly({
    plot_ly(
    get_data_country(input$countryList,"deaths"),
    x     = ~date,
    y     = ~value,
    type  = 'scatter',
    color = I("red"),
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Deaths Cases"),
      xaxis = list(title = "Date")
    )
  })
  
  output$dailyRecoveryCases <- renderPlotly({
    plot_ly(
    get_data_country(input$countryList,"recovered"),
    x     = ~date,
    y     = ~value_new,
    color = I("green"),
    type  = 'bar',
    mode  = 'bar') %>%
    layout(
      yaxis = list(title = "# Recovered Cases"),
      xaxis = list(title = "Date")
    )
  })

  output$cumulativeRecoveryCases <- renderPlotly({
    plot_ly(
    get_data_country(input$countryList,"recovered"),
    x     = ~date,
    y     = ~value,
    type  = 'scatter',
    color = I("green"),
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Recovered Cases"),
      xaxis = list(title = "Date")
    )
  })

  output$totalCases <- renderValueBox({
    valueBox(
      format(get_total_figures_country(input$countryList,"confirmed"),big.mark=",",scientific=FALSE),
      "Total Cases", 
      color = "yellow", 
      icon = icon("fas fa-th-list")
    )
  })
   
  output$totalDeaths <- renderValueBox({
    valueBox(
      format(get_total_figures_country(input$countryList,"deaths"),big.mark=",",scientific=FALSE),
      "Total Deaths", 
      color="red", 
      icon = icon("fas fa-frown")    
    )
  })

output$totalRecovered <- renderValueBox({
    valueBox(
      format(get_total_figures_country(input$countryList,"recovered"),big.mark=",",scientific=FALSE),
      "Total Recovered", 
      color="green", 
      icon = icon("fas fa-heartbeat")
    )
  })

output$totalActive<- renderValueBox({
    valueBox(
      format(get_total_figures_country(input$countryList,"active"),big.mark=",",scientific=FALSE),
      "Total Active", 
      color="orange", 
      icon = icon("fas fa-hospital")
    )
  })

output$countryPopulation<- renderValueBox({
    valueBox(
      format(get_country_population(input$countryList),big.mark=",",scientific=FALSE),
      "Total Population in Country", 
      color="teal", 
      icon = icon("fas fa-users")
    )
  })