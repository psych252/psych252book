# Linear model 4



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")    # for tidying up linear models 
library("afex")    # for running ANOVAs
library("emmeans")    # for calculating constrasts
library("car")    # for calculating ANOVAs
library("tidyverse")  # for wrangling, plotting, etc.
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Load data sets

Read in the data:


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
df.poker.unbalanced = df.poker %>% 
  filter(!participant %in% 1:10)
```

## Variance decomposition in one-way ANOVA

Let's first run the model 


```r
fit = lm(formula = balance ~ hand, 
         data = df.poker)

fit %>%
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

### Calculate sums of squares

And then let's make sure that we understand how the variance is broken down:  


```r
df.poker %>% 
  mutate(mean_grand = mean(balance)) %>% 
  group_by(hand) %>% 
  mutate(mean_group = mean(balance)) %>% 
  ungroup() %>% 
  summarize(variance_total = sum((balance - mean_grand)^2),
            variance_model = sum((mean_group - mean_grand)^2),
            variance_residual = variance_total - variance_model)
```

```
## # A tibble: 1 x 3
##   variance_total variance_model variance_residual
##            <dbl>          <dbl>             <dbl>
## 1          7580.          2559.             5021.
```

### Visualize model predictions 

#### Total variance


```r
set.seed(1)

fit_c = lm(formula = balance ~ 1,
           data = df.poker)

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

<img src="13-linear_model4_files/figure-html/linear-model4-4-1.png" width="672" />

#### Model variance


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

<img src="13-linear_model4_files/figure-html/linear-model4-5-1.png" width="672" />

#### Residual variance 


```r
set.seed(1)

fit_a = lm(formula = balance ~ hand,
           data = df.poker)

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

<img src="13-linear_model4_files/figure-html/linear-model4-6-1.png" width="672" />

## Two-way ANOVA (linear model)

Let's fit the model first:


```r
fit = lm(formula = balance ~ hand + skill, 
         data = df.poker)

fit %>%
  anova()
```

```
## Analysis of Variance Table
## 
## Response: balance
##            Df Sum Sq Mean Sq F value Pr(>F)    
## hand        2 2559.4 1279.70 76.0437 <2e-16 ***
## skill       1   39.3   39.35  2.3383 0.1273    
## Residuals 296 4981.2   16.83                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Calculate sums of squares


```r
df.poker %>% 
  mutate(mean_grand = mean(balance)) %>% 
  group_by(skill) %>% 
  mutate(mean_skill = mean(balance)) %>%
  group_by(hand) %>% 
  mutate(mean_hand = mean(balance)) %>%
  ungroup() %>%
  summarize(variance_total = sum((balance - mean_grand)^2),
            variance_skill = sum((mean_skill - mean_grand)^2),
            variance_hand = sum((mean_hand - mean_grand)^2),
            variance_residual = variance_total - variance_skill - variance_hand)
```

```
## # A tibble: 1 x 4
##   variance_total variance_skill variance_hand variance_residual
##            <dbl>          <dbl>         <dbl>             <dbl>
## 1          7580.           39.3         2559.             4981.
```

### Visualize model predictions

#### `Skill` factor


```r
set.seed(1)

df.plot = df.poker %>% 
  mutate(skill_jitter = skill %>% as.numeric(),
         skill_jitter = skill_jitter + runif(n(), min = -0.4, max = 0.4)) %>% 
  group_by(skill) %>% 
  mutate(mean_group = mean(balance)) %>% 
  ungroup() %>% 
  mutate(mean_grand = mean(balance))
  
df.means = df.poker %>% 
  group_by(skill) %>% 
  summarize(mean = mean(balance)) %>% 
  spread(skill, mean)

