# Introduction

## Thanks 

Various people have helped in the process of putting together these materials (either knowingly, or unknowingly). Big thanks go to: 

- Alexandra Chouldechova
- Ben Baumer
- Benoit Monin
- Datacamp
- David Lagnado
- Ewart Thomas
- Henrik Singmann
- Julian Jara-Ettinger
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

Special thanks also to my teaching assistants: 

- Andrew Lampinen
- Mona Rosenke 
- Shao-Fang (Pam) Wang

## List of R packages used in this book 


```r
# RMarkdown 
library("knitr")        # markdown things 
library("kableExtra")   # for nicely formatted tables

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
library("cowplot")      # making figure panels
library("ggpol")        # for making fancy boxplots
library("ggridges")     # for making joyplots 
library("gganimate")    # for making animations
library("GGally")       # for pairs plot
library("ggrepel")      # for labels in ggplots
library("corrr")        # for calculating correlations between many variables
library("corrplot")     # for plotting correlations
library("DiagrammeR")   # for drawing diagrams

# Modeling 
library("afex")         # also for running ANOVAs
library("lme4")         # mixed effects models 
library("emmeans")      # comparing estimated marginal means 
library("broom")        # getting tidy model summaries
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

# Misc 
library("tictoc")       # timing things
library("MASS")         # various useful functions (e.g. bootstrapped confidence intervals)
library("lsr")          # for computing effect size measures
library("extrafont")    # additional fonts
library("pwr")          # for power calculations
```



```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("modelr")     # for doing modeling stuff
library("tidybayes")  # tidying up results from Bayesian models
```

```
## NOTE: As of tidybayes version 1.0, several functions, arguments, and output column names
##       have undergone significant name changes in order to adopt a unified naming scheme.
##       See help('tidybayes-deprecated') for more information.
```

```r
library("brms")       # Bayesian regression models with Stan
```

```
## Loading required package: Rcpp
```

```
## Loading required package: ggplot2
```

```
## Loading 'brms' package (version 2.7.0). Useful instructions
## can be found by typing help('brms'). A more detailed introduction
## to the package is available through vignette('brms_overview').
## Run theme_set(theme_default()) to use the default bayesplot theme.
```

```r
library("rstanarm")   # for Bayesian models
```

```
## rstanarm (Version 2.18.2, packaged: 2018-11-08 22:19:38 UTC)
```

```
## - Do not expect the default priors to remain the same in future rstanarm versions.
```

```
## Thus, R scripts should specify priors explicitly, even if they are just the defaults.
```

```
## - For execution on a local, multicore CPU with excess RAM we recommend calling
```

```
## options(mc.cores = parallel::detectCores())
```

```
## - Plotting theme set to bayesplot::theme_default().
```

```
## 
## Attaching package: 'rstanarm'
```

```
## The following objects are masked from 'package:brms':
## 
##     exponential, kfold, lasso, ngrps
```

```r
library("cowplot")    # for making figure panels
```

```
## 
## Attaching package: 'cowplot'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     ggsave
```

```r
library("ggrepel")    # for labels in ggplots
library("gganimate")  # for animations
library("GGally")     # for pairs plot
library("bayesplot")  # for visualization of Bayesian model fits 
```

```
## This is bayesplot version 1.6.0
```

```
## - Online documentation and vignettes at mc-stan.org/bayesplot
```

```
## - bayesplot theme set to bayesplot::theme_default()
```

```
##    * Does _not_ affect other ggplot2 plots
```

```
##    * See ?bayesplot_theme_set for details on theme setting
```

```r
library("tidyverse")  # for wrangling, plotting, etc. 
```

```
## -- Attaching packages ---------------------------------- tidyverse 1.2.1 --
```

```
## v tibble  2.0.1       v purrr   0.3.1  
## v tidyr   0.8.3       v dplyr   0.8.0.1
## v readr   1.3.1       v stringr 1.4.0  
## v tibble  2.0.1       v forcats 0.4.0
```

```
## -- Conflicts ------------------------------------- tidyverse_conflicts() --
## x dplyr::filter()     masks stats::filter()
## x cowplot::ggsave()   masks ggplot2::ggsave()
## x dplyr::group_rows() masks kableExtra::group_rows()
## x dplyr::lag()        masks stats::lag()
```

```r
df.poker = read_csv("data/poker.csv") %>% 
  mutate(skill = factor(skill,
                        levels = 1:2,
                        labels = c("expert", "average")),
         skill = fct_relevel(skill, "average", "expert"),
         hand = factor(hand,
                       levels = 1:3,
                       labels = c("bad", "neutral", "good")),
         limit = factor(limit,
                        levels = 1:2,
                        labels = c("fixed", "none")),
         participant = 1:n()) %>% 
  select(participant, everything())
```

