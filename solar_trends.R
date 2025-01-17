.libPaths("C:/R Install/R/win-library/4.0")

### LOAD NECESSARY PACKAGES ###
library(tidyverse)
library(lubridate)
library(dynlm)
library(corrplot)
library(lmtest)
library(sandwich)
library(car)
library(ggthemes)

#############################
### GATHER AND CLEAN DATA ###
#############################

### MEDIAN AGE AND POPULATION DATA ###
med_age_pop <- read_csv("MA_med_age.csv")
med_age_pop <- med_age_pop %>% 
  select(!contains("Female")) %>% 
  select(!contains("Male")) %>% 
  select(!contains("Percent"))
med_age_pop <- med_age_pop %>% slice(1, 30, 35)
med_age_pop <- med_age_pop %>% 
  rename("Barnstable" = "Barnstable County, Massachusetts!!Total!!Estimate", 
         "Berkshire" = "Berkshire County, Massachusetts!!Total!!Estimate", 
         "Bristol" = "Bristol County, Massachusetts!!Total!!Estimate",
         "Dukes" = "Dukes County, Massachusetts!!Total!!Estimate",
         "Essex" = "Essex County, Massachusetts!!Total!!Estimate",
         "Franklin" = "Franklin County, Massachusetts!!Total!!Estimate",
         "Hampden" = "Hampden County, Massachusetts!!Total!!Estimate",
         "Hampshire" = "Hampshire County, Massachusetts!!Total!!Estimate", 
         "Middlesex" = "Middlesex County, Massachusetts!!Total!!Estimate",
         "Nantucket" = "Nantucket County, Massachusetts!!Total!!Estimate",
         "Norfolk" = "Norfolk County, Massachusetts!!Total!!Estimate",
         "Plymouth" = "Plymouth County, Massachusetts!!Total!!Estimate",
         "Suffolk" = "Suffolk County, Massachusetts!!Total!!Estimate",
         "Worcester" = "Worcester County, Massachusetts!!Total!!Estimate")
med_age_pop <- med_age_pop %>% 
  pivot_longer(!"Label (Grouping)", names_to = "county", values_to = "count") %>%
  pivot_wider(names_from = "Label (Grouping)", values_from = "count") %>%
  rename("total_pop" = "Total population",
         "age_60+" = contains("60 years and over"),
         "median_age" = contains("Median age (years)"))

# Make all columns into numeric vectors #
med_age_pop$total_pop = as.numeric(gsub(",", "", med_age_pop$total_pop))
med_age_pop$`age_60+` = as.numeric(gsub(",", "", med_age_pop$`age_60+`))
med_age_pop$median_age = as.numeric(gsub(",", "", med_age_pop$median_age))

### MEDIAN INCOME DATA ###
med_inc <- read_csv("MA_med_inc.csv")
med_inc <- med_inc %>% 
  select(!contains("amil"))
med_inc <- med_inc %>% slice(1, 12, 13)
med_inc <- med_inc %>% 
  rename("Barnstable" = "Barnstable County, Massachusetts!!Households!!Estimate", 
         "Berkshire" = "Berkshire County, Massachusetts!!Households!!Estimate", 
         "Bristol" = "Bristol County, Massachusetts!!Households!!Estimate",
         "Dukes" = "Dukes County, Massachusetts!!Households!!Estimate",
         "Essex" = "Essex County, Massachusetts!!Households!!Estimate",
         "Franklin" = "Franklin County, Massachusetts!!Households!!Estimate",
         "Hampden" = "Hampden County, Massachusetts!!Households!!Estimate",
         "Hampshire" = "Hampshire County, Massachusetts!!Households!!Estimate", 
         "Middlesex" = "Middlesex County, Massachusetts!!Households!!Estimate",
         "Nantucket" = "Nantucket County, Massachusetts!!Households!!Estimate",
         "Norfolk" = "Norfolk County, Massachusetts!!Households!!Estimate",
         "Plymouth" = "Plymouth County, Massachusetts!!Households!!Estimate",
         "Suffolk" = "Suffolk County, Massachusetts!!Households!!Estimate",
         "Worcester" = "Worcester County, Massachusetts!!Households!!Estimate")
