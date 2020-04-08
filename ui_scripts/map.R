
map_data <- read_csv("data/daily_data.csv")

ui_tab_map <- tabItem(tabName = "map",
  fluidRow(
  	valueBoxOutput( "totalCasesGlobal",width=3),
  	valueBoxOutput( "totalActiveGlobal",width=3),
  	valueBoxOutput( "totalDeathsGlobal",width=3),
  	valueBoxOutput("totalRecoveredGlobal",width=3)
  	),
  fluidRow(
  	column(
	sliderInput(
          "timeSlider",
          label      = "Select date (Simulate using the play button)",
          min        = min(data_evolution$date),
          max        = max(data_evolution$date),
          value      = max(data_evolution$date),
          width      = "100%",
          timeFormat = "%d.%m.%Y",
          animate    = animationOptions(loop = TRUE)
		),
        class = "slider",
        width = 12,
        style = 'padding-left:30px; padding-right:30px; font-size:25px; top:5px'
      )
  	),
  fluidRow(
    tabPanel("Worldwide cases",
      icon = icon("map"),
      leafletOutput(
        "mymap",width = "100%",height = "80vh"
      )
    )
  )
)