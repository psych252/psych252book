# Linear mixed effects models 4

## Learning goals

- Some worked examples. 
- Doing follow-up tests with the `emmeans` package
- Simulating, plotting, and analyzing models with different random effects structures
- Bootstrapping confidence intervals for fixed effects 
- Logistic mixed effects model

## Load packages and set plotting theme


``` r
library("knitr")       # for knitting RMarkdown 
library("kableExtra")  # for making nice tables
library("janitor")     # for cleaning column names
library("broom.mixed") # for tidying up linear mixed effects models 
library("lme4")        # for linear mixed effects models
library("afex")        # for ANOVAs
library("car")         # for ANOVAs
library("datarium")    # for ANOVA dataset
library("modelr")      # for bootstrapping
library("boot")        # also for bootstrapping
library("ggeffects")   # for plotting marginal effects
library("emmeans")     # for marginal effects
library("tidyverse")   # for wrangling, plotting, etc. 
```


``` r
theme_set(theme_classic() + #set the theme 
            theme(text = element_text(size = 20))) #set the default text size

# knitr display options 
opts_chunk$set(comment = "",
               fig.show = "hold")

# suppress grouping warning messages
options(dplyr.summarise.inform = F)
```

## Load data sets

### Sleep data


``` r
# load sleepstudy data set 
df.sleep = sleepstudy %>% 
  as_tibble() %>% 
  clean_names() %>% 
  mutate(subject = as.character(subject)) %>% 
  select(subject, days, reaction)

# add two fake participants (with missing data)
df.sleep = df.sleep %>% 
  bind_rows(tibble(subject = "374",
                   days = 0:1,
                   reaction = c(286, 288)),
            tibble(subject = "373",
                   days = 0,
                   reaction = 245))
```

### Reasoning data


``` r
df.reasoning = sk2011.1
```

### Weight loss data


``` r
data("weightloss", package = "datarium")

# Modify it to have three-way mixed design
df.weightloss = weightloss %>%
  mutate(id = rep(1:24, 2)) %>% 
  pivot_longer(cols = t1:t3,
               names_to = "timepoint",
               values_to = "score") %>% 
  arrange(id)
```

### Politness data


``` r
df.politeness = read_csv("data/politeness_data.csv") %>% 
  mutate(scenario = as.factor(scenario))
```