ggplot(data = df.plot,
       mapping = aes(x = skill_jitter,
                       y = mean_group,
                       color = skill)) + 
  geom_point(alpha = 0.8) +
  geom_segment(data = NULL,
               aes(x = 0.6,
                   xend = 1.4,
                   y = df.means$average,
                   yend = df.means$average
                   ),
               color = "black",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 1.6,
                   xend = 2.4,
                   y = df.means$expert,
                   yend = df.means$expert
                   ),
               color = "gray50",
               size = 1) +
  geom_segment(aes(xend = skill_jitter,
                   y = mean_group,
                   yend = mean_grand),
               alpha = 0.3) +
  geom_hline(yintercept = mean(df.poker$balance),
             size = 1) + 
  labs(y = "balance") + 
  scale_color_manual(values = c("black", "gray50")) + 
  scale_x_continuous(breaks = 1:2, labels = c("average", "expert")) + 
  scale_y_continuous(breaks = c(0, 10, 20), labels = c(0, 10, 20), limits = c(0, 25)) +
  theme(legend.position = "none",
        axis.title.x = element_blank())
```

<img src="13-linear_model4_files/figure-html/linear-model4-9-1.png" width="672" />

## ANOVA with unbalanced design

For the standard `anova()` function, the order of the independent predictors matters when the design is unbalanced. 


```r
# one order 
lm(formula = balance ~ skill + hand, 
         data = df.poker.unbalanced) %>% 
  anova()
```

```
## Analysis of Variance Table
## 
## Response: balance
##            Df Sum Sq Mean Sq F value  Pr(>F)    
## skill       1   74.3   74.28  4.2904 0.03922 *  
## hand        2 2385.1 1192.57 68.8827 < 2e-16 ***
## Residuals 286 4951.5   17.31                    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
# another order 
lm(formula = balance ~ hand + skill, 
         data = df.poker.unbalanced) %>% 
  anova()
```

```
## Analysis of Variance Table
## 
## Response: balance
##            Df Sum Sq Mean Sq F value Pr(>F)    
## hand        2 2419.8 1209.92 69.8845 <2e-16 ***
## skill       1   39.6   39.59  2.2867 0.1316    
## Residuals 286 4951.5   17.31                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

For unbalanced designs, we should compute an ANOVA with type 3 sums of squares. 


```r
# one order
lm(formula = balance ~ hand + skill,
   data = df.poker,
   contrasts = list(hand = "contr.sum", 
                    skill = "contr.sum")) %>% 
  Anova(type = "3")
```

```
## Anova Table (Type III tests)
## 
## Response: balance
##              Sum Sq  Df   F value Pr(>F)    
## (Intercept) 28644.7   1 1702.1527 <2e-16 ***
## hand         2559.4   2   76.0437 <2e-16 ***
## skill          39.3   1    2.3383 0.1273    
## Residuals    4981.2 296                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
# another order
lm(formula = balance ~ skill + hand,
   data = df.poker,
   contrasts = list(hand = "contr.sum", 
                    skill = "contr.sum")) %>% 
  Anova(type = "3")
```

```
## Anova Table (Type III tests)
## 
## Response: balance
##              Sum Sq  Df   F value Pr(>F)    
## (Intercept) 28644.7   1 1702.1527 <2e-16 ***
## skill          39.3   1    2.3383 0.1273    
## hand         2559.4   2   76.0437 <2e-16 ***
## Residuals    4981.2 296                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Now, the order of the independent variables doesn't matter anymore. 

We can also use the `aov_ez()` function from the `afex` package. 


```r
fit = aov_ez(id = "participant",
             dv = "balance",
             data = df.poker,
             between = c("hand", "skill"))
```

```
## Contrasts set to contr.sum for the following variables: hand, skill
```

```r
fit$Anova
```

```
## Anova Table (Type III tests)
## 
## Response: dv
##              Sum Sq  Df   F value    Pr(>F)    
## (Intercept) 28644.7   1 1772.1137 < 2.2e-16 ***
## hand         2559.4   2   79.1692 < 2.2e-16 ***
## skill          39.3   1    2.4344 0.1197776    
## hand:skill    229.0   2    7.0830 0.0009901 ***
## Residuals    4752.3 294                        
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

## Two-way ANOVA (with interaction)

Let's firt a two-way ANOVA with the interaction term. 


```r
fit = lm(formula = balance ~ hand * skill, data = df.poker)
fit %>% 
  anova()
```

