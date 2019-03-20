# Linear mixed effects models 1



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")    # for tidying up linear models 
library("patchwork")    # for making figure panels
library("lme4")    # for linear mixed effects models
library("tidyverse")  # for wrangling, plotting, etc. 

opts_chunk$set(
  comment = "",
  results = "hold",
  fig.show = "hold"
)
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Things that came up in class 

### Comparing t-test with F-test in `lm()`

What's the difference between the t-test on individual predictors in the model and the F-test comparing two models (one with, and one without the predictor)? 

Let's generate some data first: 


```r
# make example reproducible 
set.seed(1)

# parameters
sample_size = 100
b0 = 1
b1 = 0.5
b2 = 0.5
sd = 0.5

# sample
df.data = tibble(
  participant = 1:sample_size,
  x1 = runif(sample_size, min = 0, max = 1),
  x2 = runif(sample_size, min = 0, max = 1),
  # simple additive model
  y = b0 + b1 * x1 + b2 * x2 + rnorm(sample_size, sd = sd) 
) 

# fit linear model 
fit = lm(formula = y ~ 1 + x1 + x2,
         data = df.data)

# print model summary 
fit %>% summary()
```

```

Call:
lm(formula = y ~ 1 + x1 + x2, data = df.data)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.9290 -0.3084 -0.0716  0.2676  1.1659 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   0.9953     0.1395   7.133 1.77e-10 ***
x1            0.4654     0.1817   2.561  0.01198 *  
x2            0.5072     0.1789   2.835  0.00558 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.4838 on 97 degrees of freedom
Multiple R-squared:  0.1327,	Adjusted R-squared:  0.1149 
F-statistic: 7.424 on 2 and 97 DF,  p-value: 0.001
```

Let's visualize the data: 


```r
df.data %>% 
  ggplot(data = .,
         mapping = aes(x = x1,
                       y = y,
                       color = x2)) +
  geom_smooth(method = "lm",
              color = "black") + 
  geom_point()
```

<img src="17-linear_mixed_effects_models1_files/figure-html/lmer1-05-1.png" width="672" />

#### Global F-test 

The global F-test which is shown by the F-statistic at the bottom of the `summary()` output compares the full model with a  model that only has an intercept. So, to use our model comparison approach, we would compare the following two models: 


```r
# fit models 
model_compact = lm(formula = y ~ 1,
                   data = df.data)

model_augmented = lm(formula = y ~ 1 + x1 + x2,
                     data = df.data)

# compare models using the F-test
anova(model_compact, model_augmented)
```

```
Analysis of Variance Table

Model 1: y ~ 1
Model 2: y ~ 1 + x1 + x2
  Res.Df    RSS Df Sum of Sq      F Pr(>F)   
1     99 26.175                              
2     97 22.700  2    3.4746 7.4236  0.001 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Note how the result of the F-test using the `anova()` function which compares the two models is identical to the F-statistic reported at the end of the `summary` function.

#### Test for individual predictors

To test for individual predictors in the model, we compare two models, a compact model without that predictor, and an augmented model with that predictor. Let's test the significance of `x1`. 


```r
# fit models 
model_compact = lm(formula = y ~ 1 + x2,
                   data = df.data)

model_augmented = lm(formula = y ~ 1 + x1 + x2,
                     data = df.data)

# compare models using the F-test
anova(model_compact, model_augmented)
```

```
Analysis of Variance Table

Model 1: y ~ 1 + x2
Model 2: y ~ 1 + x1 + x2
  Res.Df    RSS Df Sum of Sq     F  Pr(>F)  
1     98 24.235                             
2     97 22.700  1    1.5347 6.558 0.01198 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Note how the p-value that we get from the F-test is equivalent to the one that we get from the t-test reported in the `summary()` function. The F-test statistic (in the `anova()` result) and the t-value (in the `summary()` of the linear model) are deterministically related. In fact, the relationship is just: 

$$
t = \sqrt{F}
$$

Let's check that that's correct: 


```r
# get the t-value from the fitted lm
t_value = fit %>% 
  tidy() %>% 
  filter(term == "x1") %>% 
  pull(statistic)

# get the F-value from comparing the compact model (without x1) with the 
# augmented model (with x1)

f_value = anova(model_compact, model_augmented) %>% 
  tidy() %>% 
  pull(statistic) %>% 
  .[2]

# t-value 
print(str_c("t_value: ", t_value))

# square root of f_value 
print(str_c("sqrt of f_value: ", sqrt(f_value)))
```

```
[1] "t_value: 2.56085255904998"
[1] "sqrt of f_value: 2.56085255904998"
```

Yip, they are the same. 

## Dependence 

Let's generate a data set in which two observations from the same participants are dependent, and then let's also shuffle this data set to see whether taking into account the dependence in the data matters. 


