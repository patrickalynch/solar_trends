# Residential Solar PV Installation Trends in Massachusetts
## Introduction
This project shows the trends in the installation of solar photovoltaics throughout the various counties in MA. The purpose is to evaluate how the economic turmoil caused by the COVID-19 pandemic affected solar installation trends, in order to inform public policy and the renewable energy industry moving forward in their decision making and planning.

## Data

### Variables

Column | Description
-------|------------
`date` | Month and year of observation for that county
`county` | County in MA
`num_install` | Number of solar photovoltaic installations in that month
`year` | Year of that observation
`avg_kW_cap` | Average kilowatt capacity of solar photovoltaic units installed for that county-month
`avg_total_cost` | Average total cost of solar photovoltaic units installed for that county-month (USD)
`avg_cost_per_watt` | Average cost divided by the watt capacity of solar photovoltaic units installed for that county-month
`srec1` | Indicator variable; indicates whether the Solar Carve-Out I (SREC I) program was active at that time (2010-2013) *
`srec2` | Indicator variable; indicates whether the Solar Carve-Out II (SREC II) program was active at that time (2013-2018) *
`unemp_rate_month` | Monthly unemployment rate for that county
`unemp_rate_annual_avg` | Annual average unemployment rate for that county in that year
`total_pop` | Total population in that county in 2021 **
`age_60+` | Total population of age 60 or older in that county in 2021 **
`median_age` | Median age in that county in 2021 **
`num_households` | Number of households in that county in 2021 **
`med_income` | Median income in that county in 2021 **
`mean_income` | Mean income in that county in 2021 **

\* After 2018, the solar incentive program which collected data in MA is the Solar Massachusetts Renewable Target (SMART) program, which is indicated by a value of $0$ for both the `srec1` and `srec2` variables.

** County-level data for all 14 counties in MA is only available from the US Census Bureau American Community Survey 5-year estimates. The most recent of these surveys was in 2021.

### Files

File | Description | Source
-------|------------|-------
