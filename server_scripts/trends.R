library(tmap)
library(maptools)
library(rgeos)      
library(maps)
data("World")
library("rnaturalearth")
library("rnaturalearthdata")
library(DT)


output$deathmap <- renderLeaflet({
	df <- data_worldmeter 
    df <- df %>%
  	filter(var=="deaths", date == input$ConfirmedSlider) %>%
  	rename(New_Deaths = value_new)

	d <- left_join(World, df, by=c("name"="Country/Region"))
	
	tm <- tm_shape(d) +
    		tm_polygons("New_Deaths")
	#qtm(d, fill = "value_new", fill.pallete = "RdYlGn")
 	tmap_leaflet(tm) %>%
      setView(0, 20, zoom = 1)
 })

output$confirmedmap <- renderLeaflet({
	df <- data_worldmeter 
    df <- df %>%
  	filter(var=="confirmed", date == input$ConfirmedSlider) %>%
  	rename(New_Confirmed = value_new)

	d <- left_join(World, df, by=c("name"="Country/Region"))
	
	tm <- tm_shape(d) +
    		tm_polygons("New_Confirmed")
	#qtm(d, fill = "value_new", fill.pallete = "RdYlGn")
 	tmap_leaflet(tm) %>%
      setView(0, 20, zoom = 1)
 
 })


output$top20newconfirmed <- renderPlotly({
    plot_ly(
    top20_countries_New_Confirmed,
    x     = ~reorder(`Country/Region`,-value_new),
    y     = ~value_new,
    type  = 'bar',
    color = ~`Country/Region`
    ) %>%
    layout(
      yaxis = list(title = "# Confirmed Cases Count"),
      xaxis = list(title = "Country")
    ) %>%
    config(displayModeBar = FALSE) %>%
    layout(hovermode = 'compare',showlegend = FALSE) %>%
    layout(xaxis=list(fixedrange=TRUE)) %>% 
    layout(yaxis=list(fixedrange=TRUE))
  })


 output$top20newdeaths <- renderPlotly({
    plot_ly(
    top20_countries_New_deaths,
    x     = ~reorder(`Country/Region`,-value_new),
    y     = ~value_new,
    type  = 'bar',
    color = ~`Country/Region`
    ) %>%
    layout(
      yaxis = list(title = "# Deaths Count"),
      xaxis = list(title = "Country")
    ) %>%
    config(displayModeBar = FALSE) %>%
    layout(hovermode = 'compare',showlegend = FALSE)
  })

 output$top20newconfirmedTable <- renderDataTable(top20_countries_New_Confirmed)

 output$top20newdeathsTable <- renderDataTable(top20_countries_New_deaths)
