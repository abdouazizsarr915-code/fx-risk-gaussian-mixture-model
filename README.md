# FX Risk Modeling with Gaussian Mixture and GH Distribution

## Overview

This project models foreign exchange (FX) returns using a multivariate Gaussian mixture model estimated via the EM algorithm. The analysis focuses on major currency pairs:

- EUR/USD  
- GBP/USD  
- CAD/USD  

The objective is to capture regime shifts in market behavior (calm vs stress) and improve risk estimation compared to standard Gaussian models.

---

## Methods

- Multivariate Gaussian Mixture Model (2 regimes)
- EM algorithm for parameter estimation
- Value-at-Risk (VaR) simulation
- Generalized Hyperbolic (GH) distribution
- Out-of-sample log-likelihood comparison

---

## Results

- Identification of distinct market regimes (calm vs stress)
- Better modeling of heavy tails using GH distribution
- Improved risk estimation compared to Gaussian models

---

## Project Structure

- Scripts/ → modeling and estimation code  
- Data/ → FX return datasets  
- Figures/ → generated visualizations  

---

## Key Takeaways

- Gaussian mixture models capture regime-switching behavior in FX markets  
- GH distributions improve tail risk modeling  
- Standard Gaussian assumptions underestimate extreme risk  

---

## Author

Abdoul Sarr  
BSc Mathematics & Economics  
University of Ottawa  

- Quantitative Finance  
- Risk Modeling  
- Time Series Analysis