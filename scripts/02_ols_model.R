library(MASS)

#stepwise backward selection 
base_model <- lm(gdp_growth_annual ~ . - Country, data = df)
step_model <- stepAIC(base_model, direction = "backward")
final_formula <- update(formula(step_model), . ~ . + net_trade_bop_usd)

#OLS MODEL 
reg_final <- lm(final_formula, data = df, singular.ok = FALSE)
summary(reg_final)

#NON-LINEAR VARIABLE MODEL: Squared fertility
df <- df %>% mutate(fertility_sq = Fertility.rate..total..births.per.woman.^2)
nonlinear_formula <- update(formula(step_model), . ~ . + fertility_sq +
                              net_trade_bop_usd) 
reg_nonlinear <- lm(nonlinear_formula, data = df, singular.ok = FALSE) #Fit the model
summary(reg_nonlinear)