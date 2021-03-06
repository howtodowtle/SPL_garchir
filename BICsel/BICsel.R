# ---------------------------------------------------------------------
# Book:         
# ---------------------------------------------------------------------
# Quantlet:     GARCH/ARCH_model_selection_BIC
# ---------------------------------------------------------------------
# Description:  Select the most appropriate ARCH/GARCH model for
#               fitting data by minimizing the Bayesian Information 
#               Criterion (BIC)
# ---------------------------------------------------------------------
# Usage:        
# ---------------------------------------------------------------------
# Inputs:       BIC:    Calculates and returns the Bayesian Information 
#                       Criterion
#               n.like: negative log-likelihood
#               k:      number of free parameters to be estimated
#               n:      number of data points
#               q:      order of GARCH terms
#               p:      order of ARCH terms
# ---------------------------------------------------------------------
# Output:       Matrix/ vector containing the BIC of the models we want
#               to test and the respective model with the smallest BIC
# ---------------------------------------------------------------------
# Example:      Find the most appropriate ARCH model for fitting the
#               residuals generated by an ARMA(1,1) model, by comparing
#               ARCH models up to order 10
# ---------------------------------------------------------------------
# Author:       Alexander Dautel, Thorsten Disser, Binhui Hu,
#               Nicolas Yiannakou
# ---------------------------------------------------------------------

## Clear history
rm(list = ls(all = TRUE))
graphics.off()

## Intall and load packages
libraries = c("stats", "stockPortfolio", "tseries")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

## Get Data, Returns and residuals generated by an ARMA model
grEx1 = getReturns(c('C'), start='2004-01-01', end='2008-12-31')
returns = grEx1$R
residuals = resid(arima(returns, order = c(1,0,1)), na.action=na.exclude)

## Identify BIC function
BIC = function(n.like, k, n) {
  2 * n.like + 2 * k * log(n)
}

## Use bic to test
n = length(grEx1)
q = 10
p = 0
bic.arch = NA

for(i in 1 : q) {
  bic.arch[i] = BIC(garch(residuals, order = c(p, i))$n.likeli, i + 1, n)
}

## Results
arch.min = min(bic.arch)
bic.arch
which(bic.arch == min(bic.arch), arr.ind = TRUE)