# Linear model 3



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")    # for tidying up linear models 
library("car")    # for running ANOVAs
library("afex")    # also for running ANOVAs
library("emmeans")    # for calculating constrasts
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Load data sets 


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

Selection of the data: 


```r
df.poker %>% 
  group_by(skill, hand, limit) %>% 
  filter(row_number() < 3) %>% 
  head(10) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
              full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> participant </th>
   <th style="text-align:left;"> skill </th>
   <th style="text-align:left;"> hand </th>
   <th style="text-align:left;"> limit </th>
   <th style="text-align:right;"> balance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> bad </td>
   <td style="text-align:left;"> fixed </td>
   <td style="text-align:right;"> 4.00 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> bad </td>
   <td style="text-align:left;"> fixed </td>
   <td style="text-align:right;"> 5.55 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> bad </td>
   <td style="text-align:left;"> none </td>
   <td style="text-align:right;"> 5.52 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 27 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> bad </td>
   <td style="text-align:left;"> none </td>
   <td style="text-align:right;"> 8.28 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 51 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> neutral </td>
   <td style="text-align:left;"> fixed </td>
   <td style="text-align:right;"> 11.74 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> neutral </td>
   <td style="text-align:left;"> fixed </td>
   <td style="text-align:right;"> 10.04 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 76 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> neutral </td>
   <td style="text-align:left;"> none </td>
   <td style="text-align:right;"> 21.55 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 77 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> neutral </td>
   <td style="text-align:left;"> none </td>
   <td style="text-align:right;"> 3.12 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 101 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> good </td>
   <td style="text-align:left;"> fixed </td>
   <td style="text-align:right;"> 10.86 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 102 </td>
   <td style="text-align:left;"> expert </td>
   <td style="text-align:left;"> good </td>
   <td style="text-align:left;"> fixed </td>
   <td style="text-align:right;"> 8.68 </td>
  </tr>
</tbody>
</table>

### One-way ANOVA

#### Visualization 


```r
df.poker %>% 
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
  theme(legend.position = "none")
```

<img src="12-linear_model3_files/figure-html/unnamed-chunk-6-1.png" width="672" />

#### Model fitting 

We pass the result of the `lm()` function to `anova()` to calculate an analysis of variance like so: 


```r
lm(formula = balance ~ hand, 
   data = df.poker) %>% 
  anova()
```

```
## Analysis of Variance Table
## 
## Response: balance
##            Df Sum Sq Mean Sq F value    Pr(>F)    
## hand        2 2559.4  1279.7  75.703 < 2.2e-16 ***
## Residuals 297 5020.6    16.9                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

#### Hypothesis test 

The F-test reported by the ANOVA compares the fitted model with a compact model that only predicts the grand mean: 


```r
# fit the models 
fit_c = lm(formula = balance ~ 1, data = df.poker)
fit_a = lm(formula = balance ~ hand, data = df.poker)

# compare via F-test
anova(fit_c, fit_a)
```

```
## Analysis of Variance Table
## 
## Model 1: balance ~ 1
## Model 2: balance ~ hand
##   Res.Df    RSS Df Sum of Sq      F    Pr(>F)    
## 1    299 7580.0                                  
## 2    297 5020.6  2    2559.4 75.703 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

#### Visualize the model's predictions 

Here is the model prediction of the compact model:


```r
set.seed(1)

df.plot = df.poker %>% 
  mutate(hand_jitter = 1 + runif(n(), min = -0.25, max = 0.25))

df.augment = fit_c %>% 
  augment() %>% 
  clean_names() %>% 
  bind_cols(df.plot %>% select(balance, hand, hand_jitter))

ggplot(data = df.plot, 
       mapping = aes(x = hand_jitter,
                       y = balance,
                       fill = hand)) + 
  geom_hline(yintercept = mean(df.poker$balance)) +
  geom_point(alpha = 0.5) + 
  geom_segment(data = df.augment,
               aes(xend = hand_jitter,
                   yend = fitted),
               alpha = 0.2) +
  labs(y = "balance") + 
  theme(legend.position = "none",
        axis.text.x = element_blank(),
        axis.title.x = element_blank())
```

<img src="12-linear_model3_files/figure-html/unnamed-chunk-9-1.png" width="672" />

> Note that since we have a categorical variable here, we don't really have a continuous x-axis. I've just jittered the values so it's easier to show the residuals. 

And here is the prediction of the augmented model (which predicts different means for each group).


```r
set.seed(1)


