library(dplyr)

#Data source: http://data.un.org/Data.aspx?d=POP&f=tableCode%3a22
data = read.csv("~/Downloads/UNdata_Export_20200520_053339396.csv") %>% na.omit() 

data = data %>% 
        mutate(Year = as.numeric(as.character(Year))) %>%
        dplyr::filter((data$Area == 'Total' 
                & data$Sex == 'Both Sexes'
                & !(data$Age %in% c("", "Unknown"))
                & grepl('^[[:digit:]]{,2}$', data$Age))) %>%
        group_by(Country.or.Area) %>%
        arrange(Country.or.Area, desc(Year)) %>%
        dplyr::filter(Year == max(Year)) %>%
        mutate(Age = as.numeric(as.character(Age)),
               Value = as.numeric(as.character(Value)))
  
data$Country.or.Area = as.character(data$Country.or.Area)

vars = c("Country.or.Area", "Year", "Age", "Value")
data = data[,vars]

#Split into age categories
data$AgeGroup = as.character(data$Age)

data$AgeGroup[data$Age %in% c("0","1","2","3","4","5","6","7","8","9")] = "0-9"
data$AgeGroup[data$Age %in% c("10","11","12","13","14","15","16","17","18","19")] = "10-19"
data$AgeGroup[data$Age %in% c("20","21","22","23","24","25","26","27","28","29")] = "20-29"
data$AgeGroup[data$Age %in% c("30","31","32","33","34","35","36","37","38","39")] = "30-39"
data$AgeGroup[data$Age %in% c("40","41","42","43","44","45","46","47","48","49")] = "40-49"
data$AgeGroup[data$Age %in% c("50","51","52","53","54","55","56","57","58","59")] = "50-59"
data$AgeGroup[data$Age %in% c("60","61","62","63","64","65","66","67","68","69")] = "60-69"
data$AgeGroup[data$Age %in% c("70","71","72","73","74","75","76","77","78","79")] = "70-79"
data$AgeGroup[data$Age %in% c("80","81","82","83","84","85","86","87","88","89")] = "80-89"
data$AgeGroup[data$Age %in% c("90","91","92","93","94","95","96","97","98","99","100")] = "90-100"

idx = data$AgeGroup %in% c("0-9","10-19","20-29","30-39","40-49","50-59","60-69","70-79","80-89","90-100")
data = data[idx,]

#Filter for useful cols and rename cols
names(data) = c("country_area", "year", "age", "pop", "agegroup")
  
#Aggregate counts
data = data %>%
        group_by(country_area, agegroup) %>%
        summarise(pop = sum(pop)) 

data$country_area[which(data$country_area == "Democratic People's Republic of Korea")] = "South Korea"
data$country_area[which(data$country_area == "United Kingdom of Great Britain and Northern Ireland")] = "UK"
data$country_area[which(data$country_area == "United States of America")] = "US"



#Adjust for current population
#Data source: http://data.un.org/Data.aspx?q=population&d=PopDiv&f=variableID%3a12
currpop = read.csv("~/Downloads/UNdata_Export_20200520_052347310.csv") %>% 
  na.omit() %>%
  dplyr::filter(Variant == "Medium") %>%
  dplyr::select(Country.or.Area, Value) %>%
  mutate(Value = Value * 1000,
         Country.or.Area = as.character(Country.or.Area))

names(currpop) = c("country_area", "ttlpop")

currpop$country_area[which(currpop$country_area == "Dem. People's Republic of Korea")] = "South Korea"
currpop$country_area[which(currpop$country_area == "United Kingdom")] = "UK"
currpop$country_area[which(currpop$country_area == "United States of America")] = "US"

adjdata = data %>% left_join(data %>% 
                                group_by(country_area) %>% 
                                summarise(prevttl = sum(pop))) %>%
                    mutate(prop = pop/prevttl) %>% 
                    left_join(currpop) %>% 
                    mutate(adjpop = prop * ttlpop) %>%
                    dplyr::select(country_area, agegroup, adjpop)


adjdata_broad = spread(adjdata, key = agegroup, value = adjpop)


write.csv(adjdata_broad, file = "~/.../Data/agegroups_UNdata.csv")

