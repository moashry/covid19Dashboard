library(shiny)
library(shinydashboard)
library(plotly)
library("readxl")
library("shiny")
library("shinydashboard")
library("tidyverse")
library("leaflet")
library("plotly")
library("DT")
library("fs")
library("wbstats")

ui_header <- dashboardHeader(title = "COVID19",
                              dropdownMenu(type = "tasks", 
                                badgeStatus = "warning",
                                taskItem(value = 30, color = "yellow",
                                  "Dashboard Completion"
                                )
                              ),
                              dropdownMenu(type = "notifications",
                                badgeStatus = "info",
                                notificationItem(
                                  text = "Last Updated Date: 05.04.2020",
                                  icon("calendar")
                                )
                              )
                            ) 

ui_sidebar <- dashboardSidebar(
  sidebarMenu(

    menuItem("World Status", tabName="map",icon= icon("fas fa-globe"), 
      badgeLabel = "New", badgeColor = "green"),

    menuItem("Country Status", tabName = "dashboard", icon = icon("fas fa-flag"),
      badgeLabel = "New", badgeColor = "green"),

    menuItem("Countries Comparisons", tabName = "analytics", icon = icon("fas fa-chart-bar"),
      badgeLabel = "NEW", badgeColor = "green"),

    menuItem("Trends",tabName = "trends", icon = icon("fas fa-chart-line"), 
      badgeLabel = "Soon", badgeColor = "yellow"),

    menuItem("Contact Me", tabName = "ContactMe", icon = icon("fad fa-id-badge")),

    menuItem("Source code", icon = icon("file-code-o"), 
      href = "https://github.com/moashry/covid19Dashboard")
  )
)

source("ui_scripts/dashboard.R", local = T)

source("ui_scripts/contact_me.R", local = T)

source("ui_scripts/map.R", local = T)

source("ui_scripts/analytics.R", local = T)

ui_body <- dashboardBody(tabItems(
  ui_tab_dashboard,
  ui_tab_contactme,
  ui_tab_map,
  ui_tab_analytics
))

dashboardPage(
  ui_header,ui_sidebar,ui_body
)