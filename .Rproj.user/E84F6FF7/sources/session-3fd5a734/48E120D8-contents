# ============================================
# 06_run_project.R
# Run full project pipeline
# ============================================

cat("=====================================\n")
cat(" Running full project pipeline\n")
cat("=====================================\n\n")

cat("Working directory:", getwd(), "\n\n")

cat("Step 1: Download data\n")
source("scripts/01_download_data.R")

cat("\nStep 2: Prepare returns\n")
source("scripts/02_prepare_returns.R")

cat("\nStep 3: EM estimation\n")
source("scripts/03_em_algorithm.R")

cat("\nStep 4: VaR analysis\n")
source("scripts/04_var_analysis.R")

cat("\nStep 5: GH comparison\n")
source("scripts/05_gh_comparison.R")

cat("\n=====================================\n")
cat(" Project completed successfully\n")
cat("=====================================\n")