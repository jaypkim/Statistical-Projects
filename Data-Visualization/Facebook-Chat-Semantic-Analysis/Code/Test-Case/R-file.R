library(readr)
library(tidytext)
library(lubridate)
library(ggplot2)
library(dplyr)
library(tidyr)
library(tm)
library(reshape)
library(doBy)
library(rvest)
library(zoo)
library(viridis)
library(gridExtra)
library(shiny)
library(plyr)
library(scales)

data = read_csv("Code/Test-Case/messages.csv")

# Ensuring that all the data only contains the 
# messages that I send
data_sender = data[!(data$sender != "Jay Kim"),]

# Splitting the date into hours, months, and years
data_sender$hours = hour(data_sender$date)
data_sender$years = year(data_sender$date)
data_sender$months = month(data_sender$date)
## Recoding the data into time periods
# Time of Day
data_sender$time_of_day = NA
data_sender$time_of_day[data_sender$hours >= 6 & 
                          data_sender$hours <= 11] = "Morning"
data_sender$time_of_day[data_sender$hours > 11 & 
                          data_sender$hours <= 16] = "Afternoon"
data_sender$time_of_day[data_sender$hours > 16 & 
                          data_sender$hours < 20] = "Evening"
data_sender$time_of_day[data_sender$hours >= 20 | 
                         data_sender$hours < 6] = "Night"
# Seasonal
data_sender$season = NA
data_sender$season[data_sender$months >= 12 | data_sender$months < 3] = "Winter"
data_sender$season[data_sender$months >= 3 & data_sender$months < 6] = "Spring"
data_sender$season[data_sender$months >= 6 & data_sender$months < 9] = "Summer"
data_sender$season[data_sender$months >= 9 & data_sender$months < 12] = "Fall"


## Frequency
data_2011 = data_sender[ which(data_sender$years == 2011),]
data_2011
freq_data_2011 = data_2011 %>%
  group_by(data_2011$time_of_day) %>%
  tally()
freq_data_2011$year = 2011
freq_data_2011
## dplyr::rename_ works to avoid package hell
names(freq_data_2011) = c("time_of_day", "freq", "year")

# understanding the frequency of chat per year
# isolating all data to only 2012
data_2012 = data_sender[ which(data_sender$years == 2012),]
# obtaining frequency counts
freq_data_2012 = 
  data_2012 %>%
  group_by(data_2012$time_of_day) %>%
  tally()

freq_data_2012$year = 2012
names(freq_data_2012) = c("time_of_day", "freq", "year")
freq_data_2012

data_2013 = data_sender[ which(data_sender$years == 2013),]
freq_data_2013 = 
  data_2013 %>%
  group_by(data_2013$time_of_day) %>%
  tally()

freq_data_2013$year = 2013
names(freq_data_2013) = c("time_of_day", "freq", "year")

data_2014 = data_sender[ which(data_sender$years == 2014),]
freq_data_2014 = 
  data_2011 %>%
  group_by(data_2011$time_of_day) %>%
  tally()

freq_data_2014$year = 2014
names(freq_data_2014) = c("time_of_day", "freq", "year")

# writing df to csv for tableau
freq_data_2011_hours = 
  data_2011 %>%
  group_by(data_2011$hours) %>%
  tally()

freq_data_2011_hours = rbind(freq_data_2011_hours, c(11,0))
freq_data_2011_hours$PathOrder = NA
freq_data_2011_hours$PathOrder[freq_data_2011_hours$n > 0] = 1

names(freq_data_2011_hours) = c("hours", "freq", "year")
gs.pal <- colorRampPalette(c("#1A174D","#FFD700","#1A174D"),bias=1,space="rgb")
color_count = length(unique(freq_data_2011_hours$hours))
colors = gs.pal(color_count)

color_count

## Creating an empty data frame for a graph with only the ticks (for every hour)
internal_ticks = data.frame(seq(0,23, by = 1), 0)
internal_ticks$X0

