# ============================================
# 04_var_analysis.R
# Value-at-Risk computation
# ============================================

library(mvtnorm)

# Load EM results
res_em <- readRDS("data/processed/em_results.rds")
data_train <- readRDS("data/processed/data_train.rds")

# Equally weighted portfolio
weights <- rep(1/3, 3)

# Extract parameters
mu <- res_em$mu
Sigma <- res_em$Sigma
tau <- res_em$tau
pi <- res_em$pi

# Portfolio mean and variance (calm regime)
mu_p <- sum(weights * mu)
var_p <- as.numeric(t(weights) %*% Sigma %*% weights)

# Portfolio variance (stress regime)
var_p_stress <- tau * var_p

# Simulation from mixture
n_sim <- 10000
u <- runif(n_sim)

returns_sim <- numeric(n_sim)

for (i in 1:n_sim) {
  if (u[i] <= pi) {
    returns_sim[i] <- rnorm(1, mean = mu_p, sd = sqrt(var_p))
  } else {
    returns_sim[i] <- rnorm(1, mean = mu_p, sd = sqrt(var_p_stress))
  }
}

# VaR at 1%
VaR_1 <- -quantile(returns_sim, 0.01)

cat("Value-at-Risk (1%) =", round(VaR_1, 6), "\n")

# Save result
saveRDS(VaR_1, "data/processed/var_1.rds")