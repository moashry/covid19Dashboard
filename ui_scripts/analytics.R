
ui_tab_analytics<- tabItem(tabName = "analytics",

                      fluidRow(
                         box(title = "Input", status="info", width=12,
                          selectInput("comparisonCountryList","country List:",
                            choices=as.list.data.frame(unique(data_evolution$'Country/Region')),
                            selected=as.list.data.frame(top5_countries),
                            multiple=TRUE
                            ),
                          column(width=12,
                            column(width=6,
                              sliderInput(
                                "confirmedThreshold",
                                label      = "Threshold for confirmed alignment",
                                min        = 0,
                                max        = 50000,
                                value      = 100
                                )
                              ),
                            column(width=6,
                              sliderInput(
                                "deathThreshold",
                                label      = "Threshold for deaths alignment",
                                min        = 0,
                                max        = 5000,
                                value      = 10
                                )
                              )
                            )

                          )
                      ),

                      fluidRow(
                        box(title = uiOutput('confirmedComparisonByCountryThresholdTitle'), 
                          status = "warning",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("confirmedComparisonByCountryThreshold", height = 250)),

                        box(title = uiOutput('deathComparisonByCountryThresholdTitle'), 
                          status = "warning",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("deathComparisonByCountryThreshold", height = 250))
                      ),

                      fluidRow(
                        box(title = "Confirmed Cases Compqrisons by Countires", 
                          status = "danger",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("confirmedComparisonByCountry", height = 250)),

                        box(title = "Death Cases Compqrisons by Countires", 
                          status = "danger",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("deathComparisonByCountry", height = 250))
                      ),

                    )