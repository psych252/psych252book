# Probability and causality

## Load packages 

Let's first load the packages that we need for this chapter (just use `install.packages()` to install any packages you don't have yet). 


```r
library("knitr")        # for rendering the RMarkdown file
library("kableExtra")   # for nicely formatted tables
library("arrangements") # fast generators and iterators for permutations, combinations and partitions
library("DiagrammeR")   # for drawing diagrams
library("tidyverse")    # for data wrangling 
```

## Counting 

Imagine that there are three balls in an urn. The balls are labeled 1, 2, and 3. Let's consider a few possible situations. 


```r
library("arrangements") # fast generators and iterators for permutations, combinations and partitions
balls = 1:3 # number of balls in urn 
ndraws = 2 # number of draws

# order matters, without replacement
permutations(balls, ndraws)
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    1    3
## [3,]    2    1
## [4,]    2    3
## [5,]    3    1
## [6,]    3    2
```

```r
# order matters, with replacement
permutations(balls, ndraws, replace = T)
```

```
##       [,1] [,2]
##  [1,]    1    1
##  [2,]    1    2
##  [3,]    1    3
##  [4,]    2    1
##  [5,]    2    2
##  [6,]    2    3
##  [7,]    3    1
##  [8,]    3    2
##  [9,]    3    3
```

```r
# order doesn't matter, with replacement 
combinations(balls, ndraws, replace = T)
```

```
##      [,1] [,2]
## [1,]    1    1
## [2,]    1    2
## [3,]    1    3
## [4,]    2    2
## [5,]    2    3
## [6,]    3    3
```

```r
# order doesn't matter, without replacement 
combinations(balls, ndraws)
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    1    3
## [3,]    2    3
```

