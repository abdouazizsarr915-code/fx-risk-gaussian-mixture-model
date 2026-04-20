# ============================================
# 02_prepare_returns.R
# Prepare log-returns and train/test split
# ============================================

library(xts)
library(zoo)

# Load raw data
fx_data <- readRDS("data/raw/fx_data_raw.rds")

# Create folders if needed
if (!dir.exists("data/processed")) dir.create("data/processed", recursive = TRUE)

# Compute log-returns
log_returns <- na.omit(diff(log(fx_data)))

# Train / test split
split_idx <- floor(0.8 * nrow(log_returns))

data_train <- log_returns[1:(split_idx - 1), ]
data_test  <- log_returns[split_idx:nrow(log_returns), ]

# Save processed objects
saveRDS(log_returns, file = "data/processed/log_returns.rds")
saveRDS(data_train, file = "data/processed/data_train.rds")
saveRDS(data_test, file = "data/processed/data_test.rds")

cat("Processed returns saved in data/processed/\n")
cat("Train observations:", nrow(data_train), "\n")
cat("Test observations:", nrow(data_test), "\n")
print(head(log_returns))