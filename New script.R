### REAL ESTATE SECTOR PROJECT

library(tidyverse)
library(dplyr)
library(readr)
library(sf)
library(ggplot2)
library(fpp2) # package from the "Forecasting in R" DataCamp course
library(glmnet)
library(caret)
library(randomForest)
library(ranger)
library(writexl)
library(gridExtra)
library(car)
library(MASS)
library(fpp3)
library(lmtest)
library(sandwich)


# PART 1: Load in data

## 1) Daily market data
Daily_Market_Data <- readr::read_csv("C:/Users/Paolo/Desktop/Project/Data from SQL/daily_market_data_re.csv")


## 2) Monthly frequency Long term
Data_Monthly_LT <- readr::read_csv("C:/Users/Paolo/Desktop/Bootcamp project new/economy_stockmarket_monthly_re.csv")


## 3) Monthly frequency Medium term
Data_Monthly_MT <- readr::read_csv("C:/Users/Paolo/Desktop/Bootcamp project new/economy_sm_monthly_mt_re.csv")


## 4) Quarterly frequency Long term
Data_Quarterly_LT <- readr::read_csv("C:/Users/Paolo/Desktop/Bootcamp project new/economy_stockmarket_quarterly_re.csv")


## 5) Quarterly frequency Medium term
Data_Quarterly_MT <- readr::read_csv("C:/Users/Paolo/Desktop/Bootcamp project new/economy_sm_quarterly_mt_re.csv")






# PART 2: OLS models
# Base model
real_estate_lm <- lm(avg_real_estate ~ interest_rate_us + gdp_growth_rate + 
                     interpolated_cpi + euro_dollar + avg_gold_us_price + avg_vix_close + avg_sandp_close,
                     data = Data_Monthly_MT)


# Stepwise selection
step_real_estate <- stepAIC(real_estate_lm, direction = "both")
summary(step_real_estate)

vif(step_real_estate)

par(mfrow = c(2, 2))
plot(step_real_estate)


# Durbin-Watson test for autocorrelation
dwtest(step_real_estate)

# Or check autocorrelation of residuals
acf(residuals(step_real_estate))






set.seed(123)

n <- nrow(na.omit(Data_Monthly_MT))
train_idx <- 1:floor(0.8 * n)  # first 80% of data
test_idx  <- (floor(0.8 * n) + 1):n

train_data <- Data_Monthly_MT[train_idx, ]
test_data  <- Data_Monthly_MT[test_idx, ]

model_train <- lm(formula(step_real_estate), data = train_data)

pred <- predict(model_train, newdata = test_data)

# RMSE
rmse <- sqrt(mean((test_data$avg_real_estate - pred)^2, na.rm = TRUE))
rmse







# PART 3: OLS models have high autocorrelation and are heteroscedastic, hence ARIMA models, which are bettter than OLS models
# Select the variables and coerce to numeric matrix
xreg_mat <- as.matrix(
  sapply(Data_Monthly_MT[, c("interest_rate_us", "gdp_growth_rate",
                             "interpolated_cpi", "euro_dollar",
                             "avg_sandp_close")],
         as.numeric)
)

# Optionally, remove rows with NA in response or predictors
complete_idx <- complete.cases(Data_Monthly_MT$avg_real_estate, xreg_mat)
y <- Data_Monthly_MT$avg_real_estate[complete_idx]
xreg_mat <- xreg_mat[complete_idx, ]



# ARIMA model
fit <- auto.arima(y, xreg = xreg_mat)
summary(fit)

# Check residuals
checkresiduals(fit) # good white noise residuals











# PART 4: ARIMA models to forecast the real estate sector
# Real estate variable over time
Data_Monthly_MT_tsbl <- Data_Monthly_MT %>%
  mutate(month_date = yearmonth(month_date)) %>%
  as_tsibble(index = month_date)

autoplot(Data_Monthly_MT_tsbl, avg_real_estate)








# Make sure Date column is of Date type
Data_Monthly_MT$month_date <- as.Date(Data_Monthly_MT$month_date)

# Truncate to 2015-10 onwards
Data_Monthly_MT_trunc <- subset(Data_Monthly_MT, month_date >= as.Date("2015-10-01"))


# Target variable as monthly ts starting Oct 2015
y <- ts(Data_Monthly_MT_trunc$avg_real_estate,
        start = c(2015, 10),  # year, month
        frequency = 12)


# Number of periods to forecast
h <- 12  # e.g., 12 months

 


# List of predictors
predictors <- c("interest_rate_us","gdp_growth_rate","interpolated_cpi",
                "euro_dollar","avg_sandp_close")

# Forecasts of each predictor
future_xreg <- matrix(nrow = h, ncol = length(predictors))
colnames(future_xreg) <- predictors

for (i in seq_along(predictors)) {
  x_ts <- ts(Data_Monthly_MT_trunc[[predictors[i]]],
             start = start(y),
             frequency = 12)
  
  fit_x <- auto.arima(x_ts)
  
  fc_x <- forecast(fit_x, h = h)
  
  # Use the forecast mean as future xreg
  future_xreg[, i] <- as.numeric(fc_x$mean)
}


fit_ARIMA <- auto.arima(y, xreg = as.matrix(Data_Monthly_MT_trunc[, predictors]))


forecast_fit <- forecast(fit_ARIMA, xreg = future_xreg)

autoplot(forecast_fit)



