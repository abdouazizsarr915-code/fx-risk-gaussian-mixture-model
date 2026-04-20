# ============================================
# 01_download_data.R
# Download FX data from Yahoo Finance
# ============================================

library(quantmod)
library(xts)
library(zoo)

# Create data folders if needed
if (!dir.exists("data")) dir.create("data", recursive = TRUE)
if (!dir.exists("data/raw")) dir.create("data/raw", recursive = TRUE)

# FX symbols
symbols <- c("EURUSD=X", "CADUSD=X", "GBPUSD=X")

# Download data
invisible(
  getSymbols(
    symbols,
    src = "yahoo",
    from = "2012-01-01",
    to = "2018-01-01"
  )
)

# Merge closing prices
fx_data <- merge(
  Cl(`EURUSD=X`),
  Cl(`CADUSD=X`),
  Cl(`GBPUSD=X`)
)

colnames(fx_data) <- c("EUR", "CAD", "GBP")

# Save raw data
saveRDS(fx_data, file = "data/raw/fx_data_raw.rds")

cat("Raw FX data downloaded and saved to data/raw/fx_data_raw.rds\n")
print(head(fx_data))