I've generated the figures below using the `DiagrammeR` package. It's a powerful package for drawing diagrams in R. See information on how to use the DiagrammeR package [here](http://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html). 

![(\#fig:probability-3)Drawing two marbles out of an urn __with__ replacement.](06-probability_files/figure-latex/probability-3-1.pdf) 

![(\#fig:probability-4)Drawing two marbles out of an urn __without__ replacement.](06-probability_files/figure-latex/probability-4-1.pdf) 

## Flipping a coin many times 


```r
# Example taken from here: http://statsthinking21.org/probability.html#empirical-frequency

set.seed(1) # set the seed so that the outcome is consistent
nsamples = 50000 # how many flips do we want to make?

# create some random coin flips using the rbinom() function with
# a true probability of 0.5

df.samples = tibble(
  trial_number = seq(nsamples), 
  outcomes = rbinom(nsamples, 1, 0.5)) %>% 
  mutate(mean_probability = cumsum(outcomes) / seq_along(outcomes)) %>% 
  filter(trial_number >= 10) # start with a minimum sample of 10 flips

ggplot(data = df.samples, 
       mapping = aes(x = trial_number, y = mean_probability)) +
  geom_hline(yintercept = 0.5, color = "gray", linetype = "dashed") +
  geom_line() +
  labs(
    x = "Number of trials",
    y = "Estimated probability of heads"
  )+
  theme_classic()+
  theme(text = element_text(size = 20))
```

![(\#fig:probability-5)A demonstration of the law of large numbers.](06-probability_files/figure-latex/probability-5-1.pdf) 

## Clue guide to probability 


```r
who = c("ms_scarlet", "col_mustard", "mrs_white",
        "mr_green", "mrs_peacock", "prof_plum")
what = c("candlestick", "knife", "lead_pipe",
         "revolver", "rope", "wrench")
where = c("study", "kitchen", "conservatory",
          "lounge", "billiard_room", "hall",
          "dining_room", "ballroom", "library")

df.clue = expand.grid(who = who,
                      what = what,
                      where = where) %>% 
  as_tibble()

df.suspects = df.clue %>% 
  distinct(who) %>% 
  mutate(gender = ifelse(
    test = who %in% c("ms_scarlet", "mrs_white", "mrs_peacock"), 
    yes = "female", 
    no = "male")
  )
```


```r
df.suspects %>% 
  arrange(desc(gender)) %>% 
  kable() %>% 
  kable_styling("striped", full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{l|l}
\hline
who & gender\\
\hline
col\_mustard & male\\
\hline
mr\_green & male\\
\hline
prof\_plum & male\\
\hline
ms\_scarlet & female\\
\hline
mrs\_white & female\\
\hline
mrs\_peacock & female\\
\hline
\end{tabular}
\end{table}

### Conditional probability 


```r
# conditional probability (via rules of probability)
df.suspects %>% 
  summarize(p_prof_plum_given_male = 
              sum(gender == "male" & who == "prof_plum") /
              sum(gender == "male"))
```

```
## # A tibble: 1 x 1
##   p_prof_plum_given_male
##                    <dbl>
## 1                  0.333
```

```r
# conditional probability (via rejection)
df.suspects %>% 
  filter(gender == "male") %>% 
  summarize(p_prof_plum_given_male = 
              sum(who == "prof_plum") /
              n())
```

```
## # A tibble: 1 x 1
##   p_prof_plum_given_male
##                    <dbl>
## 1                  0.333
```

### Law of total probability

![](06-probability_files/figure-latex/probability-10-1.pdf)<!-- --> 

## Probability operations 


```r
# Make a deck of cards 
df.cards = tibble(
  suit = rep(c("Clubs", "Spades", "Hearts", "Diamonds"), each = 8),
  value = rep(c("7", "8", "9", "10", "Jack", "Queen", "King", "Ace"), 4)
) 
```


```r
# conditional probability: p(Hearts | Queen) (via rules of probability)
df.cards %>% 
  summarize(p_hearts_given_queen = 
              sum(suit == "Hearts" & value == "Queen") / 
              sum(value == "Queen"))
```

```
## # A tibble: 1 x 1
##   p_hearts_given_queen
##                  <dbl>
## 1                 0.25
```


```r
# conditional probability: p(Hearts | Queen) (via rejection)
df.cards %>% 
  filter(value == "Queen") %>%
  summarize(p_hearts_given_queen = sum(suit == "Hearts")/n())
```

```
## # A tibble: 1 x 1
##   p_hearts_given_queen
##                  <dbl>
## 1                 0.25
```

## Bayesian reasoning example

![](06-probability_files/figure-latex/probability-14-1.pdf)<!-- --> 

## Bayesian networks 

### Sprinkler example

![](06-probability_files/figure-latex/probability-15-1.pdf)<!-- --> 


```r
# cloudy 
df.cloudy = tibble(
  `p(C)` = 0.5
)

df.cloudy %>% 
  kable() %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F,
                font_size = 20)
```

\begin{table}[H]
\centering\begingroup\fontsize{20}{22}\selectfont

\begin{tabular}{r}
\hline
p(C)\\
\hline
0.5\\
\hline
\end{tabular}
\endgroup{}
\end{table}

```r
# sprinkler given cloudy 
df.sprinkler_given_cloudy = tibble(
  C = c("F", "T"),
  `p(S)`= c(0.5, 0.1)
)

df.sprinkler_given_cloudy %>% 
  kable() %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F,
                font_size = 20)
```

\begin{table}[H]
\centering\begingroup\fontsize{20}{22}\selectfont

\begin{tabular}{l|r}
\hline
C & p(S)\\
\hline
F & 0.5\\
\hline
T & 0.1\\
\hline
\end{tabular}
\endgroup{}
\end{table}

```r
# rain given cloudy 
df.rain_given_cloudy = tibble(
  C = c("F", "T"),
  `p(R)`= c(0.2, 0.8)
)

df.rain_given_cloudy %>% 
  kable() %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F,
                font_size = 20)
```

\begin{table}[H]
\centering\begingroup\fontsize{20}{22}\selectfont

\begin{tabular}{l|r}
\hline
C & p(R)\\
\hline
F & 0.2\\
\hline
T & 0.8\\
\hline
\end{tabular}
\endgroup{}
\end{table}

```r
# wet given sprinkler and rain  
df.rain_given_sprinkler_and_rain = tibble(
  S = rep(c("F", "T"), 2),
  R = rep(c("F", "T"), each = 2),
  `p(W)`= c(0, 0.9, 0.9, 0.99)
)

df.rain_given_sprinkler_and_rain %>% 
  kable() %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F,
                font_size = 20)
```

\begin{table}[H]
\centering\begingroup\fontsize{20}{22}\selectfont

\begin{tabular}{l|l|r}
\hline
S & R & p(W)\\
\hline
F & F & 0.00\\
\hline
T & F & 0.90\\
\hline
F & T & 0.90\\
\hline
T & T & 0.99\\
\hline
\end{tabular}
\endgroup{}
\end{table}

## Additional resources 

### Cheatsheets 

- [Probability cheatsheet](figures/probability.pdf)

### Books and chapters

- [Probability and Statistics with examples using R](http://www.isibang.ac.in/~athreya/psweur/)
- [Learning statistics with R: Chapter 9 Introduction to probability](https://learningstatisticswithr-bookdown.netlify.com/probability.html#probstats)

### Misc 

- [Statistics 110: Probability; course at Harvard](https://projects.iq.harvard.edu/stat110)  
