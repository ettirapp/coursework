
library(scales)
library(broom)
library(modelr)
library(tidyverse)

options(na.action = na.warn)

theme_set(theme_bw())

babies <- read.table("babyweights.txt")
model <- lm(bwt ~ smoke, babies)
summary(model)

model2 <- lm(bwt ~ parity, babies)
summary(model2)

model_full <- lm(bwt ~ gestation + parity + age + height + weight + smoke, babies)
summary(model_full)
preds <- babies %>% add_predictions(model_full)