med_inc <- med_inc %>% 
  pivot_longer(!"Label (Grouping)", names_to = "county", values_to = "count") %>%
  pivot_wider(names_from = "Label (Grouping)", values_from = "count") %>%
  rename("num_households" = Total,
         "med_income" = "Median income (dollars)", 
         "mean_income" = "Mean income (dollars)")

# Make all columns into numeric vectors #
med_inc$num_households = as.numeric(gsub(",", "", med_inc$num_households))
med_inc$med_income = as.numeric(gsub(",", "", med_inc$med_income))
med_inc$mean_income = as.numeric(gsub(",", "", med_inc$mean_income))

### COUNTY UNEMPLOYMENT DATA (MONTHLY) ###
barnstable_unemp_rate <- read_csv("barnstable_unemp_rate.csv") %>% 
  rename("Barnstable" = MABARN1URN)
berkshire_unemp_rate <- read_csv("berkshire_unemp_rate.csv") %>% 
  rename("Berkshire" = MABERK2URN)
bristol_unemp_rate <- read_csv("bristol_unemp_rate.csv") %>% 
  rename("Bristol" = MABRIS5URN)
dukes_unemp_rate <- read_csv("dukes_unemp_rate.csv") %>% 
  rename("Dukes" = MADUKE7URN)
essex_unemp_rate <- read_csv("essex_unemp_rate.csv") %>% 
  rename("Essex" = MAESSE9URN)
franklin_unemp_rate <- read_csv("franklin_unemp_rate.csv") %>% 
  rename("Franklin" = MAFRAN1URN)
hampden_unemp_rate <- read_csv("hampden_unemp_rate.csv") %>% 
  rename("Hampden" = MAHAMP0URN)
hampshire_unemp_rate <- read_csv("hampshire_unemp_rate.csv") %>% 
  rename("Hampshire" = MAHAMP5URN)
middlesex_unemp_rate <- read_csv("middlesex_unemp_rate.csv") %>% 
  rename("Middlesex" = MAMIDD7URN)
nantucket_unemp_rate <- read_csv("nantucket_unemp_rate.csv") %>% 
  rename("Nantucket" = MANANT9URN)
norfolk_unemp_rate <- read_csv("norfolk_unemp_rate.csv") %>% 
  rename("Norfolk" = MANORF1URN)
plymouth_unemp_rate <- read_csv("plymouth_unemp_rate.csv") %>% 
  rename("Plymouth" = MAPLYM3URN)
suffolk_unemp_rate <- read_csv("suffolk_unemp_rate.csv") %>% 
  rename("Suffolk" = MASUFF5URN)
worcester_unemp_rate <- read_csv("worcester_unemp_rate.csv") %>% 
  rename("Worcester" = MAWORC7URN)

# Join all data frames #
county_ur_list_month = list(barnstable_unemp_rate, 
                            berkshire_unemp_rate,
                            bristol_unemp_rate,
                            dukes_unemp_rate, 
                            essex_unemp_rate,
                            franklin_unemp_rate,
                            hampden_unemp_rate, 
                            hampshire_unemp_rate, 
                            middlesex_unemp_rate, 
                            nantucket_unemp_rate, 
                            norfolk_unemp_rate, 
                            plymouth_unemp_rate, 
                            suffolk_unemp_rate, 
                            worcester_unemp_rate)
county_ur_month <- county_ur_list_month %>% 
  reduce(left_join, by='DATE')
county_ur_month <- county_ur_month %>% 
  pivot_longer(!DATE, names_to = "county", values_to = "unemp_rate_month") %>% 
  rename("date" = DATE)

# Remove obsolete tables #
rm(county_ur_list_month)
rm(barnstable_unemp_rate, 
   berkshire_unemp_rate,
   bristol_unemp_rate,
   dukes_unemp_rate, 
   essex_unemp_rate,
   franklin_unemp_rate,
   hampden_unemp_rate, 
   hampshire_unemp_rate, 
   middlesex_unemp_rate, 
   nantucket_unemp_rate, 
   norfolk_unemp_rate, 
   plymouth_unemp_rate, 
   suffolk_unemp_rate, 
   worcester_unemp_rate)

