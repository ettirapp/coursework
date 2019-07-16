library(tidyverse)

data03 <- read_csv('sqf-2003-csv.csv')
data04 <- read_csv('sqf-2004-csv.csv')
data05 <- read_csv('sqf-2005-csv.csv')
data06 <- read_csv('sqf-2006-csv.csv')
data07 <- read_csv('sqf-2007-csv.csv')
data08 <- read_csv('sqf-2008-csv.csv')
data09 <- read_csv('sqf-2009-csv.csv')
data10 <- read_csv('sqf-2010-csv.csv')
data11 <- read_csv('sqf-2011-csv.csv')
data12 <- read_csv('sqf-2012-csv.csv')
data13 <- read_csv('sqf-2013-csv.csv')
data14 <- read_csv('sqf-2014-csv.csv')
data15 <- read_csv('sqf-2015-csv.csv')
data16 <- read_csv('sqf-2016-csv.csv')

names(data13) <- tolower(names(data13))

alldata111 <- rbind(data03, data04, data05, data07, data08, data09, data10) %>%
  mutate(forceuse = NA)
alldata112 <- rbind(data11, data12, data13)

alldata <- rbind(alldata111, alldata112) %>% mutate(wepfound = NA)

data06 <- data06 %>% mutate(stname = strname, stinter = strintr, rescode = rescod,
                  premtype = premtyp, premname = prenam, dettypcm = dettyp_c,
                  addrnum = adrnum, addrpct = adrpct, detailcm = details_, 
                  forceuse = NA, linecm = NA) %>%
  select(-strname, -strintr, -rescod, -premtyp, -prenam, -dettyp_c,
         -adrnum, -adrpct, -details_, -detail1_)

data <- rbind(alldata, data06)


next3 <- rbind(data14, data15, data16) %>% mutate(wepfound = NA)
names(next3) <- tolower(names(next3))

data17 <- readxl::read_xlsx('sqf-2017.xlsx')
data18 <- readxl::read_xlsx('sqf-2018.xlsx')
colnames(data18)[colnames(data18) == "Stop Frisk Time"] <- "STOP_FRISK_TIME"
combined <- rbind(data17, data18)
names(combined) <- tolower(names(combined))

alldata03_16 <- rbind(data, next3)