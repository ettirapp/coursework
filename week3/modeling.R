library(scales)
library(broom)
library(modelr)
library(tidyverse)

options(na.action = na.warn)

theme_set(theme_bw())
options(repr.plot.width=4, repr.plot.height=3)

users <- read_tsv(gzfile('users.tsv.gz'))
head(users)


# histogram of the label/regressor variable:
ggplot(users, aes(x = daily.views)) +
  geom_histogram(bins = 50) +
  scale_x_log10(label=comma, breaks=10^(0:ceiling(log10(max(users$daily.views))))) +
  scale_y_continuous(label = comma) +
  xlab('Daily pageviews') +
  ylab('')

ggplot(data = users, aes(x = age, y = daily.views)) +
  geom_point() +
  facet_wrap(~ gender) +
  xlab('Age') +
  ylab('Daily pageviews')

nrow(users)
users <- filter(users, daily.views > 0)
nrow(users)

views_by_age_and_gender <- users %>%
  filter(age <= 90) %>%
  group_by(age, gender) %>%
  summarize(count = n(),
            median_daily_views = median(daily.views))
head(views_by_age_and_gender)


options(repr.plot.width=6, repr.plot.height=3)
ggplot(views_by_age_and_gender, aes(x = age, y = median_daily_views, color = gender)) +
  geom_line(aes(linetype=gender)) +
  geom_point(aes(size = count)) +
  xlab('Age') + 
  ylab('Daily pageviews') +
  scale_size_area(guide = F) +
  theme(legend.title=element_blank())

model_data <- filter(users, age >= 18 & age <= 65)


options(repr.plot.width=4, repr.plot.height=3)
ggplot(model_data, aes(x = age, y = daily.views)) +
  geom_smooth(method = "lm") +
  scale_y_log10(breaks = 1:100)

model <- lm(log10(daily.views) ~ age, model_data)
model
summary(model)

tidy(model)
glance(model)


M <- model.matrix(log10(daily.views) ~ age, model_data)
head(M)
tail(M)


plot_data <- model_data %>%
  data_grid(age) %>%
  add_predictions(model) %>%
  mutate(pred = 10^pred)
head(plot_data)

plot_data <- model_data %>%
  data_grid(age) %>%
  add_predictions(model) %>%
  mutate(pred = 10^pred)
head(plot_data)


ggplot(plot_data, aes(x = age, y = pred)) +
  geom_line()

plot_data <- model_data %>%
  group_by(age) %>%
  summarize(count = n(),
            geom_mean_daily_views = 10^(mean(log10(daily.views)))) %>%
  add_predictions(model) %>%
  mutate(pred = 10^pred)
head(plot_data)


ggplot(plot_data, aes(x = age, y = pred)) +
  geom_line(aes(y = pred)) +
  geom_point(aes(y = geom_mean_daily_views, size = count)) +
  scale_size_area(guide = F)


model <- lm(log10(daily.views) ~ age + I(age^2), model_data)
model
tidy(model)
glance(model)


M <- model.matrix(log10(daily.views) ~ age + I(age^2), model_data)
head(M)


plot_data <- model_data %>%
  group_by(age) %>%
  summarize(count = n(),
            geom_mean_daily_views = 10^(mean(log10(daily.views)))) %>%
  add_predictions(model) %>%
  mutate(pred = 10^pred)

ggplot(plot_data, aes(x = age, y = pred)) +
  geom_line(aes(y = pred)) +
  geom_point(aes(y = geom_mean_daily_views, size = count)) +
  scale_size_area(guide = F)


form <- as.formula(log10(daily.views) ~ gender + age + I(age^2))
M <- model.matrix(form, model_data)
model <- lm(form, model_data)
head(M)
model


options(repr.plot.width=6, repr.plot.height=3)
plot_data <- model_data %>%
  group_by(age, gender) %>%
  summarize(count = n(),
            geom_mean_daily_views = 10^(mean(log10(daily.views)))) %>%
  add_predictions(model) %>%
  mutate(pred = 10^pred)

ggplot(plot_data, aes(x = age, y = pred, color = gender)) +
  geom_line(aes(y = pred)) +
  geom_point(aes(y = geom_mean_daily_views, size = count)) +
  scale_size_area(guide = F)


form <- as.formula(log10(daily.views) ~ gender * (age + I(age^2)))
M <- model.matrix(form, model_data)
model <- lm(form, model_data)
head(M)
model


