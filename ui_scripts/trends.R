
ui_tab_trends<- tabItem(tabName = "trends",

  fluidRow(
    tabBox(width=12,height=600,
      title = "Hot spots in the worldt today",
      # The id lets us use input$tabset1 on the server to find the current tab
      id = "tabset1",
      tabPanel("Animated Map",height=500,
        box(title="New Confirmed Cases", status = "info",
          leafletOutput("confirmedmap",height=350),
          sliderInput("ConfirmedSlider",
            label      = "Select date (Simulate using the play button)",
            min        = min(data_worldmeter$date),
            max        = max(data_worldmeter$date),
            value      = max(data_worldmeter$date),
            width      = "100%",
            timeFormat = "%d.%m.%Y",
            animate    = animationOptions(loop = TRUE)
            )
          ),
        box(title="New Death Cases",status = "info",
          leafletOutput("deathmap",height=350),
          sliderInput("DeathSlider",
            label      = "Select date (Simulate using the play button)",
            min        = min(data_worldmeter$date),
            max        = max(data_worldmeter$date),
            value      = max(data_worldmeter$date),
            width      = "100%",
            timeFormat = "%d.%m.%Y",
            animate    = animationOptions(loop = TRUE)
            )
          )  
        ),
      tabPanel("Numbers", height=500,
        box(title = "Top 20 Countries with Newly Confirmed Cases", 
          status = "info",
          plotlyOutput("top20newconfirmed", height = 400)
          ),
        box(title = "Top 20 Countries with Newly Death Cases", 
          status = "info",
          plotlyOutput("top20newdeaths", height = 400)
          )
        ),
      tabPanel("Data Tables",height=500, 
        box(title = "Top 20 Countries with Newly Confirmed Cases", 
          status = "info",
          dataTableOutput('top20newconfirmedTable')
          ),
        box(title = "Top 20 Countries with Newly Death Cases", 
          status = "info",
          dataTableOutput('top20newdeathsTable')
          )
        )
      )
    )
  )