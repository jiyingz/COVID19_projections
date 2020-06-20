library(ggplot2)
library(tidyverse)
library(lubridate)

#FRANCE
france = read.csv("~/.../Data/france_cases_deaths_severe_recovered_ministresante.csv")

france$date = ymd(france$date)
france$dateind = as.numeric(rownames(france))

france_deaths = france %>% dplyr::select(dateind, deaths_ttl) %>% na.omit()
france_deaths$death_slope = NA

window_size = 15 #num days to slide moving window over
lag_days = 3
c = 15
for(i in window_size:nrow(france_deaths)) {
  lm = lm(deaths_ttl ~ dateind, data = france_deaths[(i-(window_size-1)):i,])
  france_deaths$death_slope[i-lag_days] = lm$coeff[2]
}

france = france %>% left_join(france_deaths)

france %>%
  ggplot() +
  geom_line(aes(x = date, y = severe_ttl), color = "red") +
  geom_line(aes(x = date, y = deaths_ttl), color = "blue") +
  geom_line(aes(x = date, y = death_slope*c), color = "green") +
  labs(title = "Severe Case Prediction from Deaths: France", 
       subtitle = "Blue = Ttl Deaths, Red = Ttl Severe, Green = Predicted Severe",
       x = "Date", y = "Cases") +
  theme(plot.title = element_text(hjust=0.5),
        plot.subtitle = element_text(hjust=0.5))

#NETHERLANDS
neth_hosp = read.csv("~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/netherlands_hospitalization_statista.csv")
neth_deaths = read.csv("~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/world_cases_deaths_recovered_JHU.csv")
neth = neth_deaths[(neth_deaths$country == "Netherlands" & neth_deaths$province == ""),] %>% 
          left_join(neth_hosp) %>%
          dplyr::select(date, deaths, hospitalizations_ttl)

neth$date = ymd(neth$date)
neth$dateind = as.numeric(rownames(neth))

neth_deaths = neth %>% dplyr::select(dateind, deaths) %>% na.omit()
neth_deaths$death_slope = NA

window_size = 15 #num days to slide moving window over
lag_days = 3
c = 50
for(i in window_size:nrow(neth_deaths)) {
  lm = lm(deaths ~ dateind, data = neth_deaths[(i-(window_size-1)):i,])
  neth_deaths$death_slope[i-lag_days] = lm$coeff[2]
}

neth = neth %>% left_join(neth_deaths)

neth %>%
  ggplot() +
  geom_line(aes(x = date, y = deaths), color = "blue") +
  geom_line(aes(x = date, y = hospitalizations_ttl), color = "red") +
  geom_line(aes(x = date, y = death_slope*c), color = "green") +
  labs(title = "Severe Case Prediction from Deaths: Netherlands", 
       subtitle = "Blue = Ttl Deaths, Red = Ttl Hospitalizations, Green = Predicted Hospitalizations",
       x = "Date", y = "Cases") +
  theme(plot.title = element_text(hjust=0.5),
        plot.subtitle = element_text(hjust=0.5))

#Note: Model seems to be able to predict total # in hospital per day pretty well -- but it is not fitted for total hospitalization/severe cases cumulative
#Impossible to derive one from the other since if hospital counts remain constant over two days, cannot tell if one in one out or same people stayed in
#Note: severe cases not same as hospitalizations! 

#CHINA
china = read.csv("~/.../COVID19_projections/Data/china_cases_severe_deaths_nhc.csv") %>%
  dplyr::select(date, severe_ttl, deaths_ttl)
china = china[1:80,]

china$date = ymd(china$date)
china$dateind = as.numeric(rownames(china))

china_deaths = china %>% dplyr::select(dateind, deaths_ttl) %>% na.omit()
china_deaths$death_slope = NA

window_size = 15 #num days to slide moving window over
lag_days = 3
c = 100
for(i in window_size:nrow(china_deaths)) {
  lm = lm(deaths_ttl ~ dateind, data = china_deaths[(i-(window_size-1)):i,])
  china_deaths$death_slope[i-lag_days] = lm$coeff[2]
}

china = china %>% left_join(china_deaths)

china %>%
  ggplot() +
  geom_line(aes(x = date, y = deaths_ttl), color = "blue") +
  geom_line(aes(x = date, y = severe_ttl), color = "red") +
  geom_line(aes(x = date, y = death_slope*c), color = "green") +
  labs(title = "Severe Case Prediction from Deaths: China", 
       subtitle = "Blue = Ttl Deaths, Red = Ttl Severe, Green = Predicted Severe",
       x = "Date", y = "Cases") +
  theme(plot.title = element_text(hjust=0.5),
        plot.subtitle = element_text(hjust=0.5))
