library(shiny)
library(shinydashboard)
library(plotly)
library("readxl")

my_data <- read_excel("Data/data.xlsx")
data_country <- unique(my_data$countriesAndTerritories)

ui_header <- dashboardHeader(title = "COVID19 Template",
                              dropdownMenu(type = "tasks", 
                                badgeStatus = "warning",
                                taskItem(value = 20, color = "yellow",
                                  "Dashboard Completion"
                                )
                              ),
                              dropdownMenu(type = "notifications",
                                badgeStatus = "info",
                                notificationItem(
                                  text = "Last Updated Date: 03.04.2020",
                                  icon("calendar")
                                )
                              )
                            ) 

ui_sidebar <- dashboardSidebar(
    sidebarMenu(
      
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            
      menuItem("Source code", icon = icon("file-code-o"), 
           href = "https://github.com/moashry/covid19Dashboard"),

      menuItem("Contact", tabName = "Contact", icon = icon("fad fa-id-badge"))
    )
  )

ui_tab_dashboard <- tabItem(tabName = "dashboard",

                      fluidRow(
                         box(title = "Input", status="warning", 
                          selectInput("countryList","country List:",
                            choices=as.list.data.frame(data_country),
                            selected=as.list.data.frame("Egypt")))
                      ),

                      fluidRow(
                        # A static infoBox
                        infoBox("Total Cases", 1000000, icon = icon("credit-card")),
                        infoBox("Total Deaths", 50000, icon = icon("credit-card")),
                        infoBox("Total Recovered", 250000, icon = icon("credit-card")),
                        # Dynamic infoBoxes
                        #infoBoxOutput("progressBox")
                      ),


                      fluidRow(
                        box(title = "Daily Cases", status = "primary",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("plot", height = 250)),

                        box(title = "Cumulative Cases", status = "primary",
                          solidHeader = TRUE, collapsible = TRUE,
                          plotlyOutput("plot2", height = 250))
                      )
                    )

ui_tab_widgets <- tabItem(tabName = "Contact",
                    h2("Contact content")
                  )

ui_body <- dashboardBody(tabItems(ui_tab_dashboard,ui_tab_widgets))

dashboardPage(
  ui_header,ui_sidebar,ui_body
)