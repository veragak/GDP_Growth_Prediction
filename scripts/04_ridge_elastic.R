library(caret)
library(Metrics)

# Split train/test
set.seed(100)
train_idx <- sample(1:nrow(df), 110)
train_df <- df[train_idx, ]
test_df <- df[-train_idx, ]

X_train <- model.matrix(gdp_growth_annual ~ . - Country - fertility_sq, data = train_df)[, -1]
y_train <- train_df$gdp_growth_annual
X_test  <- model.matrix(gdp_growth_annual ~ . - Country - fertility_sq, data = test_df)[, -1]
y_test  <- test_df$gdp_growth_annual

# Cross-validation setup
fitControl <- trainControl(method="repeatedcv", number=10, repeats=5)

# Ridge model
ridge_model <- train(x=X_train, y=y_train, method="glmnet",
                     tuneGrid=expand.grid(alpha=0, lambda=seq(0.0001, 1000, length=100)),
                     trControl=fitControl, preProcess=c("center", "scale"))

# Elastic Net model
elastic_model <- train(x=X_train, y=y_train, method="glmnet",
                       tuneGrid=expand.grid(alpha=seq(0,1,length=10), lambda=seq(0.0001, 1000, length=50)),
                       trControl=fitControl, preProcess=c("center", "scale"))

# Compare RMSE
res <- resamples(list(Ridge=ridge_model, ElasticNet=elastic_model))
summary(res)
xyplot(res, metric="RMSE")