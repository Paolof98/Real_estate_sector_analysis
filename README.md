# Real estate sector project: economic analysis of the US real estate sector (XRE) performance

## OLS models

I firstly attempted to look at OLS models to assess the relationships between the real estate sector and economic variables. The model summary is the following:









The OLS models, however, gave high autocorrelation and heteroscedasticity, hence I attempted to look at ARIMA models. 


## ARIMA models
The following model looks into the relationships between the XLRE and GDP growth, CPI, interest rates, echange rates with the Euro and the S&P 500:

We can interpret the model in the following way:

* Higher US interest rates are associated with slightly lower real estate index values, but not statistically significant (s.e. = 0.5233)
* A higher GDP growth rate correlates with lower real estate, but effect is small and not significant
* Higher CPI (inflation) is linked with higher real estate values. This makes sense: property often hedges against inflation. This effect is moderate but not strongly significant
* A stronger Euro vs Dollar is linked with higher real estate, but the large standard error (3.6792) means this effect is very uncertain
* The stock market has the strongest explanatory power: a 1-unit increase in S&P is associated with +0.0835 in the real estate index. With s.e. = 0.0082, this is highly significant

The graphs below demonstrate how the error terms are white noise, meaning that the error terms do not explain any of the remaining correlations:




## Forecasting
I used the ARIMA model to forecast the next 12 months of the real estate sector. The graph below shows the forecast with the 80% and 95% confidence interval areas (dark blue and light blue areas respectively):

![](ARIMA%20forecast%20of%20real%20estate%20with%20ARIMA%20external%20regressors.png)



