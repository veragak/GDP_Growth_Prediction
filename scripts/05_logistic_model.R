library(pROC)

# Create binary outcome
df <- df %>% mutate(growing_more = factor(ifelse(gdp_growth_annual > 2.7, 1, 0)))

# Train/test split
set.seed(1)
log_train_idx <- sample(1:nrow(df), 110)
train_log <- df[log_train_idx, ]
test_log  <- df[-log_train_idx, ]

x_train_log <- model.matrix(growing_more ~ . - Country - gdp_growth_annual, data = train_log)[, -1]
y_train_log <- train_log$growing_more
x_test_log  <- model.matrix(growing_more ~ . - Country - gdp_growth_annual, data = test_log)[, -1]
y_test_log  <- test_log$growing_more

# Ridge logistic regression
cv_ridge_log <- cv.glmnet(x_train_log, y_train_log, family="binomial", alpha=0, nfolds=10)

# ROC & AUC
pred_prob <- predict(cv_ridge_log, newx=x_test_log, s="lambda.min", type="response")
roc_curve <- roc(y_test_log, as.numeric(pred_prob))
plot(roc_curve, col="blue", lwd=2)
auc(roc_curve)