### COUNTY UNEMPLOYMENT DATA (ANNUAL) ###
barnstable_unemp_rate_ANNUAL <- read_csv("barnstable_unemp_rate_ANNUAL.csv") %>% 
  rename("Barnstable" = MABARN1URN)
berkshire_unemp_rate_ANNUAL <- read_csv("berkshire_unemp_rate_ANNUAL.csv") %>% 
  rename("Berkshire" = MABERK2URN)
bristol_unemp_rate_ANNUAL <- read_csv("bristol_unemp_rate_ANNUAL.csv") %>% 
  rename("Bristol" = MABRIS5URN)
dukes_unemp_rate_ANNUAL <- read_csv("dukes_unemp_rate_ANNUAL.csv") %>% 
  rename("Dukes" = MADUKE7URN)
essex_unemp_rate_ANNUAL <- read_csv("essex_unemp_rate_ANNUAL.csv") %>% 
  rename("Essex" = MAESSE9URN)
franklin_unemp_rate_ANNUAL <- read_csv("franklin_unemp_rate_ANNUAL.csv") %>% 
  rename("Franklin" = MAFRAN1URN)
hampden_unemp_rate_ANNUAL <- read_csv("hampden_unemp_rate_ANNUAL.csv") %>% 
  rename("Hampden" = MAHAMP0URN)
hampshire_unemp_rate_ANNUAL <- read_csv("hampshire_unemp_rate_ANNUAL.csv") %>% 
  rename("Hampshire" = MAHAMP5URN)
middlesex_unemp_rate_ANNUAL <- read_csv("middlesex_unemp_rate_ANNUAL.csv") %>% 
  rename("Middlesex" = MAMIDD7URN)
nantucket_unemp_rate_ANNUAL <- read_csv("nantucket_unemp_rate_ANNUAL.csv") %>% 
  rename("Nantucket" = MANANT9URN)
norfolk_unemp_rate_ANNUAL <- read_csv("norfolk_unemp_rate_ANNUAL.csv") %>% 
  rename("Norfolk" = MANORF1URN)
plymouth_unemp_rate_ANNUAL <- read_csv("plymouth_unemp_rate_ANNUAL.csv") %>% 
  rename("Plymouth" = MAPLYM3URN)
suffolk_unemp_rate_ANNUAL <- read_csv("suffolk_unemp_rate_ANNUAL.csv") %>% 
  rename("Suffolk" = MASUFF5URN)
worcester_unemp_rate_ANNUAL <- read_csv("worcester_unemp_rate_ANNUAL.csv") %>% 
  rename("Worcester" = MAWORC7URN)

# Join all data frames #
county_ur_list_annual = list(barnstable_unemp_rate_ANNUAL, 
                             berkshire_unemp_rate_ANNUAL,
                             bristol_unemp_rate_ANNUAL,
                             dukes_unemp_rate_ANNUAL, 
                             essex_unemp_rate_ANNUAL,
                             franklin_unemp_rate_ANNUAL,
                             hampden_unemp_rate_ANNUAL, 
                             hampshire_unemp_rate_ANNUAL, 
                             middlesex_unemp_rate_ANNUAL, 
                             nantucket_unemp_rate_ANNUAL, 
                             norfolk_unemp_rate_ANNUAL, 
                             plymouth_unemp_rate_ANNUAL, 
                             suffolk_unemp_rate_ANNUAL, 
                             worcester_unemp_rate_ANNUAL)
county_ur_annual <- county_ur_list_annual %>% 
  reduce(left_join, by='DATE')
county_ur_annual <- county_ur_annual %>% 
  pivot_longer(!DATE, names_to = "county", values_to = "unemp_rate_annual_avg") %>% 
  rename("date" = DATE) %>%
  complete(date = seq.Date(min(date), max(date), by="month"), county) %>%
  group_by(county) %>%
  fill(unemp_rate_annual_avg)

# Ensure values are numeric and round to 1 decimal place
county_ur_annual$unemp_rate_annual_avg <- as.numeric(county_ur_annual$unemp_rate_annual_avg) %>%
  round(digits = 1)

