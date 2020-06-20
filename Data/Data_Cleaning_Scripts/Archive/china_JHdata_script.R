### DESCRIPTION
### This script compiles the confirmed, recovered, and death cases of various regions in China
### Data updated 4/25/2020
library(tidyverse)

#Load data
confirmed = read.csv2("~/.../csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv", sep = ",")
recovered = read.csv2("~/.../csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv", sep = ",")
deaths = read.csv2("~/.../csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv", sep = ",")

#Subset for China
confirmed_china = confirmed %>% filter(Country.Region == "China") %>% select(-c("Lat", "Long"))
recovered_china = recovered %>% filter(Country.Region == "China") %>% select(-c("Lat", "Long"))
deaths_china = deaths %>% filter(Country.Region == "China") %>% select(-c("Lat", "Long"))

confirmed_china = confirmed_china %>% gather(key = "date", value = "count", 3:96)
recovered_china = recovered_china %>% gather(key = "date", value = "count", 3:96)
deaths_china = deaths_china %>% gather(key = "date", value = "count", 3:96)

#Convert dates into YYYY-MM-DD format
convertDate = function(input) {
  day = str_extract(input, pattern = '\\.[[:digit:]]+\\.') %>% str_extract(pattern = '[[:digit:]]+')
  month = str_extract(input, pattern = 'X[[:digit:]]+\\.') %>% str_extract(pattern = '[[:digit:]]+')
  year = paste("20", str_extract(input, pattern = '\\.[[:digit:]]+$') %>% str_extract(pattern = '[[:digit:]]+'), sep = "")
  as.Date(paste(year, month, day, sep = "-"))
}

confirmed_china$date = convertDate(confirmed_china$date)
recovered_china$date = convertDate(recovered_china$date)
deaths_china$date = convertDate(deaths_china$date)

#Change variable names
names(confirmed_china) = c("Province", "Country", "Date", "Count")
names(recovered_china) = c("Province", "Country", "Date", "Count")
names(deaths_china) = c("Province", "Country", "Date", "Count")


#Write output files
write.csv(confirmed_china, file = "china_confirmed_byprovince_orig.csv", row.names = F)
write.csv(recovered_china, file = "china_recovered_byprovince_orig.csv", row.names = F)
write.csv(deaths_china, file = "china_deaths_byprovince_orig.csv", row.names = F)

#Group total counts by day
confirmed_china_ttl = confirmed_china %>% group_by(Date) %>% summarise(Country = Country[1], Count = sum(Count))
recovered_china_ttl = recovered_china %>% group_by(Date) %>% summarise(Country = Country[1], Count = sum(Count))
deaths_china_ttl = deaths_china %>% group_by(Date) %>% summarise(Country = Country[1], Count = sum(Count))

#Write output files
write.csv(confirmed_china, file = "china_confirmed_ttl_orig.csv", row.names = F)
write.csv(recovered_china, file = "china_recovered_ttl_orig.csv", row.names = F)
write.csv(deaths_china, file = "china_deaths_ttl_orig.csv", row.names = F)

