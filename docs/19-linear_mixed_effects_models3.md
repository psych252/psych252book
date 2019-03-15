# Linear mixed effects models 3



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")    # for tidying up linear models 
library("patchwork")    # for making figure panels
library("lme4")    # for linear mixed effects models
library("modelr")    # for bootstrapping
library("boot")    # also for bootstrapping
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Load data set 


```r
# load sleepstudy data set 
df.sleep = sleepstudy %>% 
  as_tibble() %>% 
  clean_names() %>% 
  mutate(subject = as.character(subject)) %>% 
  select(subject, days, reaction)
```


```r
# add two fake participants (with missing data)
df.sleep = df.sleep %>% 
  bind_rows(
    tibble(subject = "374",
           days = 0:1,
           reaction = c(286, 288)),
    tibble(subject = "373",
           days = 0,
           reaction = 245)
  )
```

## Things that came up in class 

### One-tailed vs. two-tailed tests

#### t distribution

Some code to draw a t-distribution: 


```r
tibble(x = c(-4, 4)) %>% 
  ggplot(data = ., 
         mapping = aes(x = x)) + 
  stat_function(fun = "dt",
                args = list(df = 20),
                size = 1,
                geom = "area",
                fill = "red",
                # xlim = c(qt(0.95, df = 20), qt(0.999, df = 20))) +
                # xlim = c(qt(0.001, df = 20), qt(0.05, df = 20))) +
                xlim = c(qt(0.001, df = 20), qt(0.025, df = 20))) +
  stat_function(fun = "dt",
                args = list(df = 20),
                size = 1,
                geom = "area",
                fill = "red",
                xlim = c(qt(0.975, df = 20), qt(0.999, df = 20))) +
  stat_function(fun = "dt",
                args = list(df = 20),
                size = 1) +
  coord_cartesian(expand = F)
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-6-1.png" width="672" />

#### F distribution

Some code to draw an F-distribution


```r
tibble(x = c(0, 5)) %>% 
  ggplot(data = ., 
         mapping = aes(x = x)) +
  stat_function(fun = "df",
                args = list(df1 = 100, df2 = 10),
                size = 1,
                geom = "area",
                fill = "red",
                xlim = c(qf(0.95, df1 = 100, df2 = 10), qf(0.999, df1 = 100, df2 = 10))) +
  stat_function(fun = "df",
                args = list(df1 = 100, df2 = 10),
                size = 1) +
  coord_cartesian(expand = F)
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-7-1.png" width="672" />

### Mixtures of participants 

What if we have groups of participants who differ from each other? Let's generate data for which this is the case.


```r
# make example reproducible 
set.seed(1)

sample_size = 20
b0 = 1
b1 = 2
sd_residual = 0.5
sd_participant = 0.5
mean_group1 = 1
mean_group2 = 10

df.mixed = tibble(
  condition = rep(0:1, each = sample_size), 
  participant = rep(1:sample_size, 2)) %>% 
  group_by(participant) %>% 
  mutate(group = sample(1:2, size = 1),
         intercept = ifelse(group == 1,
                            rnorm(n(), mean = mean_group1, sd = sd_participant),
                            rnorm(n(), mean = mean_group2, sd = sd_participant))) %>% 
  group_by(condition) %>% 
  mutate(value = b0 + b1 * condition + intercept + rnorm(n(), sd = sd_residual)) %>% 
  ungroup %>% 
  mutate(condition = as.factor(condition),
         participant = as.factor(participant))
```

#### Ignoring mixture

Let' first fit a model that ignores the fact that there are two different groups of participatns. 


```r
# fit model
fit.mixed = lmer(formula = value ~ 1 + condition + (1 | participant),
                data = df.mixed)

fit.mixed %>% summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + condition + (1 | participant)
##    Data: df.mixed
## 
## REML criterion at convergence: 165.6
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -1.6437 -0.4510 -0.0246  0.4987  1.5265 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 21.5142  4.6383  
##  Residual                 0.3521  0.5934  
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   7.2229     1.0456   6.908
## condition1    1.6652     0.1876   8.875
## 
## Correlation of Fixed Effects:
##            (Intr)
## condition1 -0.090
```

