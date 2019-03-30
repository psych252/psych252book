# Probability and causality

## Load packages 

Let's first load the packages that we need for this chapter (just use `install.packages()` to install any packages you don't have yet). 


```r
library("knitr")        # for rendering the RMarkdown file
library("kableExtra")   # for nicely formatted tables
library("arrangements") # fast generators and iterators for permutations, combinations and partitions
library("DiagrammeR")   # for drawing diagrams
library("tidyverse")    # for data wrangling 

opts_chunk$set(
  comment = "",
  results = "hold",
  fig.show = "hold"
)
```

## Counting 

Imagine that there are three balls in an urn. The balls are labeled 1, 2, and 3. Let's consider a few possible situations. 


```r
balls = 1:3 # number of balls in urn 
ndraws = 2 # number of draws

# order matters, without replacement
permutations(balls, ndraws)

# order matters, with replacement
permutations(balls, ndraws, replace = T)

# order doesn't matter, with replacement 
combinations(balls, ndraws, replace = T)

# order doesn't matter, without replacement 
combinations(balls, ndraws)
```

```
     [,1] [,2]
[1,]    1    2
[2,]    1    3
[3,]    2    1
[4,]    2    3
[5,]    3    1
[6,]    3    2
      [,1] [,2]
 [1,]    1    1
 [2,]    1    2
 [3,]    1    3
 [4,]    2    1
 [5,]    2    2
 [6,]    2    3
 [7,]    3    1
 [8,]    3    2
 [9,]    3    3
     [,1] [,2]
[1,]    1    1
[2,]    1    2
[3,]    1    3
[4,]    2    2
[5,]    2    3
[6,]    3    3
     [,1] [,2]
[1,]    1    2
[2,]    1    3
[3,]    2    3
```

