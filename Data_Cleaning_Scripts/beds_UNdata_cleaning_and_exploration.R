library(dplyr)
library(ggplot2)

#CLEANING

data = read.csv("~/Downloads/UNdata_Export_20200520_060409390.csv")
data = data[1:(nrow(data)-4),-4] #remove footnotes
names(data) = c("country_area", "years", "beds")
data$country_area = as.character(data$country_area)
data$years = as.numeric(as.character(data$years))
data$beds = as.numeric(as.character(data$beds))


#EXPLORATION

#Line plot for changes in num of beds per country
data %>%
  ggplot(aes(x = years, y = beds, color = country_area)) +
  geom_line() +
  theme(legend.position = "none")

#Which countries had top changes in bed availability
data %>%
  group_by(country_area) %>%
  summarise(diff = max(beds) - min(beds)) %>%
  arrange(desc(diff))#there's generally not a huge increase in beds per 10k ppl over half decades... 



#
data_rec = data %>% 
            group_by(country_area) %>%
            arrange(desc(years)) %>%
            slice(1) %>%
            dplyr::select(country_area, beds)
  
data_rec$country_area[which(data_rec$country_area == "Democratic People's Republic of Korea")] = "South Korea"
data_rec$country_area[which(data_rec$country_area == "United Kingdom")] = "UK"
data_rec$country_area[which(data_rec$country_area == "United States of America")] = "US"
  
  
  
write.csv(data_rec, file = "~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/beds_UNdata.csv")
