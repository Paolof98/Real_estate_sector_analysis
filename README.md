# Real estate sector project: economic analysis of the US real estate sector (XRE) performance

## OLS models

I firstly attempted to look at OLS models to assess the relationships between the real estate sector and economic variables. The model summary is the following:


| Variable          | Estimate   | Std. Error | t value | Pr(>|t|) | Significance |
|-------------------|------------|------------|---------|----------|--------------|
| (Intercept)       | 18.760555  | 4.352645   | 4.310   | 3.74e-05 | ***          |
| interest_rate_us  | -0.784933  | 0.143656   | -5.464  | 3.25e-07 | ***          |
| gdp_growth_rate   | -0.378329  | 0.227621   | -1.662  | 0.0995   | .            |
| interpolated_cpi  | 0.649253   | 0.111763   | 5.809   | 7.05e-08 | ***          |
| euro_dollar       | -6.979859  | 3.902266   | -1.789  | 0.0766   | .            |
| avg_sandp_close   | 0.058794   | 0.002909   | 20.211  | < 2e-16  | ***          |




The OLS models, however, gave high autocorrelation and heteroscedasticity, hence I attempted to look at ARIMA models. 


## ARIMA models
The following model looks into the relationships between the XLRE and GDP growth, CPI, interest rates, echange rates with the Euro and the S&P 500:

| Variable          | Estimate | Std. Error |
|-------------------|----------|------------|
| ar1               | 0.969    | 0.037      |
| ma1               | 0.1770   | 0.1071     |
| ma2               | -0.1719  | 0.1019     |
| interest_rate_us  | -0.4363  | 0.5233     |
| gdp_growth_rate   | -0.1469  | 0.0945     |
| interpolated_cpi  | 0.4994   | 0.2708     |
| euro_dollar       | 1.0610   | 3.6792     |
| avg_sandp_close   | 0.0835   | 0.0082     |


We can interpret the model in the following way:

* Higher US interest rates are associated with slightly lower real estate index values, but not statistically significant (s.e. = 0.5233)
* A higher GDP growth rate correlates with lower real estate, but effect is small and not significant
* Higher CPI (inflation) is linked with higher real estate values. This makes sense: property often hedges against inflation. This effect is moderate but not strongly significant
* A stronger Euro vs Dollar is linked with higher real estate, but the large standard error (3.6792) means this effect is very uncertain
* The stock market has the strongest explanatory power: a 1-unit increase in S&P is associated with +0.0835 in the real estate index. With s.e. = 0.0082, this is highly significant

The graphs below demonstrate how the error terms are white noise, meaning that the error terms do not explain any of the remaining correlations:

![](ARIMA%20model%20residuals%20white%20noise.png)



## Forecasting
I used the ARIMA model to forecast the next 12 months of the real estate sector. The graph below shows the forecast with the 80% and 95% confidence interval areas (dark blue and light blue areas respectively):

![](ARIMA%20forecast%20of%20real%20estate%20with%20ARIMA%20external%20regressors.png)



