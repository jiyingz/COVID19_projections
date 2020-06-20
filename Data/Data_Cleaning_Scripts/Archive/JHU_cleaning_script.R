#RETIRED
library(dplyr)

#Data source: JHU -- https://github.com/CSSEGISandData/COVID-19

global_confirmed = read.csv("~/Downloads/.../csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
global_deaths = read.csv("~/.../csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
global_recovered = read.csv("~/.../csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")

global_confirmed = global_confirmed %>% 
                      dplyr::select(-c("Lat", "Long")) %>%
                      gather(key = "date", value = "confirmed", 3:(ncol(global_confirmed)-2)) %>%
                      mutate(date = as.Date(gsub("X", "", date), format = "%m.%d.%y"),
                             Country.Region = as.character(Country.Region),
                             Province.State = as.character(Province.State)) %>%
                      arrange(Country.Region, Province.State, date)

global_deaths = global_deaths %>% 
                    dplyr::select(-c("Lat", "Long")) %>%
                    gather(key = "date", value = "deaths", 3:(ncol(global_deaths)-2)) %>%
                    mutate(date = as.Date(gsub("X", "", date), format = "%m.%d.%y"),
                           Country.Region = as.character(Country.Region),
                           Province.State = as.character(Province.State)) %>%
                    arrange(Country.Region, Province.State, date)

global_recovered = global_recovered %>% 
                      dplyr::select(-c("Lat", "Long")) %>%
                      gather(key = "date", value = "recovered", 3:(ncol(global_recovered)-2)) %>%
                      mutate(date = as.Date(gsub("X", "", date), format = "%m.%d.%y"),
                             Country.Region = as.character(Country.Region),
                             Province.State = as.character(Province.State)) %>%
                      arrange(Country.Region, Province.State, date)

global = global_confirmed %>% full_join(global_deaths) %>% full_join(global_recovered)
names(global)[1:3] = c("province", "country", "date")

global$country[which(global$country == "United Kingdom")] = "UK"

write.csv(global, file = "~/.../Data/world_cases_deaths_recovered_JHU.csv")


