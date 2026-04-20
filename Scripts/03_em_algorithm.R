# ============================================
# 03_em_algorithm.R
# EM estimation for multivariate Gaussian mixture
# ============================================

library(mvtnorm)
library(ellipse)

# Load processed data
data_train <- readRDS("data/processed/data_train.rds")
train_mat <- as.matrix(data_train)

# Create figures folder if needed
if (!dir.exists("figures")) dir.create("figures", recursive = TRUE)

# --------------------------------------------
# Log-likelihood of the Gaussian mixture
# --------------------------------------------
log_vraisemblance_melange <- function(data, pi, mu, Sigma, tau) {
  log_d1 <- mvtnorm::dmvnorm(data, mean = mu, sigma = Sigma, log = TRUE)
  log_d2 <- mvtnorm::dmvnorm(data, mean = mu, sigma = tau * Sigma, log = TRUE)
  
  log_mix <- numeric(length(log_d1))
  
  for (i in seq_along(log_d1)) {
    a <- log(pi) + log_d1[i]
    b <- log(1 - pi) + log_d2[i]
    m <- max(a, b)
    log_mix[i] <- m + log(exp(a - m) + exp(b - m))
  }
  
  sum(log_mix)
}

# --------------------------------------------
# EM algorithm
# --------------------------------------------
EM_melange <- function(data, max_iter = 200, tol = 1e-6) {
  data <- as.matrix(data)
  n <- nrow(data)
  d <- ncol(data)
  
  diag_emp <- diag(cov(data))
  
  mu_init <- colMeans(data)
  Sigma_init <- cov(data) + diag(1e-8, d)
  inv_Sigma_init <- solve(Sigma_init)
  
  dist2 <- apply(data, 1, function(x) {
    diff <- matrix(x - mu_init, ncol = 1)
    as.numeric(t(diff) %*% inv_Sigma_init %*% diff)
  })
  
  threshold <- quantile(dist2, 0.8)
  gamma <- ifelse(dist2 <= threshold, 0.9, 0.1)
  
  pi_old <- mean(gamma)
  mu_old <- colSums(gamma * data) / sum(gamma)
  
  Sigma_old <- matrix(0, d, d)
  for (t in 1:n) {
    diff_vec <- matrix(data[t, ] - mu_old, ncol = 1)
    Sigma_old <- Sigma_old + gamma[t] * (diff_vec %*% t(diff_vec))
  }
  Sigma_old <- Sigma_old / sum(gamma)
  diag(Sigma_old) <- diag_emp
  Sigma_old <- Sigma_old + diag(1e-8, d)
  
  inv_Sigma_old <- solve(Sigma_old)
  sum_quad <- 0
  for (t in 1:n) {
    diff_vec <- matrix(data[t, ] - mu_old, ncol = 1)
    quad_val <- as.numeric(t(diff_vec) %*% inv_Sigma_old %*% diff_vec)
    sum_quad <- sum_quad + (1 - gamma[t]) * quad_val
  }
  
  tau_old <- sum_quad / (d * sum(1 - gamma))
  tau_old <- max(tau_old, 1.20)
  
  ll_old <- -Inf
  loglik_path <- numeric(max_iter)
  
  for (iter in 1:max_iter) {
    log_d1 <- mvtnorm::dmvnorm(data, mean = mu_old, sigma = Sigma_old, log = TRUE)
    log_d2 <- mvtnorm::dmvnorm(data, mean = mu_old, sigma = tau_old * Sigma_old, log = TRUE)
    
    gamma <- numeric(n)
    
    for (t in 1:n) {
      a <- log(pi_old) + log_d1[t]
      b <- log(1 - pi_old) + log_d2[t]
      m <- max(a, b)
      log_denom <- m + log(exp(a - m) + exp(b - m))
      gamma[t] <- exp(a - log_denom)
    }
    
    gamma <- pmax(pmin(gamma, 0.9999), 0.0001)
    
    pi_new <- mean(gamma)
    sum_gamma <- sum(gamma)
    mu_new <- colSums(gamma * data) / sum_gamma
    
    Sigma_new <- matrix(0, d, d)
    for (t in 1:n) {
      diff_vec <- matrix(data[t, ] - mu_new, ncol = 1)
      Sigma_new <- Sigma_new + gamma[t] * (diff_vec %*% t(diff_vec))
    }
    Sigma_new <- Sigma_new / sum_gamma
    
    diag(Sigma_new) <- diag_emp
    Sigma_new <- Sigma_new + diag(1e-8, d)
    
    inv_Sigma <- solve(Sigma_new)
    sum_quad <- 0
    for (t in 1:n) {
      diff_vec <- matrix(data[t, ] - mu_new, ncol = 1)
      quad_val <- as.numeric(t(diff_vec) %*% inv_Sigma %*% diff_vec)
      sum_quad <- sum_quad + (1 - gamma[t]) * quad_val
    }
    
    tau_new <- sum_quad / (d * sum(1 - gamma))
    tau_new <- max(tau_new, 1.20)
    
    ll_new <- log_vraisemblance_melange(data, pi_new, mu_new, Sigma_new, tau_new)
    loglik_path[iter] <- ll_new
    
    if (abs(ll_new - ll_old) < tol) break
    
    pi_old <- pi_new
    mu_old <- mu_new
    Sigma_old <- Sigma_new
    tau_old <- tau_new
    ll_old <- ll_new
  }
  
  list(
    pi = pi_new,
    mu = mu_new,
    Sigma = Sigma_new,
    tau = tau_new,
    gamma = gamma,
    log_vraisemblance = ll_new,
    iterations = iter,
    loglik_path = loglik_path[1:iter]
  )
}