```r
# make example reproducible 
set.seed(1)

df.dependence = data_frame(
  participant = 1:20,
  condition1 = rnorm(20),
  condition2 = condition1 + rnorm(20, mean = 0.2, sd = 0.1)
) %>% 
  mutate(condition2shuffled = sample(condition2)) # shuffles the condition label
```

```
Warning: `data_frame()` is deprecated, use `tibble()`.
This warning is displayed once per session.
```

Let's visualize the original and shuffled data set: 


```r
df.plot = df.dependence %>% 
  gather("condition", "value", -participant) %>% 
  mutate(condition = str_replace(condition, "condition", ""))

p1 = ggplot(data = df.plot %>% filter(condition != "2shuffled"), 
            mapping = aes(x = condition, y = value)) +
  geom_line(aes(group = participant), alpha = 0.3) +
  geom_point() +
  stat_summary(fun.y = "mean", 
               geom = "point",
               shape = 21, 
               fill = "red",
               size = 4) +
  labs(title = "original",
       tag = "a)")

p2 = ggplot(data = df.plot %>% filter(condition != "2"), 
            mapping = aes(x = condition, y = value)) +
  geom_line(aes(group = participant), alpha = 0.3) +
  geom_point() +
  stat_summary(fun.y = "mean", 
               geom = "point",
               shape = 21, 
               fill = "red",
               size = 4) +
  labs(title = "shuffled",
       tag = "b)")

p1 + p2 
```

<img src="17-linear_mixed_effects_models1_files/figure-html/lmer1-10-1.png" width="672" />

Let's save the two original and shuffled data set as two separate data sets.


```r
# separate the data sets 
df.original = df.dependence %>% 
  gather("condition", "value", -participant) %>% 
  mutate(condition = str_replace(condition, "condition", "")) %>% 
  filter(condition != "2shuffled")

df.shuffled = df.dependence %>% 
  gather("condition", "value", -participant) %>% 
  mutate(condition = str_replace(condition, "condition", "")) %>% 
  filter(condition != "2")
```

Let's run a linear model, and independent samples t-test on the original data set. 


```r
# linear model (assuming independent samples)
lm(formula = value ~ condition,
   data = df.original) %>% 
  summary() 

t.test(df.original$value[df.original$condition == "1"],
       df.original$value[df.original$condition == "2"],
       alternative = "two.sided",
       paired = F
)
```

```

Call:
lm(formula = value ~ condition, data = df.original)

Residuals:
    Min      1Q  Median      3Q     Max 
-2.4100 -0.5530  0.1945  0.5685  1.4578 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   0.1905     0.2025   0.941    0.353
condition2    0.1994     0.2864   0.696    0.491

Residual standard error: 0.9058 on 38 degrees of freedom
Multiple R-squared:  0.01259,	Adjusted R-squared:  -0.0134 
F-statistic: 0.4843 on 1 and 38 DF,  p-value: 0.4907


	Welch Two Sample t-test

data:  df.original$value[df.original$condition == "1"] and df.original$value[df.original$condition == "2"]
t = -0.69595, df = 37.99, p-value = 0.4907
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.7792396  0.3805339
sample estimates:
mean of x mean of y 
0.1905239 0.3898767 
```

The mean difference between the conditions is extremely small, and non-significant (if we ignore the dependence in the data). 

Let's fit a linear mixed effects model with a random intercept for each participant: 


```r
# fit a linear mixed effects model 
lmer(formula = value ~ condition + (1 | participant),
     data = df.original) %>% 
  summary()
```

```
Linear mixed model fit by REML ['lmerMod']
Formula: value ~ condition + (1 | participant)
   Data: df.original

REML criterion at convergence: 17.3

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-1.55996 -0.36399 -0.03341  0.34400  1.65823 

Random effects:
 Groups      Name        Variance Std.Dev.
 participant (Intercept) 0.816722 0.90373 
 Residual                0.003796 0.06161 
Number of obs: 40, groups:  participant, 20

Fixed effects:
            Estimate Std. Error t value
(Intercept)  0.19052    0.20255   0.941
condition2   0.19935    0.01948  10.231

Correlation of Fixed Effects:
           (Intr)
condition2 -0.048
```

To test for whether condition is a significant predictor, we need to use our model comparison approach: 


```r
# fit models
fit.compact = lmer(formula = value ~ 1 + (1 | participant),
                   data = df.original)
fit.augmented = lmer(formula = value ~ condition + (1 | participant),
                     data = df.original)

# compare via Chisq-test
anova(fit.compact, fit.augmented)
```

```
refitting model(s) with ML (instead of REML)
```

