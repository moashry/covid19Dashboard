get_country_list <-  function() {
  countries_list <- data_evolution$'Country/Region'
  countries_list <- unique(countries_list)
  return(countries_list)
}

get_country_population <- function(country){
   data <- data_evolution_latest[data_evolution_latest$'Country/Region' == country,] 
    return(data[1,]$population)
}

get_data_countries <- function(countries,caseType,threshold){
    
    data <- data_worldmeter %>%
      arrange(date) %>%
      filter( value >= threshold & var == caseType ) %>%
      group_by(`Country/Region`, population, date) %>%
      filter(if (is.null(countries)) TRUE else `Country/Region` %in% countries) %>%
      summarise(value = sum(value, na.rm = T)) %>%
      mutate("daySequence" = row_number()) %>%
      ungroup()

  return(data)
}

get_wolrd_daily_growth_rate <- function(dateLimit,caseType){

  data <- data_worldmeter %>%
          arrange(date) %>%
          group_by(date, var) %>%
          filter(date <= dateLimit & var == caseType) %>%
          summarise(value_new = sum(value_new, na.rm = T)) %>%
          ungroup()

  # Calculating Daily Growth
  df <- data
  growth_rate <- tail(df$value_new, -1) / head(df$value_new, -1)
  initialRate <- data.frame(growth_rate=c(NaN))
  x <- bind_rows(initialRate,as.data.frame(growth_rate))
  df$growth_rate <- x
  df$growth_rate <- unlist(x)
  return(as.data.frame(df))
}

get_data_worldwide <- function(dateLimit){
    
    data <- data_worldmeter %>%
      arrange(date) %>%
      group_by(date, var) %>%
      filter(date <= dateLimit) %>%
      summarise(value = sum(value, na.rm = T)) %>%
      ungroup()

  return(data)
}

get_data_country <- function(country,CaseType){
  d <- data_worldmeter
  d <- d[(d$`Country/Region`==country & d$var=="confirmed" & d$value>0), ]
  startDate <- min(d$date)

  data <- data_worldmeter %>%
          filter(var==CaseType,`Country/Region`==country, date >= startDate) %>%
          group_by(date) %>%
          summarise(
            "value" = sum(value, na.rm = T),
            "value_new" = sum(value_new, na.rm = T)
          ) %>%
          ungroup()

  return(data)
}

get_total_figures_global <- function(dateInput,caseType){
  sum <- data_worldmeter %>%
         filter(var==caseType,date == dateInput) %>%
         group_by(date) %>%
         summarise(sum=sum(value,na.rm=T)) %>%
         ungroup()

  return(sum$sum)
}

get_total_figures_country <- function(country,caseType){
  sum <- data_worldmeter %>%
         filter(`Country/Region`== country,var==caseType,date == Sys.Date()) %>%
         group_by(date) %>%
         summarise(sum=sum(value,na.rm=T)) %>%
         ungroup()

  return(sum$sum)
}

# get_total_confirmed <- function(country,date){
#   data <- data_atDate(input$timeSlider)
#   data <- data[data$'Country/Region'== country,]
#   return(sum(data$confirmed))
# }

# get_total_deaths_global <- function(date){
#   data <- data_atDate(input$timeSlider)
#   return(sum(data$deaths))
# }

# get_total_deaths <- function(country,date){
#   data <- data_atDate(input$timeSlider)
#   data <- data[data$'Country/Region'== country,]
#   return(sum(data$deaths))
# }

# get_total_recovered_global <- function(date){
#   data <- data_atDate(input$timeSlider)
#   return(sum(data$recovered))
# }

# get_total_recovered <- function(country,date){
#   data <- data_atDate(input$timeSlider)
#   data <- data[data$'Country/Region'== country,]
#   return(sum(data$recovered))
# }

# get_total_active_global <- function(date){
#   data <- data_atDate(input$timeSlider)
#   return(sum(data$active))
# }

# get_total_active <- function(country,date){
#   data <- data_atDate(input$timeSlider)
#   data <- data[data$'Country/Region'== country,]
#   return(sum(data$active))
# }