```
## Analysis of Variance Table
## 
## Response: balance
##             Df Sum Sq Mean Sq F value    Pr(>F)    
## hand         2 2559.4 1279.70 79.1692 < 2.2e-16 ***
## skill        1   39.3   39.35  2.4344 0.1197776    
## hand:skill   2  229.0  114.49  7.0830 0.0009901 ***
## Residuals  294 4752.3   16.16                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

And let's compute how the the sums of squares are decomposed:


```r
df.poker %>% 
  mutate(mean_grand = mean(balance)) %>% 
  group_by(skill) %>% 
  mutate(mean_skill = mean(balance)) %>% 
  group_by(hand) %>% 
  mutate(mean_hand = mean(balance)) %>%
  group_by(hand, skill) %>% 
  mutate(mean_hand_skill = mean(balance)) %>%
  ungroup() %>%
  summarize(variance_total = sum((balance - mean_grand)^2),
            variance_skill = sum((mean_skill - mean_grand)^2),
            variance_hand = sum((mean_hand - mean_grand)^2),
            variance_hand_skill = sum((mean_hand_skill - mean_skill - mean_hand + mean_grand)^2),
            variance_residual = variance_total - variance_skill - variance_hand - variance_hand_skill
            )
```

```
## # A tibble: 1 x 5
##   variance_total variance_skill variance_hand variance_hand_s…
##            <dbl>          <dbl>         <dbl>            <dbl>
## 1          7580.           39.3         2559.             229.
## # … with 1 more variable: variance_residual <dbl>
```


## Planned contrasts 

Here is a planned contrast that assumes that there is a linear relationship between the quality of one's hand, and the final balance.  


```r
df.poker = df.poker %>% 
  mutate(hand_contrast = factor(hand,
                                levels = c("bad", "neutral", "good"),
                                labels = c(-1, 0, 1)),
         hand_contrast = hand_contrast %>% as.character() %>% as.numeric())

fit.contrast = lm(formula = balance ~ hand_contrast,
         data = df.poker)

fit.contrast %>% summary()
```

```
## 
## Call:
## lm(formula = balance ~ hand_contrast, data = df.poker)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -13.214  -2.684  -0.019   2.444  15.858 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept)     9.7715     0.2381   41.03   <2e-16 ***
## hand_contrast   3.5424     0.2917   12.14   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.125 on 298 degrees of freedom
## Multiple R-squared:  0.3311,	Adjusted R-squared:  0.3289 
## F-statistic: 147.5 on 1 and 298 DF,  p-value: < 2.2e-16
```

Here is a visualization of the model prediction together with the residuals. 


```r
df.plot = df.poker %>% 
  mutate(hand_jitter = hand %>% as.numeric(),
         hand_jitter = hand_jitter + runif(n(), min = -0.4, max = 0.4))

df.tidy = fit.contrast %>% 
  tidy() %>% 
  select_if(is.numeric) %>% 
  mutate_all(funs(round, .args = list(digits = 2)))

df.augment = fit.contrast %>% 
  augment() %>%
  clean_names() %>% 
  bind_cols(df.plot %>% select(hand_jitter))

ggplot(data = df.plot,
       mapping = aes(x = hand_jitter,
                       y = balance,
                       color = as.factor(hand_contrast))) + 
  geom_point(alpha = 0.8) +
  geom_segment(data = NULL,
               aes(x = 0.6,
                   xend = 1.4,
                   y = df.tidy$estimate[1]-df.tidy$estimate[2],
                   yend = df.tidy$estimate[1]-df.tidy$estimate[2]
                   ),
               color = "red",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 1.6,
                   xend = 2.4,
                   y = df.tidy$estimate[1],
                   yend = df.tidy$estimate[1]
                   ),
               color = "orange",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 2.6,
                   xend = 3.4,
                   y = df.tidy$estimate[1] + df.tidy$estimate[2],
                   yend = df.tidy$estimate[1] + df.tidy$estimate[2]
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

<img src="13-linear_model4_files/figure-html/linear-model4-16-1.png" width="672" />

### Hypothetical data 

Here is some code to generate a hypothetical developmental data set. 


