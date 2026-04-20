# ============================================
# 05_gh_comparison.R
# GH model comparison
# ============================================

library(ghyp)
library(mvtnorm)

data_train <- readRDS("data/processed/data_train.rds")
data_test  <- readRDS("data/processed/data_test.rds")
res_em     <- readRDS("data/processed/em_results.rds")

train_mat <- as.matrix(data_train)
test_mat  <- as.matrix(data_test)

# Fit GH model
fit_gh <- fit.ghypmv(train_mat, silent = TRUE)

# Log-likelihood (train)
ll_gh_train <- logLik(fit_gh)

# Log-likelihood (test)
ll_gh_test <- sum(dghyp(test_mat, fit_gh, logvalue = TRUE))

cat("GH LogLik (train):", ll_gh_train, "\n")
cat("GH LogLik (test):", ll_gh_test, "\n")

# Save results
saveRDS(fit_gh, "data/processed/gh_model.rds")