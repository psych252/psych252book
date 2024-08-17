# Introduction

## Thanks

Various people have helped in the process of putting together these materials (either knowingly, or unknowingly). Big thanks go to: 

- [Alexandra Chouldechova](https://www.andrew.cmu.edu/user/achoulde/)
- [Allison Horst](https://www.allisonhorst.com/)
- [Andrew Heiss](https://www.andrewheiss.com/)
- [Ben Baumer](https://www.smith.edu/academics/faculty/ben-baumer)
- [Benoit Monin](https://www.gsb.stanford.edu/faculty-research/faculty/benoit-monin)
- [Bodo Winter](https://bodowinter.com/)
- [David Lagnado](https://www.ucl.ac.uk/pals/people/david-lagnado)
- [Ewart Thomas](https://profiles.stanford.edu/ewart-thomas)
- [Henrik Singmann](http://singmann.org/)
- [Julian Jara-Ettinger](https://psychology.yale.edu/people/julian-jara-ettinger)
- [Justin Gardner](https://profiles.stanford.edu/justin-gardner)
- [Kevin Smith](http://www.mit.edu/~k2smith/)
- [Lisa DeBruine](https://debruine.github.io/)
- [Maarten Speekenbrink](https://www.ucl.ac.uk/pals/people/maarten-speekenbrink)
- [Matthew Kay](https://www.mjskay.com/)
- [Matthew Salganik](http://www.princeton.edu/~mjs3/)
- [Michael Franke](https://michael-franke.github.io/heimseite/)
- [Mika Braginsky](https://mikabr.io/) 
- [Mike Frank](https://web.stanford.edu/~mcfrank/) 
- [Mine Çetinkaya-Rundel](https://mine-cr.com/)
- [Nick C. Huntington-Klein](https://www.nickchk.com/)
- [Nilam Ram](https://profiles.stanford.edu/nilam-ram)
- [Patrick Mair](https://psychology.fas.harvard.edu/people/patrick-mair)
- [Paul-Christian Bürkner](https://paul-buerkner.github.io/about/) 
- [Peter Cushner Mohanty](https://explorecourses.stanford.edu/instructor/pmohanty)
- [Richard McElreath](https://xcelab.net/rm/)
- [Russ Poldrack](https://profiles.stanford.edu/russell-poldrack) 
- [Stephen Dewitt](https://www.ucl.ac.uk/pals/research/experimental-psychology/person/stephen-dewitt/)
- [Solomon Kurz](https://solomonkurz.netlify.app/) 
- [Tom Hardwicke](https://tomhardwicke.netlify.app/)
- [Tristan Mahr](https://www.tjmahr.com/) 

Special thanks go to my teaching teams: 

- 2024: 
  - Ari Beller
  - Beth Rispoli
  - Satchel Grant 
  - Shawn Schwartz
- 2023: 
  - Nilam Ram (instructor)
  - Ari Beller
  - Yoonji Lee
  - Satchel Grant 
  - Josh Wilson
- 2022: 
  - Ari Beller
  - Sarah Wu
  - Chengxu Zhuang 
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


``` r
# RMarkdown
library("knitr")            # markdown things
library("bookdown")         # markdown things
library("kableExtra")       # for nicely formatted tables

# Datasets
library("gapminder")        # data available from Gapminder.org
library("NHANES")           # data set
library("datarium")         # data set
library("titanic")          # titanic dataset

# Data manipulation
library("arrangements")     # fast generators and iterators for permutations, combinations and partitions
library("magrittr")         # for wrangling
library("tidyverse")        # everything else

# Visualization
library("patchwork")        # making figure panels
library("ggpol")            # for making fancy boxplots
library("ggridges")         # for making joyplots
library("gganimate")        # for making animations
library("transformr")       # for gganmiate
library("GGally")           # for pairs plot
library("ggrepel")          # for labels in ggplots
library("corrr")            # for calculating correlations between many variables
library("corrplot")         # for plotting correlations
library("DiagrammeR")       # for drawing diagrams
library("DiagrammeRsvg")    # for visualizing diagrams
library("ggeffects")        # for visualizing effects
library("bayesplot")        # for visualization of Bayesian model fits
library("skimr")            # for quick data visualizations
library("visdat")           # for quick data visualizations
library("rsvg")             # for visualization
library("see")              # for visualizing data

# Modeling
library("afex")             # also for running ANOVAs
library("lme4")             # mixed effects models
library("emmeans")          # comparing estimated marginal means
library("broom.mixed")      # getting tidy mixed model summaries
library("janitor")          # cleaning variable names
library("car")              # for running ANOVAs
library("rstanarm")         # for Bayesian models
library("greta")            # Bayesian models
library("tidybayes")        # tidying up results from Bayesian models
library("boot")             # bootstrapping
library("modelr")           # cross-validation and bootstrapping
library("mediation")        # for mediation and moderation analysis
library("multilevel")       # Sobel test
library("extraDistr")       # additional probability distributions
library("effects")          # for showing effects in linear, generalized linear, and other models
library("brms")             # Bayesian regression
library("parameters")       # For extracting parameters
library("rstanarm")         # For Bayesian modeling with Stan

# Misc
library("tictoc")           # timing things
library("MASS")             # various useful functions (e.g. bootstrapped confidence intervals)
library("lsr")              # for computing effect size measures
library("extrafont")        # additional fonts
library("pwr")              # for power calculations
library("arrangements")     # fast generators and iterators for permutations, combinations and partitions
library("stargazer")        # for regression tables
library("sjPlot")           # for regression tables
library("xtable")           # for tables
library("DT")               # for tables
library("papaja")           # for reporting results
library("statsExpressions") # for extracting stats results APA style
library("devtools")         # for installing packages from GitHub
library("sf")               # package needed for the transformr package
```

## Install all packages needed for this book 


``` r
install.packages(c("knitr", "bookdown", "kableExtra", "gapminder", "NHANES", "datarium", "titanic", "arrangements", "magrittr", "tidyverse", "patchwork", "ggpol", "ggridges", "gganimate", "GGally", "ggrepel", "corrr", "corrplot", "DiagrammeR", "DiagrammeRsvg", "ggeffects", "bayesplot", "skimr", "visdat", "rsvg", "see", "afex", "lme4", "emmeans", "broom.mixed", "janitor", "car", "rstanarm", "greta", "tidybayes", "boot", "modelr", "mediation", "multilevel", "extraDistr", "effects", "brms", "parameters", "tictoc", "MASS", "lsr", "extrafont", "pwr", "arrangements", "stargazer", "sjPlot", "xtable", "DT", "papaja", "statsExpressions", "devtools", "sf", "rstanarm"))

devtools::install_github("thomasp85/transformr")
```


## Session info


```
## R version 4.4.1 (2024-06-14)
## Platform: aarch64-apple-darwin20
## Running under: macOS Sonoma 14.6
## 
## Matrix products: default
## BLAS:   /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRblas.0.dylib 
## LAPACK: /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## time zone: America/Los_Angeles
## tzcode source: internal
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## loaded via a namespace (and not attached):
##  [1] digest_0.6.36     R6_2.5.1          bookdown_0.40     fastmap_1.2.0    
##  [5] xfun_0.45         cachem_1.1.0      knitr_1.48        htmltools_0.5.8.1
##  [9] rmarkdown_2.27    lifecycle_1.0.4   cli_3.6.3         sass_0.4.9       
## [13] jquerylib_0.1.4   compiler_4.4.1    tools_4.4.1       evaluate_0.24.0  
## [17] bslib_0.7.0       yaml_2.3.9        rlang_1.1.4       jsonlite_1.8.8
```