Let's look at the model's predictions: 


```r
fit.mixed %>%
  augment() %>%
  clean_names() %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = value,
                       group = participant)) +
  geom_point(alpha = 0.5) +
  geom_line(alpha = 0.5) +
  geom_point(aes(y = fitted),
             color = "red") +
  geom_line(aes(y = fitted),
             color = "red")
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-10-1.png" width="672" />


And let's simulate some data from the fitted model: 


```r
# simulated data 
fit.mixed %>%
  simulate() %>%
  bind_cols(df.mixed) %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-11-1.png" width="672" />

As we can see, the simulated data doesn't look like the data that was used to fit the model.  

#### Modeling mixture

Now, let's fit a model that takes the differences between groups into account by adding a fixed effect for `group`.


```r
# fit model
fit.grouped = lmer(formula = value ~ 1 + group + condition + (1 | participant),
                data = df.mixed)

fit.grouped %>% summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + group + condition + (1 | participant)
##    Data: df.mixed
## 
## REML criterion at convergence: 83.7
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -1.56168 -0.69876  0.05887  0.50419  2.30259 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 0.1147   0.3387  
##  Residual                0.3521   0.5934  
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  -6.8299     0.4055 -16.842
## group         9.0663     0.2424  37.409
## condition1    1.6652     0.1876   8.875
## 
## Correlation of Fixed Effects:
##            (Intr) group 
## group      -0.926       
## condition1 -0.231  0.000
```

Note how the variance of the random intercepts is much smaller now that we've taken the group structure in the data into account. 

Let's visualize the model's predictions:


```r
fit.grouped %>%
  augment() %>%
  clean_names() %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = value,
                       group = participant)) +
  geom_point(alpha = 0.5) +
  geom_line(alpha = 0.5) +
  geom_point(aes(y = fitted),
             color = "red") +
  geom_line(aes(y = fitted),
             color = "red")
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-13-1.png" width="672" />

And simulate some data from the model: 


```r
# simulated data 
fit.grouped %>%
  simulate() %>%
  bind_cols(df.mixed) %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-14-1.png" width="672" />

This time, the simulated data looks much more like the data that was used to fit the model. Yay! 

#### Heterogeneity in variance

The example above has shown that we can take overall differences between groups into account by adding a fixed effect. Can we also deal with heterogeneity in variance between groups? For example, what if the responses of one group exhibit much more variance than the responses of another group? 

Let's first generate some data with heterogeneous variance: 


```r
# make example reproducible 
set.seed(1)

sample_size = 20
b0 = 1
b1 = 2
sd_residual = 0.5
mean_group1 = 1
sd_group1 = 1
mean_group2 = 30
sd_group2 = 10

df.variance = tibble(
  condition = rep(0:1, each = sample_size), 
  participant = rep(1:sample_size, 2)) %>% 
  group_by(participant) %>% 
  mutate(group = sample(1:2, size = 1),
         intercept = ifelse(group == 1,
                            rnorm(n(), mean = mean_group1, sd = sd_group1),
                            rnorm(n(), mean = mean_group2, sd = sd_group2))) %>% 
  group_by(condition) %>% 
  mutate(value = b0 + b1 * condition + intercept + rnorm(n(), sd = sd_residual)) %>% 
  ungroup %>% 
  mutate(condition = as.factor(condition),
         participant = as.factor(participant))
```

Let's fit the model: 


```r
# fit model
fit.variance = lmer(formula = value ~ 1 + group + condition + (1 | participant),
                data = df.variance)

fit.variance %>% summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + group + condition + (1 | participant)
##    Data: df.variance
## 
## REML criterion at convergence: 250
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -2.70344 -0.21278  0.07355  0.43873  1.39493 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 17.60    4.196   
##  Residual                26.72    5.169   
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept) -26.5805     4.1525  -6.401
## group        29.6200     2.5010  11.843
## condition1    0.1853     1.6346   0.113
## 
## Correlation of Fixed Effects:
##            (Intr) group 
## group      -0.934       
## condition1 -0.197  0.000
```

Look at the data and model predictions: 


