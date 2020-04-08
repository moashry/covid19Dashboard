  output$confirmedComparisonByCountryThreshold <- renderPlotly({

    plot_ly(
    get_data_by_countries(input$comparisonCountryList,"confirmed",input$confirmedThreshold),
    x     = ~daySequence,
    y     = ~value,
    type  = 'scatter',
	color = ~`Country/Region`,
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Confirmed Cases"),
      xaxis = list(title = "Day Sequence")
    )
  })


    output$deathComparisonByCountryThreshold <- renderPlotly({
    plot_ly(
    get_data_by_countries(input$comparisonCountryList,"deaths",0),
    x     = ~date,
    y     = ~value,
    type  = 'scatter',
    color = ~`Country/Region`,
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Death Cases"),
      xaxis = list(title = "Day Sequence")
    )
  })

 output$confirmedComparisonByCountry <- renderPlotly({

    plot_ly(
    get_data_by_countries(input$comparisonCountryList,"confirmed",0),
    x     = ~date,
    y     = ~value,
    type  = 'scatter',
	color = ~`Country/Region`,
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Confirmed Cases"),
      xaxis = list(title = "Day Sequence")
    )
  })


  output$deathComparisonByCountry <- renderPlotly({
    plot_ly(
    get_data_by_countries(input$comparisonCountryList,"deaths",input$deathThreshold),
    x     = ~daySequence,
    y     = ~value,
    type  = 'scatter',
    color = ~`Country/Region`,
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Death Cases"),
      xaxis = list(title = "Day Sequence")
    )
  })

  output$confirmedComparisonByCountryThresholdTitle = renderPrint({
   HTML(cat("Confirmed Cases Compqrison after", input$confirmedThreshold, "cases reached"), "</font>")
  })

  output$deathComparisonByCountryThresholdTitle = renderPrint({
   HTML(cat("Confirmed Cases Compqrison after", input$deathThreshold, "cases reached"), "</font>")
  })