I've generated the figures below using the `DiagrammeR` package. It's a powerful package for drawing diagrams in R. See information on how to use the DiagrammeR package [here](http://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html). 

<div class="figure">
<!--html_preserve--><div id="htmlwidget-fe723ca412462cd8e6c6" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-fe723ca412462cd8e6c6">{"x":{"diagram":"\ndigraph dot{\n  \n  # general settings for all nodes\n  node [\n    shape = circle,\n    style = filled,\n    color = black,\n    label = \"\"\n    fontname = \"Helvetica\",\n    fontsize = 24,\n    fillcolor = lightblue\n    ]\n  \n  # edges between nodes\n  edge [color = black]\n  0 -> {1 2 3}\n  1 -> {11 12 13}\n  2 -> {21 22 23}\n  3 -> {31 32 33}\n  \n  # labels for each node\n  0 [fillcolor = \"black\", width = 0.1]\n  1 [label = \"1\"]\n  2 [label = \"2\"]\n  3 [label = \"3\"]\n  11 [label = \"1\"]\n  12 [label = \"2\"]\n  13 [label = \"3\"]\n  21 [label = \"1\"]\n  22 [label = \"2\"]\n  23 [label = \"3\"]\n  31 [label = \"1\"]\n  32 [label = \"2\"]\n  33 [label = \"3\"]\n    \n  # direction in which arrows are drawn (from left to right)\n  rankdir = LR\n}\n","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:probability-3)Drawing two marbles out of an urn __with__ replacement.</p>
</div>

<div class="figure">
<!--html_preserve--><div id="htmlwidget-f7adfb21de4b69ebdf1b" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-f7adfb21de4b69ebdf1b">{"x":{"diagram":"\ndigraph dot{\n  \n  # general settings for all nodes\n  node [\n    shape = circle,\n    style = filled,\n    color = black,\n    label = \"\"\n    fontname = \"Helvetica\",\n    fontsize = 24,\n    fillcolor = lightblue\n    ]\n  \n  # edges between nodes\n  edge [color = black]\n  0 -> {1 2 3}\n  1 -> {12 13}\n  2 -> {21 23}\n  3 -> {31 32}\n  \n  # labels for each node\n  0 [fillcolor = \"black\", width = 0.1]\n  1 [label = \"1\"]\n  2 [label = \"2\"]\n  3 [label = \"3\"]\n  12 [label = \"2\"]\n  13 [label = \"3\"]\n  21 [label = \"1\"]\n  23 [label = \"3\"]\n  31 [label = \"1\"]\n  32 [label = \"2\"]\n  \n  # direction in which arrows are drawn (from left to right)\n  rankdir = LR\n}\n","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:probability-4)Drawing two marbles out of an urn __without__ replacement.</p>
</div>

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

<div class="figure">
<img src="06-probability_files/figure-html/probability-5-1.png" alt="A demonstration of the law of large numbers." width="672" />
<p class="caption">(\#fig:probability-5)A demonstration of the law of large numbers.</p>
</div>

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

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> who </th>
   <th style="text-align:left;"> gender </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> col_mustard </td>
   <td style="text-align:left;"> male </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mr_green </td>
   <td style="text-align:left;"> male </td>
  </tr>
  <tr>
   <td style="text-align:left;"> prof_plum </td>
   <td style="text-align:left;"> male </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ms_scarlet </td>
   <td style="text-align:left;"> female </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mrs_white </td>
   <td style="text-align:left;"> female </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mrs_peacock </td>
   <td style="text-align:left;"> female </td>
  </tr>
</tbody>
</table>

### Conditional probability 


```r
# conditional probability (via rules of probability)
df.suspects %>% 
  summarize(p_prof_plum_given_male = 
              sum(gender == "male" & who == "prof_plum") /
              sum(gender == "male"))
```

```
# A tibble: 1 x 1
  p_prof_plum_given_male
                   <dbl>
1                  0.333
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
# A tibble: 1 x 1
  p_prof_plum_given_male
                   <dbl>
1                  0.333
```

### Law of total probability

<!--html_preserve--><div id="htmlwidget-272085ef344c8098d1cd" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-272085ef344c8098d1cd">{"x":{"diagram":"\ndigraph dot{\n  \n  # general settings for all nodes\n  node [\n    shape = circle,\n    style = filled,\n    color = black,\n    label = \"\"\n    fontname = \"Helvetica\",\n    fontsize = 9,\n    fillcolor = lightblue,\n    fixedsize=true,\n    width = 0.8\n    ]\n  \n  # edges between nodes\n  edge [color = black,\n        fontname = \"Helvetica\",\n        fontsize = 10]\n  1 -> 2 [label = \"p(female)\"]\n  1 -> 3 [label = \"p(male)\"]\n  2 -> 4 [label = \"p(revolver | female)\"] \n  3 -> 4 [label = \"p(revolver | male)\"]\n  \n  \n\n  # labels for each node\n  1 [label = \"Gender?\"]\n  2 [label = \"If female\nuse revolver?\"]\n  3 [label = \"If male\nuse revolver?\"]\n  4 [label = \"Revolver\nused?\"]\n  \n  rankdir=\"LR\"\n  }","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

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
# A tibble: 1 x 1
  p_hearts_given_queen
                 <dbl>
1                 0.25
```


```r
# conditional probability: p(Hearts | Queen) (via rejection)
df.cards %>% 
  filter(value == "Queen") %>%
  summarize(p_hearts_given_queen = sum(suit == "Hearts")/n())
```

```
# A tibble: 1 x 1
  p_hearts_given_queen
                 <dbl>
1                 0.25
```

## Bayesian reasoning example

<!--html_preserve--><div id="htmlwidget-c94cfa8fd4ccaeaa1e53" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-c94cfa8fd4ccaeaa1e53">{"x":{"diagram":"\ndigraph dot{\n  \n  # general settings for all nodes\n  node [\n    shape = circle,\n    style = filled,\n    color = black,\n    label = \"\"\n    fontname = \"Helvetica\",\n    fontsize = 10,\n    fillcolor = lightblue,\n    fixedsize=true,\n    width = 0.8\n    ]\n  \n  # edges between nodes\n  edge [color = black,\n        fontname = \"Helvetica\",\n        fontsize = 10]\n  1 -> 2 [label = \"ill\"]\n  1 -> 3 [label = \"healthy\"]\n  2 -> 4 [label = \"test +\"] \n  2 -> 5 [label = \"test -\"]\n  3 -> 6 [label = \"test +\"]\n  3 -> 7 [label = \"test -\"]\n  \n\n  # labels for each node\n  1 [label = \"10000\npeople\"]\n  2 [label = \"100\"]\n  3 [label = \"9900\"]\n  4 [label = \"95\"]\n  5 [label = \"5\"]\n  6 [label = \"495\"]\n  7 [label = \"9405\"]\n  \n  rankdir=\"LR\"\n  }","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

## Bayesian networks 

### Sprinkler example

<!--html_preserve--><div id="htmlwidget-1e1a5fd2ce6d5435a93f" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-1e1a5fd2ce6d5435a93f">{"x":{"diagram":"\ndigraph dot{\n  \n  # general settings for all nodes\n  node [\n    shape = circle,\n    style = filled,\n    color = black,\n    label = \"\"\n    fontname = \"Helvetica\",\n    fontsize = 10,\n    fillcolor = lightblue,\n    fixedsize=true,\n    width = 0.8\n    ]\n  \n  # edges between nodes\n  edge [color = black,\n        fontname = \"Helvetica\",\n        fontsize = 10]\n  1 -> 2 [label = \"\"]\n  1 -> 3 [label = \"\"]\n  2 -> 4 [label = \"\"] \n  3 -> 4 [label = \"\"]\n  \n  # labels for each node\n  1 [label = \"Cloudy\"]\n  2 [label = \"Sprinkler\"]\n  3 [label = \"Rain\"]\n  4 [label = \"Wet grass\"]\n  }","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


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

<table class="table table-striped" style="font-size: 20px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> p(C) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
</tbody>
</table>

<table class="table table-striped" style="font-size: 20px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> C </th>
   <th style="text-align:right;"> p(S) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 0.5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T </td>
   <td style="text-align:right;"> 0.1 </td>
  </tr>
</tbody>
</table>

<table class="table table-striped" style="font-size: 20px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> C </th>
   <th style="text-align:right;"> p(R) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 0.2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T </td>
   <td style="text-align:right;"> 0.8 </td>
  </tr>
</tbody>
</table>

<table class="table table-striped" style="font-size: 20px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> S </th>
   <th style="text-align:left;"> R </th>
   <th style="text-align:right;"> p(W) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 0.00 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 0.90 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> F </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:right;"> 0.90 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> T </td>
   <td style="text-align:left;"> T </td>
   <td style="text-align:right;"> 0.99 </td>
  </tr>
</tbody>
</table>

## Additional resources 

### Cheatsheets 

- [Probability cheatsheet](figures/probability.pdf)

### Books and chapters

- [Probability and Statistics with examples using R](http://www.isibang.ac.in/~athreya/psweur/)
- [Learning statistics with R: Chapter 9 Introduction to probability](https://learningstatisticswithr-bookdown.netlify.com/probability.html#probstats)

### Misc 

- [Statistics 110: Probability; course at Harvard](https://projects.iq.harvard.edu/stat110)  