```
## Parsed with column specification:
## cols(
##   skill = col_double(),
##   hand = col_double(),
##   limit = col_double(),
##   balance = col_double()
## )
```

```r
fit.brm1 = brm(formula = balance ~ 1 + hand,
               data = df.poker,
               file = "cache/brm1")

fit.brm1 %>% summary()
```

```
##  Family: gaussian 
##   Links: mu = identity; sigma = identity 
## Formula: balance ~ 1 + hand 
##    Data: df.poker (Number of observations: 300) 
## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
##          total post-warmup samples = 4000
## 
## Population-Level Effects: 
##             Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## Intercept       5.95      0.42     5.12     6.79       3609 1.00
## handneutral     4.38      0.59     3.24     5.56       3489 1.00
## handgood        7.07      0.59     5.94     8.22       3553 1.00
## 
## Family Specific Parameters: 
##       Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## sigma     4.13      0.17     3.81     4.47       3578 1.00
## 
## Samples were drawn using sampling(NUTS). For each parameter, Eff.Sample 
## is a crude measure of effective sample size, and Rhat is the potential 
## scale reduction factor on split chains (at convergence, Rhat = 1).
```

```r
# generate predictive samples 
df.predictive_samples = fit.brm1 %>% 
  posterior_samples() %>% 
  clean_names() %>% 
  select(contains("b_"), sigma) %>% 
  sample_n(size = 20) %>% 
  mutate(sample = 1:n()) %>% 
  group_by(sample) %>% 
  nest() %>% 
  mutate(bad = map(data, ~ .$b_intercept + rnorm(100, sd = .$sigma)),
         neutral = map(data, ~ .$b_intercept + .$b_handneutral + rnorm(100, sd = .$sigma)),
         good = map(data, ~ .$b_intercept + .$b_handgood + rnorm(100, sd = .$sigma))) %>% 
  unnest(bad, neutral, good)

# plot the results as an animation
df.predictive_samples %>% 
  gather("hand", "balance", -sample) %>% 
  mutate(hand = factor(hand, levels = c("bad", "neutral", "good"))) %>% 
  ggplot(mapping = aes(x = hand,
                       y = balance,
                       fill = hand)) + 
  geom_point(alpha = 0.2,
             position = position_jitter(height = 0, width = 0.1)) + 
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               size = 1) + 
  stat_summary(fun.y = "mean",
               geom = "point",
               shape = 21,
               size = 4) +
  labs(y = "final balance (in Euros)") + 
  scale_fill_manual(values = c("red", "orange", "green")) +
  theme(legend.position = "none") + 
  transition_manual(sample)
```

```
## nframes and fps adjusted to match transition
```

```
## Rendering [=>-------------------------------------] at 2.3 fps ~ eta: 8s
```

```
## Rendering [===>-------------------------------------] at 3 fps ~ eta: 6s
```

```
## Rendering [=====>---------------------------------] at 3.3 fps ~ eta: 5s
```

```
## Rendering [=======>-------------------------------] at 2.6 fps ~ eta: 6s
```

```
## Rendering [=========>-----------------------------] at 2.4 fps ~ eta: 6s
```

```
## Rendering [===========>---------------------------] at 2.4 fps ~ eta: 6s
```

```
## Rendering [=============>-------------------------] at 2.6 fps ~ eta: 5s
```

```
## Rendering [===============>-----------------------] at 2.7 fps ~ eta: 4s
```

```
## Rendering [=================>---------------------] at 2.8 fps ~ eta: 4s
```

```
## Rendering [===================>-------------------] at 2.9 fps ~ eta: 3s
```

```
## Rendering [======================>------------------] at 3 fps ~ eta: 3s
```

```
## Rendering [======================>----------------] at 3.1 fps ~ eta: 3s
```

```
## Rendering [========================>--------------] at 3.2 fps ~ eta: 2s
```

```
## Rendering [==========================>------------] at 3.1 fps ~ eta: 2s
```

```
## Rendering [============================>----------] at 3.1 fps ~ eta: 2s
```

```
## Rendering [==============================>--------] at 3.1 fps ~ eta: 1s
```

```
## Rendering [================================>------] at 3.1 fps ~ eta: 1s
```

```
## Rendering [==================================>----] at 3.1 fps ~ eta: 1s
```

```
## Rendering [====================================>--] at 3.2 fps ~ eta: 0s
```

```
## Rendering [=======================================] at 3.3 fps ~ eta: 0s
```


\animategraphics[,controls,loop]{60}{01-introduction_files/figure-latex/unnamed-chunk-2-}{1}{20}

