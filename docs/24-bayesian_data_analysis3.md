# Bayesian data analysis 3

## Learning goals

- Evidence for null results. 
- Only positive predictors. 
- Dealing with unequal variance. 
- Modeling slider data: Zero-one inflated beta binomial model. 
- Modeling Likert scale data: Ordinal logistic regression. 

## Load packages and set plotting theme


```r
library("knitr")       # for knitting RMarkdown 
library("kableExtra")  # for making nice tables
library("janitor")     # for cleaning column names
library("tidybayes")   # tidying up results from Bayesian models
library("brms")        # Bayesian regression models with Stan
library("patchwork")   # for making figure panels
library("GGally")      # for pairs plot
library("broom.mixed") # for tidy lmer results
library("bayesplot")   # for visualization of Bayesian model fits 
library("modelr")      # for modeling functions
library("lme4")        # for linear mixed effects models 
library("afex")        # for ANOVAs
library("car")         # for ANOVAs
library("emmeans")     # for linear contrasts
library("ggeffects")   # for help with logistic regressions
library("titanic")     # titanic dataset
library("gganimate")   # for animations
library("parameters")  # for getting parameters
library("transformr")  # for gganimate
library("rstanarm")    # for Bayesian models
library("ggrepel")     # for labels in ggplots
library("scales")      # for percent y-axis
library("tidyverse")   # for wrangling, plotting, etc. 
```


```r
theme_set(theme_classic() + #set the theme 
            theme(text = element_text(size = 20))) #set the default text size

# set rstan options
rstan::rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

opts_chunk$set(comment = "",
               fig.show = "hold")
```

## Evidence for the null hypothesis