plot_data <- model_data %>%
  group_by(age, gender) %>%
  summarize(count = n(),
            geom_mean_daily_views = 10^(mean(log10(daily.views)))) %>%
  add_predictions(model) %>%
  mutate(pred = 10^pred)

options(repr.plot.width=6, repr.plot.height=3)
ggplot(plot_data, aes(x = age, y = pred, color = gender)) +
  geom_line(aes(y = pred)) +
  geom_point(aes(y = geom_mean_daily_views, size = count)) +
  scale_size_area(guide = F)

#EVALUATING MODELS:

library(tidyverse)
library(scales)

library(modelr)
options(na.action = na.warn)

library(broom)

theme_set(theme_bw())
options(repr.plot.width=4, repr.plot.height=3)

users <- read_tsv(gzfile('users.tsv.gz'))

model_data <- filter(users, daily.views > 0, age >= 18 & age <= 65)

form <- as.formula(log10(daily.views) ~ gender * (age + I(age^2)))
M <- model.matrix(form, model_data)
head(M)


model <- lm(form, model_data)
tidy(model)
glance(model)


plot_data <- model_data %>%
  group_by(age, gender) %>%
  summarize(count = n(),
            geom_mean_daily_views = 10^(mean(log10(daily.views)))) %>%
  add_predictions(model) %>%
  mutate(pred = 10^pred)

options(repr.plot.width=6, repr.plot.height=3)
ggplot(plot_data, aes(x = age, y = pred, color = gender)) +
  geom_line(aes(y = pred)) +
  geom_point(aes(y = geom_mean_daily_views, size = count)) +
  scale_size_area(guide = F)


options(repr.plot.width=4, repr.plot.height=3)

ggplot(plot_data, aes(x = pred, y = geom_mean_daily_views)) +
  geom_point() +
  geom_abline(linetype = "dashed") +
  xlab('Predicted') +
  ylab('Actual')


ggplot(plot_data, aes(x = pred, y = geom_mean_daily_views, color = gender)) +
  geom_point() +
  geom_abline(linetype = "dashed") +
  xlab('Predicted') +
  ylab('Actual')


ggplot(plot_data, aes(x = pred, y = geom_mean_daily_views, color = desc(age))) +
  geom_point() +
  geom_abline(linetype = "dashed") +
  xlab('Predicted') +
  ylab('Actual') +
  facet_wrap(~ gender, scale = "free")

pred_actual <- model_data %>%
  add_predictions(model) %>%
  mutate(actual = log10(daily.views))

head(pred_actual)

ggplot(pred_actual, aes(x = 10^pred, y = 10^actual)) +
  geom_point(alpha = 0.1) +
  geom_abline(linetype = "dashed") +
  scale_x_log10(label = comma, breaks = seq(0,100,by=10)) +
  scale_y_log10(label = comma) +
  xlab('Predicted') +
  ylab('Actual')


pred_actual %>%
  summarize(rmse = sqrt(mean((pred - actual)^2)))


pred_actual %>%
  summarize(rmse = sqrt(mean((10^pred - 10^actual)^2)))


pred_actual %>%
  summarize(rmse = sqrt(mean((pred - actual)^2)),
            cor = cor(pred, actual),
            cor_sq = cor^2)

rmse(model, model_data)
rsquare(model, model_data)

pred_actual %>%
  summarize(mse = mean((pred - actual)^2),
            mse_baseline = mean((mean(actual) - actual)^2),
            mse_vs_baseline = (mse_baseline - mse) / mse_baseline,
            cor = cor(pred, actual),
            cor_sq = cor^2)


K <- 30
form <- as.formula(log10(daily.views) ~ gender * poly(age, K, raw=T))
M <- model.matrix(form, model_data)
head(M)

model <- lm(form, model_data)
glance(model)
tidy(model)


plot_data <- model_data %>%
  group_by(age, gender) %>%
  summarize(count = n(),
            geom_mean_daily_views = 10^(mean(log10(daily.views)))) %>%
  add_predictions(model) %>%
  mutate(pred = 10^pred)

options(repr.plot.width=6, repr.plot.height=3)
ggplot(plot_data, aes(x = age, y = pred, color = gender)) +
  geom_line(aes(y = pred)) +
  geom_point(aes(y = geom_mean_daily_views, size = count)) +
  scale_size_area(guide = F)