df.plot = df.poker %>% 
  mutate(hand_jitter = hand %>% as.numeric(),
         hand_jitter = hand_jitter + runif(n(), min = -0.4, max = 0.4))

df.tidy = fit_a %>% 
  tidy() %>% 
  select_if(is.numeric) %>% 
  mutate_all(funs(round, .args = list(digits = 2)))
```

```
## Warning: funs() is soft deprecated as of dplyr 0.8.0
## please use list() instead
## 
## # Before:
## funs(name = f(.)
## 
## # After: 
## list(name = ~f(.))
## This warning is displayed once per session.
```

```r
df.augment = fit_a %>% 
  augment() %>%
  clean_names() %>% 
  bind_cols(df.plot %>% select(hand_jitter))

ggplot(data = df.plot,
       mapping = aes(x = hand_jitter,
                       y = balance,
                       color = hand)) + 
  geom_point(alpha = 0.8) +
  geom_segment(data = NULL,
               aes(x = 0.6,
                   xend = 1.4,
                   y = df.tidy$estimate[1],
                   yend = df.tidy$estimate[1]
                   ),
               color = "red",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 1.6,
                   xend = 2.4,
                   y = df.tidy$estimate[1] + df.tidy$estimate[2],
                   yend = df.tidy$estimate[1] + df.tidy$estimate[2]
                   ),
               color = "orange",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 2.6,
                   xend = 3.4,
                   y = df.tidy$estimate[1] + df.tidy$estimate[3],
                   yend = df.tidy$estimate[1] + df.tidy$estimate[3]
                   ),
               color = "green",
               size = 1) +
  geom_segment(data = df.augment,
               aes(xend = hand_jitter,
                   y = balance,
                   yend = fitted),
               alpha = 0.3) +
  labs(y = "balance") + 
  scale_color_manual(values = c("red", "orange", "green")) + 
  scale_x_continuous(breaks = 1:3, labels = c("bad", "neutral", "good")) + 
  theme(legend.position = "none",
        axis.title.x = element_blank())
```

<img src="12-linear_model3_files/figure-html/unnamed-chunk-10-1.png" width="672" />

The vertical lines illustrate the residual sum of squares. 

We can illustrate the model sum of squares like so: 


```r
set.seed(1)

df.plot = df.poker %>% 
  mutate(hand_jitter = hand %>% as.numeric(),
         hand_jitter = hand_jitter + runif(n(), min = -0.4, max = 0.4)) %>% 
  group_by(hand) %>% 
  mutate(mean_group = mean(balance)) %>% 
  ungroup() %>% 
  mutate(mean_grand = mean(balance))
  
df.means = df.poker %>% 
  group_by(hand) %>% 
  summarize(mean = mean(balance)) %>% 
  spread(hand, mean)

ggplot(data = df.plot,
       mapping = aes(x = hand_jitter,
                       y = mean_group,
                       color = hand)) + 
  geom_point(alpha = 0.8) +
  geom_segment(data = NULL,
               aes(x = 0.6,
                   xend = 1.4,
                   y = df.means$bad,
                   yend = df.means$bad
                   ),
               color = "red",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 1.6,
                   xend = 2.4,
                   y = df.means$neutral,
                   yend = df.means$neutral
                   ),
               color = "orange",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 2.6,
                   xend = 3.4,
                   y = df.means$good,
                   yend = df.means$good
                   ),
               color = "green",
               size = 1) +
  geom_segment(aes(xend = hand_jitter,
                   y = mean_group,
                   yend = mean_grand),
               alpha = 0.3) +
  geom_hline(yintercept = mean(df.poker$balance),
             size = 1) + 
  labs(y = "balance") + 
  scale_color_manual(values = c("red", "orange", "green")) + 
  scale_x_continuous(breaks = 1:3, labels = c("bad", "neutral", "good")) + 
  scale_y_continuous(breaks = c(0, 10, 20), labels = c(0, 10, 20), limits = c(0, 25)) + 
  theme(legend.position = "none",
        axis.title.x = element_blank())
```

<img src="12-linear_model3_files/figure-html/unnamed-chunk-11-1.png" width="672" />

This captures the variance in the data that is accounted for by the `hand` variable. 

Just for kicks, let's calculate our cherished proportion of reduction in error PRE:


```r
df.c = fit_c %>% 
  augment() %>% 
  clean_names() %>% 
  summarize(sse = sum(resid^2) %>% round)

df.a = fit_a %>% 
  augment() %>% 
  clean_names() %>% 
  summarize(sse = sum(resid^2) %>% round)