```
Rows: 84 Columns: 5
── Column specification ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
Delimiter: ","
chr (3): subject, gender, attitude
dbl (2): scenario, frequency

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## Follow-up tests with emmeans

Just like with the linear model `lm()`, we can use linear contrasts to test more specific hypotheses with `lmer()`. The `emmeans()` function from the `emmeans` package will be our friend. 

### Sleep study

Let's ask some more specific question aboust the sleep study. 

1. Do reaction times differ between day 0 and the first day of sleep deprivation? 
2. Do reaction times differ between the first and the second half of the study? 

Let's visualize the data first: 


``` r
ggplot(data = df.sleep %>% 
         mutate(days = as.factor(days)),
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_point(position = position_jitter(width = 0.1),
             alpha = 0.1) + 
  stat_summary(fun.data = "mean_cl_boot")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-7-1.png" width="672" />

And now let's fit the model, and compute the contrasts: 


``` r
fit = lmer(formula = reaction ~ 1 + days + (1 | subject),
           data = df.sleep %>% 
             mutate(days = as.factor(days)))

contrast = list(first_vs_second = c(-1, 1, rep(0, 8)),
                early_vs_late = c(rep(-1, 5)/5, rep(1, 5)/5))

fit %>% 
  emmeans(specs = "days",
          contr = contrast) %>% 
  pluck("contrasts")
```

```
 contrast        estimate    SE  df t.ratio p.value
 first_vs_second     7.82 10.10 156   0.775  0.4398
 early_vs_late      53.66  4.65 155  11.534  <.0001

Degrees-of-freedom method: kenward-roger 
```

``` r
df.sleep %>% 
  # filter(days %in% c(0, 1)) %>% 
  group_by(days) %>% 
  summarize(reaction = mean(reaction))
```

```
# A tibble: 10 × 2
    days reaction
   <dbl>    <dbl>
 1     0     258.
 2     1     266.
 3     2     265.
 4     3     283.
 5     4     289.
 6     5     309.
 7     6     312.
 8     7     319.
 9     8     337.
10     9     351.
```

``` r
df.sleep %>% 
  mutate(index = ifelse(days %in% 0:4, "early", "late")) %>% 
  group_by(index) %>% 
  summarize(reaction = mean(reaction))
```

```
# A tibble: 2 × 2
  index reaction
  <chr>    <dbl>
1 early     272.
2 late      325.
```

### Weight loss study

For the weight loss data set, we want to check: 

1. Whether there was a difference between the first two vs. the last time point. 
2. Whether there was a linear trend across the time points. 

Let's first visualize again: 


``` r
ggplot(data = df.weightloss,
       mapping = aes(x = timepoint,
                     y = score,
                     group = diet,
                     color = diet)) + 
  geom_point(position = position_jitterdodge(dodge.width = 0.5,
                                  jitter.width = 0.1,
                                  jitter.height = 0),
             alpha = 0.1) + 
  stat_summary(fun.data = "mean_cl_boot",
               position = position_dodge(width = 0.5)) +
  facet_wrap(~ exercises) + 
  scale_color_brewer(palette = "Set1")

ggplot(data = df.weightloss,
       mapping = aes(x = timepoint,
                     y = score)) + 
  geom_point(position = position_jitter(width = 0.1),
             alpha = 0.1) + 
  stat_summary(fun.data = "mean_cl_boot") +
  scale_color_brewer(palette = "Set1")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-9-1.png" width="672" /><img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-9-2.png" width="672" />
And then fit the model, and compute the contrasts:


``` r
fit = aov_ez(id = "id",
       dv = "score",
       between = "exercises",
       within = c("diet", "timepoint"),
       data = df.weightloss)
```

```
Contrasts set to contr.sum for the following variables: exercises
```

``` r
contrasts = list(first_two_vs_last = c(-0.5, -0.5, 1),
                 linear_increase = c(-1, 0, 1))

fit %>% 
  emmeans(spec = "timepoint",
          contr = contrasts)
```

```
$emmeans
 timepoint emmean    SE df lower.CL upper.CL
 t1          11.2 0.169 22     10.9     11.6
 t2          12.7 0.174 22     12.3     13.0
 t3          14.2 0.182 22     13.8     14.6

Results are averaged over the levels of: exercises, diet 
Confidence level used: 0.95 

$contrasts
 contrast          estimate    SE df t.ratio p.value
 first_two_vs_last     2.24 0.204 22  11.016  <.0001
 linear_increase       2.97 0.191 22  15.524  <.0001

Results are averaged over the levels of: exercises, diet 
```

Because we only had one observation in each cell of our design, the ANOVA was appropriate here (no data points needed to be aggregated). 

Both contrasts are significant. 

### Politeness study

For the politeness study, we'll be interested in one particular contrast: 

1. Was there an effect of attitude on frequency for female participants? 

Let's visualize first: 


``` r
# overview of the data 
ggplot(data = df.politeness,
        mapping = aes(x = attitude,
                      y = frequency,
                      group = gender,
                      color = gender)) + 
  geom_point(position = position_jitter(width = 0.1),
             alpha = 0.1) + 
  stat_summary(fun.data = "mean_cl_boot") + 
  scale_color_brewer(palette = "Set1")
```

```
Warning: Removed 1 row containing non-finite outside the scale range
(`stat_summary()`).
```

```
Warning: Removed 1 row containing missing values or values outside the scale
range (`geom_point()`).
```

``` r
# variation across scenarios 
ggplot(data = df.politeness,
        mapping = aes(x = scenario,
                      y = frequency)) + 
  geom_point(position = position_jitter(width = 0.1),
             alpha = 0.1) + 
  stat_summary(fun.data = "mean_cl_boot") + 
  scale_color_brewer(palette = "Set1")
```

```
Warning: Removed 1 row containing non-finite outside the scale range (`stat_summary()`).
Removed 1 row containing missing values or values outside the scale range (`geom_point()`).
```

``` r
# variation across participants
ggplot(data = df.politeness,
        mapping = aes(x = subject,
                      y = frequency)) + 
  geom_point(position = position_jitter(width = 0.1),
             alpha = 0.1) + 
  stat_summary(fun.data = "mean_cl_boot") + 
  scale_color_brewer(palette = "Set1")
```

```
Warning: Removed 1 row containing non-finite outside the scale range (`stat_summary()`).
Removed 1 row containing missing values or values outside the scale range (`geom_point()`).
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-11-1.png" width="672" /><img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-11-2.png" width="672" /><img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-11-3.png" width="672" />

We fit the model and compute the contrasts. 


``` r
fit = lmer(formula = frequency ~ 1 + attitude * gender + 
             (1 + attitude | subject) + 
             (1 + attitude | scenario),
           data = df.politeness)

fit %>% 
  joint_tests()
```

```
 model term      df1  df2 F.ratio p.value
 attitude          1 3.20   9.522  0.0495
 gender            1 4.00  26.600  0.0067
 attitude:gender   1 3.99   1.997  0.2305
```

``` r
fit %>% 
  emmeans(specs = pairwise ~ attitude + gender, 
          adjust = "none")
```

```
$emmeans
 attitude gender emmean   SE   df lower.CL upper.CL
 inf      F         261 16.0 4.97    219.4      302
 pol      F         233 16.8 5.17    190.5      276
 inf      M         144 16.0 4.97    103.2      186
 pol      M         133 16.9 5.23     89.8      175

Degrees-of-freedom method: kenward-roger 
Confidence level used: 0.95 

$contrasts
 contrast      estimate    SE   df t.ratio p.value
 inf F - pol F     27.4  8.35 4.08   3.283  0.0295
 inf F - inf M    116.2 21.30 4.00   5.448  0.0055
 inf F - pol M    128.1 22.00 4.73   5.824  0.0025
 pol F - inf M     88.8 21.90 4.70   4.046  0.0112
 pol F - pol M    100.7 22.10 4.00   4.551  0.0104
 inf M - pol M     11.9  8.46 4.28   1.405  0.2283

Degrees-of-freedom method: kenward-roger 
```

Here, I've computed all pairwise contrasts. We were only interested in one: `inf F - pol F` and that one is significant. So the frequency of female participants' pitch differed between the informal and polite condition. 

If we had used an ANOVA approach for this data set, we could have done it like so: 


``` r
aov_ez(id = "subject",
       dv = "frequency",
       between = "gender",
       within = "attitude",
       data = df.politeness)
```

```
Converting to factor: gender
```

```
Warning: More than one observation per design cell, aggregating data using `fun_aggregate = mean`.
To turn off this warning, pass `fun_aggregate = mean` explicitly.
```

```
Warning: Missing values for 1 ID(s), which were removed before analysis:
M4
Below the first few rows (in wide format) of the removed cases with missing data.
    subject gender pol   inf
# 5      M4      M  NA 146.3
```

```
Contrasts set to contr.sum for the following variables: gender
```

```
Anova Table (Type 3 tests)

Response: frequency
           Effect   df     MSE          F  ges p.value
1          gender 1, 3 1729.42    17.22 * .851    .025
2        attitude 1, 3    3.65 309.71 *** .179   <.001
3 gender:attitude 1, 3    3.65    21.30 * .015    .019
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '+' 0.1 ' ' 1
```

This approach ignores the variation across scenarios (and just computed the mean instead). Arguably, the `lmer()` approach is better here as it takes all of the data into account. 

## Mixtures of participants

What if we have groups of participants who differ from each other? Let's generate data for which this is the case.


``` r
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

Let' first fit a model that ignores the fact that there are two different groups of participants. 


``` r
# fit model
fit.mixed = lmer(formula = value ~ 1 + condition + (1 | participant),
                 data = df.mixed)

summary(fit.mixed)
```

```
Linear mixed model fit by REML. t-tests use Satterthwaite's method [
lmerModLmerTest]
Formula: value ~ 1 + condition + (1 | participant)
   Data: df.mixed

