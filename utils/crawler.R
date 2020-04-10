downloadWorldMeterData <- function(){
  url <- "https://www.worldometers.info/coronavirus/"
  worldmeter <- url %>%
  xml2::read_html() %>%
    html_nodes(xpath='//*/table[@id="main_table_countries_today"]')

  worldmeter <- html_table(worldmeter)  
  worldmeter <- worldmeter[[1]]

  df <- as.data.frame(worldmeter)

  df[,1] <- as.character(df[,1])
  df[,2] <- as.numeric(as.character(gsub(",","",df[,2])))
  df[,3] <- as.numeric(as.character(gsub(",","",df[,3])))
  df[,4] <- as.numeric(as.character(gsub(",","",df[,4])))
  df[,5] <- as.numeric(as.character(gsub(",","",df[,5])))
  df[,6] <- as.numeric(as.character(gsub(",","",df[,6])))
  df[,7] <- as.numeric(as.character(gsub(",","",df[,7])))
  df[,8] <- as.numeric(as.character(gsub(",","",df[,8])))
  df[,9] <- as.numeric(as.character(gsub(",","",df[,9])))
  df[,10] <- as.numeric(as.character(gsub(",","",df[,10])))
  df[,11] <- as.numeric(as.character(gsub(",","",df[,11])))
  df[,12] <- as.numeric(as.character(gsub(",","",df[,12])))
  df[,13] <- as.character(df[,13])

  #Update Country Name to Match our data
  df[df$`Country,Other` == "UK", ]$`Country,Other` <- "United Kingdom"
  df[df$`Country,Other` == "USA", ]$`Country,Other` <- "US"
  df[df$`Country,Other` == "Taiwan", ]$`Country,Other` <- "Taiwan*"
  df[df$`Country,Other` == "CAR", ]$`Country,Other` <- "Central African Republic"
  df[df$`Country,Other` == "Palestine", ]$`Country,Other` <- "West Bank and Gaza"
  df[df$`Country,Other` == "Ivory Coast", ]$`Country,Other` <- "Cote d'Ivoire"
  df[df$`Country,Other` == "UAE", ]$`Country,Other` <- "United Arab Emirates"
  df[df$`Country,Other` == "S. Korea", ]$`Country,Other` <- "Korea, South"
  df[df$`Country,Other` == "Congo", ]$`Country,Other` <- "Congo (Brazzaville"
  df[df$`Country,Other` == "St. Vincent Grenadines", ]$`Country,Other` <- "Saint Vincent and the Grenadines"
  df[df$`Country,Other` == "Myanmar", ]$`Country,Other` <- "Burma"
  df$date <- as.character(Sys.Date())

  write.csv(df,file=paste("data/worldmeter/worldmeter_",as.character(Sys.Date()),".csv"))

  return(df)
}

enrich_data_worldmeter <- function(){

  df <- downloadWorldMeterData()

  dataPerCountry <- data_evolution %>%
  group_by(`Country/Region`,`date`,var) %>%
  summarise(value = sum(value, na.rm = T),
    value_new=sum(value_new,na.rm = T),
    population=max(population),
    Lat = sample(Lat,1),
    Long = sample(Long,1)) %>%
  ungroup()

dc <- unique(dataPerCountry$`Country/Region`)

dfc <- unique(df$`Country,Other`)

dif <- dc[!(dc %in% dfc)]
dif2 <- dfc[!(dfc %in% dc)]

commonCountirs <- dc[dc %in% dfc]


df_common <- df[df$`Country,Other` %in% commonCountirs, ]

  if(Sys.Date()==max(dataPerCountry$date)){
    enriched_dataPerCountry <- dataPerCountry %>%
    left_join(df_common, by=c("Country/Region" = "Country,Other")) %>%
    mutate(value = ifelse(var=="confirmed",TotalCases,
                   ifelse(var=="active",ActiveCases,
                   ifelse(var=="deaths",TotalDeaths,
                   ifelse(var=="recovered",TotalRecovered,value)))),

          value_new = ifelse(var=="confirmed",NewCases,
                      ifelse(var=="active",value_new,
                      ifelse(var=="deaths",NewDeaths,
                      ifelse(var=="recovered",value_new,value_new)))))
  
    dataPerCountry[dataPerCountry$date==max(dataPerCountry$date),] <- enriched_dataPerCountry[,1:8]
  }else{
    add <- dataPerCountry[dataPerCountry$date==max(dataPerCountry$date),]
    add$date <- Sys.Date()
    dataPerCountry <- rbind(dataPerCountry,add)

    enriched_dataPerCountry <- dataPerCountry %>%
    filter(dataPerCountry$date == max(dataPerCountry$date)) %>%
    left_join(df_common, by=c("Country/Region" = "Country,Other")) %>%
    mutate(value = ifelse(var=="confirmed",TotalCases,
                   ifelse(var=="active",ActiveCases,
                   ifelse(var=="deaths",TotalDeaths,
                   ifelse(var=="recovered",TotalRecovered,value)))),

          value_new = ifelse(var=="confirmed",NewCases,
                      ifelse(var=="active",value_new,
                      ifelse(var=="deaths",NewDeaths,
                      ifelse(var=="recovered",value_new,value_new)))))

    dataPerCountry[dataPerCountry$date==max(dataPerCountry$date),] <- enriched_dataPerCountry[,1:8]  
  }
  write.csv(enriched_dataPerCountry,file=paste("data/enricheddata/worldmeter_",as.character(Sys.Date()),".csv"))

  return(dataPerCountry)

}

