# Introduction

## Thanks 

Various people have helped in the process of putting together these materials (either knowingly, or unknowingly). Big thanks go to: 

- Alexandra Chouldechova
- Ben Baumer
- Benoit Monin
- David Lagnado
- Ewart Thomas
- Henrik Singmann
- Julian Jara-Ettinger
- Justin Gardner
- Kevin Smith
- Maarten Speekenbrink
- Matthew Kay
- Matthew Salganik
- Mika Braginsky 
- Mike Frank 
- Mine Çetinkaya-Rundel
- Patrick Mair
- Peter Cushner Mohanty
- Richard McElreath
- Russ Poldrack 
- Stephen Dewitt
- Tom Hardwicke
- Tristan Mahr

Special thanks go to my teaching teams: 

- 2021: 
  - Andrew Nam 
  - Catherine Thomas 
  - Jon Walters
  - Dan Yamins
- 2020: 
  - Tyler Bonnen
  - Andrew Nam 
  - Jinxiao Zhang
- 2019:
  - Andrew Lampinen
  - Mona Rosenke 
  - Shao-Fang (Pam) Wang

## List of R packages used in this book 


```r
# RMarkdown 
library("knitr")      # markdown things 
library("kableExtra") # for nicely formatted tables

# Datasets 
library("gapminder")    # data available from Gapminder.org 
library("NHANES")       # data set 
library("titanic")      # titanic dataset

# Data manipulation
library("arrangements") # fast generators and iterators for permutations, combinations and partitions
library("magrittr")     # for wrangling
library("tidyverse")    # everything else

# Visualization
library("patchwork")    # making figure panels
library("ggpol")        # for making fancy boxplots
library("ggridges")     # for making joyplots 
library("gganimate")    # for making animations
library("GGally")       # for pairs plot
library("ggrepel")      # for labels in ggplots
library("corrr")        # for calculating correlations between many variables
library("corrplot")     # for plotting correlations
library("DiagrammeR")   # for drawing diagrams
library("ggeffects")    # for visualizing effects
library("bayesplot")    # for visualization of Bayesian model fits 

# Modeling 
library("afex")         # also for running ANOVAs
library("lme4")         # mixed effects models 
library("emmeans")      # comparing estimated marginal means 
library("broom.mixed")  # getting tidy mixed model summaries
library("janitor")      # cleaning variable names 
library("car")          # for running ANOVAs
library("rstanarm")     # for Bayesian models
library("greta")        # Bayesian models
library("tidybayes")    # tidying up results from Bayesian models
library("boot")         # bootstrapping
library("modelr")       # cross-validation and bootstrapping
library("mediation")    # for mediation and moderation analysis 
library("multilevel")   # Sobel test
library("extraDistr")   # additional probability distributions
library("effects")      # for showing effects in linear, generalized linear, and other models
library("brms")         # Bayesian regression
library("parameters")   # For extracting parameters 

# Misc 
library("tictoc")       # timing things
library("MASS")         # various useful functions (e.g. bootstrapped confidence intervals)
library("lsr")          # for computing effect size measures
library("extrafont")    # additional fonts
library("pwr")          # for power calculations
library("arrangements") # fast generators and iterators for permutations, combinations and partitions
library("stargazer")    # for regression tables
library("sjPlot")       # for regression tables
library("xtable")       # for tables
```

## Installing packages 




## Session info


```
## R version 4.0.3 (2020-10-10)
## Platform: x86_64-apple-darwin17.0 (64-bit)
## Running under: macOS Catalina 10.15.7
## 
## Matrix products: default
## BLAS:   /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRblas.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## loaded via a namespace (and not attached):
##  [1] compiler_4.0.3    magrittr_2.0.1    bookdown_0.21     htmltools_0.5.1.1
##  [5] tools_4.0.3       yaml_2.2.1        stringi_1.5.3     rmarkdown_2.6    
##  [9] knitr_1.31        stringr_1.4.0     digest_0.6.27     xfun_0.21        
## [13] rlang_0.4.10      evaluate_0.14
```