See [this tutorial](https://vuorre.netlify.com/post/2017/03/21/bayes-factors-with-brms/) and this paper [@wagenmakers2010bayesiana] for more information. 

### Bayes factor

#### Fit the model

- Define a binomial model
- Give a uniform prior `beta(1, 1)`
- Get samples from the prior


```r
df.null = tibble(s = 6, k = 10)

fit.brm_bayes = brm(s | trials(k) ~ 0 + Intercept, 
               family = binomial(link = "identity"),
               prior = set_prior("beta(1, 1)", class = "b", lb = 0, ub = 1),
               data = df.null,
               sample_prior = TRUE,
               cores = 4,
               file = "cache/brm_bayes")
```

#### Visualize the results

Visualize the prior and posterior samples: 


```r
fit.brm_bayes %>% 
  posterior_samples(pars = "b") %>% 
  pivot_longer(cols = everything()) %>% 
  ggplot(mapping = aes(x = value,
                       fill = name)) + 
  geom_density(alpha = 0.5) + 
  scale_fill_brewer(palette = "Set1")
```

```
Warning: Method 'posterior_samples' is deprecated. Please see ?as_draws for
recommended alternatives.
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-4-1.png" width="672" />


We test the H0: $\theta = 0.5$ versus the H1: $\theta \neq 0.5$ using the Savage-Dickey Method, according to which we can compute the Bayes factor like so:  

$BF_{01} = \frac{p(D|H_0)}{p(D|H_1)} = \frac{p(\theta = 0.5|D, H_1)}{p(\theta = 0.5|H_1)}$


```r
fit.brm_bayes %>% 
  hypothesis(hypothesis = "Intercept = 0.5")
```

```
Hypothesis Tests for class b:
             Hypothesis Estimate Est.Error CI.Lower CI.Upper Evid.Ratio
1 (Intercept)-(0.5) = 0     0.08      0.14    -0.21     0.34       2.13
  Post.Prob Star
1      0.68     
---
'CI': 90%-CI for one-sided and 95%-CI for two-sided hypotheses.
'*': For one-sided hypotheses, the posterior probability exceeds 95%;
for two-sided hypotheses, the value tested against lies outside the 95%-CI.
Posterior probabilities of point hypotheses assume equal prior probabilities.
```

The result shows that the evidence ratio is in favor of the H0 with $BF_{01} = 2.22$. This means that H0 is 2.2 more likely than H1 given the data. 

### LOO

Another way to test different models is to compare them via approximate leave-one-out cross-validation. 


```r
set.seed(1)
df.loo = tibble(x = rnorm(n = 50),
                y = rnorm(n = 50))

# visualize 
ggplot(data = df.loo,
       mapping = aes(x = x, 
                     y = y)) + 
  geom_point()

# fit the frequentist model 
fit.lm_loo = lm(formula = y ~ 1 + x,
                data = df.loo)

fit.lm_loo %>% 
  summary()
```

```

Call:
lm(formula = y ~ 1 + x, data = df.loo)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.92760 -0.66898 -0.00225  0.48768  2.34858 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  0.12190    0.13935   0.875    0.386
x           -0.04555    0.16807  -0.271    0.788

Residual standard error: 0.9781 on 48 degrees of freedom
Multiple R-squared:  0.001528,	Adjusted R-squared:  -0.01927 
F-statistic: 0.07345 on 1 and 48 DF,  p-value: 0.7875
```

```r
# fit and compare bayesian models 
fit.brm_loo1 = brm(formula = y ~ 1,
                   data = df.loo,
                   seed = 1, 
                   file = "cache/brm_loo1")

fit.brm_loo2 = brm(formula = y ~ 1 + x,
                   data = df.loo,
                   seed = 1, 
                   file = "cache/brm_loo2")

fit.brm_loo1 = add_criterion(fit.brm_loo1,
                             criterion = "loo",
                             file = "cache/brm_loo1")

fit.brm_loo2 = add_criterion(fit.brm_loo2,
                             criterion = "loo",
                             file = "cache/brm_loo2")

loo_compare(fit.brm_loo1, fit.brm_loo2)
```

```
             elpd_diff se_diff
fit.brm_loo1  0.0       0.0   
fit.brm_loo2 -1.1       0.5   
```

```r
model_weights(fit.brm_loo1, fit.brm_loo2)
```

```
fit.brm_loo1 fit.brm_loo2 
9.999986e-01 1.351561e-06 
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-6-1.png" width="672" />


## Dealing with heteroscedasticity

Let's generate some fake developmental data where the variance in the data is greatest for young children, smaller for older children, and even smaller for adults:  


```r
# make example reproducible 
set.seed(1)

df.variance = tibble(group = rep(c("3yo", "5yo", "adults"), each = 20),
                     response = rnorm(n = 60,
                                      mean = rep(c(0, 5, 8), each = 20),
                                      sd = rep(c(3, 1.5, 0.3), each = 20)))
```

### Visualize the data


```r
df.variance %>%
  ggplot(aes(x = group, y = response)) +
  geom_jitter(height = 0,
              width = 0.1,
              alpha = 0.7)
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-8-1.png" width="672" />

### Frequentist analysis

#### Fit the model


```r
fit.lm_variance = lm(formula = response ~ 1 + group,
                     data = df.variance)

fit.lm_variance %>% 
  summary()
```

```

Call:
lm(formula = response ~ 1 + group, data = df.variance)

Residuals:
    Min      1Q  Median      3Q     Max 
-7.2157 -0.3613  0.0200  0.7001  4.2143 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   0.5716     0.3931   1.454    0.151    
group5yo      4.4187     0.5560   7.948  8.4e-11 ***
groupadults   7.4701     0.5560  13.436  < 2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 1.758 on 57 degrees of freedom
Multiple R-squared:  0.762,	Adjusted R-squared:  0.7537 
F-statistic: 91.27 on 2 and 57 DF,  p-value: < 2.2e-16
```

```r
fit.lm_variance %>% 
  glance()
```

```
# A tibble: 1 × 12
  r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC
      <dbl>         <dbl> <dbl>     <dbl>    <dbl> <dbl>  <dbl> <dbl> <dbl>
1     0.762         0.754  1.76      91.3 1.70e-18     2  -117.  243.  251.
# … with 3 more variables: deviance <dbl>, df.residual <int>, nobs <int>
```

#### Visualize the model predictions


```r
set.seed(1)

fit.lm_variance %>% 
  simulate() %>% 
  bind_cols(df.variance) %>% 
  ggplot(aes(x = group, y = sim_1)) +
  geom_jitter(height = 0,
              width = 0.1,
              alpha = 0.7)
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-10-1.png" width="672" />

Notice how the model predicts that the variance is equal for each group.

### Bayesian analysis

While frequentist models (such as a linear regression) assume equality of variance, Bayesian models afford us with the flexibility of inferring both the parameter estimates of the groups (i.e. the means and differences between the means), as well as the variances. 

#### Fit the model

We define a multivariate model which tries to fit both the `response` as well as the variance `sigma`: 


```r
fit.brm_variance = brm(formula = bf(response ~ group,
                                    sigma ~ group),
                       data = df.variance,
                       file = "cache/brm_variance",
                       seed = 1)

summary(fit.brm_variance)
```

```
 Family: gaussian 
  Links: mu = identity; sigma = log 
Formula: response ~ group 
         sigma ~ group
   Data: df.variance (Number of observations: 60) 
  Draws: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
         total post-warmup draws = 4000

Population-Level Effects: 
                  Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept            -0.01      0.73    -1.41     1.51 1.01     1107     1072
sigma_Intercept       1.15      0.17     0.85     1.51 1.00     1991     1922
group5yo              5.18      0.77     3.60     6.65 1.00     1253     1327
groupadults           7.98      0.74     6.47     9.37 1.01     1110     1079
sigma_group5yo       -1.05      0.24    -1.51    -0.57 1.00     2249     2420
sigma_groupadults    -2.19      0.24    -2.66    -1.74 1.00     2171     2427

Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
and Tail_ESS are effective sample size measures, and Rhat is the potential
scale reduction factor on split chains (at convergence, Rhat = 1).
```

Notice that sigma is on the log scale. To get the standard deviations, we have to exponentiate the predictors, like so:  


```r
fit.brm_variance %>% 
  tidy(parameters = "^b_") %>% 
  filter(str_detect(term, "sigma")) %>% 
  select(term, estimate) %>% 
  mutate(term = str_remove(term, "b_sigma_")) %>% 
  pivot_wider(names_from = term,
              values_from = estimate) %>% 
  clean_names() %>% 
  mutate(across(-intercept, ~ exp(. + intercept))) %>% 
  mutate(intercept = exp(intercept))
```

```
Warning in tidy.brmsfit(., parameters = "^b_"): some parameter names contain
underscores: term naming may be unreliable!
```

```
# A tibble: 1 × 3
  intercept group5yo groupadults
      <dbl>    <dbl>       <dbl>
1      3.16     1.10       0.352
```

#### Visualize the model predictions


```r
df.variance %>%
  expand(group) %>% 
  add_fitted_draws(fit.brm_variance, dpar = TRUE) %>%
  select(group, .row, .draw, posterior = .value, mu, sigma) %>% 
  pivot_longer(cols = c(mu, sigma),
               names_to = "index",
               values_to = "value") %>% 
  ggplot(aes(x = value, y = group)) +
  geom_halfeyeh() +
  geom_vline(xintercept = 0, linetype = "dashed") +
  facet_grid(cols = vars(index))
```

```
Warning: `fitted_draws` and `add_fitted_draws` are deprecated as their names were confusing.
Use [add_]epred_draws() to get the expectation of the posterior predictive.
Use [add_]linpred_draws() to get the distribution of the linear predictor.
For example, you used [add_]fitted_draws(..., scale = "response"), which
means you most likely want [add_]epred_draws(...).
```

```
Warning: 'geom_halfeyeh' is deprecated.
Use 'stat_halfeye' instead.
See help("Deprecated") and help("tidybayes-deprecated").
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-13-1.png" width="672" />

This plot shows what the posterior looks like for both mu (the inferred means), and for sigma (the inferred variances) for the different groups. 


```r
set.seed(1)

df.variance %>% 
  add_predicted_draws(object = fit.brm_variance,
                      ndraws = 1) %>% 
  ggplot(aes(x = group, y = .prediction)) +
  geom_jitter(height = 0,
              width = 0.1,
              alpha = 0.7)
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-14-1.png" width="672" />

## Zero-one inflated beta binomial model

See this [blog post](https://vuorre.netlify.com/post/2019/02/18/analyze-analog-scale-ratings-with-zero-one-inflated-beta-models/#zoib-regression). 

## Ordinal regression

Check out the following two papers: 

- @liddell2018analyzin
- @burkner2019ordinal

Let's read in some movie ratings: 


```r
df.movies = read_csv(file = "data/MoviesData.csv")

df.movies = df.movies %>% 
  pivot_longer(cols = n1:n5,
               names_to = "stars",
               values_to = "rating") %>% 
  mutate(stars = str_remove(stars,"n"),
         stars = as.numeric(stars))

df.movies = df.movies %>% 
  uncount(weights = rating) %>% 
  mutate(id = as.factor(ID)) %>% 
  filter(ID <= 6)
```

### Ordinal regression (assuming equal variance)

#### Fit the model


```r
fit.brm_ordinal = brm(formula = stars ~ 1 + id,
                      family = cumulative(link = "probit"),
                      data = df.movies,
                      file = "cache/brm_ordinal",
                      seed = 1)

summary(fit.brm_ordinal)
```

```
 Family: cumulative 
  Links: mu = probit; disc = identity 
Formula: stars ~ 1 + id 
   Data: df.movies (Number of observations: 21708) 
  Draws: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
         total post-warmup draws = 4000

Population-Level Effects: 
             Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept[1]    -1.22      0.04    -1.30    -1.14 1.00     1483     2215
Intercept[2]    -0.90      0.04    -0.98    -0.82 1.00     1448     1966
Intercept[3]    -0.44      0.04    -0.52    -0.36 1.00     1419     1853
Intercept[4]     0.33      0.04     0.25     0.41 1.00     1380     1861
id2              0.84      0.06     0.72     0.96 1.00     2045     2455
id3              0.22      0.06     0.11     0.33 1.00     1973     2400
id4              0.33      0.04     0.25     0.42 1.00     1491     1937
id5              0.45      0.05     0.34     0.55 1.00     1734     2681
id6              0.76      0.04     0.68     0.84 1.00     1367     1851

Family Specific Parameters: 
     Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
disc     1.00      0.00     1.00     1.00   NA       NA       NA

Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
and Tail_ESS are effective sample size measures, and Rhat is the potential
scale reduction factor on split chains (at convergence, Rhat = 1).
```

#### Visualizations

##### Model parameters

The model infers the thresholds and the means of the Gaussian distributions in latent space. 


```r
df.params = fit.brm_ordinal %>% 
  parameters(centrality = "mean") %>% 
  as_tibble() %>% 
  clean_names() %>% 
  select(term = parameter, estimate = mean)

ggplot(data = tibble(x = c(-3, 3)),
       mapping = aes(x = x)) + 
  stat_function(fun = ~ dnorm(.),
                size = 1,
                color = "black") +
  stat_function(fun = ~ dnorm(., mean = df.params %>% 
                                filter(str_detect(term, "id2")) %>% 
                                pull(estimate)),
                size = 1,
                color = "blue") +
  geom_vline(xintercept = df.params %>% 
               filter(str_detect(term, "Intercept")) %>% 
               pull(estimate))
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-17-1.png" width="672" />

##### MCMC inference


```r
fit.brm_ordinal %>% 
  plot(N = 9)
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-18-1.png" width="768" /><img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-18-2.png" width="768" />


```r
fit.brm_ordinal %>% 
  pp_check(nsamples = 20)
```

```
Warning: Argument 'nsamples' is deprecated. Please use argument 'ndraws'
instead.
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-19-1.png" width="672" />


##### Model predictions


```r
conditional_effects(fit.brm_ordinal,
                    effects = "id",
                    categorical = T)
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-20-1.png" width="672" />


```r
df.model = add_fitted_draws(newdata = expand_grid(id = 1:6),
                            model = fit.brm_ordinal,
                            n = 10)
```

```
Warning: `fitted_draws` and `add_fitted_draws` are deprecated as their names were confusing.
Use [add_]epred_draws() to get the expectation of the posterior predictive.
Use [add_]linpred_draws() to get the distribution of the linear predictor.
For example, you used [add_]fitted_draws(..., scale = "response"), which
means you most likely want [add_]epred_draws(...).
```

```r
df.plot = df.movies %>% 
  count(id, stars) %>% 
  group_by(id) %>% 
  mutate(p = n / sum(n)) %>% 
  mutate(stars = as.factor(stars))

ggplot(data = df.plot,
       mapping = aes(x = stars,
                     y = p)) +
  geom_col(color = "black",
           fill = "lightblue") +
  geom_point(data = df.model,
             mapping = aes(x = .category,
                           y = .value),
             alpha = 0.3,
             position = position_jitter(width = 0.3)) +
  facet_wrap(~id, ncol = 6) 
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-21-1.png" width="672" />

### Gaussian regression (assuming equal variance)

#### Fit the model


```r
fit.brm_metric = brm(formula = stars ~ 1 + id,
                     data = df.movies,
                     file = "cache/brm_metric",
                     seed = 1)

summary(fit.brm_metric)
```

```
 Family: gaussian 
  Links: mu = identity; sigma = identity 
Formula: stars ~ 1 + id 
   Data: df.movies (Number of observations: 21708) 
  Draws: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
         total post-warmup draws = 4000

Population-Level Effects: 
          Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept     3.77      0.04     3.70     3.85 1.00     1100     1471
id2           0.64      0.05     0.54     0.75 1.00     1532     2032
id3           0.20      0.05     0.10     0.30 1.00     1435     2045
id4           0.37      0.04     0.29     0.45 1.00     1146     1448
id5           0.30      0.05     0.20     0.39 1.00     1416     1784
id6           0.72      0.04     0.64     0.80 1.00     1130     1506

Family Specific Parameters: 
      Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
sigma     1.00      0.00     0.99     1.01 1.00     3221     2577

Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
and Tail_ESS are effective sample size measures, and Rhat is the potential
scale reduction factor on split chains (at convergence, Rhat = 1).
```

#### Visualizations

##### Model predictions


```r
# get the predictions for each value of the Likert scale 
df.model = fit.brm_metric %>% 
  parameters(centrality = "mean") %>% 
  as_tibble() %>% 
  select(term = Parameter, estimate = Mean) %>% 
  mutate(term = str_remove(term, "b_")) %>% 
  pivot_wider(names_from = term,
              values_from = estimate) %>% 
  clean_names() %>%
  mutate(across(.cols = id2:id6,
                .fns = ~ . + intercept)) %>% 
  rename_with(.fn = ~ c(str_c("mu_", 1:6), "sigma")) %>% 
  pivot_longer(cols = everything(),
               names_to = c("parameter", "movie"),
               names_sep = "_",
               values_to = "value") %>% 
  pivot_wider(names_from = parameter, 
              values_from = value) %>% 
  mutate(data = map(.x = mu, 
                    .f = ~ tibble(x = 1:5,
                                  y  = dnorm(x, mean = .x)))) %>% 
  select(movie, data) %>% 
  unnest(c(data)) %>% 
  group_by(movie) %>% 
  mutate(y = y/sum(y)) %>% 
  ungroup() %>% 
  rename(id = movie)
```

```
Warning: Expected 2 pieces. Missing pieces filled with `NA` in 1 rows [7].
```

```r
# visualize the predictions 
df.plot = df.movies %>% 
  count(id, stars) %>% 
  group_by(id) %>% 
  mutate(p = n / sum(n)) %>% 
  mutate(stars = as.factor(stars))

ggplot(data = df.plot,
       mapping = aes(x = stars,
                     y = p)) +
  geom_col(color = "black",
           fill = "lightblue") +
  geom_point(data = df.model,
            mapping = aes(x = x,
                          y = y)) +
  facet_wrap(~id, ncol = 6) 
```

```
Warning: Removed 5 rows containing missing values (geom_point).
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-23-1.png" width="672" />

### Oridnal regression (unequal variance)

#### Fit the model


```r
fit.brm_ordinal_variance = brm(formula = bf(stars ~ 1 + id) + 
                                 lf(disc ~ 0 + id, cmc = FALSE),
                               family = cumulative(link = "probit"),
                               data = df.movies,
                               file = "cache/brm_ordinal_variance",
                               seed = 1)

summary(fit.brm_ordinal_variance)
```

```
 Family: cumulative 
  Links: mu = probit; disc = log 
Formula: stars ~ 1 + id 
         disc ~ 0 + id
   Data: df.movies (Number of observations: 21708) 
  Draws: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
         total post-warmup draws = 4000

Population-Level Effects: 
             Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept[1]    -1.41      0.06    -1.53    -1.29 1.00     1395     2292
Intercept[2]    -1.00      0.05    -1.10    -0.91 1.00     1906     2567
Intercept[3]    -0.46      0.04    -0.54    -0.38 1.00     2645     2897
Intercept[4]     0.41      0.05     0.32     0.50 1.00     1358     1824
id2              2.70      0.32     2.13     3.38 1.00     1577     2220
id3              0.33      0.07     0.20     0.48 1.00     1795     2246
id4              0.36      0.05     0.26     0.46 1.00     1506     1917
id5              1.64      0.17     1.32     1.98 1.00     1568     2099
id6              0.86      0.06     0.74     0.97 1.00     1065     1919
disc_id2        -1.12      0.10    -1.32    -0.93 1.00     1557     2377
disc_id3        -0.23      0.06    -0.34    -0.12 1.00     1336     2071
disc_id4        -0.01      0.04    -0.10     0.07 1.00      927     1572
disc_id5        -1.09      0.07    -1.23    -0.95 1.00     1249     1966
disc_id6        -0.07      0.04    -0.15     0.01 1.00      856     1528

Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
and Tail_ESS are effective sample size measures, and Rhat is the potential
scale reduction factor on split chains (at convergence, Rhat = 1).
```

#### Visualizations

##### Model parameters


```r
df.params = fit.brm_ordinal_variance %>% 
  tidy(parameters = "^b_") %>% 
  select(term, estimate) %>% 
  mutate(term = str_remove(term, "b_"))
```

```
Warning in tidy.brmsfit(., parameters = "^b_"): some parameter names contain
underscores: term naming may be unreliable!
```

```r
ggplot(data = tibble(x = c(-3, 3)),
       mapping = aes(x = x)) + 
  stat_function(fun = ~ dnorm(.),
                size = 1,
                color = "black") +
  stat_function(fun = ~ dnorm(.,
                              mean = 1,
                              sd = 2),
                size = 1,
                color = "blue") +
  geom_vline(xintercept = df.params %>% 
               filter(str_detect(term, "Intercept")) %>% 
               pull(estimate))
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-25-1.png" width="672" />

##### Model predictions


```r
df.model = add_fitted_draws(newdata = expand_grid(id = 1:6),
                            model = fit.brm_ordinal_variance,
                            n = 10)
```

```
Warning: `fitted_draws` and `add_fitted_draws` are deprecated as their names were confusing.
Use [add_]epred_draws() to get the expectation of the posterior predictive.
Use [add_]linpred_draws() to get the distribution of the linear predictor.
For example, you used [add_]fitted_draws(..., scale = "response"), which
means you most likely want [add_]epred_draws(...).
```

```r
df.plot = df.movies %>% 
  count(id, stars) %>% 
  group_by(id) %>% 
  mutate(p = n / sum(n)) %>% 
  mutate(stars = as.factor(stars))
  
ggplot(data = df.plot,
       mapping = aes(x = stars,
                     y = p)) +
  geom_col(color = "black",
           fill = "lightblue") +
  geom_point(data = df.model,
             mapping = aes(x = .category,
                           y = .value),
             alpha = 0.3,
             position = position_jitter(width = 0.3)) +
  facet_wrap(~id, ncol = 6) 
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-26-1.png" width="672" />

### Gaussian regression (unequal variance)

#### Fit the model


```r
fit.brm_metric_variance = brm(formula = bf(stars ~ 1 + id,
                            sigma ~ 1 + id),
               data = df.movies,
               file = "cache/brm_metric_variance",
               seed = 1)

summary(fit.brm_metric_variance)
```

```
 Family: gaussian 
  Links: mu = identity; sigma = log 
Formula: stars ~ 1 + id 
         sigma ~ 1 + id
   Data: df.movies (Number of observations: 21708) 
  Draws: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
         total post-warmup draws = 4000

Population-Level Effects: 
                Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
Intercept           3.77      0.05     3.68     3.86 1.00     1562     1853
sigma_Intercept     0.20      0.03     0.15     0.26 1.00     1194     1613
id2                 0.64      0.07     0.51     0.77 1.00     2058     2521
id3                 0.20      0.06     0.08     0.33 1.00     2029     2337
id4                 0.37      0.05     0.27     0.47 1.00     1660     2146
id5                 0.30      0.06     0.17     0.42 1.00     2033     2370
id6                 0.72      0.05     0.63     0.81 1.00     1601     1961
sigma_id2           0.02      0.04    -0.05     0.09 1.00     1727     2141
sigma_id3           0.03      0.04    -0.04     0.10 1.00     1436     1982
sigma_id4          -0.14      0.03    -0.19    -0.08 1.00     1266     1581
sigma_id5           0.20      0.03     0.14     0.27 1.00     1505     2072
sigma_id6          -0.35      0.03    -0.40    -0.29 1.00     1210     1576

Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
and Tail_ESS are effective sample size measures, and Rhat is the potential
scale reduction factor on split chains (at convergence, Rhat = 1).
```

#### Visualizations

##### Model predictions


```r
df.model = fit.brm_metric_variance %>% 
  tidy(parameters = "^b_") %>% 
  select(term, estimate) %>% 
  mutate(term = str_remove(term, "b_")) %>% 
  pivot_wider(names_from = term,
              values_from = estimate) %>% 
  clean_names() %>%
  mutate(across(.cols = c(id2:id6),
                .fns = ~ . + intercept)) %>% 
  mutate(across(.cols = contains("sigma"),
                .fns = ~ 1/exp(.))) %>% 
  mutate(across(.cols = c(sigma_id2:sigma_id5),
                .fns = ~ . + sigma_intercept)) %>% 
  set_names(c("mu_1", "sigma_1", str_c("mu_", 2:6), str_c("sigma_", 2:6))) %>% 
  pivot_longer(cols = everything(),
               names_to = c("parameter", "movie"),
               names_sep = "_",
               values_to = "value") %>% 
  pivot_wider(names_from = parameter, 
              values_from = value) %>% 
  mutate(data = map2(.x = mu,
                     .y = sigma,
                     .f = ~ tibble(x = 1:5,
                                   y  = dnorm(x,
                                              mean = .x,
                                              sd = .y)))) %>% 
  select(movie, data) %>% 
  unnest(c(data)) %>% 
  group_by(movie) %>% 
  mutate(y = y/sum(y)) %>% 
  ungroup() %>% 
  rename(id = movie)
```

```
Warning in tidy.brmsfit(., parameters = "^b_"): some parameter names contain
underscores: term naming may be unreliable!
```

```r
df.plot = df.movies %>% 
  count(id, stars) %>% 
  group_by(id) %>% 
  mutate(p = n / sum(n)) %>% 
  mutate(stars = as.factor(stars))

ggplot(data = df.plot,
       mapping = aes(x = stars,
                     y = p)) +
  geom_col(color = "black",
           fill = "lightblue") +
  geom_point(data = df.model,
             mapping = aes(x = x,
                           y = y)) +
  facet_wrap(~id, ncol = 6) 
```

<img src="24-bayesian_data_analysis3_files/figure-html/unnamed-chunk-28-1.png" width="672" />

### Model comparison


```r
# ordinal regression with equal variance 
fit.brm_ordinal = add_criterion(fit.brm_ordinal,
                                criterion = "loo",
                                file = "cache/brm_ordinal")

# Gaussian regression with equal variance
fit.brm_ordinal_variance = add_criterion(fit.brm_ordinal_variance,
                                         criterion = "loo",
                                         file = "cache/brm_ordinal_variance")

loo_compare(fit.brm_ordinal, fit.brm_ordinal_variance)
```

```
                         elpd_diff se_diff
fit.brm_ordinal_variance    0.0       0.0 
fit.brm_ordinal          -340.2      27.0 
```

## Additional resources

- [Tutorial on visualizing brms posteriors with tidybayes](https://mjskay.github.io/tidybayes/articles/tidy-brms.html)
- [Hypothetical outcome plots](https://mucollective.northwestern.edu/files/2018-HOPsTrends-InfoVis.pdf)
- [Visual MCMC diagnostics](https://cran.r-project.org/web/packages/bayesplot/vignettes/visual-mcmc-diagnostics.html#general-mcmc-diagnostics)
- [Visualiztion of different MCMC algorithms](https://chi-feng.github.io/mcmc-demo/)

## Session info

Information about this R session including which version of R was used, and what packages were loaded.


```r
sessionInfo()
```

```
R version 4.1.2 (2021-11-01)
Platform: x86_64-apple-darwin17.0 (64-bit)
Running under: macOS Big Sur 10.16

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRblas.0.dylib
LAPACK: /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRlapack.dylib

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] forcats_0.5.1       stringr_1.4.0       dplyr_1.0.9        
 [4] purrr_0.3.4         readr_2.1.2         tidyr_1.2.0        
 [7] tibble_3.1.7        tidyverse_1.3.1     scales_1.2.0       
[10] ggrepel_0.9.1       rstanarm_2.21.3     transformr_0.1.3   
[13] parameters_0.17.0   gganimate_1.0.7     titanic_0.1.0      
[16] ggeffects_1.1.2     emmeans_1.7.3       car_3.0-13         
[19] carData_3.0-5       afex_1.1-1          lme4_1.1-29        
[22] Matrix_1.4-1        modelr_0.1.8        bayesplot_1.9.0    
[25] broom.mixed_0.2.9.4 GGally_2.1.2        ggplot2_3.3.6      
[28] patchwork_1.1.1     brms_2.17.0         Rcpp_1.0.8.3       
[31] tidybayes_3.0.2     janitor_2.1.0       kableExtra_1.3.4   
[34] knitr_1.39         

loaded via a namespace (and not attached):
  [1] utf8_1.2.2           tidyselect_1.1.2     htmlwidgets_1.5.4   
  [4] grid_4.1.2           lpSolve_5.6.15       munsell_0.5.0       
  [7] codetools_0.2-18     units_0.8-0          DT_0.22             
 [10] future_1.25.0        gifski_1.6.6-1       miniUI_0.1.1.1      
 [13] withr_2.5.0          Brobdingnag_1.2-7    colorspace_2.0-3    
 [16] highr_0.9            rstudioapi_0.13      stats4_4.1.2        
 [19] listenv_0.8.0        labeling_0.4.2       rstan_2.21.5        
 [22] bit64_4.0.5          farver_2.1.0         datawizard_0.4.0    
 [25] bridgesampling_1.1-2 coda_0.19-4          parallelly_1.31.1   
 [28] vctrs_0.4.1          generics_0.1.2       TH.data_1.1-1       
 [31] xfun_0.30            R6_2.5.1             markdown_1.1        
 [34] reshape_0.8.9        assertthat_0.2.1     vroom_1.5.7         
 [37] promises_1.2.0.1     multcomp_1.4-19      gtable_0.3.0        
 [40] globals_0.14.0       processx_3.5.3       sandwich_3.0-1      
 [43] rlang_1.0.2          systemfonts_1.0.4    splines_4.1.2       
 [46] broom_0.8.0          checkmate_2.1.0      inline_0.3.19       
 [49] yaml_2.3.5           reshape2_1.4.4       abind_1.4-5         
 [52] threejs_0.3.3        crosstalk_1.2.0      backports_1.4.1     
 [55] httpuv_1.6.5         tensorA_0.36.2       tools_4.1.2         
 [58] bookdown_0.26        ellipsis_0.3.2       jquerylib_0.1.4     
 [61] posterior_1.2.1      RColorBrewer_1.1-3   proxy_0.4-26        
 [64] ggridges_0.5.3       plyr_1.8.7           base64enc_0.1-3     
 [67] progress_1.2.2       classInt_0.4-3       ps_1.7.0            
 [70] prettyunits_1.1.1    zoo_1.8-10           haven_2.5.0         
 [73] fs_1.5.2             furrr_0.3.0          magrittr_2.0.3      
 [76] ggdist_3.1.1         lmerTest_3.1-3       reprex_2.0.1        
 [79] colourpicker_1.1.1   mvtnorm_1.1-3        matrixStats_0.62.0  
 [82] hms_1.1.1            shinyjs_2.1.0        mime_0.12           
 [85] evaluate_0.15        arrayhelpers_1.1-0   xtable_1.8-4        
 [88] shinystan_2.6.0      readxl_1.4.0         gridExtra_2.3       
 [91] rstantools_2.2.0     compiler_4.1.2       KernSmooth_2.23-20  
 [94] crayon_1.5.1         minqa_1.2.4          StanHeaders_2.21.0-7
 [97] htmltools_0.5.2      tzdb_0.3.0           later_1.3.0         
[100] RcppParallel_5.1.5   lubridate_1.8.0      DBI_1.1.2           
[103] tweenr_1.0.2         dbplyr_2.1.1         MASS_7.3-57         
[106] sf_1.0-7             boot_1.3-28          cli_3.3.0           
[109] parallel_4.1.2       insight_0.17.0       igraph_1.3.1        
[112] pkgconfig_2.0.3      numDeriv_2016.8-1.1  xml2_1.3.3          
[115] svUnit_1.0.6         dygraphs_1.1.1.6     svglite_2.1.0       
[118] bslib_0.3.1          webshot_0.5.3        estimability_1.3    
[121] rvest_1.0.2          snakecase_0.11.0     distributional_0.3.0
[124] callr_3.7.0          digest_0.6.29        cellranger_1.1.0    
[127] rmarkdown_2.14       shiny_1.7.1          gtools_3.9.2        
[130] nloptr_2.0.0         lifecycle_1.0.1      nlme_3.1-157        
[133] jsonlite_1.8.0       viridisLite_0.4.0    fansi_1.0.3         
[136] pillar_1.7.0         lattice_0.20-45      loo_2.5.1           
[139] fastmap_1.1.0        httr_1.4.3           pkgbuild_1.3.1      
[142] survival_3.3-1       glue_1.6.2           xts_0.12.1          
[145] bayestestR_0.12.1    shinythemes_1.2.0    bit_4.0.4           
[148] class_7.3-20         stringi_1.7.6        sass_0.4.1          
[151] e1071_1.7-9         
```
