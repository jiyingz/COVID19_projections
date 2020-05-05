library(dplyr)
library(ggplot2)

data = read.csv("~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/beds_UNdata.csv")
data = data[,-4] #remove col 4
data = data[1:(nrow(data)-4),] #remove footnote rows
names(data) = c("country_area", "years", "beds")
apply(data, 2, typeof)
data$years = as.numeric(as.character(data$years))
data$beds = as.numeric(as.character(data$beds))

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


  