REML criterion at convergence: 163.5

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-1.62997 -0.41663 -0.05607  0.54750  1.54023 

Random effects:
 Groups      Name        Variance Std.Dev.
 participant (Intercept) 19.2206  4.3841  
 Residual                 0.3521  0.5934  
Number of obs: 40, groups:  participant, 20

Fixed effects:
            Estimate Std. Error      df t value Pr(>|t|)    
(Intercept)   5.8729     0.9893 19.3449   5.937 9.54e-06 ***
condition1    1.6652     0.1876 19.0000   8.875 3.47e-08 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Correlation of Fixed Effects:
           (Intr)
condition1 -0.095
```

Let's look at the model's predictions: 


``` r
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

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-16-1.png" width="672" />


And let's simulate some data from the fitted model: 


``` r
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

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-17-1.png" width="672" />

As we can see, the simulated data doesn't look like the data that was used to fit the model.  

#### Modeling mixture

Now, let's fit a model that takes the differences between groups into account by adding a fixed effect for `group`.


``` r
# fit model
fit.grouped = lmer(formula = value ~ 1 + group + condition + (1 | participant),
                   data = df.mixed)

summary(fit.grouped)
```

```
Linear mixed model fit by REML. t-tests use Satterthwaite's method [
lmerModLmerTest]
Formula: value ~ 1 + group + condition + (1 | participant)
   Data: df.mixed

REML criterion at convergence: 82.2

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-1.61879 -0.61378  0.02557  0.49842  2.19076 

Random effects:
 Groups      Name        Variance Std.Dev.
 participant (Intercept) 0.09265  0.3044  
 Residual                0.35208  0.5934  
Number of obs: 40, groups:  participant, 20

Fixed effects:
            Estimate Std. Error      df t value Pr(>|t|)    
(Intercept)  -6.3136     0.3633 20.5655 -17.381 9.10e-14 ***
group         8.7046     0.2366 18.0000  36.791  < 2e-16 ***
condition1    1.6652     0.1876 19.0000   8.875 3.47e-08 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Correlation of Fixed Effects:
           (Intr) group 
group      -0.912       
condition1 -0.258  0.000
```

Note how the variance of the random intercepts is much smaller now that we've taken the group structure in the data into account. 

Let's visualize the model's predictions:


``` r
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

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-19-1.png" width="672" />

And simulate some data from the model: 


``` r
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

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-20-1.png" width="672" />

This time, the simulated data looks much more like the data that was used to fit the model. Yay! 



``` r
ggpredict(model = fit.grouped,
          terms = "condition") %>% 
  plot()

ggpredict(model = fit.mixed,
          terms = "condition") %>% 
  plot()
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-21-1.png" width="672" /><img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-21-2.png" width="672" />


#### Heterogeneity in variance

The example above has shown that we can take overall differences between groups into account by adding a fixed effect. Can we also deal with heterogeneity in variance between groups? For example, what if the responses of one group exhibit much more variance than the responses of another group? 

Let's first generate some data with heterogeneous variance: 


``` r
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


``` r
# fit model
fit.variance = lmer(formula = value ~ 1 + group + condition + (1 | participant),
                    data = df.variance)

summary(fit.variance)
```

```
Linear mixed model fit by REML. t-tests use Satterthwaite's method [
lmerModLmerTest]
Formula: value ~ 1 + group + condition + (1 | participant)
   Data: df.variance

REML criterion at convergence: 232.7

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-2.96291 -0.19619  0.03751  0.28317  1.45552 

