
map_data <- read_csv("data/daily_data.csv")

ui_tab_map <- tabItem(tabName = "map",
  fluidRow(
  	valueBoxOutput( "totalCasesGlobal",width=3),
  	valueBoxOutput( "totalActiveGlobal",width=3),
  	valueBoxOutput( "totalDeathsGlobal",width=3),
  	valueBoxOutput("totalRecoveredGlobal",width=3)
  	),
  fluidRow(
  column(width=8,
  	sliderInput("timeSlider",
      label      = "Select date (Simulate using the play button)",
      min        = min(data_evolution$date),
      max        = max(Sys.Date()),
      value      = max(Sys.Date()),
      width      = "100%",
      timeFormat = "%d.%m.%Y",
      animate    = animationOptions(loop = TRUE)
  		),
    class = "slider",
    style = 'padding-left:30px; padding-right:30px; font-size:25px; top:5px'  
  	),
  column(width=4,

      plotlyOutput("worldwideGrowthRate", height = 125)

    )
  ),
  fluidRow(
    column(width=8,
      leafletOutput(
        "mymap",width = "100%",height = "50vh"
        )
      ),
    column(width=4,
      box(title = "Figures", 
        status = "info",
        width=NULL,
        plotlyOutput("worldwideStatus", height = 300)
        )
      )
  )
)