```r
fit.variance %>%
  augment() %>%
  clean_names() %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = value,
                       group = participant)) +
  geom_point(alpha = 0.5) +
  geom_line(alpha = 0.5) +
  geom_point(aes(y = fitted),
             color = "red") +
  geom_line(aes(y = fitted),
             color = "red")
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-17-1.png" width="672" />

And the simulated data: 


```r
# simulated data 
fit.mixed %>%
  simulate() %>%
  bind_cols(df.mixed) %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-18-1.png" width="672" />

The lmer() fails here. It uses one normal distribution to model the variance between participants. It cannot account for the fact that the answers of one groups of participants vary more than the answers from another groups of participants. Again, the simulated data doesn't look the original data, even though we did take the grouping into account. 

## Pooling and shrinkage 

Let's illustrate the concept of pooling and shrinkage via the sleep data set that comes with the lmer package. We've already loaded the data set into our environment as `df.sleep`. 

Let's start by visualizing the data 


```r
# visualize the data
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-19-1.png" width="672" />

The plot shows the effect of the number of days of sleep deprivation on the average reaction time (presumably in an experiment). Note that for participant 373 and 374 we only have one and two data points respectively. 

### Complete pooling 

Let's first fit a model the simply combines all the data points. This model ignores the dependence structure in the data (i.e. the fact that we have repeated observations from the same participants). 


```r
fit.complete = lm(formula = reaction ~ days,
                  data = df.sleep)

fit.params = tidy(fit.complete)

fit.complete %>% 
  summary()
```

```
## 
## Call:
## lm(formula = reaction ~ days, data = df.sleep)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -110.646  -27.951    1.829   26.388  139.875 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  252.321      6.406  39.389  < 2e-16 ***
## days          10.328      1.210   8.537 5.48e-15 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 47.43 on 181 degrees of freedom
## Multiple R-squared:  0.2871,	Adjusted R-squared:  0.2831 
## F-statistic: 72.88 on 1 and 181 DF,  p-value: 5.484e-15
```

And let's visualize the predictions of this model.


```r
# visualization (aggregate) 
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_abline(intercept = fit.params$estimate[1],
              slope = fit.params$estimate[2],
              color = "blue") +
  geom_point() +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-21-1.png" width="672" />

And here is what the model's predictions look like separated by participant.


```r
# visualization (separate participants) 
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_abline(intercept = fit.params$estimate[1],
              slope = fit.params$estimate[2],
              color = "blue") +
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-22-1.png" width="672" />

The model predicts the same relationship between sleep deprivation and reaction time for each participant (not surprising since we didn't even tell the model that this data is based on different participants). 

### No pooling 

We could also fit separate regressions for each participant. Let's do that.


```r
# fit regressions and extract parameter estimates 
df.no_pooling = df.sleep %>% 
  group_by(subject) %>% 
  nest(days, reaction) %>% 
  mutate(fit = map(data, ~ lm(reaction ~ days, data = .)),
         params = map(fit, tidy)) %>% 
  unnest(params) %>% 
  select(subject, term, estimate) %>% 
  complete(subject, term, fill = list(estimate = 0)) %>% 
  spread(term, estimate) %>% 
  clean_names()
