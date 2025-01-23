# Residential Solar PV Installation Trends in Massachusetts
## Introduction
This project shows the trends in the installation of solar photovoltaics throughout the various counties in MA. The purpose is to evaluate how the economic turmoil caused by the COVID-19 pandemic affected solar installation trends in Massachusetts, in order to inform public policy and the renewable energy industry moving forward in their decision making and planning. 

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
MA_med_age.csv | Population data on the county level in MA in 2021 | data.census.gov
MA_med_inc.csv | Income data on the county level in MA in 2021 | data.census.gov
SMART_Solar_Tariff_Generation_Units.csv | Installation data from solar photovoltaic systems under the SREC I incentive program in MA (2018-2023) | mass.gov
Solar_Carve-Out_Qualified_Units.csv | Installation data from solar photovoltaic systems under the SREC I incentive program in MA (2010-2013) | mass.gov
Solar_Carve-Out II_Renewable_Generation_Units.csv | Installation data from solar photovoltaic systems under the SREC II incentive program in MA (2013-2018) | mass.gov
barnstable_unemp_rate.csv | Monthly unemployment rate in Barnstable County from 1990-2022 | fred.stlouisfed.org
barnstable_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Barnstable County from 1990-2022 | fred.stlouisfed.org
berkshire_unemp_rate.csv | Monthly unemployment rate in Berkshire County from 1990-2022 | fred.stlouisfed.org
berkshire_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Berkshire County from 1990-2022 | fred.stlouisfed.org
bristol_unemp_rate.csv | Monthly unemployment rate in Bristol County from 1990-2022 | fred.stlouisfed.org
bristol_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Bristol County from 1990-2022 | fred.stlouisfed.org
dukes_unemp_rate.csv | Monthly unemployment rate in Dukes County from 1990-2022 | fred.stlouisfed.org
dukes_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Dukes County from 1990-2022 | fred.stlouisfed.org
essex_unemp_rate.csv | Monthly unemployment rate in Essex County from 1990-2022 | fred.stlouisfed.org
essex_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Essex County from 1990-2022 | fred.stlouisfed.org
franklin_unemp_rate.csv | Monthly unemployment rate in Franklin County from 1990-2022 | fred.stlouisfed.org
franklin_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Franklin County from 1990-2022 | fred.stlouisfed.org
hampden_unemp_rate.csv | Monthly unemployment rate in Hampden County from 1990-2022 | fred.stlouisfed.org
hampden_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Hampden County from 1990-2022 | fred.stlouisfed.org
hampshire_unemp_rate.csv | Monthly unemployment rate in Hampshire County from 1990-2022 | fred.stlouisfed.org
hampshire_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Hampshire County from 1990-2022 | fred.stlouisfed.org
middlesex_unemp_rate.csv | Monthly unemployment rate in Middlesex County from 1990-2022 | fred.stlouisfed.org
middlesex_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Middlesex County from 1990-2022 | fred.stlouisfed.org
nantucket_unemp_rate.csv | Monthly unemployment rate in Nantucket County from 1990-2022 | fred.stlouisfed.org
nantucket_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Nantucket County from 1990-2022 | fred.stlouisfed.org
norfolk_unemp_rate.csv | Monthly unemployment rate in Norfolk County from 1990-2022 | fred.stlouisfed.org
norfolk_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Norfolk County from 1990-2022 | fred.stlouisfed.org
plymouth_unemp_rate.csv | Monthly unemployment rate in Plymouth County from 1990-2022 | fred.stlouisfed.org
plymouth_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Plymouth County from 1990-2022 | fred.stlouisfed.org
solar_trends.R | Code that imports, cleans, and analyzes economic and social data to inform a conclusion on the impact of an economic downturn on the installation rate of solar photovoltaic systems | Created by Patrick Lynch
suffolk_unemp_rate.csv | Monthly unemployment rate in Suffolk County from 1990-2022 | fred.stlouisfed.org
suffolk_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Suffolk County from 1990-2022 | fred.stlouisfed.org
worcester_unemp_rate.csv | Monthly unemployment rate in Worcester County from 1990-2022 | fred.stlouisfed.org
worcester_unemp_rate_ANNUAL.csv | Annual average unemployment rate in Worcester County from 1990-2022 | fred.stlouisfed.org
zips_towns_counties.csv | Zip codes for every town/city in MA, including the county for each town/city | zip-codes.com
