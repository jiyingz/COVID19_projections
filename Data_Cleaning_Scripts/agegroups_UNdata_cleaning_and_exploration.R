library(dplyr)

data = read.csv("~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/agegroups_UNdata.csv")
data = data[(data$Sex == "Both Sexes" & 
               data$Age != "Total" & 
               data$Age != "" &
               data$Age != "Unknown"),]
data = data[,-10] #remove last col
data = data[!grepl("-",data$Age),] #remove ranges

data$Age = as.character(data$Age)

#Split into age categories
data$Age[data$Age %in% c("0","1","2","3","4","5","6","7","8","9")] = "0-9"
data$Age[data$Age %in% c("10","11","12","13","14","15","16","17","18","19")] = "10-19"
data$Age[data$Age %in% c("20","21","22","23","24","25","26","27","28","29")] = "20-29"
data$Age[data$Age %in% c("30","31","32","33","34","35","36","37","38","39")] = "30-39"
data$Age[data$Age %in% c("40","41","42","43","44","45","46","47","48","49")] = "40-49"
data$Age[data$Age %in% c("50","51","52","53","54","55","56","57","58","59")] = "50-59"
data$Age[data$Age %in% c("60","61","62","63","64","65","66","67","68","69")] = "60-69"
data$Age[data$Age %in% c("70","71","72","73","74","75","76","77","78","79")] = "70-79"
data$Age[data$Age %in% c("80","81","82","83","84","85","86","87","88","89")] = "80-89"
data$Age[data$Age %in% c("90","91","92","93","94","95","96","97","98","99","100")] = "90-100"

idx = data$Age %in% c("0-9","10-19","20-29","30-39","40-49","50-59","60-69","70-79","80-89","90-100")
data = data[idx,]

#Filter for useful cols and rename cols
data = data %>% select(c("Country.or.Area", "Year", "Age", "Value"))
names(data) = c("country_area", "year", "agegroup", "pop")
  
#Aggregate counts
data = data %>%
        group_by(country_area, year, agegroup) %>%
        summarise(pop = sum(pop))

write.csv(data, file = "~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/agegroups_UNdata.csv")

