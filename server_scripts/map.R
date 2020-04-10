addLabel <- function(data) {
  data$label <- paste0(
    '<b>', ifelse(is.na(data$`Province/State`), data$`Country/Region`, data$`Province/State`), '</b><br>
    <table style="width:120px;">
    <tr><td>Total Cases:</td><td align="right">', data$confirmed, '</td></tr>
    <tr><td>Total Deaths:</td><td align="right">', data$deaths, '</td></tr>
    </table>'
  )
  data$label <- lapply(data$label, HTML)
  return(data)
}

output$mymap <- renderLeaflet({

    labels <- addLabel(data_evolution_latest)
    map <- leaflet(labels, options = leafletOptions(zoomControl = TRUE)) %>%
      addProviderTiles(providers$CartoDB.Positron, group="Light") %>%
      addProviderTiles(providers$HERE.satelliteDay, group = "Satellite") %>%
      addProviderTiles(providers$NASAGIBS.ViirsEarthAtNight2012, group="Night") %>%
      addProviderTiles(providers$CartoDB.DarkMatterOnlyLabels , group="Night") %>%
      setMaxBounds(-180, -90, 180, 90) %>%
      setView(0, 20, zoom = 2) %>%
      addLayersControl(
        baseGroups    = c("Light","Night", "Satellite"),
        overlayGroups = c("Total Cases", "Total Deaths")) %>%
      hideGroup("Total Deaths") %>%
      addEasyButton(easyButton(
        icon="fa-globe", title="Zoom to Level 1",
        onClick=JS("function(btn, map){ map.setZoom(1); }"))) %>%
      addEasyButton(easyButton(
        icon="fa-crosshairs", title="Locate Me",
        onClick=JS("function(btn, map){ map.locate({setView: true, maxZoom: 6}); }")))
})



observe({
  req(input$timeSlider)
  zoomLevel <- input$mymap_zoom
  data <- data_atDate(input$timeSlider-1) %>% addLabel()

  leafletProxy("mymap", data = data) %>%
    clearMarkers() %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(confirmed^(zoomLevel / 4)),
      stroke       = FALSE,
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Total Cases"
    ) %>%

    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(deaths^(zoomLevel/2)),
      stroke       = FALSE,
      color        = "#E7590B",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Total Deaths"
    )

})


 output$worldwideStatus <- renderPlotly({

    plot_ly(
    get_data_worldwide(input$timeSlider),
    x     = ~date,
    y     = ~value,
    type  = 'scatter',
    color = ~var,
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Confirmed Cases"),
      xaxis = list(title = "Day Sequence")
    )
  })

 output$worldwideGrowthRate <- renderPlotly({
  data <- get_wolrd_daily_growth_rate(input$timeSlider,"confirmed")
 
  plot_ly(
    data,
    x     = ~date,
    y     = ~growth_rate,
    type  = 'scatter',
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "Growth Rate",range = c(0,3)),
      xaxis = list(title = FALSE)
    )
  })

output$totalCasesGlobal <- renderValueBox({
    valueBox(
      format(get_total_figures_global(input$timeSlider,"confirmed"),big.mark=",",scientific=FALSE),
      "Total Cases", 
      color = "yellow", 
      icon = icon("fas fa-th-list") 
    )
  })

output$totalDeathsGlobal <- renderValueBox({
    valueBox(
      format(get_total_figures_global(input$timeSlider,"deaths"),big.mark=",",scientific=FALSE),
      "Total Deaths", 
      color="red", 
      icon = icon("fas fa-frown")    
    )
  })

output$totalRecoveredGlobal <- renderValueBox({
    valueBox(
      format(get_total_figures_global(input$timeSlider,"recovered"),big.mark=",",scientific=FALSE),
      "Total Recovered", 
      color="green", 
      icon = icon("fas fa-heartbeat")
    )
  })

output$totalActiveGlobal<- renderValueBox({
    valueBox(
      format(get_total_figures_global(input$timeSlider,"active"),big.mark=",",scientific=FALSE), 
      "Total Active", 
      color="orange", 
      icon = icon("fas fa-hospital")
    )
  })
