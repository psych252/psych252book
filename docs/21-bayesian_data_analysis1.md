# Bayesian data analysis 1

In this lecture, we did not perform any Bayesian data analysis. I discussed the costs and benefits of Bayesian analysis and introduced the Bayesian model of multi-modal integration based on the Plinko task. 

## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("modelr")     # for permutation test 
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Things that came up 

### Bias in Cosyne 2019 conference admission? 

Code up the data: 


```r
# data frame 
df.conference = tibble(sex = rep(c("female", "male"), c(264, 677)),
  accepted = rep(c("yes", "no", "yes", "no"), c(83, 264 - 83, 255, 677 - 255))) %>%
  mutate(accepted = factor(accepted, levels = c("no", "yes"), labels = 0:1),
    sex = as.factor(sex))
```

Visualize the results: 


```r
df.conference %>% 
  ggplot(data = .,
         mapping = aes(x = sex, fill = accepted)) + 
  geom_bar(color = "black") + 
  scale_fill_brewer(palette = "Set1") +
  coord_flip() +
  theme(legend.direction = "horizontal",
        legend.position = "top") + 
  guides(fill = guide_legend(reverse = T))
```

<img src="21-bayesian_data_analysis1_files/figure-html/bda1-04-1.png" width="672" />

Run a logistic regression with one binary predictor (Binomial test):


```r
# logistic regression
fit.glm = glm(formula = accepted ~ 1 + sex,
              family = "binomial",
              data = df.conference)

# model summary 
fit.glm %>% 
  summary()
```

```
## 
## Call:
## glm(formula = accepted ~ 1 + sex, family = "binomial", data = df.conference)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -0.9723  -0.9723  -0.8689   1.3974   1.5213  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -0.7797     0.1326  -5.881 4.07e-09 ***
## sexmale       0.2759     0.1545   1.786   0.0741 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1228.9  on 940  degrees of freedom
## Residual deviance: 1225.6  on 939  degrees of freedom
## AIC: 1229.6
## 
## Number of Fisher Scoring iterations: 4
```

The results of the logistic regression are not quite significant (at least when considering a two-tailed test) with $p = .0741$. 

Let's run a permutation test (as suggested by the tweet I showed in class):


```r
# make example reproducible 
set.seed(1)

# difference in proportion 
fun.difference = function(df){
  df %>% 
    as_tibble() %>% 
    count(sex, accepted) %>% 
    group_by(sex) %>% 
    mutate(proportion = n / sum(n)) %>% 
    filter(accepted == 1) %>% 
    select(sex, proportion) %>% 
    spread(sex, proportion) %>% 
    mutate(difference = male - female) %>% 
    pull(difference)  
}

# actual difference 
difference = df.conference %>% 
  fun.difference()

# permutation test 
df.permutation = df.conference %>% 
  permute(n = 1000, sex) %>% 
  mutate(difference = map_dbl(perm, ~ fun.difference(.)))
```

Let's calculate the p-value based on the permutation test: 


```r
sum(df.permutation$difference > difference) / nrow(df.permutation)
```

```
## [1] 0.026
```

And let's visualize the result (showing our observed value and comparing it to the sampling distribution under the null hypothesis):  


```r
df.permutation %>% 
  ggplot(data = .,
         mapping = aes(x = difference)) +
  stat_density(geom = "line") + 
  geom_vline(xintercept = difference, 
             color = "red",
              size = 1)
```

<img src="21-bayesian_data_analysis1_files/figure-html/bda1-08-1.png" width="672" />
