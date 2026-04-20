# FX Risk Modeling with Gaussian Mixture and GH Distribution

## Overview

This project models foreign exchange (FX) returns using a multivariate Gaussian mixture model estimated via the EM algorithm. The analysis focuses on major currency pairs:

    EUR/USD
    GBP/USD
    CAD/USD

The goal is to capture regime shifts in market behavior and improve risk estimation compared to standard models.


## Methods

    Multivariate Gaussian Mixture Model (2 regimes)
    EM algorithm for parameter estimation
    Value-at-Risk (VaR) simulation
    Generalized Hyperbolic (GH) distribution
    Out-of-sample log-likelihood comparison


## Results

    Identification of distinct market regimes (calm vs stress)
    Better modeling of heavy tails using GH distribution
    Improved risk estimation compared to Gaussian assumptions


## Project Structure

    `Scripts/` → modeling and estimation code
    `Data/` → FX return data
    `figures/` → generated visualizations


## Author

Abdoul Sarr  
BSc Mathematics & Economics  
University of Ottawa