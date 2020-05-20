#Data source: https://data.europa.eu/euodp/en/data/dataset/covid-19-coronavirus-data
df = read.csv("~/Downloads/data_europa_covid19cases", sep = ",")

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

write.csv(df, file = "~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/world_cases_deaths_EUopendataportal.csv")