pre = 1 - df.a$sse/df.c$sse
print(pre %>% round(2))
```

```
## [1] 0.34
```
Note that this is the same as the $R^2$ for the augmented model: 


```r
fit_a %>% 
  summary()
```

```
## 
## Call:
## lm(formula = balance ~ hand, data = df.poker)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -12.9264  -2.5902  -0.0115   2.6573  15.2834 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   5.9415     0.4111  14.451  < 2e-16 ***
## handneutral   4.4051     0.5815   7.576 4.55e-13 ***
## handgood      7.0849     0.5815  12.185  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.111 on 297 degrees of freedom
## Multiple R-squared:  0.3377,	Adjusted R-squared:  0.3332 
## F-statistic:  75.7 on 2 and 297 DF,  p-value: < 2.2e-16
```

#### Dummy coding

Let's check that we understand how dummy-coding works for a variable with more than 2 levels: 


```r
# dummy code the hand variable
df.poker = df.poker %>% 
  mutate(hand_neutral = ifelse(hand == "neutral", 1, 0),
         hand_good = ifelse(hand == "good", 1, 0))

# show the dummy coded variables 
df.poker %>% 
  select(participant, contains("hand"), balance) %>% 
  group_by(hand) %>% 
  top_n(3) %>% 
  head(10) %>% 
  kable(digits = 3) %>% 
  kable_styling(bootstrap_options = "striped",
              full_width = F)
```

```
## Selecting by balance
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> participant </th>
   <th style="text-align:left;"> hand </th>
   <th style="text-align:right;"> hand_neutral </th>
   <th style="text-align:right;"> hand_good </th>
   <th style="text-align:right;"> balance </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 31 </td>
   <td style="text-align:left;"> bad </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 12.22 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 46 </td>
   <td style="text-align:left;"> bad </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 12.06 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 50 </td>
   <td style="text-align:left;"> bad </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 16.68 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 76 </td>
   <td style="text-align:left;"> neutral </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 21.55 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 87 </td>
   <td style="text-align:left;"> neutral </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 20.89 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 89 </td>
   <td style="text-align:left;"> neutral </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 25.63 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 127 </td>
   <td style="text-align:left;"> good </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 26.99 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 129 </td>
   <td style="text-align:left;"> good </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 21.36 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 283 </td>
   <td style="text-align:left;"> good </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 22.48 </td>
  </tr>
</tbody>
</table>

```r
# fit the model
fit.tmp = lm(balance ~ 1 + hand_neutral + hand_good, df.poker)

# show the model summary 
fit.tmp %>% 
  summary()
```

```
## 
## Call:
## lm(formula = balance ~ 1 + hand_neutral + hand_good, data = df.poker)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -12.9264  -2.5902  -0.0115   2.6573  15.2834 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    5.9415     0.4111  14.451  < 2e-16 ***
## hand_neutral   4.4051     0.5815   7.576 4.55e-13 ***
## hand_good      7.0849     0.5815  12.185  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.111 on 297 degrees of freedom
## Multiple R-squared:  0.3377,	Adjusted R-squared:  0.3332 
## F-statistic:  75.7 on 2 and 297 DF,  p-value: < 2.2e-16
```
Here, I've directly put the dummy-coded variables as predictors into the `lm()`. We get the same model as if we used the `hand` variable instead. 

#### Follow up questions

Here are some follow up questions we may ask about the data. 

Are bad hands different from neutral hands? 


```r
df.poker %>% 
  filter(hand %in% c("bad", "neutral")) %>% 
  lm(formula = balance ~ hand, 
     data = .) %>% 
  summary()
```

```
## 
## Call:
## lm(formula = balance ~ hand, data = .)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -9.9566 -2.5078 -0.2365  2.4410 15.2834 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   5.9415     0.3816  15.570  < 2e-16 ***
## handneutral   4.4051     0.5397   8.163 3.76e-14 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3.816 on 198 degrees of freedom
## Multiple R-squared:  0.2518,	Adjusted R-squared:  0.248 
## F-statistic: 66.63 on 1 and 198 DF,  p-value: 3.758e-14
```

Are neutral hands different from good hands? 


```r
df.poker %>% 
  filter(hand %in% c("neutral", "good")) %>% 
  lm(formula = balance ~ hand, 
     data = .) %>% 
  summary()
```

```
## 
## Call:
## lm(formula = balance ~ hand, data = .)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -12.9264  -2.7141   0.2585   2.7184  15.2834 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  10.3466     0.4448   23.26  < 2e-16 ***
## handgood      2.6798     0.6291    4.26 3.16e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.448 on 198 degrees of freedom
## Multiple R-squared:  0.08396,	Adjusted R-squared:  0.07933 
## F-statistic: 18.15 on 1 and 198 DF,  p-value: 3.158e-05
```