# Remove obsolete tables #
rm(county_ur_list_annual)
rm(barnstable_unemp_rate_ANNUAL, 
   berkshire_unemp_rate_ANNUAL,
   bristol_unemp_rate_ANNUAL,
   dukes_unemp_rate_ANNUAL, 
   essex_unemp_rate_ANNUAL,
   franklin_unemp_rate_ANNUAL,
   hampden_unemp_rate_ANNUAL, 
   hampshire_unemp_rate_ANNUAL, 
   middlesex_unemp_rate_ANNUAL, 
   nantucket_unemp_rate_ANNUAL, 
   norfolk_unemp_rate_ANNUAL, 
   plymouth_unemp_rate_ANNUAL, 
   suffolk_unemp_rate_ANNUAL, 
   worcester_unemp_rate_ANNUAL)

### COUNTY/ZIP CODE DATA ###
zip_data <- read_csv("zips_towns_counties.csv")
zip_data <- zip_data[,2:3] %>%
  rename("zip"= "Zip Code",
         county = County) %>%
  distinct() # Eliminate accidental duplicate row

### SREC I DATA ###
# Load in data and delete empty rows #
srec1 <- read_csv("Solar_Carve-Out_Qualified_Units.csv", col_names = FALSE) %>% 
  slice(-(1:6))

# Rename top row to header #
names(srec1) <- srec1[1,]
srec1 <- srec1[-1,]

# Select/filter rows and columns #
srec1 <- srec1 %>% 
  select("Facility Type", 
         "City/Town PTS", 
         "Zip Code - PTS", 
         contains("Commercial Operation Date"), 
         "NA", 
         "Total Installation Costs", 
         "Installation Cost per Watt") %>% 
  rename("facility_type" = "Facility Type", 
         "city/town" = "City/Town PTS", 
         "zip" = "Zip Code - PTS", 
         "kW_cap" = "NA", 
         "total_cost" = "Total Installation Costs", 
         "cost_per_watt" = "Installation Cost per Watt", 
         "date" = contains("Commercial Operation Date")) %>% #date that system became operational
  filter(facility_type == "Residential")

# Change "date" column to a "Date" object, make dates by month #
srec1$date <- mdy(srec1$date)
srec1 <- srec1 %>% mutate(date = floor_date(srec1$date, "month"))

# Change "total_cost" and "cost_per_watt" columns into numeric types #
srec1$total_cost = as.factor(gsub(",", "", srec1$total_cost))
srec1$total_cost = as.numeric(gsub("\\$", "", srec1$total_cost))
srec1$cost_per_watt = as.factor(gsub(",", "", srec1$cost_per_watt))
srec1$cost_per_watt = as.numeric(gsub("\\$", "", srec1$cost_per_watt))

# Join with zip codes #
srec1 <- srec1 %>% left_join(zip_data, by = "zip")

# Get averages by county-month, count of monthly installations, SREC1 indicator #
srec1 <- srec1 %>% 
  group_by(date, county) %>% 
  add_count(date, county) %>% 
  mutate(avg_kW_cap_s1 = mean(kW_cap), 
         avg_total_cost_s1 = mean(total_cost), 
         avg_cost_per_watt_s1 = mean(cost_per_watt),
         srec1 = 1) %>% 
  rename(num_install_s1 = "n")


# Keep relevant columns, re-order columns, re-arrange rows, delete duplicate rows #
srec1 <- srec1[,c(4,8,9,10,11,12,13)] %>% 
  arrange(date, county) %>% 
  distinct()

### SREC II DATA ###
# Load in data and delete empty rows #
srec2 <- read_csv("Solar_Carve-out II_Renewable_Generation_Units.csv", col_names = FALSE) %>% 
  slice(-(1:12))

# Rename top row to header #
names(srec2) <- srec2[1,]
srec2 <- srec2[-1,]

# Filter/select rows and columns #
srec2 <- srec2[c(5, 6, 7, 13, 8, 17, 18)]
srec2 <- srec2 %>% 
  rename("facility_type" = "Facility Type", 
         "city/town" = "City/Town", 
         "zip" = "Zip Code", 
         "date" = "Commercial Operation Date", #date that system became operational
         "kW_cap" = "NA", 
         "total_cost" = "Total Installation Cost", 
         "cost_per_watt" = "Cost/Watt") %>%
  filter(facility_type == "Residential (3 or fewer dwelling units per building)")