```r
# make example reproducible 
set.seed(1)

# means = c(5, 10, 5)
means = c(3, 5, 20)
# means = c(3, 5, 7)
# means = c(3, 7, 12)
sd = 2
sample_size = 20

# generate data 
df.contrast = tibble(
  group = rep(c("3-4", "5-6", "7-8"), each = sample_size),
  performance = NA) %>% 
  mutate(performance = ifelse(group == "3-4",
                              rnorm(sample_size,
                                    mean = means[1],
                                    sd = sd),
                              performance),
         performance = ifelse(group == "5-6",
                              rnorm(sample_size,
                                    mean = means[2],
                                    sd = sd),
                              performance),
         performance = ifelse(group == "7-8",
                              rnorm(sample_size,
                                    mean = means[3],
                                    sd = sd),
                              performance),
         group = factor(group, levels = c("3-4", "5-6", "7-8")),
         group_contrast = group %>% 
           fct_recode(`-1` = "3-4",
                      `0` = "5-6",
                      `1` = "7-8") %>% 
           as.character() %>%
           as.numeric())
```

Let's define a linear contrast, and test whether it's significant. 


```r
fit = lm(formula = performance ~ group,
   data = df.contrast)

# define the contrasts of interest 
contrasts = list(linear = c(-1, 0, 1))

# compute estimated marginal means
leastsquare = emmeans(fit, "group")

# run follow-up analyses
contrast(leastsquare,
         contrasts,
         adjust = "bonferroni")
```

```
##  contrast estimate    SE df t.ratio p.value
##  linear       16.9 0.548 57 30.856  <.0001
```

### Visualization

Total variance: 


```r
set.seed(1)

fit_c = lm(formula = performance ~ 1,
           data = df.contrast)

df.plot = df.contrast %>% 
  mutate(group_jitter = 1 + runif(n(), min = -0.25, max = 0.25))

df.augment = fit_c %>% 
  augment() %>% 
  clean_names() %>% 
  bind_cols(df.plot %>% select(performance, group, group_jitter))

ggplot(data = df.plot, 
       mapping = aes(x = group_jitter,
                       y = performance,
                       fill = group)) + 
  geom_hline(yintercept = mean(df.contrast$performance)) +
  geom_point(alpha = 0.5) + 
  geom_segment(data = df.augment,
               aes(xend = group_jitter,
                   yend = fitted),
               alpha = 0.2) +
  labs(y = "performance") + 
  theme(legend.position = "none",
        axis.text.x = element_blank(),
        axis.title.x = element_blank())
```

<img src="13-linear_model4_files/figure-html/linear-model4-19-1.png" width="672" />

With contrast


```r
# make example reproducible 
set.seed(1)

fit = lm(formula = performance ~ group_contrast,
         data = df.contrast)

df.plot = df.contrast %>% 
  mutate(group_jitter = group %>% as.numeric(),
         group_jitter = group_jitter + runif(n(), min = -0.4, max = 0.4))

df.tidy = fit %>% 
  tidy() %>% 
  select_if(is.numeric) %>% 
  mutate_all(funs(round, .args = list(digits = 2)))

df.augment = fit %>% 
  augment() %>%
  clean_names() %>% 
  bind_cols(df.plot %>% select(group_jitter, group_contrast))

ggplot(data = df.plot,
       mapping = aes(x = group_jitter,
                       y = performance,
                       color = as.factor(group_contrast))) + 
  geom_point(alpha = 0.8) +
  geom_segment(data = NULL,
               aes(x = 0.6,
                   xend = 1.4,
                   y = df.tidy$estimate[1]-df.tidy$estimate[2],
                   yend = df.tidy$estimate[1]-df.tidy$estimate[2]
                   ),
               color = "red",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 1.6,
                   xend = 2.4,
                   y = df.tidy$estimate[1],
                   yend = df.tidy$estimate[1]
                   ),
               color = "orange",
               size = 1) +
  geom_segment(data = NULL,
               aes(x = 2.6,
                   xend = 3.4,
                   y = df.tidy$estimate[1] + df.tidy$estimate[2],
                   yend = df.tidy$estimate[1] + df.tidy$estimate[2]
                   ),
               color = "green",
               size = 1) +
  geom_segment(data = df.augment,
               aes(xend = group_jitter,
                   y = performance,
                   yend = fitted),
               alpha = 0.3) +
  labs(y = "balance") + 
  scale_color_manual(values = c("red", "orange", "green")) + 
  scale_x_continuous(breaks = 1:3, labels = levels(df.contrast$group)) +
  theme(legend.position = "none",
        axis.title.x = element_blank())
```