```

And let's visualize what the predictions of these separate regressions would look like: 


```r
ggplot(data = df.sleep,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_abline(data = df.no_pooling %>% 
                filter(subject != 373),
              aes(intercept = intercept,
                  slope = days),
              color = "blue") +
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-24-1.png" width="672" />

When we fit separate regression, no information is shared between participants. 

### Partial pooling 

By usign linear mixed effects models, we are partially pooling information. That is, the estimates for one participant are influenced by the rest of the participants.

We'll fit a number of mixed effects models that differ in their random effects structure. 

#### Random intercept and random slope

This model allows for random differences in the intercepts and slopes between subjects (and also models the correlation between intercepts and slopes). 

Let's fit the model


```r
fit.random_intercept_slope = lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                                  data = df.sleep)
```

and take a look at the model's predictions: 


```r
fit.random_intercept_slope %>% 
  augment() %>% 
  clean_names() %>% 
ggplot(data = .,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_line(aes(y = fitted),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-26-1.png" width="672" />

As we can see, the lines for each participant are different. We've allowed for the intercept as well as the relationship between sleep deprivation and reaction time to be different between participants. 

#### Only random intercepts 

Let's fit a model that only allows for the intercepts to vary between participants. 


```r
fit.random_intercept = lmer(formula = reaction ~ 1 + days + (1 | subject),
                            data = df.sleep)
```

And let's visualize what these predictions look like: 


```r
fit.random_intercept %>% 
  augment() %>% 
  clean_names() %>% 
ggplot(data = .,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_line(aes(y = fitted),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-28-1.png" width="672" />

Now, all the lines are parallel but the intercept differs between participants. 

#### Only random slopes 

Finally, let's compare a model that only allows for the slopes to differ but not the intercepts. 


```r
fit.random_slope = lmer(formula = reaction ~ 1 + days + (0 + days | subject),
                        data = df.sleep)
```

And let's visualize the model fit: 


```r
fit.random_slope %>% 
  augment() %>% 
  clean_names() %>% 
ggplot(data = .,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_line(aes(y = fitted),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-30-1.png" width="672" />

Here, all the lines have the same starting point (i.e. the same intercept) but the slopes are different. 

### Compare results 

Let's compare the results of the different methods -- complete pooling, no pooling, and partial pooling (with random intercepts and slopes). 


```r
# complete pooling
fit.complete_pooling = lm(formula = reaction ~ days,
                          data = df.sleep)  

df.complete_pooling =  fit.complete_pooling %>% 
  augment() %>% 
  bind_rows(
    fit.complete_pooling %>% 
      augment(newdata = tibble(subject = c("373", "374"),
                               days = rep(10, 2)))
  ) %>% 
  clean_names() %>% 
  select(reaction, days, complete_pooling = fitted)

# no pooling
df.no_pooling = df.sleep %>% 
  group_by(subject) %>% 
  nest(days, reaction) %>% 
  mutate(fit = map(data, ~ lm(reaction ~ days, data = .)),
         augment = map(fit, augment)) %>% 
  unnest(augment) %>% 
  clean_names() %>% 
  select(subject, reaction, days, no_pooling = fitted)

# partial pooling
fit.lmer = lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                data = df.sleep) 

df.partial_pooling = fit.lmer %>% 
  augment() %>% 
  bind_rows(
    fit.lmer %>% 
      augment(newdata = tibble(subject = c("373", "374"),
                               days = rep(10, 2)))
  ) %>% 
  clean_names() %>% 
  select(subject, reaction, days, partial_pooling = fitted)

# combine results
df.pooling = df.partial_pooling %>% 
  left_join(df.complete_pooling) %>% 
  left_join(df.no_pooling)
```

Let's compare the predictions of the different models visually: 


```r
ggplot(data = df.pooling,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_smooth(method = "lm",
              se = F,
              color = "orange",
              fullrange = T) + 
  geom_line(aes(y = complete_pooling),
            color = "green") + 
  geom_line(aes(y = partial_pooling),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## Warning: Removed 4 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 4 rows containing missing values (geom_point).
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-32-1.png" width="672" />

To better see the differences between the approaches, let's focus on the predictions for the participants with incomplete data: 


```r
# subselection
ggplot(data = df.pooling %>% 
         filter(subject %in% c("373", "374")),
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_smooth(method = "lm",
              se = F,
              color = "orange",
              fullrange = T) + 
  geom_line(aes(y = complete_pooling),
            color = "green") + 
  geom_line(aes(y = partial_pooling),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## Warning: Removed 4 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 4 rows containing missing values (geom_point).
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-33-1.png" width="672" />

### Coefficients 

One good way to get a sense for what the different models are doing is by taking a look at the coefficients: 


```r
fit.complete_pooling %>% 
  coef()
```

```
## (Intercept)        days 
##   252.32070    10.32766
```


```r
fit.random_intercept %>% 
  coef()
```

```
## $subject
##     (Intercept)     days
## 308    292.2749 10.43191
## 309    174.0559 10.43191
## 310    188.7454 10.43191
## 330    256.0247 10.43191
## 331    261.8141 10.43191
## 332    259.8262 10.43191
## 333    268.0765 10.43191
## 334    248.6471 10.43191
## 335    206.5096 10.43191
## 337    323.5643 10.43191
## 349    230.5114 10.43191
## 350    265.6957 10.43191
## 351    243.7988 10.43191
## 352    287.8850 10.43191
## 369    258.6454 10.43191
## 370    245.2931 10.43191
## 371    248.3508 10.43191
## 372    269.6861 10.43191
## 373    248.2086 10.43191
## 374    273.9400 10.43191
## 
## attr(,"class")
## [1] "coef.mer"
```


```r
fit.random_slope %>% 
  coef()
```

```
## $subject
##     (Intercept)       days
## 308    252.2965 19.9526801
## 309    252.2965 -4.3719650
## 310    252.2965 -0.9574726
## 330    252.2965  8.9909957
## 331    252.2965 10.5394285
## 332    252.2965 11.3994289
## 333    252.2965 12.6074020
## 334    252.2965 10.3413879
## 335    252.2965 -0.5722073
## 337    252.2965 24.2246485
## 349    252.2965  7.7702676
## 350    252.2965 15.0661415
## 351    252.2965  7.9675415
## 352    252.2965 17.0002999
## 369    252.2965 11.6982767
## 370    252.2965 11.3939807
## 371    252.2965  9.4535879
## 372    252.2965 13.4569059
## 373    252.2965 10.4142695
## 374    252.2965 11.9097917
## 
## attr(,"class")
## [1] "coef.mer"
```


```r
fit.random_intercept_slope %>% 
  coef()
```

```
## $subject
##     (Intercept)       days
## 308    253.9479 19.6264139
## 309    211.7328  1.7319567
## 310    213.1579  4.9061843
## 330    275.1425  5.6435987
## 331    273.7286  7.3862680
## 332    260.6504 10.1632535
## 333    268.3684 10.2245979
## 334    244.5523 11.4837825
## 335    251.3700 -0.3355554
## 337    286.2321 19.1090061
## 349    226.7662 11.5531963
## 350    238.7807 17.0156766
## 351    256.2344  7.4119501
## 352    272.3512 13.9920698
## 369    254.9484 11.2985741
## 370    226.3701 15.2027922
## 371    252.5051  9.4335432
## 372    263.8916 11.7253342
## 373    248.9752 10.3915245
## 374    271.1451 11.0782697
## 
## attr(,"class")
## [1] "coef.mer"
```

### Shrinkage 

In mixed effects models, the variance of parameter estimates across participants shrinks compared to a no pooling model (where we fit a different regression to each participant). Expressed differently, individual parameter estimates are borrowing strength from the overall data set in mixed effects models. 


```r
# get estimates from partial pooling model
df.partial_pooling = fit.random_intercept_slope %>% 
  coef() %>% 
  .[[1]] %>% 
  rownames_to_column("subject") %>% 
  clean_names()

# combine estimates from no pooling with partial pooling model 
df.plot = df.sleep %>% 
  group_by(subject) %>% 
  nest(days, reaction) %>% 
  mutate(fit = map(data, ~ lm(reaction ~ days, data = .)),
         tidy = map(fit, tidy)) %>% 
  unnest(tidy) %>% 
  select(subject, term, estimate) %>% 
  spread(term, estimate) %>% 
  clean_names() %>% 
  mutate(method = "no pooling") %>% 
  bind_rows(df.partial_pooling %>% 
              mutate(method = "partial pooling")) %>% 
  gather("index", "value", -c(subject, method)) %>% 
  mutate(index = factor(index, levels = c("intercept", "days")))

  
# visualize the results  
ggplot(data = df.plot,
       mapping = aes(x = value,
                     group = method,
                     fill = method)) + 
  stat_density(position = "identity",
               geom = "area",
               color = "black",
               alpha = 0.3) +
  facet_grid(cols = vars(index),
             scales = "free")
```

```
## Warning: Removed 1 rows containing non-finite values (stat_density).
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-38-1.png" width="672" />

## Bootstrapping 

Bootstrapping is a good way to estimate our uncertainty on the parameter estimates in the model. 

### Linear model 

Let's briefly review how to do bootstrapping in a simple linear model. 


```r
# fit model 
fit.lm = lm(formula = reaction ~ 1 + days,
            data = df.sleep)

# coefficients
fit.lm %>% coef()
```

```
## (Intercept)        days 
##   252.32070    10.32766
```

```r
# bootstrapping 
df.boot = df.sleep %>% 
  bootstrap(n = 100,
            id = "id") %>% 
  mutate(fit = map(strap, ~ lm(formula = reaction ~ 1 + days, data = .)),
         tidy = map(fit, tidy)) %>% 
  unnest(tidy) %>% 
  select(id, term, estimate) %>% 
  spread(term, estimate) %>% 
  clean_names() 
```

Let's illustrate the linear model with a confidence interval (making parametric assumptions using the t-distribution). 


```r
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_smooth(method = "lm") + 
  geom_point(alpha = 0.3)
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-40-1.png" width="672" />

And let's compare this with the different regression lines that we get out of our bootstrapped samples:


```r
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_abline(data = df.boot,
              aes(intercept = intercept,
                  slope = days,
                  group = id),
              alpha = 0.1) +
  geom_point(alpha = 0.3)
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-41-1.png" width="672" />

#### bootmer() function

For the linear mixed effects model, we can use the `bootmer()` function to do bootstrapping. 


```r
# fit the model 
fit.lmer = lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                data = df.sleep)

# bootstrap parameter estimates 
boot.lmer = bootMer(fit.lmer,
                    FUN = fixef,
                    nsim = 100)

# compute confidence interval 
boot.ci(boot.lmer, index = 2, type = "perc")
```

```
## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
## Based on 100 bootstrap replicates
## 
## CALL : 
## boot.ci(boot.out = boot.lmer, type = "perc", index = 2)
## 
## Intervals : 
## Level     Percentile     
## 95%   ( 7.36, 13.52 )  
## Calculations and Intervals on Original Scale
## Some percentile intervals may be unstable
```

```r
# plot estimates 
boot.lmer$t %>% 
  as_tibble() %>% 
  clean_names() %>% 
  mutate(id = 1:n()) %>% 
  gather("index", "value", - id) %>% 
  ggplot(data = .,
       mapping = aes(x = value)) + 
  geom_density() + 
  facet_grid(cols = vars(index),
             scales = "free") +
  coord_cartesian(expand = F)
```

<img src="19-linear_mixed_effects_models3_files/figure-html/unnamed-chunk-42-1.png" width="672" />

## Getting p-values 

We can use the "lmerTest" package to get p-values for the different fixed effects. 


```r
lmerTest::lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                data = df.sleep) %>% 
  summary()
```

```
## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
## lmerModLmerTest]
## Formula: reaction ~ 1 + days + (1 + days | subject)
##    Data: df.sleep
## 
## REML criterion at convergence: 1771.4
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -3.9707 -0.4703  0.0276  0.4594  5.2009 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr
##  subject  (Intercept) 582.73   24.140       
##           days         35.03    5.919   0.07
##  Residual             649.36   25.483       
## Number of obs: 183, groups:  subject, 20
## 
## Fixed effects:
##             Estimate Std. Error      df t value Pr(>|t|)    
## (Intercept)  252.543      6.433  19.294  39.256  < 2e-16 ***
## days          10.452      1.542  17.163   6.778 3.06e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##      (Intr)
## days -0.137
```

## Understanding the lmer() syntax 

Here is an overview of how to specify different kinds of linear mixed effects models.

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> formula </th>
   <th style="text-align:left;"> description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (1 | g)` </td>
   <td style="text-align:left;"> Random intercept for each level of `g` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (0 + x1 | g)` </td>
   <td style="text-align:left;"> Random slope for each level of `g` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (x1 | g)` </td>
   <td style="text-align:left;"> Correlated random slope and intercept for each level of `g` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (x1 || g)` </td>
   <td style="text-align:left;"> Uncorrelated random slope and intercept for each level of `g` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (1 | school) + (1 | teacher)` </td>
   <td style="text-align:left;"> Random intercept for each level of `school` and for each level of `teacher` (crossed) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (1 | school/teacher)` </td>
   <td style="text-align:left;"> Random intercept for each level of `school` and for each level of `teacher` in `school` (nested) </td>
  </tr>
</tbody>
</table>
