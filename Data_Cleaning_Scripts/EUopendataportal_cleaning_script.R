#Data source: https://data.europa.eu/euodp/en/data/dataset/covid-19-coronavirus-data
#Download the first csv file: "COVID-19 cases worldwide"
library(dplyr)
df = read.csv("~/Downloads/download", sep = ",")

df = df %>% 
  dplyr::select(dateRep, countriesAndTerritories, cases, deaths) %>%
  mutate(dateRep = as.Date(dateRep, format = "%d/%m/%Y")) %>%
  group_by(countriesAndTerritories) %>%
  arrange(dateRep) %>%
  mutate(cases = cumsum(cases),
         deaths = cumsum(deaths)) 

df$countriesAndTerritories = gsub("_", " ", df$countriesAndTerritories)
df$countriesAndTerritories[which(df$countriesAndTerritories == "United Kingdom")] = "UK"
df$countriesAndTerritories[which(df$countriesAndTerritories == "United States of America")] = "US"

names(df) = c("date", "country", "cases_ttl", "deaths_ttl")

write.csv(df, file = "~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/world_cases_deaths_EUopendataportal.csv")

