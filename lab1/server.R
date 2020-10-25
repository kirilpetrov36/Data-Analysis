library(shiny)
library(ggplot2)
library(dplyr)
library(treemapify)

#Read data -------------------------------------------------------------------------------------

lct <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")

data <- read.csv(file="DATABASE.csv", sep=";", stringsAsFactors=FALSE, encoding="UTF-8")
vector <- c(as.Date("14may2001", "%d%b%Y"))

for (row in 1:nrow(data)) {
  if(grepl("AM", data[row, 2])){
    data[row, 2] <- gsub(" AM", "", data[row, 2], fixed = TRUE)
  } 
  else if(grepl("PM", data[row, 2])) {
    data[row, 2] <- gsub(" PM", "", data[row, 2], fixed = TRUE)
    if(regexpr(":", data[row, 2]) == 2){
      hour <- substr(data[row, 2], 1, 1)
      hour <- toString(as.numeric(hour) + 12)
      data[row, 2] <- paste(hour, substr(data[row, 2], 3, 4), sep=":")
    } 
    else if (regexpr(":", data[row, 2]) == 3){
      hour <- substr(data[row, 2], 1, 2)
      hour <- toString(as.numeric(hour) + 12)
      if (hour == 24) {
        hour <- "00"
      }
      data[row, 2] <- paste(hour, substr(data[row, 2], 4, 5), sep=":")
    }
  }
  lct <- Sys.getlocale("LC_TIME");
  Sys.setlocale("LC_TIME", "C")
  vector[row] <- as.Date(gsub(".", "", paste(data[row, 1], "2019", sep=""), fixed = TRUE), "%d%b%Y")
  
  data[row, 5] <- gsub("%", "", data[row, 5], fixed = TRUE)
  data[row, 7] <- gsub(" mph", "", data[row, 7], fixed = TRUE)
  data[row, 8] <- gsub(" mph", "", data[row, 8], fixed = TRUE)
  data[row, 9] <- gsub(",", ".", data[row, 9], fixed = TRUE)
}

data$date <- vector
data$date <- factor(data$date)
data$Temperature <- as.numeric(data$Temperature)
data$Dew.Point <- as.numeric(data$Dew.Point)
data$Humidity <- as.numeric(data$Humidity)
data$Wind.Speed <- as.numeric(data$Wind.Speed)
data$Wind.Gust <- as.numeric(data$Wind.Gust)
data$Pressure <- as.double(data$Pressure)

data

# End read data -------------------------------------------------------------------------------------

server <- function(input, output) {
  
# Temperature
  output$temp_point<-renderPlot({
    ggplot(data, aes(x=date, y=Temperature)) + geom_point() +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$temp_count<-renderPlot({
    ggplot(data, aes(x=date, y=Temperature)) + geom_count(col="tomato3", show.legend=F) +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$temp_bar<-renderPlot({
    data %>%
      group_by(date) %>%
      summarize(mean_temperature = mean(Temperature, na.rm = TRUE)) %>%
      ggplot(aes(x = date, y = mean_temperature)) + geom_bar(stat="identity", width=.5, fill="tomato3") +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  
# Dew.Point
  output$dewPoint_point<-renderPlot({
    ggplot(data, aes(x=date, y=Dew.Point)) + geom_point() +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$dewPoint_count<-renderPlot({
    ggplot(data, aes(x=date, y=Dew.Point)) + geom_count(col="tomato3", show.legend=F) +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$dewPoint_bar<-renderPlot({
    data %>%
      group_by(date) %>%
      summarize(mean_dewpoint = mean(Dew.Point, na.rm = TRUE)) %>%
      ggplot(aes(x = date, y = mean_dewpoint)) + geom_bar(stat="identity", width=.5, fill="tomato3") +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  
# Humidity
  output$humidity_point<-renderPlot({
    ggplot(data, aes(x=date, y=Humidity)) + geom_point() +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$humidity_count<-renderPlot({
    ggplot(data, aes(x=date, y=Humidity)) + geom_count(col="tomato3", show.legend=F) +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$humidity_bar<-renderPlot({
    data %>%
      group_by(date) %>%
      summarize(mean_humidity = mean(Humidity, na.rm = TRUE)) %>%
      ggplot(aes(x = date, y = mean_humidity)) + geom_bar(stat="identity", width=.5, fill="tomato3") +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  
# Wind. Speed
  output$windspeed_point<-renderPlot({
    ggplot(data, aes(x=date, y=Wind.Speed)) + geom_point() +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$windspeed_count<-renderPlot({
    ggplot(data, aes(x=date, y=Wind.Speed)) + geom_count(col="tomato3", show.legend=F) +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$windspeed_bar<-renderPlot({
    data %>%
      group_by(date) %>%
      summarize(mean_speed = mean(Wind.Gust, na.rm = TRUE)) %>%
      ggplot(aes(x = date, y = mean_speed)) + geom_bar(stat="identity", width=.5, fill="tomato3") +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  
  # Wind. Gust
  output$windgust_point<-renderPlot({
    ggplot(data, aes(x=date, y=Humidity)) + geom_point() +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$windgust_count<-renderPlot({
    ggplot(data, aes(x=date, y=Wind.Gust)) + geom_count(col="tomato3", show.legend=F) +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$windgust_bar<-renderPlot({
    data %>%
      group_by(date) %>%
      summarize(mean_gust = mean(Wind.Gust, na.rm = TRUE)) %>%
      ggplot(aes(x = date, y = mean_gust)) + geom_bar(stat="identity", width=.5, fill="tomato3") +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  
# Pressure
  output$pressure_point<-renderPlot({
    ggplot(data, aes(x=date, y=Pressure)) + geom_point() +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$pressure_count<-renderPlot({
    ggplot(data, aes(x=date, y=Pressure)) + geom_count(col="tomato3", show.legend=F) +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  output$pressure_bar<-renderPlot({
    data %>%
      group_by(date) %>%
      summarize(mean_Pressure = mean(Pressure, na.rm = TRUE)) %>%
      ggplot(aes(x = date, y = mean_Pressure)) + geom_bar(stat="identity", width=.5, fill="tomato3") +
      theme(axis.text.x = element_text(angle=45, hjust = 1))},
    height = 400,
    width = 850
  )
  
# Wind
  output$wind_bar<-renderPlot({
    ggplot(data, aes(x=Wind)) + geom_bar()
     },
    height = 400,
    width = 850
  )
  output$wind_pie<-renderPlot({
    ggplot(data, aes(x="lol", y=Wind, fill=Wind)) +
      geom_bar(stat="identity", width=1) +
      coord_polar("y", start=0)+
      theme_void()
  },
  height = 400,
  width = 850
  )
 
  
# Condition
  output$condition_bar<-renderPlot({
    ggplot(data, aes(x=Condition)) + geom_bar() +
      theme(axis.text.x = element_text(angle=45, hjust = 1))
  },
  height = 400,
  width = 850
  )
  output$condition_pie<-renderPlot({
    ggplot(data, aes(x="", y=Condition, fill=Condition)) +
      geom_bar(stat="identity", width=1) +
      coord_polar("y", start=0)+
      theme_void()
  },
  height = 400,
  width = 850
  )
  
}