# Change "date" column to a "Date" object, make dates by month #
srec2$date <- mdy(srec2$date)
srec2 <- srec2 %>% mutate(date = floor_date(srec2$date, "month"))

# Change "total_cost" and "cost_per_watt" columns into numeric types #
srec2$total_cost = as.factor(gsub(",", "", srec2$total_cost))
srec2$total_cost = as.numeric(gsub("\\$", "", srec2$total_cost))
srec2$cost_per_watt = as.factor(gsub(",", "", srec2$cost_per_watt))
srec2$cost_per_watt = as.numeric(gsub("\\$", "", srec2$cost_per_watt))

# Join with zip codes #
srec2 <- srec2 %>% left_join(zip_data, by = "zip")

# Get averages by county-month, count of monthly installations, SREC2 indicator #
srec2 <- srec2 %>% 
  group_by(date, county) %>% 
  add_count(date, county) %>% 
  mutate(avg_kW_cap_s2 = mean(kW_cap), 
         avg_total_cost_s2 = mean(total_cost), 
         avg_cost_per_watt_s2 = mean(cost_per_watt),
         srec2 = 1) %>% 
  rename(num_install_s2 = "n")

# Keep relevant columns, re-order columns, re-arrange rows, delete duplicate rows #
srec2 <- srec2[,c(4,8,9,10,11,12,13)] %>% 
  arrange(date, county) %>% 
  distinct()

### SMART DATA ###
# Load in data and delete empty rows #
smart <- read_csv("SMART_Solar_Tariff_Generation_Units.csv", col_names = FALSE) %>%
  slice(-(1:18))

# Rename top row to header #
names(smart) <- smart[1,]
smart <- smart[-1,]

# Filter/select rows and columns #
smart <- smart[c(5, 12, 14, 17, 35, 36)] %>% 
  rename("facility_type" = "Facility Type", 
         "zip" = "Zip Code", 
         "date" = "Commercial Operation Date", #date that system became operational
         "kW_cap" = "NA", 
         "total_cost" = "Total Installation Cost", 
         "cost_per_watt" = "Cost/Watt") %>%
  filter(facility_type == "Residential - Residential (3 or less units/bldg)")

# Change "date" column to a "Date" object, make dates by month #
smart$date <- mdy(smart$date)
smart <- smart %>% mutate(date = floor_date(smart$date, "month"))

# Change "total_cost" and "cost_per_watt" columns into numeric types #
smart$total_cost = as.factor(gsub(",", "", smart$total_cost))
smart$total_cost = as.numeric(gsub("\\$", "", smart$total_cost))
smart$cost_per_watt = as.factor(gsub(",", "", smart$cost_per_watt))
smart$cost_per_watt = as.numeric(gsub("\\$", "", smart$cost_per_watt))

# Join with zip codes #
smart <- smart %>% left_join(zip_data, by = "zip")

# Get averages by county-month, count of monthly installations, SMART indicator #
smart <- smart %>% 
  group_by(date, county) %>% 
  add_count(date, county) %>% 
  mutate(avg_kW_cap_sm = mean(kW_cap), 
         avg_total_cost_sm = mean(total_cost), 
         avg_cost_per_watt_sm = mean(cost_per_watt),
         smart = 1) %>% 
  rename(num_install_sm = "n")

# Keep relevant columns, re-order columns, re-arrange rows, delete duplicate rows #
smart <- smart[,c(1,7,8,9,10,11)] %>% # column 12 (SMART indicator) is not necessary because indicators for SREC1&2 imply this value -> if both SREC1 & SREC2 are 0, then SMART would be 1
  arrange(date, county) %>%
  distinct() %>%
  drop_na(date) #delete rows with "NA" date - not operational