Doing the same thing by recoding our hand factor and taking "neutral" to be the reference category:


```r
df.poker %>% 
  mutate(hand = fct_relevel(hand, "neutral")) %>% 
  lm(formula = balance ~ hand,
     data = .) %>% 
  summary()
```

```
## 
## Call:
## lm(formula = balance ~ hand, data = .)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -12.9264  -2.5902  -0.0115   2.6573  15.2834 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  10.3466     0.4111  25.165  < 2e-16 ***
## handbad      -4.4051     0.5815  -7.576 4.55e-13 ***
## handgood      2.6798     0.5815   4.609 6.02e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.111 on 297 degrees of freedom
## Multiple R-squared:  0.3377,	Adjusted R-squared:  0.3332 
## F-statistic:  75.7 on 2 and 297 DF,  p-value: < 2.2e-16
```

## Two-way ANOVA 

Now let's take a look at a case where we have multiple categorical predictors. 

### Visualization

Let's look at the overall effect of skill: 


```r
ggplot(data = df.poker,
       mapping = aes(x = skill,
                     y = balance)) +
  geom_point(position = position_jitter(width = 0.2,
                                             height = 0),
             alpha = 0.2) + 
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               color = "black",
               position = position_dodge(0.9)) + 
  stat_summary(fun.y = "mean",
               geom = "point",
               color = "black",
               position = position_dodge(0.9),
               aes(shape = skill),
               size = 3,
               fill = "black") +
  scale_shape_manual(values = c(21, 22)) +
  guides(shape = F)
```

<img src="12-linear_model3_files/figure-html/unnamed-chunk-18-1.png" width="672" />

And now let's take a look at the means for the full the 3 (hand) x 2 (skill) design:


```r
ggplot(data = df.poker,
       mapping = aes(x = hand,
                     y = balance,
                     group = skill,
                     fill = hand)) +
  geom_point(position = position_jitterdodge(jitter.width = 0.3,
                                             jitter.height = 0,
                                             dodge.width = 0.9),
             alpha = 0.2) + 
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               color = "black",
               position = position_dodge(0.9)) + 
  stat_summary(fun.y = "mean",
               geom = "point",
               aes(shape = skill),
               color = "black",
               position = position_dodge(0.9),
               size = 3) +
  scale_fill_manual(values = c("red", "orange", "green")) +
  scale_shape_manual(values = c(21, 22)) +
  guides(fill = F)
```

<img src="12-linear_model3_files/figure-html/unnamed-chunk-19-1.png" width="672" />

### Model fitting

For N-way ANOVAs, we need to be careful about what sums of squares we are using. The standard (based on the SPSS output) is to use type III sums of squares. We set this up in the following way: 


```r
lm(formula = balance ~ hand * skill,
   data = df.poker,
   contrasts = list(hand = "contr.sum",
                    skill = "contr.sum")) %>% 
  Anova(type = 3)
```

```
## Anova Table (Type III tests)
## 
## Response: balance
##              Sum Sq  Df   F value    Pr(>F)    
## (Intercept) 28644.7   1 1772.1137 < 2.2e-16 ***
## hand         2559.4   2   79.1692 < 2.2e-16 ***
## skill          39.3   1    2.4344 0.1197776    
## hand:skill    229.0   2    7.0830 0.0009901 ***
## Residuals    4752.3 294                        
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

So, we fit our linear model, but set the contrasts to "contr.sum" (which yields effect coding instead of dummy coding), and then specify the desired type of sums of squares in the `Anova()` function call.  

Alternatively, we could use the `afex` package and specify the ANOVA like so: 


```r
aov_ez(id = "participant",
       dv = "balance",
       data = df.poker,
       between = c("hand", "skill")
)
```

```
## Contrasts set to contr.sum for the following variables: hand, skill
```

```
## Anova Table (Type 3 tests)
## 
## Response: balance
##       Effect     df   MSE         F  ges p.value
## 1       hand 2, 294 16.16 79.17 ***  .35  <.0001
## 2      skill 1, 294 16.16      2.43 .008     .12
## 3 hand:skill 2, 294 16.16  7.08 ***  .05   .0010
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '+' 0.1 ' ' 1
```

The `afex` package uses effect coding and type 3 sums of squares by default.

### Interpreting interactions 

Code I've used to generate the different plots in the competition: 


```r
set.seed(1)

