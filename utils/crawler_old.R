# CRAWLER for worldmeter

d <- ContentScraper(Url = "https://www.worldometers.info/coronavirus/", 
	XpathPatterns =c("//*/table[@id='main_table_countries_today']")) 
d <- str_replace_all(d,"\n",";")
d <- str_split(d,";")
d <- unlist(d)

n <- length(d) ## row numbers
k <- 12 ## your LEN

dd <- split(d, rep(1:ceiling(n/k), each=k)[1:n])

df  <- do.call(rbind, dd)#
colnames(df) <- df[1,]
df <- df[-c(1,nrow(df)), ]
#df <- apply(df,2,function(x)gsub('\\s+', '',x))
df <- as.data.frame(df)

dj <- read_csv("/Users/mohamedramzyhassan/Desktop/Github/covid19Dashboard/data/daily_data.csv")
#dj <- apply(dj,2,function(x)gsub('\\s+', '',x))
dj <- as.data.frame(dj)

dc <- unique(dj$`Country/Region`)

dfc <- unique(df$`Country,Other`)

dif <- dc[!(dc %in% dfc)]
dif2 <- dfc[!(dfc %in% dc)]

#############################################

url <- "https://www.worldometers.info/coronavirus/"
population <- url %>%
xml2::read_html() %>%
  html_nodes(xpath='//*/table[@id="main_table_countries_today"]')

population <- html_table(population)  
population <- population[[1]]

df <- as.data.frame(population)

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


 dj <- read_csv("/Users/mohamedramzyhassan/Desktop/Github/covid19Dashboard/data/daily_data.csv")
  #dj <- apply(dj,2,function(x)gsub('\\s+', '',x))
  dj <- as.data.frame(dj)

  dataPerCountry <- dj %>%
  filter(date == max(dj$date)) %>%
  group_by(`Country/Region`,`date`,var) %>%
  summarise(value = sum(value, na.rm = T),
    value_new=sum(value_new,na.rm = T),
    population=max(population)) %>%
  ungroup()

  dj <- dataPerCountry

dc <- unique(dj$`Country/Region`)

dfc <- unique(df$`CountryOther`)

dif <- dc[!(dc %in% dfc)]
dif2 <- dfc[!(dfc %in% dc)]

commonCountirs <- dc[dc %in% dfc]
