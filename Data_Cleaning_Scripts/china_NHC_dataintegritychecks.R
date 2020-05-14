data = read.csv("~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/chinadata_nhc.csv")
#data = data[-nrow(data),]
write.csv(data, file = "~/Documents/School/Grad/Q3/CS472/COVID19_projections/Data/chinadata_nhc.csv", row.names = F)

#Variables
names(data)

#Check if new cases sum up to total
sum((cumsum(data$confirmed_new) + 214) != data$confirmed_ttl)

#Note: some of the data doesn't add up!

#Interpolate new severe cases where possible