b0 = 15
nsamples = 30
sd = 5

# simple effect of condition
b1 = 10
b2 = 1
b1_2 = 1

# two simple effects
# b1 = 5
# b2 = -5
# b1_2 = 0
 
# interaction effect
# b1 = 10
# b2 = 10
# b1_2 = -20

# interaction and simple effect
# b1 = 10
# b2 = 0
# b1_2 = -20

# all three
# b1 = 2
# b2 = 2
# b1_2 = 10

df.data = tibble(
  condition = rep(c(0, 1), each = nsamples),
  treatment = rep(c(0, 1), nsamples),
  rating = b0 + b1 * condition + b2 * treatment + (b1_2 * condition * treatment) + rnorm(nsamples, sd = sd)) %>%
  mutate(condition = factor(condition, labels = c("A", "B")),
  treatment = factor(treatment, labels = c("1", "2")))

ggplot(df.data,
       aes(x = condition,
           y = rating,
           group = treatment,
           fill = treatment)) + 
  stat_summary(fun.y = "mean",
               geom = "bar",
               color = "black",
               position = position_dodge(0.9)) +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               size = 1,
               position = position_dodge(0.9)) +
  scale_fill_brewer(palette = "Set1")
```

<img src="12-linear_model3_files/figure-html/unnamed-chunk-22-1.png" width="672" />

And here is one specific example. Let's generate the data first: 


```r
# make example reproducible 
set.seed(1)

# set parameters
nsamples = 30

b0 = 15
b1 = 10 # simple effect of condition
b2 = 0 # simple effect of treatment
b1_2 = -20 # interaction effect
sd = 5

# generate data
df.data = tibble(
  condition = rep(c(0, 1), each = nsamples),
  treatment = rep(c(0, 1), nsamples),
  rating = b0 + 
    b1 * condition + 
    b2 * treatment + (b1_2 * condition * treatment) + 
    rnorm(nsamples, sd = sd)) %>%
  mutate(condition = factor(condition, labels = c("A", "B")),
  treatment = factor(treatment, labels = c("1", "2")))
```

Show part of the generated data frame: 


```r
# show data frame
df.data %>% 
  group_by(condition, treatment) %>% 
  filter(row_number() < 3) %>% 
  ungroup() %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> condition </th>
   <th style="text-align:left;"> treatment </th>
   <th style="text-align:right;"> rating </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 11.87 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 15.92 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 10.82 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> A </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 22.98 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 21.87 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 5.92 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 20.82 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 12.98 </td>
  </tr>
</tbody>
</table>

Plot the data:


```r
# plot data
ggplot(df.data,
       aes(x = condition,
           y = rating,
           group = treatment,
           fill = treatment)) + 
  stat_summary(fun.y = "mean",
               geom = "bar",
               color = "black",
               position = position_dodge(0.9)) +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               size = 1,
               position = position_dodge(0.9)) +
  scale_fill_brewer(palette = "Set1")
```

<img src="12-linear_model3_files/figure-html/unnamed-chunk-25-1.png" width="672" />

And check whether we can successfully infer the parameters that we used to generate the data: 


```r
# infer parameters
lm(formula = rating ~ 1 + condition + treatment + condition:treatment,
   data = df.data) %>% 
  summary()
```

```
## 
## Call:
## lm(formula = rating ~ 1 + condition + treatment + condition:treatment, 
##     data = df.data)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -10.6546  -3.6343   0.7988   3.3514   8.3953 
## 
## Coefficients:
##                       Estimate Std. Error t value Pr(>|t|)    
## (Intercept)             16.244      1.194  13.608  < 2e-16 ***
## conditionB              10.000      1.688   5.924 2.02e-07 ***
## treatment2              -1.662      1.688  -0.985    0.329    
## conditionB:treatment2  -20.000      2.387  -8.378 1.86e-11 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.623 on 56 degrees of freedom
## Multiple R-squared:  0.7473,	Adjusted R-squared:  0.7338 
## F-statistic: 55.21 on 3 and 56 DF,  p-value: < 2.2e-16
```

## Additional resources 

### Datacamp 

- [Statistical modeling 1](https://www.datacamp.com/courses/statistical-modeling-in-r-part-1)
- [Statistical modeling 2](https://www.datacamp.com/courses/statistical-modeling-in-r-part-2)
- [Correlation and regression](https://www.datacamp.com/courses/correlation-and-regression)

### Misc 

- [Explanation of different types of sums of squares](https://mcfromnz.wordpress.com/2011/03/02/anova-type-iiiiii-ss-explained/)
