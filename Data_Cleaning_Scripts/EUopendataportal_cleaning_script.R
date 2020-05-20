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