# Estimate model
res_em <- EM_melange(train_mat)

# Save results
saveRDS(res_em, file = "data/processed/em_results.rds")

cat("EM estimation complete\n")
cat("pi =", round(res_em$pi, 4), "\n")
cat("tau =", round(res_em$tau, 4), "\n")
cat("logLik =", round(res_em$log_vraisemblance, 4), "\n")
cat("iterations =", res_em$iterations, "\n")

# --------------------------------------------
# Plot 1: EM convergence
# --------------------------------------------
png("figures/em_convergence.png", width = 900, height = 600)
plot(res_em$loglik_path, type = "b", pch = 19, lwd = 2,
     main = "EM Convergence",
     xlab = "Iteration",
     ylab = "Log-likelihood")
dev.off()

# --------------------------------------------
# Plot 2: Posterior probabilities
# --------------------------------------------
png("figures/gamma_probabilities.png", width = 900, height = 600)
plot(res_em$gamma, type = "l", lwd = 1.5,
     main = "Posterior Probability of Calm Regime",
     xlab = "Time",
     ylab = expression(gamma[t]))
abline(h = 0.5, lty = 2)
dev.off()

# --------------------------------------------
# Plot 3: Ellipses
# --------------------------------------------
eur <- as.numeric(data_train$EUR)
cad <- as.numeric(data_train$CAD)
regime_colors <- ifelse(res_em$gamma > 0.5, "royalblue", "firebrick")

x_margin <- 0.25 * diff(range(eur))
y_margin <- 0.25 * diff(range(cad))

png("figures/ellipses.png", width = 900, height = 700)
plot(eur, cad,
     col = regime_colors,
     pch = 19,
     cex = 0.5,
     main = "95% Concentration Ellipses",
     xlab = "EUR Returns",
     ylab = "CAD Returns",
     xlim = c(min(eur) - x_margin, max(eur) + x_margin),
     ylim = c(min(cad) - y_margin, max(cad) + y_margin))

lines(
  ellipse(res_em$Sigma[1:2, 1:2],
          centre = res_em$mu[1:2],
          level = 0.95),
  col = "royalblue",
  lwd = 2
)

lines(
  ellipse(res_em$tau * res_em$Sigma[1:2, 1:2],
          centre = res_em$mu[1:2],
          level = 0.95),
  col = "firebrick",
  lwd = 2,
  lty = 2
)

legend("topright",
       legend = c("Calm regime", "Stress regime"),
       col = c("royalblue", "firebrick"),
       lty = c(1, 2),
       lwd = 2,
       bty = "n")
dev.off()