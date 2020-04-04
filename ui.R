library(shiny)
library(shinydashboard)
library("readxl")


ui_header <- dashboardHeader(title = "COVID19 Template",
                              dropdownMenu(type = "tasks", badgeStatus = "warning",
                                taskItem(value = 20, color = "yellow",
                                  "Dashboard Completion"
                                )
                              ),
                              dropdownMenu(type = "notifications",badgeStatus = "info",
                                notificationItem(
                                  text = "Last Updated Date: 03.04.2020",
                                  icon("calendar")
                                )
                              )
                            ) 

ui_sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"))
    )
  )

ui_tab_dashboard <- tabItem(tabName = "dashboard",
                      fluidRow(
                        box(plotOutput("plot", height = 250)),
                        box(plotOutput("plot2", height = 250)),
                        box(
                          title = "Country",
                          textInput("country", "Country:", "Egypt")
                        )
                      )
                    )

ui_tab_widgets <- tabItem(tabName = "widgets",
                    h2("Widgets tab content")
                  )

ui_body <- dashboardBody(tabItems(ui_tab_dashboard,ui_tab_widgets))

dashboardPage(
  ui_header,ui_sidebar,ui_body
)