Random effects:
 Groups      Name        Variance Std.Dev.
 participant (Intercept) 17.12    4.137   
 Residual                13.74    3.706   
Number of obs: 40, groups:  participant, 20

Fixed effects:
            Estimate Std. Error       df t value Pr(>|t|)    
(Intercept) -24.0018     3.3669  19.1245  -7.129 8.56e-07 ***
group        27.0696     2.2353  18.0000  12.110 4.36e-10 ***
condition1    0.5716     1.1720  19.0000   0.488    0.631    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Correlation of Fixed Effects:
           (Intr) group 
group      -0.929       
condition1 -0.174  0.000
```

Look at the data and model predictions: 


``` r
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

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-24-1.png" width="672" />

And the simulated data: 


``` r
# simulated data 
fit.variance %>%
  simulate() %>%
  bind_cols(df.mixed) %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-25-1.png" width="672" />

The `lmer()` fails here. It uses one normal distribution to model the variance between participants. It cannot account for the fact that the answers of one group of participants vary more than the answers from another groups of participants. Again, the simulated data doesn't look like the original data, even though we did take the grouping into account. 

We will later see that it's straightforward in Bayesian models to explicitly model heterogeneity in variance. 

## Simulating different random effects structures  

The examples below are taken from [this post](https://rpsychologist.com/r-guide-longitudinal-lme-lmer#power-analysis-and-simulating-these-models). 

### Two-level model

<div class="figure">
<img src="figures/two_level.png" alt="Two-level model" width="95%" />
<p class="caption">(\#fig:two-level-model)Two-level model</p>
</div>

#### Conditional model 


##### Cimulate the data


``` r
set.seed(1)

n_participants = 100
n_timepoints = 3
n_conditions = 2
p_condition = 0.5
b0 = 10
b1 = 10
sd_participant = 2
sd_residual = 1

df.data = tibble(participant = rep(1:n_participants, each = n_timepoints),
                 timepoint = rep(1:n_timepoints, times = n_participants),
                 intercept_participant = rep(rnorm(n_participants, sd = sd_participant), 
                                             each = n_timepoints)) %>% 
  group_by(participant) %>% 
  mutate(condition = rbinom(n = 1, size = 1, prob = p_condition)) %>% 
  ungroup() %>% 
  mutate(value = b0 + b1 * condition + intercept_participant + 
           rnorm(n_participants * n_timepoints, sd = sd_residual))
```

##### Plot the data 


``` r
df.plot = df.data %>% 
  mutate(condition = factor(condition,
                            levels = c(0, 1),
                            labels = c("control", "treatment")),
         timepoint = as.factor(timepoint))

ggplot(data = df.plot,
       mapping = aes(x = timepoint,
                     y = value,
                     group = participant)) +
  geom_point(alpha = 0.5) +
  geom_line(alpha = 0.5) +
  facet_grid(~ condition) +
  labs(x = "timepoint")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-27-1.png" width="672" />

##### Fit the model 


``` r
fit = lmer(formula = value ~ 1 + condition + (1 | participant),
           data = df.data)

fit %>% 
  summary()
```

```
Linear mixed model fit by REML. t-tests use Satterthwaite's method [
lmerModLmerTest]
Formula: value ~ 1 + condition + (1 | participant)
   Data: df.data

REML criterion at convergence: 1102

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-2.30522 -0.57146  0.03152  0.56826  2.28135 

Random effects:
 Groups      Name        Variance Std.Dev.
 participant (Intercept) 3.106    1.762   
 Residual                1.087    1.043   
Number of obs: 300, groups:  participant, 100

Fixed effects:
            Estimate Std. Error      df t value Pr(>|t|)    
(Intercept)  10.2199     0.2365 98.0000   43.21   <2e-16 ***
condition    10.0461     0.3837 98.0000   26.18   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Correlation of Fixed Effects:
          (Intr)
condition -0.616
```

##### Simulate and plot new data


``` r
set.seed(1)

fit %>% 
  simulate() %>% 
  bind_cols(df.data) %>% 
  mutate(condition = factor(condition,
                            levels = c(0, 1),
                            labels = c("control", "treatment")),
         timepoint = as.factor(timepoint)) %>% 
  ggplot(data = .,
         mapping = aes(x = timepoint,
                       y = sim_1,
                       group = participant)) +
  geom_point(alpha = 0.5,
             color = "blue") +
  geom_line(alpha = 0.5,
            color = "blue") +
  facet_grid(~ condition) +
  labs(x = "timepoint")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-29-1.png" width="672" />

#### Conditional growth model 

##### Simulate the data


``` r
set.seed(1)

n_participants = 100
n_timepoints = 3
n_conditions = 2
p_condition = 0.5
b0 = 10 # intercept 
b1 = 10 # condition
b2 = 2 # time 
b3 = 3 # interaction
sd_participant = 2
sd_time = 2
sd_residual = 1

