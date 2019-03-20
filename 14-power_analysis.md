# Power analysis



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")      # for tidying up model fits
library("magrittr")   # for going all in with the pipe
library("lsr")        # for computing effect size measures
library("pwr")        # for power calculations
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

## Load data sets 


```r
df.poker = read_csv("data/poker.csv")
```

```
Parsed with column specification:
cols(
  skill = col_double(),
  hand = col_double(),
  limit = col_double(),
  balance = col_double()
)
```

```r
df.credit = read_csv("data/credit.csv") %>% 
  rename(index = X1) %>% 
  clean_names()
```

```
Warning: Missing column names filled in: 'X1' [1]
```

```
Parsed with column specification:
cols(
  X1 = col_double(),
  Income = col_double(),
  Limit = col_double(),
  Rating = col_double(),
  Cards = col_double(),
  Age = col_double(),
  Education = col_double(),
  Gender = col_character(),
  Student = col_character(),
  Married = col_character(),
  Ethnicity = col_character(),
  Balance = col_double()
)
```

## Decision-making 

Figures to illustrate power: 


```r
mu0 = 10
mu1 = 18
# mu0 = 8
# mu1 = 20
# sd0 = 3
# sd1 = 3
sd0 = 2
sd1 = 2
alpha = 0.05
# alpha = 0.01

ggplot(data = tibble(x = c(0, 30)),
       mapping = aes(x = x)) + 
  stat_function(fun = "dnorm",
                size = 1,
                color = "blue",
                args = list(mean = mu0,
                            sd = sd0)) +
  stat_function(fun = "dnorm",
                size = 1,
                color = "red",
                args = list(mean = mu1,
                            sd = sd1)) +
  stat_function(fun = "dnorm",
                geom = "area",
                size = 1,
                fill = "blue",
                alpha = 0.5,
                args = list(mean = mu0,
                            sd = sd0),
                xlim = c(qnorm(1-alpha, mean = mu0, sd = sd0), 20)
                ) +
  stat_function(fun = "dnorm",
                geom = "area",
                size = 1,
                fill = "red",
                alpha = 0.5,
                args = list(mean = mu1,
                            sd = sd1),
                xlim = c(0, c(qnorm(1-alpha, mean = mu0, sd = sd0)))
                ) +
  geom_vline(xintercept = qnorm(1-alpha, mean = mu0, sd = sd0),
             size = 1) +
  coord_cartesian(expand = F)
```

<img src="14-power_analysis_files/figure-html/power-analysis-05-1.png" width="672" />

## Effect sizes

### eta-squared and partial eta-squared

One-way ANOVA: 


```r
fit = lm(formula = balance ~ hand, 
         data = df.poker)

# use function
etaSquared(fit)

# compute by hand 
fit %>% 
  anova %>% 
  tidy() %>% 
  pull(sumsq) %>% 
  divide_by(sum(.)) %>% 
  magrittr::extract(1)
```

```
        eta.sq eta.sq.part
hand 0.3311076   0.3311076
[1] 0.3311076
```

Two-way ANOVA: 


```r
fit = lm(formula = balance ~ hand * skill, 
         data = df.poker)

# use function
etaSquared(fit)

# compute by hand 
eta_squared = fit %>% 
  anova %>% 
  tidy() %>% 
  pull(sumsq) %>% 
  divide_by(sum(.)) %>% 
  magrittr::extract(1)

# compute partial eta squared by hand
eta_partial_squared = fit %>% 
  anova %>% 
  tidy() %>% 
  filter(term %in% c("hand","Residuals")) %>% 
  select(term, sumsq) %>% 
  spread(term, sumsq) %>% 
  summarize(eta_partial_squared = hand / (hand + Residuals)) %>% 
  pull(eta_partial_squared)
```

```
                eta.sq eta.sq.part
hand       0.331107585 0.343119717
skill      0.005191225 0.008123029
hand:skill 0.029817351 0.044925866
```

### Cohen's d

Cohen's $d$ is defined as: 

$$
d = \frac{\overline y_1 - \overline y_2}{s_p}
$$

