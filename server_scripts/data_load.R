get_country_list <-  function() {
  countries_list <- data_evolution$'Country/Region'
  countries_list <- unique(countries_list)
  return(countries_list)
}

get_country_population <- function(country){
   data <- data_evolution_latest[data_evolution_latest$'Country/Region' == country,] 
    return(data[1,]$population)
}

get_data_by_countries <- function(country,caseType,threshold){
    
    data <- data_evolution %>%
      arrange(date) %>%
      filter( value >= threshold & var == caseType ) %>%
      group_by(`Country/Region`, population, date) %>%
      filter(if (is.null(country)) TRUE else `Country/Region` %in% country) %>%
      summarise(value = sum(value, na.rm = T)) %>%
      mutate("daySequence" = row_number()) %>%
      ungroup()

  return(data)
}



get_data_daily_cases <- function(country,CaseType){
  data <- data_evolution
  data <- data[data$'Country/Region'== country,]
  data <- data[data$var==CaseType,]
  data <- data %>%
    group_by(date) %>%
    summarise(
      "value" = sum(value, na.rm = T),
      "value_new" = sum(value_new, na.rm = T)
    ) %>%
    as.data.frame()

  return(data)
}

get_total_confirmed_global <- function(date){
  data <- data_atDate(input$timeSlider)
  return(sum(data$confirmed))
}

get_total_confirmed <- function(country,date){
  data <- data_atDate(input$timeSlider)
  data <- data[data$'Country/Region'== country,]
  return(sum(data$confirmed))
}

get_total_deaths_global <- function(date){
  data <- data_atDate(input$timeSlider)
  return(sum(data$deaths))
}

get_total_deaths <- function(country,date){
  data <- data_atDate(input$timeSlider)
  data <- data[data$'Country/Region'== country,]
  return(sum(data$deaths))
}

get_total_recovered_global <- function(date){
  data <- data_atDate(input$timeSlider)
  return(sum(data$recovered))
}

get_total_recovered <- function(country,date){
  data <- data_atDate(input$timeSlider)
  data <- data[data$'Country/Region'== country,]
  return(sum(data$recovered))
}

get_total_active_global <- function(date){
  data <- data_atDate(input$timeSlider)
  return(sum(data$active))
}

get_total_active <- function(country,date){
  data <- data_atDate(input$timeSlider)
  data <- data[data$'Country/Region'== country,]
  return(sum(data$active))
}