df.data = tibble(participant = rep(1:n_participants, each = n_timepoints),
                 timepoint = rep(1:n_timepoints, times = n_participants),
                 intercept_participant = rep(rnorm(n_participants, sd = sd_participant), 
                                             each = n_timepoints),
                 time_participant = rep(rnorm(n_participants, sd = sd_time), 
                                             each = n_timepoints)) %>% 
  group_by(participant) %>% 
  mutate(condition = rbinom(n = 1, size = 1, prob = p_condition)) %>% 
  ungroup() %>% 
  mutate(value = b0 + intercept_participant + 
           b1 * condition + 
           (b2  + time_participant) * timepoint +  
           b3 * condition * timepoint +
           rnorm(n_participants * n_timepoints, sd = sd_residual))
```

##### Plot the data 


``` r
df.plot = df.data %>% 
  mutate(condition = factor(condition,
                            levels = c(0, 1),
                            labels = c("control", "treatment")),
         timepoint = as.factor(timepoint))

ggplot(data = df.plot,
       mapping = aes(x = timepoint,
                     y = value,
                     group = participant)) +
  geom_point(alpha = 0.5) +
  geom_line(alpha = 0.5) +
  facet_grid(~ condition) +
  labs(x = "timepoint")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-31-1.png" width="672" />

##### Fit the model 


``` r
fit = lmer(formula = value ~ 1 + condition * timepoint + (1 + timepoint | participant),
           data = df.data)

fit %>% 
  summary()
```

```
Linear mixed model fit by REML. t-tests use Satterthwaite's method [
lmerModLmerTest]
Formula: value ~ 1 + condition * timepoint + (1 + timepoint | participant)
   Data: df.data

REML criterion at convergence: 1360.3

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-2.14633 -0.46360  0.03902  0.42302  2.82945 

Random effects:
 Groups      Name        Variance Std.Dev. Corr 
 participant (Intercept) 3.190    1.786         
             timepoint   3.831    1.957    -0.06
 Residual                1.149    1.072         
Number of obs: 300, groups:  participant, 100

Fixed effects:
                    Estimate Std. Error      df t value Pr(>|t|)    
(Intercept)          10.0101     0.3328 98.0000  30.079  < 2e-16 ***
condition            10.0684     0.4854 98.0000  20.741  < 2e-16 ***
timepoint             2.0595     0.2883 97.9999   7.143 1.62e-10 ***
condition:timepoint   2.9090     0.4205 97.9999   6.917 4.76e-10 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Correlation of Fixed Effects:
            (Intr) condtn timpnt
condition   -0.686              
timepoint   -0.266  0.182       
cndtn:tmpnt  0.182 -0.266 -0.686
```

##### Data with individual model predictions 


``` r
df.plot = fit %>% 
  augment() %>% 
  mutate(condition = factor(condition,
                            levels = c(0, 1),
                            labels = c("control", "treatment")),
         timepoint = as.factor(timepoint))
         

ggplot(data = df.plot,
       mapping = aes(x = timepoint,
                     y = value,
                     group = participant)) +
  # geom_point(alpha = 0.5) +
  # geom_line(alpha = 0.5) +
  geom_point(mapping = aes(y = .fitted),
             alpha = 0.3,
             color = "red") +
  geom_line(mapping = aes(y = .fitted),
             alpha = 0.3,
             color = "red") +
  facet_grid(~ condition) +
  labs(x = "timepoint")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-33-1.png" width="672" />

##### Data with overall model predictions 


``` r
df.model = ggpredict(model = fit, 
                     terms = c("timepoint", "condition"),
                     type = "fixed") %>% 
  rename(timepoint = x,
         condition = group) %>% 
  mutate(condition = factor(condition,
                            levels = c(0, 1),
                            labels = c("control", "treatment")),
         timepoint = as.factor(timepoint))

ggplot(data = df.plot,
       mapping = aes(x = timepoint,
                     y = value,
                     group = participant)) +
  geom_point(alpha = 0.2) +
  geom_line(alpha = 0.2) +
  geom_ribbon(data = df.model,
              mapping = aes(ymin = conf.low,
                            ymax = conf.high,
                            y = predicted,
                            group = NA),
              fill = "red",
              alpha = 0.4) +
  geom_point(data = df.model,
             mapping = aes(y = predicted,
                           group = NA),
             color = "red",
             size = 3) +
  geom_line(data = df.model,
            mapping = aes(y = predicted,
                          group = NA),
            color = "red",
            linewidth = 1) +
  facet_grid(~ condition) +
  labs(x = "timepoint")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-34-1.png" width="672" />

##### Simulate and plot new data


``` r
set.seed(1)

fit %>% 
  simulate() %>% 
  bind_cols(df.data) %>% 
  mutate(condition = factor(condition,
                            levels = c(0, 1),
                            labels = c("control", "treatment")),
         timepoint = as.factor(timepoint)) %>% 
  ggplot(data = .,
         mapping = aes(x = timepoint,
                       y = sim_1,
                       group = participant)) +
  geom_point(alpha = 0.5,
             color = "blue") +
  geom_line(alpha = 0.5,
            color = "blue") +
  facet_grid(~ condition) +
  labs(x = "timepoint")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-35-1.png" width="672" />

### Three-level model 

<div class="figure">
<img src="figures/three_level.png" alt="Three-level model" width="95%" />
<p class="caption">(\#fig:three-level-model)Three-level model</p>
</div>

##### Simulate the data


``` r
set.seed(1)