### BUILD MASTER TABLE ###
solar_1_2 <- srec1 %>% full_join(srec2, by = c("date", "county"))
solar_1_2 <- solar_1_2 %>% 
  mutate_all(funs(ifelse(is.na(.), 0, .))) %>%
  mutate(num_install_1_2 = num_install_s1 + num_install_s2, 
         avg_kW_cap_1_2 = weighted.mean(c(avg_kW_cap_s1, 
                                          avg_kW_cap_s2), 
                                        c(num_install_s1, 
                                          num_install_s2)),
         avg_total_cost_1_2 = weighted.mean(c(avg_total_cost_s1, 
                                              avg_total_cost_s2), 
                                            c(num_install_s1, 
                                              num_install_s2)),
         avg_cost_per_watt_1_2 = weighted.mean(c(avg_cost_per_watt_s1, 
                                                 avg_cost_per_watt_s2), 
                                               c(num_install_s1, 
                                                 num_install_s2))) %>%
  select("date", 
         "county", 
         "num_install_1_2", 
         "avg_kW_cap_1_2", 
         "avg_total_cost_1_2", 
         "avg_cost_per_watt_1_2", 
         "srec1", 
         "srec2")
master_solar <- solar_1_2 %>% full_join(smart, by = c("date", "county"))
master_solar <- master_solar %>% 
  mutate_all(funs(ifelse(is.na(.), 0, .))) %>%
  mutate(num_install = num_install_1_2 + num_install_sm, 
         avg_kW_cap = weighted.mean(c(avg_kW_cap_1_2, 
                                      avg_kW_cap_sm), 
                                    c(num_install_1_2, 
                                      num_install_sm)),
         avg_total_cost = weighted.mean(c(avg_total_cost_1_2, 
                                          avg_total_cost_sm), 
                                        c(num_install_1_2, 
                                          num_install_sm)),
         avg_cost_per_watt = weighted.mean(c(avg_cost_per_watt_1_2, 
                                             avg_cost_per_watt_sm), 
                                           c(num_install_1_2, 
                                             num_install_sm)),
         year = as.numeric(format(date, "%Y"))) %>%
  filter(!is.na(county)) %>%
  select("date", 
         "county",
         "num_install",
         "year",
         "avg_kW_cap", 
         "avg_total_cost", 
         "avg_cost_per_watt", 
         "srec1", 
         "srec2") # SMART indicator is not necessary because indicators for SREC1&2 imply this value
med_age_pop_inc <- med_age_pop %>% full_join(med_inc)
master <- master_solar %>% 
  left_join(county_ur_month) %>% 
  left_join(county_ur_annual)
master <- master %>% 
  left_join(med_age_pop_inc) %>%
  filter(year(date) < 2023)

# Remove obsolete tables #
rm(solar_1_2,
   master_solar)

##################################
### VISUALIZATIONS/EXPLORATION ###
##################################

# Plot installations over time by county #
ggplot(master, aes(x=date,
                   y=num_install)) +
  geom_line() +
  facet_wrap("county")

# Plot installations over time #
master_state <- aggregate(master$num_install, 
                          by=list(date=master$date), 
                          FUN=sum) %>%
  rename(num_install = "x")
ggplot(master_state, aes(x=date,
                         y=num_install)) +
  geom_point() +
  geom_smooth() +
  ylim(0,3000) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y")

# Unemployment vs. installations #
ggplot(master, aes(x=unemp_rate_month, # plot each county separately
                   y=num_install)) +
  geom_line() +
  facet_wrap("county")

ggplot(master, aes(x=unemp_rate_month, # plot aggregate of counties
                   y=num_install)) +
  geom_point() +
  geom_smooth()

# Average total cost over time #
ggplot(master, aes(x=date,
                   y=avg_total_cost)) +
  geom_point() +
  geom_smooth() +
  ylim(0, 151000) #Removes one outlier from view

# Average cost per watt over time #
ggplot(master, aes(x=date,
                   y=avg_cost_per_watt)) +
  geom_point() +
  geom_smooth() 

# Average kW capacity over time #
ggplot(master, aes(x=date,
                   y=avg_kW_cap)) +
  geom_point() +
  geom_smooth() +
  ylim(0,25) #Removes one outlier from view

# Relationships and Correlation #
pairs(master[,-c(1,2,3)]) # Shows matrix of scatterplots to identify potential relationships between variables
cor(master[,-c(1,2,3)]) # Computes correlation coefficient for each pair of variables
corrplot(cor(master[,-c(1,2,3)]), method="number") # Shows correlation matrix

# Monthly unemployment rate over time #
ggplot(master, aes(x=date,
                   y=unemp_rate_month)) +
  geom_point(color = "darkslategray4") +
  ggtitle("County Unemployment Rate in MA") +
  xlab("Date") +
  ylab("Monthly Unemployment Rate") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  theme_clean() +
  theme(plot.title = element_text(hjust = 0.5))

