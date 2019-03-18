
# Mediation & Moderation



These notes are adapted from this tutorial: [Mediation and moderation](https://ademos.people.uic.edu/Chapter14.html)

> _Mediation analysis_ tests a hypothetical causal chain where one variable __X__ affects a second variable __M__ and, in turn, that variable affects a third variable __Y__. Mediators describe the how or why of a (typically well-established) relationship between two other variables and are sometimes called intermediary variables since they often describe the process through which an effect occurs. This is also sometimes called an indirect effect. For instance, people with higher incomes tend to live longer but this effect is explained by the mediating influence of having access to better health care. 

## Recommended reading 

- @fiedler2011mediation
- @mackinnon2007mediationa

## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("mediation")  # for mediation and moderation analysis 
library("multilevel") # Sobel test
library("broom")      # tidying up regression results
library("brms")       # Bayesian regression models 
library("tidybayes")  # visualize the posterior
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Mediation 

<div class="figure">
<img src="figures/mediation.png" alt="__Basic mediation model__. c = the total effect of X on Y; c = c’ + ab; c’ = the direct effect of X on Y after controlling for M; c’ = c - ab; ab = indirect effect of X on Y." width="75%" />
<p class="caption">(\#fig:mediation-04)__Basic mediation model__. c = the total effect of X on Y; c = c’ + ab; c’ = the direct effect of X on Y after controlling for M; c’ = c - ab; ab = indirect effect of X on Y.</p>
</div>

Mediation tests whether the effects of __X__ (the independent variable) on __Y__ (the dependent variable) operate through a third variable, __M__ (the mediator). In this way, mediators explain the causal relationship between two variables or "how" the relationship works, making it a very popular method in psychological research.

Figure \@ref(fig:mediation-04) shows the standard mediation model. Perfect mediation occurs when the effect of __X__ on __Y__ decreases to 0 with __M__ in the model. Partial mediation occurs when the effect of __X__ on __Y__ decreases by a nontrivial amount (the actual amount is up for debate) with __M__ in the model.

__Important__: Both mediation and moderation assume that the DV __did not CAUSE the mediator/moderator__.

### Generate data 


```r
# make example reproducible
set.seed(123)

# number of participants
n = 100 

# generate data
df.mediation = tibble(
  x = rnorm(n, 75, 7), # grades
  m = 0.7 * x + rnorm(n, 0, 5), # self-esteem
  y = 0.4 * m + rnorm(n, 0, 5) # happiness
)
```

### Method 1: Baron & Kenny’s (1986) indirect effect method

The @baron1986moderator method is among the original methods for testing for mediation but tends to have low statistical power. It is covered in this chapter because it provides a very clear approach to establishing relationships between variables and is still occassionally requested by reviewers.

__The three steps__:

1. Estimate the relationship between $X$ and $Y$ (hours since dawn on degree of wakefulness). Path “c” must be significantly different from 0; must have a total effect between the IV & DV. 

2. Estimate the relationship between $X$ and $M$ (hours since dawn on coffee consumption). Path “a” must be significantly different from 0; IV and mediator must be related.

3. Estimate the relationship between $M$ and $Y$ controlling for $X$ (coffee consumption on wakefulness, controlling for hours since dawn). Path “b” must be significantly different from 0; mediator and DV must be related. The effect of $X$ on $Y$ decreases with the inclusion of $M$ in the model. 


#### Total effect 

Total effect of X on Y (not controlling for M).


```r
# fit the model
fit.y_x = lm(formula = y ~ 1 + x,
            data = df.mediation)

# summarize the results
fit.y_x %>% summary()
```

```
## 
## Call:
## lm(formula = y ~ 1 + x, data = df.mediation)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -10.917  -3.738  -0.259   2.910  12.540 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)  
## (Intercept)  8.78300    6.16002   1.426   0.1571  
## x            0.16899    0.08116   2.082   0.0399 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 5.16 on 98 degrees of freedom
## Multiple R-squared:  0.04237,	Adjusted R-squared:  0.0326 
## F-statistic: 4.336 on 1 and 98 DF,  p-value: 0.03993
```

#### Path a 


```r
fit.m_x = lm(formula = m ~ 1 + x,
            data = df.mediation)

fit.m_x %>% summary()
```

```
## 
## Call:
## lm(formula = m ~ 1 + x, data = df.mediation)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -9.5367 -3.4175 -0.4375  2.9032 16.4520 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  2.29696    5.79432   0.396    0.693    
## x            0.66252    0.07634   8.678 8.87e-14 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.854 on 98 degrees of freedom
## Multiple R-squared:  0.4346,	Adjusted R-squared:  0.4288 
## F-statistic: 75.31 on 1 and 98 DF,  p-value: 8.872e-14
```

#### Path b and c'

Effect of M on Y controlling for X. 


```r
fit.y_mx = lm(formula = y ~ 1 + m + x,
            data = df.mediation)

fit.y_mx %>% summary()
```

```
## 
## Call:
## lm(formula = y ~ 1 + m + x, data = df.mediation)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -9.3651 -3.3037 -0.6222  3.1068 10.3991 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  7.80952    5.68297   1.374    0.173    
## m            0.42381    0.09899   4.281 4.37e-05 ***
## x           -0.11179    0.09949  -1.124    0.264    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.756 on 97 degrees of freedom
## Multiple R-squared:  0.1946,	Adjusted R-squared:  0.1779 
## F-statistic: 11.72 on 2 and 97 DF,  p-value: 2.771e-05
```

#### Interpretation


```r
fit.y_x %>% 
  tidy() %>% 
  mutate(path = "c") %>% 
  bind_rows(
    fit.m_x %>% 
    tidy() %>% 
    mutate(path = "a"),
    fit.y_mx %>% 
    tidy() %>% 
    mutate(path = c("(Intercept)", "b", "c'"))
  ) %>% 
  filter(term != "(Intercept)") %>% 
  mutate(significance = p.value < .05,
         dv = ifelse(path %in% c("c'", "b"), "y", "m")) %>% 
  select(path, iv = term, dv, estimate, p.value, significance)
```

```
## # A tibble: 4 x 6
##   path  iv    dv    estimate  p.value significance
##   <chr> <chr> <chr>    <dbl>    <dbl> <lgl>       
## 1 c     x     m        0.169 3.99e- 2 TRUE        
## 2 a     x     m        0.663 8.87e-14 TRUE        
## 3 b     m     y        0.424 4.37e- 5 TRUE        
## 4 c'    x     y       -0.112 2.64e- 1 FALSE
```

Here we find that our total effect model shows a significant positive relationship between hours since dawn (X) and wakefulness (Y). Our Path A model shows that hours since down (X) is also positively related to coffee consumption (M). Our Path B model then shows that coffee consumption (M) positively predicts wakefulness (Y) when controlling for hours since dawn (X). 

Since the relationship between hours since dawn and wakefulness is no longer significant when controlling for coffee consumption, this suggests that coffee consumption does in fact mediate this relationship. However, this method alone does not allow for a formal test of the indirect effect so we don’t know if the change in this relationship is truly meaningful.

### Method 2: Sobel Test 

The Sobel Test tests whether the indirect effect from X via M to Y is significant. 


```r
library("multilevel")

# run the sobel test
fit.sobel = sobel(pred = df.mediation$x,
                  med = df.mediation$m,
                  out = df.mediation$y)

# calculate the p-value 
(1 - pnorm(fit.sobel$z.value))*2
```

```
## [1] 0.0001233403
```

The relationship between "hours since dawn" and "wakefulness" is significantly mediated by "coffee consumption".

The Sobel Test is largely considered an outdated method since it assumes that the indirect effect (ab) is normally distributed and tends to only have adequate power with large sample sizes. Thus, again, it is highly recommended to use the mediation bootstrapping method instead.

### Method 3: Bootstrapping

The "mediation" packages uses the more recent bootstrapping method of @preacher2004spss to address the power limitations of the Sobel Test.

This method does not require that the data are normally distributed, and is particularly suitable for small sample sizes. 


```r
library("mediation")

# bootstrapped mediation 
fit.mediation = mediate(model.m = fit.m_x,
                        model.y = fit.y_mx,
                        treat = "x",
                        mediator = "m",
                        boot = T)

# summarize results
fit.mediation %>% summary()
```

```
## 
## Causal Mediation Analysis 
## 
## Nonparametric Bootstrap Confidence Intervals with the Percentile Method
## 
##                Estimate 95% CI Lower 95% CI Upper p-value    
## ACME            0.28078      0.14059         0.42  <2e-16 ***
## ADE            -0.11179     -0.29276         0.10   0.272    
## Total Effect    0.16899     -0.00415         0.34   0.064 .  
## Prop. Mediated  1.66151     -3.22476        11.46   0.064 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Sample Size Used: 100 
## 
## 
## Simulations: 1000
```

- ACME = Average causal mediation effect 
- ADE = Average direct effect
- Total effect = ACME + ADE 

Plot the results: 


```r
fit.mediation %>% plot()
```

<img src="24-mediation_moderation_files/figure-html/mediation-12-1.png" width="672" />

#### Interpretation 

The `mediate()` function gives us our Average Causal Mediation Effects (ACME), our Average Direct Effects (ADE), our combined indirect and direct effects (Total Effect), and the ratio of these estimates (Prop. Mediated). The ACME here is the indirect effect of M (total effect - direct effect) and thus this value tells us if our mediation effect is significant.

### Method 4: Bayesian approach 


```r
# model specification 
y_mx = bf(y ~ 1 + m + x)
m_x = bf(m ~ 1 + x)
 
# fit the model  
fit.brm_mediation = brm(
  formula = y_mx + m_x + set_rescor(FALSE),
  data = df.mediation,
  file = "cache/brm_mediation",
  seed = 1
)

# summarize the result
fit.brm_mediation %>% summary()
```

```
##  Family: MV(gaussian, gaussian) 
##   Links: mu = identity; sigma = identity
##          mu = identity; sigma = identity 
## Formula: y ~ 1 + m + x 
##          m ~ 1 + x 
##    Data: df.mediation (Number of observations: 100) 
## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
##          total post-warmup samples = 4000
## 
## Population-Level Effects: 
##             Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## y_Intercept     7.80      5.67    -3.21    18.67       5173 1.00
## m_Intercept     2.33      5.72    -9.30    13.69       5851 1.00
## y_m             0.43      0.10     0.23     0.62       4469 1.00
## y_x            -0.11      0.10    -0.31     0.09       4324 1.00
## m_x             0.66      0.07     0.51     0.81       5922 1.00
## 
## Family Specific Parameters: 
##         Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## sigma_y     4.80      0.35     4.18     5.58       5747 1.00
## sigma_m     4.91      0.36     4.27     5.71       5195 1.00
## 
## Samples were drawn using sampling(NUTS). For each parameter, Eff.Sample 
## is a crude measure of effective sample size, and Rhat is the potential 
## scale reduction factor on split chains (at convergence, Rhat = 1).
```

`set_rescor(FALSE)` makes it such that the residual correlation between the response variables is not modeled. 


```r
# check inference 
fit.brm_mediation %>% plot()
```

<img src="24-mediation_moderation_files/figure-html/mediation-14-1.png" width="672" /><img src="24-mediation_moderation_files/figure-html/mediation-14-2.png" width="672" />

Looks pretty solid! 

Let's get the posterior samples 


```r
df.samples = fit.brm_mediation %>% 
  posterior_samples() %>% 
  mutate(ab = b_m_x * b_y_m,
         total = ab + b_y_x)
```


And visualize the posterior: 


```r
df.samples %>% 
  select(ab, total) %>%
  gather("effect", "value") %>% 
  ggplot(aes(y = effect, x = value)) +
  geom_halfeyeh() + 
  coord_cartesian(ylim = c(1.5, 2.3))
```

<img src="24-mediation_moderation_files/figure-html/mediation-16-1.png" width="672" />

Let's also get some summaries of the posterior (MAP with highest density intervals).


```r
df.samples %>% 
  select(ab, total) %>% 
  gather("effect", "value") %>% 
  group_by(effect) %>% 
  mode_hdi(value) %>% 
  clean_names()
```

```
## # A tibble: 2 x 7
##   effect value  lower upper width point interval
##   <chr>  <dbl>  <dbl> <dbl> <dbl> <chr> <chr>   
## 1 ab     0.287 0.139  0.426  0.95 mode  hdi     
## 2 total  0.178 0.0131 0.333  0.95 mode  hdi
```

## Moderation 

<div class="figure">
<img src="figures/moderation.png" alt="__Basic moderation model__." width="75%" />
<p class="caption">(\#fig:mediation-18)__Basic moderation model__.</p>
</div>

Moderation can be tested by looking for significant interactions between the moderating variable (Z) and the IV (X). Notably, it is important to mean center both your moderator and your IV to reduce multicolinearity and make interpretation easier.

### Generate data 


```r
# make example reproducible 
set.seed(123)

# number of participants
n  = 100 

df.moderation = tibble(
  x  = abs(rnorm(n, 6, 4)), # hours of sleep
  x1 = abs(rnorm(n, 60, 30)), # adding some systematic variance to our DV
  z  = rnorm(n, 30, 8), # ounces of coffee consumed
  y  = abs((-0.8 * x) * (0.2 * z) - 0.5 * x - 0.4 * x1 + 10 + rnorm(n, 0, 3)) # attention Paid
)
```

### Moderation analysis 


```r
# scale the predictors 
df.moderation = df.moderation %>%
  mutate_at(vars(x, z), ~ scale(.)[,])

# run regression model with interaction 
fit.moderation = lm(formula = y ~ 1 + x * z,
                    data = df.moderation)

# summarize result 
fit.moderation %>% 
  summary()
```

```
## 
## Call:
## lm(formula = y ~ 1 + x * z, data = df.moderation)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -21.466  -8.972  -0.233   6.180  38.051 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   48.544      1.173  41.390  < 2e-16 ***
## x             17.863      1.196  14.936  < 2e-16 ***
## z              8.393      1.181   7.108 2.08e-10 ***
## x:z            6.094      1.077   5.656 1.59e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 11.65 on 96 degrees of freedom
## Multiple R-squared:  0.7661,	Adjusted R-squared:  0.7587 
## F-statistic: 104.8 on 3 and 96 DF,  p-value: < 2.2e-16
```

#### Visualize result 


```r
# generate data grid with three levels of the moderator 
df.newdata = df.moderation %>% 
  expand(x = c(min(x), 
               max(x)), 
         z = c(mean(z) - sd(z),
               mean(z),
               mean(z) + sd(z))) %>% 
  mutate(moderator = rep(c("low", "average", "high"), nrow(.)/3))

# predictions for the three levels of the moderator 
df.prediction = fit.moderation %>% 
  augment(newdata = df.newdata) %>% 
  mutate(moderator = factor(moderator, levels = c("high", "average", "low")))

# visualize the result 
df.moderation %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_point() + 
  geom_line(aes(y = .fitted,
                group = moderator,
                color = moderator),
            data = df.prediction,
            size = 1) +
  labs(x = "hours of sleep (z-scored)",
       y = "attention paid",
       color = "coffee consumed") + 
  scale_color_brewer(palette = "Set1")
```

<img src="24-mediation_moderation_files/figure-html/mediation-21-1.png" width="672" />


```r
df.prediction %>% 
  head(9) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
              full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> x </th>
   <th style="text-align:right;"> z </th>
   <th style="text-align:left;"> moderator </th>
   <th style="text-align:right;"> .fitted </th>
   <th style="text-align:right;"> .se.fit </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> -1.83 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:left;"> low </td>
   <td style="text-align:right;"> 18.58 </td>
   <td style="text-align:right;"> 3.75 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.83 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:left;"> average </td>
   <td style="text-align:right;"> 15.80 </td>
   <td style="text-align:right;"> 2.51 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> -1.83 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> high </td>
   <td style="text-align:right;"> 13.02 </td>
   <td style="text-align:right;"> 2.99 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.41 </td>
   <td style="text-align:right;"> -1 </td>
   <td style="text-align:left;"> low </td>
   <td style="text-align:right;"> 68.52 </td>
   <td style="text-align:right;"> 4.32 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.41 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:left;"> average </td>
   <td style="text-align:right;"> 91.60 </td>
   <td style="text-align:right;"> 3.09 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2.41 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> high </td>
   <td style="text-align:right;"> 114.68 </td>
   <td style="text-align:right;"> 4.12 </td>
  </tr>
</tbody>
</table>

## Additional resources 

### Books 

- [Introduction to Mediation, Moderation, and Conditional Process Analysis (Second Edition): A Regression-Based Approach](https://www.guilford.com/books/Introduction-to-Mediation-Moderation-and-Conditional-Process-Analysis/Andrew-Hayes/9781462534654)
  - [Recoded with BRMS and Tidyverse](https://bookdown.org/connect/#/apps/1523/access)

### Tutorials

- [R tutorial on mediation and moderation](https://ademos.people.uic.edu/Chapter14.html)
- [R tutorial on moderated mediation](https://ademos.people.uic.edu/Chapter15.html)
- [Path analysis with brms](http://www.imachordata.com/bayesian-sem-with-brms/)