n_participants = 100
n_therapists = 6
n_timepoints = 3
n_conditions = 2
p_condition = 0.5
b0 = 10 # intercept 
b1 = 10 # condition
b2 = 2 # time 
b3 = 3 # interaction
sd_intercept_therapist = 3
sd_intercept_participant = 2
sd_time_therapist = 2
sd_time_participant = 1
sd_residual = 1

df.data = tibble(participant = rep(1:n_participants, each = n_timepoints),
                 timepoint = rep(1:n_timepoints, times = n_participants),
                 intercept_participant = rep(rnorm(n_participants,
                                                   sd = sd_intercept_participant), 
                                             each = n_timepoints),
                 time_participant = rep(rnorm(n_participants, sd = sd_time_participant), 
                                             each = n_timepoints)) %>% 
  group_by(participant) %>% 
  mutate(condition = rbinom(n = 1, size = 1, prob = p_condition),
         therapist = ifelse(condition == 0, sample(x = 1:(n_therapists/2),
                                                   size = 1),
                        sample(x = ((n_therapists/2)+1):n_therapists,
                               size = 1))) %>% 
  ungroup() %>% 
  group_by(therapist) %>%
  mutate(intercept_therapist = rnorm(1, sd = sd_intercept_therapist),
         time_therapist = rnorm(1, sd = sd_time_therapist)) %>%
  ungroup() %>% 
  mutate(value = b0 + intercept_therapist + intercept_participant + 
           b1 * condition + 
           (b2 + time_therapist + time_participant) * timepoint +  
           b3 * condition * timepoint +
           rnorm(n_participants * n_timepoints, sd = sd_residual))
```

##### Plot the data 


``` r
df.plot = df.data %>% 
  mutate(condition = factor(condition,
                            levels = c(0, 1),
                            labels = c("control", "treatment")),
         timepoint = as.factor(timepoint),
         therapist = as.factor(therapist))

ggplot(data = df.plot,
       mapping = aes(x = timepoint,
                     y = value,
                     group = participant,
                     color = therapist)) +
  geom_point(alpha = 0.5) +
  geom_line(alpha = 0.5) +
  facet_grid(~ condition) +
  labs(x = "timepoint")
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-37-1.png" width="672" />

##### Fit the model 


``` r
fit = lmer(formula = value ~ 1 + condition * timepoint + 
             (1 + timepoint | therapist) + 
             (1 + timepoint | therapist:participant),
           data = df.data)

fit %>% 
  summary()
```

```
Linear mixed model fit by REML. t-tests use Satterthwaite's method [
lmerModLmerTest]
Formula: value ~ 1 + condition * timepoint + (1 + timepoint | therapist) +  
    (1 + timepoint | therapist:participant)
   Data: df.data

REML criterion at convergence: 1237.9

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-2.02926 -0.51103  0.01576  0.48074  2.12179 

Random effects:
 Groups                Name        Variance Std.Dev. Corr 
 therapist:participant (Intercept) 2.1361   1.4616        
                       timepoint   0.8205   0.9058   0.33 
 therapist             (Intercept) 5.6350   2.3738        
                       timepoint   2.4175   1.5548   -0.21
 Residual                          1.0515   1.0254        
Number of obs: 300, groups:  therapist:participant, 100; therapist, 6

Fixed effects:
                    Estimate Std. Error      df t value Pr(>|t|)   
(Intercept)          10.5078     1.4037  3.9706   7.486  0.00175 **
condition             7.7672     1.9866  3.9825   3.910  0.01754 * 
timepoint             1.5160     0.9126  3.9765   1.661  0.17244   
condition:timepoint   5.0489     1.2913  3.9845   3.910  0.01752 * 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Correlation of Fixed Effects:
            (Intr) condtn timpnt
condition   -0.707              
timepoint   -0.208  0.147       
cndtn:tmpnt  0.147 -0.208 -0.707
```

## Bootstrapping

Bootstrapping is a good way to estimate our uncertainty on the parameter estimates in the model. 

### Linear model

Let's briefly review how to do bootstrapping in a simple linear model. 


``` r
# fit model 
fit.lm = lm(formula = reaction ~ 1 + days,
            data = df.sleep)

# coefficients
coef(fit.lm)
```

```
(Intercept)        days 
  252.32070    10.32766 
```

``` r
# bootstrapping 
df.boot = df.sleep %>% 
  bootstrap(n = 100,
            id = "id") %>% 
  mutate(fit = map(.x = strap,
                   .f = ~ lm(formula = reaction ~ 1 + days,
                             data = .x)),
         tidy = map(.x = fit, 
                    .f = tidy)) %>% 
  unnest(tidy) %>% 
  select(id, term, estimate) %>% 
  spread(term, estimate) %>% 
  clean_names() 
```

Let's illustrate the linear model with a confidence interval (making parametric assumptions using the t-distribution). 