```
Data: df.original
Models:
fit.compact: value ~ 1 + (1 | participant)
fit.augmented: value ~ condition + (1 | participant)
              Df    AIC    BIC   logLik deviance  Chisq Chi Df Pr(>Chisq)
fit.compact    3 53.315 58.382 -23.6575   47.315                         
fit.augmented  4 17.849 24.605  -4.9247    9.849 37.466      1  9.304e-10
                 
fit.compact      
fit.augmented ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

This result is identical to running a paired samples t-test: 


```r
t.test(df.original$value[df.original$condition == "1"],
       df.original$value[df.original$condition == "2"],
       alternative = "two.sided",
       paired = T)
```

```

	Paired t-test

data:  df.original$value[df.original$condition == "1"] and df.original$value[df.original$condition == "2"]
t = -10.231, df = 19, p-value = 3.636e-09
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.2401340 -0.1585717
sample estimates:
mean of the differences 
             -0.1993528 
```

But, unlike in the paired samples t-test, the linear mixed effects model explicitly models the variation between participants, and it's a much more flexible approach for modeling dependence in data. 

Let's fit a linear model and a linear mixed effects model to the original (non-shuffled) data. 


```r
# model assuming independence
fit.independent = lm(formula = value ~ 1 + condition,
                     data = df.original)

# model assuming dependence
fit.dependent = lmer(formula = value ~ 1 + condition + (1 | participant),
                     data = df.original)
```

Let's visualize the linear model's predictions: 


```r
# plot with predictions by fit.independent 
fit.independent %>% 
  augment() %>% 
  bind_cols(df.original %>% select(participant)) %>% 
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

<img src="17-linear_mixed_effects_models1_files/figure-html/lmer1-17-1.png" width="672" />

And this is what the residuals look like: 


```r
# make example reproducible 
set.seed(1)

fit.independent %>% 
  augment() %>% 
  bind_cols(df.original %>% select(participant)) %>% 
  clean_names() %>% 
  mutate(index = as.numeric(condition),
         index = index + runif(n(), min = -0.3, max = 0.3)) %>% 
  ggplot(data = .,
         mapping = aes(x = index,
                       y = value,
                       group = participant,
                       color = condition)) +
  geom_point() + 
  geom_smooth(method = "lm",
              se = F,
              formula = "y ~ 1",
              aes(group = condition)) +
  geom_segment(aes(xend = index,
                   yend = fitted),
               alpha = 0.5) +
  scale_color_brewer(palette = "Set1") +
  scale_x_continuous(breaks = 1:2, 
                     labels = 1:2) +
  labs(x = "condition") +
  theme(legend.position = "none")
```

<img src="17-linear_mixed_effects_models1_files/figure-html/lmer1-18-1.png" width="672" />

It's clear from this residual plot, that fitting two separate lines (or points) is not much better than just fitting one line (or point). 

Let's visualize the predictions of the linear mixed effects model: 


```r
# plot with predictions by fit.independent 
fit.dependent %>% 
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

<img src="17-linear_mixed_effects_models1_files/figure-html/lmer1-19-1.png" width="672" />

Let's compare the residuals of the linear model with that of the linear mixed effects model: 


```r
# linear model 
p1 = fit.independent %>% 
  augment() %>% 
  clean_names() %>% 
  ggplot(data = .,
         mapping = aes(x = fitted,
                       y = resid)) +
  geom_point() +
  coord_cartesian(ylim = c(-2.5, 2.5))

# linear mixed effects model 
p2 = fit.dependent %>% 
  augment() %>% 
  clean_names() %>% 
  ggplot(data = .,
         mapping = aes(x = fitted,
                       y = resid)) +
  geom_point() + 
  coord_cartesian(ylim = c(-2.5, 2.5))

p1 + p2
```

<img src="17-linear_mixed_effects_models1_files/figure-html/lmer1-20-1.png" width="672" />

The residuals of the linear mixed effects model are much smaller. Let's test whether taking the individual variation into account is worth it (statistically speaking). 


```r
# fit models (without and with dependence)
fit.compact = lm(formula = value ~ 1 + condition,
                 data = df.original)

fit.augmented = lmer(formula = value ~ 1 + condition + (1 | participant),
                     data = df.original)

# compare models
# note: the lmer model has to be supplied first 
anova(fit.augmented, fit.compact) 
```

```
refitting model(s) with ML (instead of REML)
```

```
Data: df.original
Models:
fit.compact: value ~ 1 + condition
fit.augmented: value ~ 1 + condition + (1 | participant)
              Df     AIC     BIC  logLik deviance  Chisq Chi Df Pr(>Chisq)
fit.compact    3 109.551 114.617 -51.775  103.551                         
fit.augmented  4  17.849  24.605  -4.925    9.849 93.701      1  < 2.2e-16
                 
fit.compact      
fit.augmented ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Yes, the likelihood of the data given the linear mixed effects model is significantly higher compared to its likelihood given the linear model. 

## Additional resources 

### Readings 

- [Linear mixed effects models tutorial by Bodo Winter](https://arxiv.org/pdf/1308.5499.pdf)
