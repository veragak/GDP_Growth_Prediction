library(glmnet)

# Prepare matrix
X <- model.matrix(nonlinear_formula, data = df)[, -1]
y <- df$gdp_growth_annual

set.seed(100)
lasso_cv <- cv.glmnet(X, y, alpha = 1, maxit = 1e6)
plot(lasso_cv)
coef(lasso_cv, s = "lambda.min")