###########################
### REGRESSION ANALYSIS ###
###########################

### OLS Regression Analysis ###

# Simple linear regressions with transformations #
model1 <- lm(num_install ~ unemp_rate_month, 
             data = master)
  hist(residuals(model1), 
       col = "steelblue")
  plot(fitted(model1), 
       residuals(model1))
  abline(h = 0, 
         lty = 2)
  summary(model1)
model1b <- lm(log(num_install) ~ unemp_rate_month, 
              data = master)
  hist(residuals(model1b), 
       col = "steelblue")
  plot(fitted(model1b), 
       residuals(model1b))
  abline(h = 0, 
         lty = 2)
  summary(model1b)
model1c <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=1), 
                 data = master)
  hist(residuals(model1c), 
       col = "steelblue")
  plot(fitted(model1c), 
       residuals(model1c))
  abline(h = 0, lty = 2)
  summary(model1c)
model1d <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3), # Highest R^2, 
                 data = master) # these transformations will be used going forward
  hist(residuals(model1d), 
     col = "steelblue")
  plot(fitted(model1d), 
       residuals(model1d))
  abline(h = 0, 
         lty = 2)
  summary(model1d)
model1e <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=6), 
                 data = master)
  hist(residuals(model1e), 
       col = "steelblue")
  plot(fitted(model1e), 
       residuals(model1e))
  abline(h = 0, 
         lty = 2)
  summary(model1e)

# Multiple regression models; will compare these models to find best one #
model2 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                   year,
                data = master)
  hist(residuals(model2), 
       col = "steelblue")
  plot(fitted(model2), 
       residuals(model2))
  abline(h = 0, 
         lty = 2)
  summary(model2)
model3 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                   year + 
                                   avg_cost_per_watt,
                data = master)
  hist(residuals(model3), col = "steelblue")
  plot(fitted(model3), residuals(model3))
  abline(h = 0, lty = 2)
  summary(model3)
model4 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                   year + 
                                   avg_cost_per_watt + 
                                   med_income, 
                data = master)
  hist(residuals(model4), col = "steelblue")
  plot(fitted(model4), residuals(model4))
  abline(h = 0, lty = 2)
  summary(model4)
model5 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                   year + 
                                   avg_cost_per_watt + 
                                   med_income + 
                                   total_pop, 
                data = master)
  hist(residuals(model5), col = "steelblue")
  plot(fitted(model5), residuals(model5))
  abline(h = 0, lty = 2)
  summary(model5)
model6 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                   year + 
                                   avg_cost_per_watt + 
                                   med_income + 
                                   total_pop + 
                                   median_age, 
                data = master)
  hist(residuals(model6), col = "steelblue")
  plot(fitted(model6), residuals(model6))
  abline(h = 0, lty = 2)
  summary(model6)
model7 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                   year + 
                                   avg_cost_per_watt + 
                                   med_income + 
                                   total_pop + 
                                   median_age + 
                                   srec1 + 
                                   srec2, 
                data = master)
  hist(residuals(model7), col = "steelblue")
  plot(fitted(model7), residuals(model7))
  abline(h = 0, lty = 2)
  summary(model7)
model8 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                   year + 
                                   avg_kW_cap + 
                                   avg_total_cost + 
                                   avg_cost_per_watt + 
                                   srec1 + 
                                   srec2 + 
                                   total_pop + 
                                   `age_60+` + 
                                   median_age + 
                                   num_households + 
                                   med_income + 
                                   mean_income,
                data = master)
  hist(residuals(model8), col = "steelblue")
  plot(fitted(model8), residuals(model8))
  abline(h = 0, lty = 2)
  summary(model8)
model9 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                   year + 
                                   srec1 + 
                                   srec2 + 
                                   total_pop + 
                                   `age_60+` + 
                                   median_age + 
                                   num_households + 
                                   med_income + 
                                   mean_income,
                data = master)
  hist(residuals(model9), col = "steelblue")
  plot(fitted(model9), residuals(model9))
  abline(h = 0, lty = 2)
  summary(model9)
