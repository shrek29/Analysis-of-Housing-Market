###########################################################################################################################################################################

#setwd("C:/Users/Sreekanth/Desktop/STAT 425/Housing_data/")
#Loading the data
kings_house_data = read.csv("kingshouse_data.csv", header = TRUE)

#Extracting the year
kings_house_data$date1 = as.numeric(substring(kings_house_data$date,1,8))

#Extract the year and the month
kings_house_data$month = as.numeric(substring(kings_house_data$date,5,6))
kings_house_data$year = as.numeric(substring(kings_house_data$date,1,4))

#Drop the id and the date column and create a data format column
kings_house_data = kings_house_data[,-c(2)]
kings_house_data$date = as.Date(as.character(kings_house_data$date1), "%Y%m%d")

#Drop the id and character format date columns
kings_house_data = kings_house_data[,-c(1, 21)]

#Adding age of the house
kings_house_data$houseage = kings_house_data$year - kings_house_data$yr_built


#############################################################################################################################################################################

#Preprocessing the data to get in the desired final format

kings_house_data_final = kings_house_data[, c(1,4,6,8,9, 13,15,20, 16, 17)]

#Defining the variables to be used in the sidebar panel
vars = unique(kings_house_data_final$zipcode)
minprice = min(kings_house_data$price)
maxprice = max(kings_house_data$price)