<img src="13-linear_model4_files/figure-html/linear-model4-20-1.png" width="672" />

Results figure


```r
df.contrast %>% 
  ggplot(aes(x = group, y = performance)) + 
  geom_point(alpha = 0.3, position = position_jitter(width = 0.1, height = 0)) +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange", size = 1) + 
  stat_summary(fun.y = "mean", geom = "point", shape = 21, fill = "white", size = 3)
```

<img src="13-linear_model4_files/figure-html/linear-model4-21-1.png" width="672" />

### Constrasts 

Estimated marginal means: 


```r
df.development = df.contrast

fit = lm(formula = performance ~ group,
         data = df.development)

# check factor levels 
levels(df.development$group)
```

```
## [1] "3-4" "5-6" "7-8"
```

```r
# define the contrasts of interest 
contrasts = list(young_vs_old = c(-0.5, -0.5, 1),
                 three_vs_five = c(-1, 1, 0))

# compute estimated marginal means
leastsquare = emmeans(fit, "group")

# run analyses
contrast(leastsquare,
         contrasts,
         adjust = "bonferroni")
```

```
##  contrast      estimate    SE df t.ratio p.value
##  young_vs_old     16.09 0.474 57 33.936  <.0001 
##  three_vs_five     1.61 0.548 57  2.933  0.0097 
## 
## P value adjustment: bonferroni method for 2 tests
```

### Post-hoc tests

Post-hoc tests for a single predictor:


```r
fit = lm(formula = performance ~ group,
         data = df.development)

# post hoc tests 
leastsquare = emmeans(fit, "group")
pairs(leastsquare,
      adjust = "bonferroni")
```

```
##  contrast  estimate    SE df t.ratio p.value
##  3-4 - 5-6    -1.61 0.548 57  -2.933 0.0145 
##  3-4 - 7-8   -16.90 0.548 57 -30.856 <.0001 
##  5-6 - 7-8   -15.29 0.548 57 -27.923 <.0001 
## 
## P value adjustment: bonferroni method for 3 tests
```

Post-hoc tests for two predictors:


```r
# fit the model
fit = lm(formula = balance ~ hand + skill,
         data = df.poker)

# post hoc tests 
leastsquare = emmeans(fit, c("hand", "skill"))
pairs(leastsquare,
      adjust = "bonferroni")
```

```
##  contrast                         estimate    SE  df t.ratio p.value
##  bad,average - neutral,average      -4.405 0.580 296  -7.593 <.0001 
##  bad,average - good,average         -7.085 0.580 296 -12.212 <.0001 
##  bad,average - bad,expert           -0.724 0.474 296  -1.529 1.0000 
##  bad,average - neutral,expert       -5.129 0.749 296  -6.849 <.0001 
##  bad,average - good,expert          -7.809 0.749 296 -10.427 <.0001 
##  neutral,average - good,average     -2.680 0.580 296  -4.619 0.0001 
##  neutral,average - bad,expert        3.681 0.749 296   4.914 <.0001 
##  neutral,average - neutral,expert   -0.724 0.474 296  -1.529 1.0000 
##  neutral,average - good,expert      -3.404 0.749 296  -4.545 0.0001 
##  good,average - bad,expert           6.361 0.749 296   8.492 <.0001 
##  good,average - neutral,expert       1.955 0.749 296   2.611 0.1424 
##  good,average - good,expert         -0.724 0.474 296  -1.529 1.0000 
##  bad,expert - neutral,expert        -4.405 0.580 296  -7.593 <.0001 
##  bad,expert - good,expert           -7.085 0.580 296 -12.212 <.0001 
##  neutral,expert - good,expert       -2.680 0.580 296  -4.619 0.0001 
## 
## P value adjustment: bonferroni method for 15 tests
```