model10 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                    year + 
                                    srec1 +
                                    srec2 +
                                    total_pop + 
                                    median_age + 
                                    med_income,
                 data = master)
  hist(residuals(model10), col = "steelblue")
  plot(fitted(model10), residuals(model10))
  abline(h = 0, lty = 2)
  summary(model10)
model11 <- dynlm(log(num_install) ~ lag(unemp_rate_month, n=3) + 
                                    year + 
                                    med_income + 
                                    total_pop + 
                                    median_age, 
                 data = master)
  hist(residuals(model11), col = "steelblue")
  plot(fitted(model11), residuals(model11))
  abline(h = 0, lty = 2)
  summary(model11)
model12 <- dynlm(log(num_install) ~ med_income, 
                 data = master)
  hist(residuals(model12), col = "steelblue")
  plot(fitted(model12), residuals(model12))
  abline(h = 0, lty = 2)
  summary(model12)
  
# Compare Adj. R-squared #
summary(model2)$adj.r.squared
summary(model3)$adj.r.squared
summary(model4)$adj.r.squared
summary(model5)$adj.r.squared
summary(model6)$adj.r.squared
summary(model7)$adj.r.squared
summary(model8)$adj.r.squared
summary(model9)$adj.r.squared
summary(model10)$adj.r.squared
summary(model11)$adj.r.squared
summary(model12)$adj.r.squared

# Compare AIC #
AIC(model2, model3, model4, model5, model6, model7, model8, model9, model10, model11, model12)

# Using these two measures of goodness-of-fit (Adj R^2 and AIC) and considering
# the parsimony of the models, models 5, 6, and 11 have the best combination of
# GOF and parsimony. These models will be considered going forward.

### DIAGNOSTICS ###

# Variance Inflation Factor #
vif(model5) # VIF is low for all parameters, no concern for multicollinearity
vif(model6) # VIF is low for all parameters, no concern for multicollinearity
vif(model11) # VIF is low for all parameters, no concern for multicollinearity

# Y Outliers - Studentized Deleted Residuals #
resid5=resid(model5)
  sse5=sum(resid5^2)
  h5=hatvalues(model5)
  SDR5=resid5*((1689-7-1)/(sse5*(1-h5)-resid5^2))^0.5
  which(SDR5>3.571) # No Y outliers
resid6=resid(model6)
  sse6=sum(resid6^2)
  h6=hatvalues(model6)
  SDR6=resid6*((1689-7-1)/(sse6*(1-h6)-resid6^2))^0.5
  which(SDR6>3.571) # No Y outliers
resid11=resid(model11)
  sse11=sum(resid11^2)
  h11=hatvalues(model11)
  SDR11=resid11*((1689-7-1)/(sse11*(1-h11)-resid11^2))^0.5
  which(SDR11> 3.571) # No Y outliers

# X Outliers - Cook's Distance #
which(cooks.distance(model5)>0.1) # No X outliers
which(cooks.distance(model6)>0.1) # No X outliers
which(cooks.distance(model11)>0.1) # No X outliers

# Breusch-Pagan tests for constancy of residual variance #
bptest(model5) # result is heteroskedastic
bptest(model11) # result is heteroskedastic
bptest(model6) # result is heteroskedastic

# To combat heteroskedasticity, robust standard errors are calculated so that
# the error terms for the regression coefficients might be better used for 
# making inferences. The confidence intervals will also use these robust 
# standard errors in their calculations.

# Robust Standard Errors
coef5 <- coeftest(model5, vcov = vcovHC(model5))
coef5[2,2] # returns RSE of regression coefficient for monthly unemployment
coef6 <- coeftest(model6, vcov = vcovHC(model6))
coef6[2,2]
coef11 <- coeftest(model11, vcov = vcovHC(model11))
coef11[2,2]
confint(coef5)
confint(coef6)
confint(coef11)

###############
### RESULTS ###
###############

# Model 6 had the best combination of goodness-of-fit and parsimony, and all of 
# the diagnostics show that model 6 is a viable model. Taking this as our best
# model, we can conclude the following:
#
# Controlling for year, average cost per watt, median income, total population, 
# and median age, for every increase in one percentage point of unemployment, 
# the rate of solar installations decreases by 5.45%
summary(model6)$coefficients[2,1]