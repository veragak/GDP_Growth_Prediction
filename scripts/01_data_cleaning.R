# Load libraries
library(dplyr)
library(ggplot2)
library(caret)
library(glmnet)
library(MASS)
library(car)
library(Metrics)
library(pROC)
library(corrplot)
library(tinytex)

# Load data
df <- read.csv2("a1_data_group_22.csv", sep = ",") %>%
  rename(gdp_growth_annual = GDP.growth..annual...,
         net_trade_bop_usd = Net.trade.in.goods.and.services..BoP..current.US.. ) %>%
  na.omit() %>% mutate(across(2:74, as.numeric), Country = as.factor(Country))

# Clean column names
names(df) <- make.names(names(df))