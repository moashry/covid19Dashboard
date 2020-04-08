
ui_tab_dashboard <- tabItem(tabName = "dashboard",

                      fluidRow(
                         box(title = "Input", status="info", 
                          selectInput("countryList","country List:",
                            choices=as.list.data.frame(unique(data_evolution$'Country/Region')),
                            selected=as.list.data.frame("Egypt"))
                          ),
						            column(
                          width=6,
                          fluidRow(
                            valueBoxOutput( "countryPopulation",width=12)
                            )
                          )
						            

                      ),

                      fluidRow(
                        valueBoxOutput( "totalCases",width=3),
                        valueBoxOutput( "totalActive",width=3),
                        valueBoxOutput( "totalDeaths",width=3),
                        valueBoxOutput( "totalRecovered",width=3)
                      ),


                      fluidRow(
                        box(title = "Daily Confirmed Cases", 
                          status = "warning",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("dailyConfirmedCases", height = 250)),

                        box(title = "Cumulative Confirmed Cases", 
                          status = "warning",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("cumulativeConfirmedCases", height = 250))
                      ),

                      fluidRow(
                        box(title = "Daily Death Cases", 
                          status = "danger",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("dailyDeathsCases", height = 250)),

                        box(title = "Cumulative Death Cases", 
                          status = "danger",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("cumulativeDeathsCases", height = 250))
                      ),
                      
                      fluidRow(
                        box(title = "Daily Recovery Cases", 
                          status = "success",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("dailyRecoveryCases", height = 250)),

                        box(title = "Cumulative Recovery Cases", 
                          status = "success",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("cumulativeRecoveryCases", height = 250))
                      )

                    )