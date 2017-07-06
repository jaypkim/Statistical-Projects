library(readr)
library(tidytext)
library(lubridate)
library(ggplot2)
library(dplyr)
library(plyr)
library(tm)
library(reshape)
library(doBy)

data = read_csv("Code/Test-Case/messages.csv")

# Ensuring that all the data only contains the 
# messages that I send
data_sender = data[!(data$sender != "Jay Kim"),]

# Splitting the date into hours, months, and years
data_sender$hours = hour(data_sender$date)
data_sender$years = year(data_sender$date)
data_sender$months = month(data_sender$date)

## Refactoring the data into time periods
# Time of Day
data_sender$time_of_day
attach(data_sender)
data_sender$time_of_day[data_sender$hours >= 6 & 
                          data_sender$hours <= 11] = "Morning"
data_sender$time_of_day[data_sender$hours > 11 & 
                          data_sender$hours <= 16] = "Afternoon"
data_sender$time_of_day[data_sender$hours > 16 & 
                          data_sender$hours < 20] = "Evening"
data_sender$time_of_day[data_sender$hours >= 20 & 
                         data_sender$hours < 6] = "Night"
# Seasonal
data_sender$season[data_sender$months >= 12 | data_sender$months < 3] = "Winter"
data_sender$season[data_sender$months >= 3 & data_sender$months < 6] = "Spring"
data_sender$season[data_sender$months >= 6 & data_sender$months < 9] = "Summer"
data_sender$season[data_sender$months >= 9 & data_sender$months < 12] = "Fall"


## Frequency
data_2011 = data_sender[ which(data_sender$years == 2011),]
freq_data_2011 = count(data_2011, 'time_of_day')
freq_data_2011$year = 2011
freq_data_2011

data_2012 = data_sender[ which(data_sender$years == 2012),]
freq_data_2012 = count(data_2012, 'time_of_day')
freq_data_2012$year = 2012

data_2013 = data_sender[ which(data_sender$years == 2013),]
freq_data_2013 = count(data_2013, 'time_of_day')
freq_data_2013$year = 2013

data_2014 = data_sender[ which(data_sender$years == 2014),]
freq_data_2014 = count(data_2014, 'time_of_day')
freq_data_2014$year = 2014

## Data merge
data_sender_complete = rbind(freq_data_2011, freq_data_2012, freq_data_2013, freq_data_2014)
data_sender_complete

# Reordering variables (for aesthetics)
data_sender_complete$time_of_day = factor(data_sender_complete$time_of_day, levels = c("Night", "Evening", "Afternoon", "Morning"))

# Year comparison (totals)
ggplot(data_sender_complete, aes(x = year, y = freq )) + 
  geom_bar(stat = "identity",position = "stack", aes(fill = time_of_day)) + 
  scale_fill_brewer(palette = "RdBu", direction = -1) + 
  labs(fill = "Time of Day") + ylab("Total Messages Sent") + xlab("Year") +
  theme(axis.line = element_line(colour = "black"),
                                                                                 panel.grid.major = element_blank(),
                                                                                 panel.grid.minor = element_blank(),
                                                                                 panel.border = element_blank(),
                                                                                 panel.background = element_blank(),
                                                                                 axis.text.x = element_text(color="black"),
                                                                                 axis.text.y = element_text(color="black"))

## 2011 Seasonal data
data_2011_seasons = data_2011
data_2011_seasons
summary(data_2011_seasons)
data_2011_seasons_freq = count(data_2011, 'time_of_day')
data_2011_seasons_freq

# Data is aggregated by time of day and seasons, to understand the total
# occurence of messages based on those variables
data_2011_seasons_completed = aggregate(data_2011_seasons, 
                                        by = list(data_2011_seasons$time_of_day, 
                                                  data_2011_seasons$season), FUN = length)
data_2011_seasons_completed
data_2011_seasons_completed$Group.1 = factor(data_2011_seasons_completed$Group.1, levels = c("Night", "Evening", "Afternoon", "Morning"))


ggplot(data_2011_seasons_completed, aes(x = Group.2, y = thread )) + 
  geom_bar(stat = "identity",position = "stack", aes(fill = Group.1)) + 
  scale_fill_brewer(palette = "RdBu", direction = -1) + 
  labs(fill = "Time of Day") + ylab("Total Messages Sent") + xlab("Season") +
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.x = element_text(color="black"),
        axis.text.y = element_text(color="black"))
 