where

$$
s_p = \sqrt\frac{(n_1-1)s_1^2 + (n_2-1)s_2^2}{n_1 + n_2 - 2}
$$



```r
# use function from "lsr" package
cohensD(x = balance ~ student,
        data = df.credit)

# compute by hand
df.cohen = df.credit %>% 
  group_by(student) %>% 
  summarize(mean = mean(balance),
            var = var(balance),
            n = n()) %>% 
  ungroup()

n1 = df.cohen$n[1]
n2 = df.cohen$n[2]
var1 = df.cohen$var[1]
var2 = df.cohen$var[2]
mean1 = df.cohen$mean[1]
mean2 = df.cohen$mean[2]

sp = sqrt(((n1 - 1) * var1 + (n2 - 1) * var2) / (n1 + n2 - 2))

d = abs(mean1 - mean2) / sp
print(d)
```

```
[1] 0.8916607
[1] 0.8916607
```

## Determining sample size 

### `pwr` package


```r
pwr.p.test(h = ES.h(p1 = 0.75, p2 = 0.50), 
           sig.level = 0.05, 
           power = 0.80, 
           alternative = "greater")
```

```

     proportion power calculation for binomial distribution (arcsine transformation) 

              h = 0.5235988
              n = 22.55126
      sig.level = 0.05
          power = 0.8
    alternative = greater
```


```r
pwr.p.test(h = ES.h(p1 = 0.75, p2 = 0.50), 
           sig.level = 0.05, 
           power = 0.80, 
           alternative = "greater") %>% 
  plot() +
  theme(title = element_text(size = 16))
```

<img src="14-power_analysis_files/figure-html/power-analysis-10-1.png" width="672" />

### Simulation


```r
# make reproducible 
set.seed(1)

# number of simulations
n_simulations = 100

# run simulation
df.power = crossing(n = seq(10, 50, 1),
                    simulation = 1:n_simulations,
                    p = c(0.75, 0.8, 0.85)) %>%
  mutate(index = 1:n()) %>% # add an index column
  group_by(index, n, simulation) %>% 
  mutate(response = rbinom(n = n(), size = n, prob = p)) %>% # generate random data
  group_by(index, simulation, p) %>% 
  nest() %>% # put data in list column
  mutate(fit = map(data, 
                   ~ binom.test(x = .$response, # define formula
                          n = .$n,
                          p = 0.5,
                          alternative = "two.sided")),
         p.value = map_dbl(fit, ~ .$p.value)) %>% # run binomial test and extract p-value
  unnest(data) %>% 
  select(-fit)

# data frame for plot   
df.plot = df.power %>% 
  group_by(n, p) %>% 
  summarize(power = sum(p.value < 0.05) / n()) %>% 
  ungroup() %>% 
  mutate(p = as.factor(p))

# plot data 
ggplot(data = df.plot, 
       mapping = aes(x = n, y = power, color = p, group = p)) +
  geom_smooth(method = "loess")

# based on simulations
df.plot %>%
  filter(p == 0.75, near(power, 0.8, tol = 0.02))
  
 
# analytic solution
pwr.p.test(h = ES.h(0.5, 0.75),
           power = 0.8,
           alternative = "two.sided")
```

```
# A tibble: 0 x 3
# … with 3 variables: n <dbl>, p <fct>, power <dbl>

     proportion power calculation for binomial distribution (arcsine transformation) 

              h = 0.5235988
              n = 28.62923
      sig.level = 0.05
          power = 0.8
    alternative = two.sided
```

<img src="14-power_analysis_files/figure-html/power-analysis-11-1.png" width="672" />

## Additional resources 

- [Getting started with `pwr`](https://cran.r-project.org/web/packages/pwr/vignettes/pwr-vignette.html)
- [Visualize power](https://rpsychologist.com/d3/NHST/)
- [Calculating and reporting effect sizes to facilitate cumulative science: a practical primer for t-tests and ANOVAs](https://www.frontiersin.org/articles/10.3389/fpsyg.2013.00863/full)