``` r
ggplot(data = df.sleep,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_smooth(method = "lm") + 
  geom_point(alpha = 0.3)
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-40-1.png" width="672" />

And let's compare this with the different regression lines that we get out of our bootstrapped samples:


``` r
ggplot(data = df.sleep,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_abline(data = df.boot,
              aes(intercept = intercept,
                  slope = days,
                  group = id),
              alpha = 0.1) +
  geom_point(alpha = 0.3)
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-41-1.png" width="672" />

### Linear mixed effects model 

For the linear mixed effects model, we can use the `bootmer()` function to do bootstrapping. 


``` r
set.seed(1)

# fit the model 
fit.lmer = lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                data = df.sleep)

# bootstrap parameter estimates 
boot.lmer = bootMer(fit.lmer,
                    FUN = fixef,
                    nsim = 100)

# compute confidence interval 
boot.ci(boot.lmer,
        index = 2,
        type = "perc")
```

```
BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
Based on 100 bootstrap replicates

CALL : 
boot.ci(boot.out = boot.lmer, type = "perc", index = 2)

Intervals : 
Level     Percentile     
95%   ( 7.26, 13.79 )  
Calculations and Intervals on Original Scale
Some percentile intervals may be unstable
```

Let's plot the distribution of estimates.


``` r
# plot distribution of estimates 
boot.lmer$t %>% 
  as_tibble() %>% 
  clean_names() %>% 
  mutate(id = 1:n()) %>% 
  pivot_longer(cols = -id,
               names_to = "index",
               values_to = "value") %>% 
  ggplot(data = .,
         mapping = aes(x = value)) + 
  geom_density() + 
  facet_grid(cols = vars(index),
             scales = "free") +
  coord_cartesian(expand = F)
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-43-1.png" width="672" />

And let's look at the predictions together with the data. 


``` r
df.boot_lmer = boot.lmer$t %>% 
  as_tibble() %>% 
  clean_names() %>% 
  mutate(id = 1:n())

ggplot(data = df.sleep,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_abline(data = df.boot_lmer,
              aes(intercept = intercept,
                  slope = days,
                  group = id),
              alpha = 0.1) +
  geom_point(alpha = 0.3)
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-44-1.png" width="672" />

As you'll notice, once we take the dependence in the data into account, the bootstrapped confidence interval is wider than when we ignore the dependence. 

## Logistic mixed effects model

Just like we can build linear mixed effects models using `lmer()` instead of `lm()`, we can also build a logistic mixed effects regression using `glmer()` instead of `glm()`. 

Let's read in some data: 


``` r
# load bdf data set from nlme package
data(bdf, package = "nlme")

df.language = bdf %>% 
  clean_names() %>% 
  filter(repeatgr != 2) %>% 
  mutate(repeatgr = repeatgr %>% 
           as.character() %>% 
           as.numeric())

rm(bdf)
```

Fit the model, and print out the results: 


``` r
fit =  glmer(repeatgr ~ 1 + ses + minority + (1 | school_nr),
             data = df.language,
             family = "binomial")

fit %>%
  summary()
```

```
Generalized linear mixed model fit by maximum likelihood (Laplace
  Approximation) [glmerMod]
 Family: binomial  ( logit )
Formula: repeatgr ~ 1 + ses + minority + (1 | school_nr)
   Data: df.language

     AIC      BIC   logLik deviance df.resid 
  1659.1   1682.1   -825.6   1651.1     2279 

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-0.9235 -0.4045 -0.3150 -0.2249  5.8372 

Random effects:
 Groups    Name        Variance Std.Dev.
 school_nr (Intercept) 0.2489   0.4989  
Number of obs: 2283, groups:  school_nr, 131

Fixed effects:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.506280   0.197568  -2.563  0.01039 *  
ses         -0.060086   0.007524  -7.986 1.39e-15 ***
minorityY    0.673605   0.238655   2.823  0.00477 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Correlation of Fixed Effects:
          (Intr) ses   
ses       -0.898       
minorityY -0.308  0.208
```

To visualize the results, we can use the `ggeffects` package. 


``` r
ggpredict(model = fit,
          terms = c("ses [all]", "minority")) %>% 
  plot()
```

```
You are calculating adjusted predictions on the population-level (i.e.
  `type = "fixed"`) for a *generalized* linear mixed model.
  This may produce biased estimates due to Jensen's inequality. Consider
  setting `bias_correction = TRUE` to correct for this bias.
  See also the documentation of the `bias_correction` argument.
```

<img src="20-linear_mixed_effects_models4_files/figure-html/unnamed-chunk-47-1.png" width="672" />

And for significance testing, we can use the the `joint_tests()` function from the "emmeans" package


``` r
glmer(formula = repeatgr ~ 1 + ses + minority + (1 | school_nr),
      data = df.language,
      family = "binomial") %>% 
  joint_tests()
```

```
 model term df1 df2 F.ratio  Chisq p.value
 ses          1 Inf  63.784 63.784  <.0001
 minority     1 Inf   7.967  7.967  0.0048
```

The results show that there was both a significant effect of ses and of minority. 

Note: This post [here](https://stats.stackexchange.com/questions/400101/using-emmeans-with-clmm-to-look-at-joint-effects) says a little more about the relationship of the F.ratio in the `joint_tests()` function, and what a likelihood ratio test yields. In short, it's roughly the same thing. 

If you'd like to compute the likelihood ratio test, a convenient way of doing so is by using the `mixed()` function from the "afex" package.


``` r
mixed(formula = repeatgr ~ 1 + ses + minority + (1 | school_nr),
      family = "binomial",
      data = df.language,
      method = "LRT")
```

```
Contrasts set to contr.sum for the following variables: minority, school_nr
```

```
Numerical variables NOT centered on 0: ses
If in interactions, interpretation of lower order (e.g., main) effects difficult.
```

```
Mixed Model Anova Table (Type 3 tests, LRT-method)

Model: repeatgr ~ 1 + ses + minority + (1 | school_nr)
Data: df.language
Df full model: 4
    Effect df     Chisq p.value
1      ses  1 75.39 ***   <.001
2 minority  1   7.53 **    .006
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '+' 0.1 ' ' 1
```
And we can compare that the model comparison approach gives us the same result: 


``` r
fit_a =  glmer(repeatgr ~ 1 + ses + minority + (1 | school_nr),
             data = df.language,
             family = "binomial")

# dropping ses as a predictor
fit_c =  glmer(repeatgr ~ 1 +  minority + (1 | school_nr),
             data = df.language,
             family = "binomial")

anova(fit_a, fit_c, test = "LRT")
```

```
Data: df.language
Models:
fit_c: repeatgr ~ 1 + minority + (1 | school_nr)
fit_a: repeatgr ~ 1 + ses + minority + (1 | school_nr)
      npar    AIC    BIC  logLik deviance  Chisq Df Pr(>Chisq)    
fit_c    3 1732.5 1749.7 -863.27   1726.5                         
fit_a    4 1659.1 1682.1 -825.57   1651.1 75.395  1  < 2.2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


## Session info

Information about this R session including which version of R was used, and what packages were loaded. 


``` r
sessionInfo()
```

```
R version 4.4.2 (2024-10-31)
Platform: aarch64-apple-darwin20
Running under: macOS Sequoia 15.2

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRblas.0.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: America/Los_Angeles
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] lubridate_1.9.3     forcats_1.0.0       stringr_1.5.1      
 [4] dplyr_1.1.4         purrr_1.0.2         readr_2.1.5        
 [7] tidyr_1.3.1         tibble_3.2.1        ggplot2_3.5.1      
[10] tidyverse_2.0.0     emmeans_1.10.6      ggeffects_2.0.0    
[13] boot_1.3-31         modelr_0.1.11       datarium_0.1.0     
[16] car_3.1-3           carData_3.0-5       afex_1.4-1         
[19] lme4_1.1-35.5       Matrix_1.7-1        broom.mixed_0.2.9.6
[22] janitor_2.2.1       kableExtra_1.4.0    knitr_1.49         

loaded via a namespace (and not attached):
 [1] gridExtra_2.3       rlang_1.1.4         magrittr_2.0.3     
 [4] snakecase_0.11.1    furrr_0.3.1         compiler_4.4.2     
 [7] mgcv_1.9-1          systemfonts_1.1.0   vctrs_0.6.5        
[10] reshape2_1.4.4      pkgconfig_2.0.3     crayon_1.5.3       
[13] fastmap_1.2.0       backports_1.5.0     labeling_0.4.3     
[16] utf8_1.2.4          rmarkdown_2.29      tzdb_0.4.0         
[19] haven_2.5.4         nloptr_2.1.1        bit_4.0.5          
[22] xfun_0.49           cachem_1.1.0        jsonlite_1.8.8     
[25] broom_1.0.7         parallel_4.4.2      cluster_2.1.6      
[28] R6_2.5.1            RColorBrewer_1.1-3  bslib_0.7.0        
[31] stringi_1.8.4       parallelly_1.37.1   rpart_4.1.23       
[34] jquerylib_0.1.4     numDeriv_2016.8-1.1 estimability_1.5.1 
[37] Rcpp_1.0.13         bookdown_0.42       base64enc_0.1-3    
[40] splines_4.4.2       nnet_7.3-19         timechange_0.3.0   
[43] tidyselect_1.2.1    rstudioapi_0.16.0   abind_1.4-5        
[46] yaml_2.3.10         sjlabelled_1.2.0    codetools_0.2-20   
[49] listenv_0.9.1       lattice_0.22-6      lmerTest_3.1-3     
[52] plyr_1.8.9          withr_3.0.2         coda_0.19-4.1      
[55] evaluate_0.24.0     foreign_0.8-87      future_1.33.2      
[58] xml2_1.3.6          pillar_1.9.0        checkmate_2.3.1    
[61] insight_1.0.0       generics_0.1.3      vroom_1.6.5        
[64] hms_1.1.3           munsell_0.5.1       scales_1.3.0       
[67] minqa_1.2.7         globals_0.16.3      xtable_1.8-4       
[70] glue_1.8.0          Hmisc_5.2-1         tools_4.4.2        
[73] data.table_1.15.4   mvtnorm_1.2-5       grid_4.4.2         
[76] datawizard_0.13.0   colorspace_2.1-0    nlme_3.1-166       
[79] htmlTable_2.4.2     Formula_1.2-5       cli_3.6.3          
[82] fansi_1.0.6         viridisLite_0.4.2   svglite_2.1.3      
[85] gtable_0.3.5        sass_0.4.9          digest_0.6.36      
[88] pbkrtest_0.5.3      farver_2.1.2        htmlwidgets_1.6.4  
[91] htmltools_0.5.8.1   lifecycle_1.0.4     bit64_4.0.5        
[94] MASS_7.3-64        
```