## The actual graph
ggplot(freq_data_2011_hours, aes(x = hours, y = freq))+
  scale_fill_manual(values = gs.pal(24), name = "Hours", breaks = seq(0,23, by = 6)) +
  geom_bar(width = 1, stat = "identity", aes(fill = factor(hours))) + labs(x = "", y ="") +
  scale_y_continuous(limits = c(-5000,4000)) + scale_x_continuous(breaks = seq(0, 23, by = 24), labels = seq(0,23, by = 24), position = "bottom") +
  coord_polar(start = -pi/24)+ 
  theme(axis.line = element_line(colour = "white"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.text.x = element_text(color="black"),
        axis.text.y = element_text(color="white"),
        axis.ticks = element_blank()) 

## To obtain the data visualization for the inner ticks
## Superimposing plots do not work with ggplot, so I manually
## copied this plot into the above plot
ggplot(internal_ticks, aes(x = seq.0..23..by...1., y = X0)) +
  geom_bar(width = 1, stat = "identity", aes(fill = factor(seq.0..23..by...1.))) +
  labs(x = "", y = "") +
  scale_y_continuous(limits = c(-2, 10)) + coord_polar(start = -pi/24) + 
  scale_x_continuous(breaks = seq(0,23, by = 1)) + theme(axis.line = element_line(colour = "white"),
                                                         panel.grid.major = element_blank(),
                                                         panel.grid.minor = element_blank(),
                                                         panel.border = element_blank(),
                                                         panel.background = element_blank(),
                                                         axis.text.x = element_text(color="black"),
                                                         axis.text.y = element_text(color="white"),
                                                         axis.ticks = element_blank(),
                                                         legend.position = "none")


## grid arrange can be used to combine plots (although not superimpose)

freq_data_2012_hours = count(data_2012, 'hours')
freq_data_2012_hours
freq_data_2012_hours_copy = freq_data_2012_hours
freq_data_2012_hours_copy$freq = 0
freq_data_2012_hours = rbind(freq_data_2012_hours, freq_data_2012_hours_copy)
freq_data_2012_hours$PathOrder[freq_data_2012_hours$freq > 0] = 1
freq_data_2012_hours$PathOrder[freq_data_2012_hours$freq == 0] = 0
names(freq_data_2011_hours) = c("hours", "freq", "year")


freq_data_2013_hours = count(data_2013, 'hours')
freq_data_2013_hours_copy = freq_data_2013_hours
freq_data_2013_hours_copy$freq = 0
freq_data_2013_hours = rbind(freq_data_2013_hours, freq_data_2013_hours_copy)
freq_data_2013_hours$PathOrder[freq_data_2013_hours$freq > 0] = 1
freq_data_2013_hours$PathOrder[freq_data_2013_hours$freq == 0] = 0

freq_data_2014_hours = count(data_2014, 'hours')
freq_data_2014_hours_copy = freq_data_2014_hours
freq_data_2014_hours_copy$freq = 0
freq_data_2014_hours = rbind(freq_data_2014_hours, freq_data_2014_hours_copy)
freq_data_2014_hours$PathOrder[freq_data_2014_hours$freq > 0] = 1
freq_data_2014_hours$PathOrder[freq_data_2014_hours$freq == 0] = 0


write.csv(x = freq_data_2011_hours, file ="data_2011.csv")
write.csv(x = freq_data_2012_hours, file ="data_2012.csv")
write.csv(x = freq_data_2013_hours, file ="data_2013.csv")
write.csv(x = freq_data_2014_hours, file ="data_2014.csv")


## Data merge 
# This is a tibble with the frequency of the time of day, separated by year
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

## Data parser from friends - showing time-line updates
friends_html = read_html("Code/Test-Case/friends.htm")
friends = html_nodes(friends_html, 'body > div.contents > div > ul:nth-child(2)')

friends_data_test = html_nodes(friends, 'li') %>%
  html_text()
head(friends_data_test)

# applied the data.frame function to the list
friends_df = ldply(friends_data_test, data.frame)
# renamed the weird column name
friends_df$names = friends_df$X..i.. 
# replaced factor into characters
friends_df$names = as.character(friends_df$names)

# left only the names column instead of the original weird name
friends_df = subset(friends_df, select = -c(1))
head(friends_df)
# parsed through data, creating a column of names and dates
foo = friends_df %>%
  separate(names, into = c("name", "date"), sep="\\(" )
# cleaning through, removing special character bracket
foo$date = strsplit(foo$date, "\\)")
# transforming list format to vector (column)
foo$date = unlist(foo$date)
head(foo$date)
# The date inside is mixed into two formats in the same column
#   %b %d for all 2017 data
#   %b %d, %y
# will separate the dates based on the comma delimiter
# transform to POSITX conditionally
year_stuff = foo[grep('\\,', foo$date),]
tail(year_stuff)
year_stuff$date = strptime(year_stuff$date, format = '%b %d, %Y')
year_stuff

same_year_stuff = foo[1:20,]
same_year_stuff$date = strptime(same_year_stuff$date, format = '%b %d')
same_year_stuff$date

foo_complete = foo
foo_complete = rbind(same_year_stuff, year_stuff)
foo_complete$date


foo_freq = count(foo_complete, 'date')
cum = cumsum(foo_freq$freq)

daty = unique(foo_complete$date)
friend_growth = data.frame(cum, daty)

ggplot(data = friend_growth, aes(x = daty, y = 38 + 608 - cum)) +
  geom_line()

# if possible, annotate it! 2013= graduate, college,  2015 = internship, club leader, 2009 
# = high school, beginning, color in the segments posssibly to represent this?

## Comparing growth of friends to message frequency

comparative_foo = foo
comparative_foo = rbind(same_year_stuff, year_stuff)
comparative_foo
comparative_foo$date
comparative_foo_freq = count(comparative_foo, 'date')
head(comparative_foo_freq)
data$no_hour = trunc(data$date, "days")
messages = unique(data$no_hour)

messages = data.frame(messages)
attributes(messages)$tzone = "EST"
tail(messages)
colnames(messages)[colnames(messages) == "messages"] = "date"
attributes(comparative_foo_freq$date)$tzone = "EST"
complete_comparative_foo = rbind.fill(comparative_foo_freq, messages)
head(complete_comparative_foo)
tail(complete_comparative_foo)
## Note, the index ordering is weird, and that the hours are irrelevant, as
## messages are "0" as it is EST, while the friends data did not include initial hours
complete_comparative_foo$date = trunc(complete_comparative_foo$date, "days")
complete_comparative_foo[is.na(complete_comparative_foo)] = 0
# order by date
complete_comparative_foo = complete_comparative_foo[order(complete_comparative_foo$date),]
complete_comparative_foo
cum = cumsum(complete_comparative_foo$freq)
tail(cum)
complete_comparative_foo$cum_friends = cum + 38
head(complete_comparative_foo)

## ^^ Finished with friends data set cleaning

data$date
count_messages = data.frame(table(format(data$no_hour, "%y-%m-%d")))
head(count_messages)
count_messages$Var1 = as.character(count_messages$Var1)
count_messages$Var1 = as.POSIXlt(count_messages$Var1, format = "%y-%m-%d")
attributes(count_messages$Var1)$tzone = "EST"
attributes(comparative_foo$date)$tzone = "EST"
head(count_messages)
class(count_messages$Var1)
count_messages$Var1
colnames(count_messages)[colnames(count_messages) == "Var1"] = "date"

complete_comparative_messages = rbind.fill(count_messages, comparative_foo_freq)
head(complete_comparative_messages)
tail(complete_comparative_messages)

complete_comparative_messages$date = trunc(complete_comparative_messages$date, "days")
head(complete_comparative_messages)

class(complete_comparative_messages$Var1)
class(complete_comparative_messages$date)

complete_comparative_messages[is.na(complete_comparative_messages)] = 0
# order by date
complete_comparative_messages = complete_comparative_messages[order(complete_comparative_messages$date),]
head(complete_comparative_messages)
cum = cumsum(complete_comparative_messages$Freq)
tail(cum)
complete_comparative_messages$cum_messages = cum
head(complete_comparative_messages)
tail(complete_comparative_messages)
## done

head(complete_comparative_foo)
head(complete_comparative_messages)
# deleting names
complete_comparative_messages = complete_comparative_messages[c(-3)]
colnames(complete_comparative_messages)
complete_comparative_foo$date = as.POSIXct(complete_comparative_foo$date)
complete_comparative_messages$date = as.POSIXct(complete_comparative_messages$date)
comparing_friends_messages = merge(complete_comparative_foo, complete_comparative_messages)
head(comparing_friends_messages)

ggplot(comparing_friends_messages, aes(cum_friends)) +
  geom_line(aes(y = cum_messages))

# Separate this into close and non-close friends?
# That is, include the names column here for messages and add an identifying column
# for closeness.
# identify closeness by the max number of messages by person
# then make y lines comparing close friend messages to non-close friends


## counting only friend growth now over time (exploratory)

total_messages = cumsum(count_messages$Freq)
total_messages = data.frame(total_messages, messages)
tail(total_messages)
total_messages$friends = NA
colnames(total_messages)[colnames(total_messages) == "messages"] = "date"

colnames(friend_growth)[colnames(friend_growth) == "daty"] = "date"
colnames(friend_growth)[colnames(friend_growth) == "cum"] = "friends"
friend_growth$total_messages = NA
max(friend_growth$date)
colnames(friend_growth)
colnames(total_messages)

comparing_friend_message = rbind(total_messages, friend_growth)
comparing_friend_message$friends = - comparing_friend_message$friends + 38 + 608
comparing_friend_message$total_messages = - comparing_friend_message$total_messages + 107083

ggplot(data = comparing_friend_message, aes(date)) +
  geom_line(aes(y = comparing_friend_message$total_messages, color = "red")) +
  geom_line(aes(y = comparing_friend_message$friends, color = "blue"))


ggplot(data = comparing_friend_message, aes(x= friends)) +
  geom_line(aes(y = total_messages, color = "blue"))

## Comparing Social outgoingness
data_sender
message_freq_by_id = count(data_sender, 'thread')
head(message_freq_by_id)

## Deciding if someone is a good friend based on if they have more than 
## 1000 messages. If less than 1000 but more than 100, friend
## If less than 100 but more than 25, work colleague
## If less than 25, not really friend

message_freq_by_id = message_freq_by_id %>%
  mutate(good_friend = case_when(
    freq >= 1000 ~ 3,
    freq >= 100 & freq < 1000 ~ 2,
    freq > 25 & freq < 100 ~ 1,
    TRUE ~ 0) )

# message_freq_by_id[1,]$thread = "India Fullerton"
# message_freq_by_id[2,]$thread = "Cristiam Enciso"
# message_freq_by_id[3,]$thread = "Amelia Helin"
# message_freq_by_id[4,]$thread = "Shabbu Sayed"
# message_freq_by_id[5,]$thread = "Sarah Hock"
# message_freq_by_id[6,]$thread = "David Grigg"
# message_freq_by_id[7,]$thread = "Rebecca Cook"
# message_freq_by_id[8,]$thread = "Jesus Aviles"
# message_freq_by_id[10,]$thread = "Natalie Whiting"
# message_freq_by_id[11,]$thread = "Chelsea Gabeler"
# message_freq_by_id[12,]$thread = "Larry Rhoop"
# message_freq_by_id[13,]$thread = "Tessah Warren"
# message_freq_by_id[14,]$thread = "Hannah Adams"
# message_freq_by_id[15,]$thread = "Amanda Lifter"
# message_freq_by_id[16,]$thread = "Robert Wehrli"
# message_freq_by_id = message_freq_by_id[which(message_freq_by_id$thread != "1253375952@facebook.com, 1784408966@facebook.com"),]
head(message_freq_by_id)
ordered.message.freq.by.id = message_freq_by_id[order(-message_freq_by_id$freq),]
head(ordered.message.freq.by.id)

## Useless right now, but this is a flattener function that expands the
## frequency table into its original form
# tableinv <- function(x){
#   y <- x[rep(rownames(x),x$freq),1:(ncol(x))]
#   rownames(y) <- c(1:nrow(y))
#   return(y)}

## merge based

## NOTE: CANNOT DO THIS!
# must make a new frequency measure by which it adds upon the prior
# message's count
## To do so, order by date, then make an additive frequency based on time

complete.friended.data = merge(data_sender, message_freq_by_id, by ="thread", all.x = TRUE)
colnames(complete.friended.data)
# why not just make a new column with the cum sum next to it?
complete.friend.type = complete.friended.data %>%
  group_by(date) %>%
  mutate(cumsum = cumsum(freq))
## issue: frequency is same as long



complete.total = cumsum(complete.friended.data$freq)
ggplot()
complete.total = data.frame(complete.friended.data, complete.total)
head(complete.total)
colnames(complete.total)[colnames(complete.total) == "complete.total"] = "cumulative_freq"
colnames(complete.total)
head(complete.total$date)
complete.total$date = trunc(complete.total$date, "days")

ggplot(data = complete.total, aes(years, cumulative_freq, color = good_friend)) +
  geom_point(alpha = 0.01)

## debugging
# why is there different/not good cum sum?
max(complete.total[which(complete.total$years == 2013),]$cumulative_freq)
min(complete.total[which(complete.total$years == 2014),]$cumulative_freq)
## clearly it's not transitioning based on the date, maybe limited to year due to posix form?

complete.total[which(complete.total$year == 2014 & complete.total$cumulative_freq < 5*10^7),] 
# message_freq_by_id = message_freq_by_id[which(message_freq_by_id$thread != "1253375952@facebook.com, 1784408966@facebook.com"),]
