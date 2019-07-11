library(tidyverse)

load('stop_frisk.csv')

data14 <- read_csv('sqf-2014-csv.csv')
data15 <- read_csv('sqf-2015-csv.csv')
data16 <- read_csv('sqf-2016-csv.csv')
next3 <- rbind(data14, data15, data16) %>% mutate(wepfound = NA)
names(next3) <- tolower(names(next3))

data17 <- readxl::read_xlsx('sqf-2017.xlsx')
data18 <- readxl::read_xlsx('sqf-2018.xlsx')
colnames(data18)[colnames(data18) == "Stop Frisk Time"] <- "STOP_FRISK_TIME"
combined <- rbind(data17, data18)
names(combined) <- tolower(names(combined))

alldata03_16 <- rbind(data, next3)
