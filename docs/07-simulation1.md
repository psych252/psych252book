# Simulation 1 

## Load packages and set plotting theme  




```r
library("knitr")
library("kableExtra")
library("MASS")
library("patchwork")
library("extrafont")
library("tidyverse")

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

## Working with distributions 

Every distribution that R handles has four functions. There is a root name, for example, the root name for the normal distribution is `norm`. This root is prefixed by one of the letters here:

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> letter </th>
   <th style="text-align:left;"> description </th>
   <th style="text-align:left;"> example </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> `d` </td>
   <td style="text-align:left;"> for "__density__", the density function (probability function (for _discrete_ variables) or probability density function (for _continuous_ variables)) </td>
   <td style="text-align:left;"> `dnorm()` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `p` </td>
   <td style="text-align:left;"> for "__probability__", the cumulative distribution function </td>
   <td style="text-align:left;"> `pnorm()` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `q` </td>
   <td style="text-align:left;"> for "__quantile__", the inverse cumulative distribution function </td>
   <td style="text-align:left;"> `qnorm()` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `r` </td>
   <td style="text-align:left;"> for "__random__", a random variable having the specified distribution </td>
   <td style="text-align:left;"> `rnorm()` </td>
  </tr>
</tbody>
</table>


For the normal distribution, these functions are `dnorm`, `pnorm`, `qnorm`, and `rnorm`. For the binomial distribution, these functions are `dbinom`, `pbinom`, `qbinom`, and `rbinom`. And so forth.

You can get more info about the distributions that come with R via running `help(Distributions)` in your console. If you need a distribution that doesn't already come with R, then take a look [here](https://cran.r-project.org/web/views/Distributions.html) for many more distributions that can be loaded with different R packages. 

### Plotting distributions 

Here's an easy way to plot distributions in `ggplot2` using the `stat_function()` function. 


```r
ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) +
  stat_function(fun = "dnorm")
```

<img src="07-simulation1_files/figure-html/simulation1-05-1.png" width="672" />

Note that the data frame I created with `tibble()` only needs to have the minimum and the maximum value of the x-range that we are interested in. Here, I chose `-5` and `5` as the minimum and maximum, respectively. 

The `stat_function()` is very flexible. We can define our own functions and plot these like here: 


```r
# define the breakpoint function 
fun.breakpoint = function(x, breakpoint){
  x[x < breakpoint] = breakpoint
  return(x)
}

# plot the function
ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) +
  stat_function(fun = "fun.breakpoint",
                args = list(breakpoint = 2)
                )
```

<img src="07-simulation1_files/figure-html/simulation1-06-1.png" width="672" />

Here, I defined a breakpoint function. If the value of `x` is below the breakpoint, `y` equals the value of the breakpoint. If the value of `x` is greater than the breakpoint, then `y` equals `x`. 

Note how I used the `args = ` argument in the `stat_function()` to supply the breakpoint parameter that my `fun.breakpoint()` wants. Make sure to put these parameters into a `list()` as shown above. 

Let's play around with the parameters of the normal distribution. The normal distribution takes two parameters, the mean and standard deviation. Again, I'm going to use the `args = ` argument to supply these parameters.  


```r
tmp.mean = 0
tmp.sd = 2

ggplot(data = tibble(x = c(140, 220)),
       mapping = aes(x = x)) +
  stat_function(fun = "dnorm",
                args = list(mean = tmp.mean,
                            sd = tmp.sd))

# remove all variables with tmp in their name 
rm(list = ls() %>% str_subset(pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/simulation1-07-1.png" width="672" />

To keep my environment clean, I've named the parameters `tmp.mean` and `tmp.sd` and then, at the end of the code chunk, I removed all variables from the environment that have "tmp." in their name using the `ls()` function (which prints out all variables in the environment as a vector), and the `str_subset()` function which filters out only those variables that contain the specified pattern.

### Sampling from distributions 

For each distribution, R provides a way of sampling random number from this distribution. For the normal distribution, we can use the `rnorm()` function to take random samples. 

So let's take some random samples and plot a histogram. 


```r
# make this example reproducible 
set.seed(1)

# define how many samples to draw 
tmp.nsamples = 100

# make a data frame with the samples
df.plot = tibble(
  x = rnorm(n = tmp.nsamples, mean = 0, sd = 1)
) 

# plot the samples using a histogram 
ggplot(data = df.plot,
       mapping = aes(x = x)) +
  geom_histogram(binwidth = 0.2,
                 color = "black",
                 fill = "lightblue") +
  scale_x_continuous(breaks = -4:4, labels = -4:4) +
  coord_cartesian(xlim = c(-4, 4), expand = T)

# remove all variables with tmp in their name 
rm(list = ls() %>% str_subset(pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/simulation1-08-1.png" width="672" />

Let's see how many samples it takes to closely approximate the shape of the normal distribution with our histogram of samples. 


```r
# make this example reproducible 
set.seed(1)

# play around with this value
tmp.nsamples = 100
# tmp.nsamples = 10000
tmp.binwidth = 0.2

# make a data frame with the samples
df.plot = tibble(
  x = rnorm(n = tmp.nsamples, mean = 0, sd = 1)
) 

# adjust the density of the normal distribution based on the samples and binwidth 
fun.dnorm = function(x, mean, sd, n, binwidth){
  dnorm(x = x, mean = mean, sd = sd) * n * binwidth
}

# plot the samples using a histogram 
ggplot(data = df.plot,
       mapping = aes(x = x)) +
  geom_histogram(binwidth = tmp.binwidth,
                 color = "black",
                 fill = "lightblue") +
  stat_function(fun = "fun.dnorm",
                args = list(mean = 0,
                            sd = 1,
                            n = tmp.nsamples,
                            binwidth = tmp.binwidth),
                xlim = c(min(df.plot$x), max(df.plot$x)),
                size = 2) +
  annotate(geom = "text",
           label = str_c("n = ", tmp.nsamples),
           x = -3.9,
           y = Inf,
           hjust = 0,
           vjust = 1.1,
           size = 10,
           family = "Courier New") +
  scale_x_continuous(breaks = -4:4, labels = -4:4) +
  coord_cartesian(xlim = c(-4, 4), expand = F)

# remove all variables with tmp in their name 
rm(list = ls() %>% str_subset(pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/simulation1-09-1.png" width="672" />

With 10,000 samples, our histogram of samples already closely resembles the theoretical shape of the normal distribution. 

### Cumulative probability distribution


```r
ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) +
  stat_function(fun = "pnorm",
                args = list(mean = 0,
                            sd = 1))
```

<img src="07-simulation1_files/figure-html/simulation1-10-1.png" width="672" />

Let's find the cumulative probability of a particular value. 


```r
tmp.x = 1
tmp.y = pnorm(tmp.x, mean = 0, sd = 1)

print(tmp.y %>% round(3))

# draw the cumulative probability distribution and show the value
ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) +
  stat_function(fun = "pnorm",
                args = list(mean = 0,
                            sd = 1)) +
  annotate(geom = "point",
           x = tmp.x, 
           y = tmp.y,
           size = 4,
           color = "blue") +
  geom_segment(mapping = aes(x = tmp.x,
                             xend = tmp.x,
                             y = 0,
                             yend = tmp.y),
               size = 1,
               color = "blue") +
  geom_segment(mapping = aes(x = -5,
                             xend = tmp.x,
                             y = tmp.y,
                             yend = tmp.y),
               size = 1,
               color = "blue") +
  scale_x_continuous(breaks = -5:5) + 
  coord_cartesian(xlim = c(-5, 5),
                  ylim = c(0, 1.05),
                  expand = F)

# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

```
[1] 0.841
```

<img src="07-simulation1_files/figure-html/simulation1-11-1.png" width="672" />

Let's illustrate what this would look like using a normal density plot. 


```r
ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) + 
  stat_function(fun = "dnorm",
                geom = "area",
                fill = "lightblue",
                xlim = c(-5, 1),
                color = "black",
                linetype = 2) +
  stat_function(fun = "dnorm",
                size = 1.5) +
  coord_cartesian(xlim = c(-5, 5)) +
  scale_x_continuous(breaks = -5:5) +
  scale_y_continuous(expand = expand_scale(mult = c(0, 0.1))) 
```

<img src="07-simulation1_files/figure-html/simulation1-12-1.png" width="672" />

### Inverse cumulative distribution 


```r
ggplot(data = tibble(x = c(0, 1)),
       mapping = aes(x = x)) +
  stat_function(fun = "qnorm",
                args = list(mean = 0,
                            sd = 1))
```

<img src="07-simulation1_files/figure-html/simulation1-13-1.png" width="672" />

And let's compute the inverse cumulative probability for a particular value. 


```r
# tmp.x = 0.841
tmp.x = 0.975
tmp.y = qnorm(tmp.x, mean = 0, sd = 1)

print(tmp.y %>% round(3))

# draw the cumulative probability distribution and show the value
ggplot(data = tibble(x = c(0, 1)),
       mapping = aes(x = x)) +
  stat_function(fun = "qnorm",
                args = list(mean = 0,
                            sd = 1)) +
  annotate(geom = "point",
           x = tmp.x, 
           y = tmp.y,
           size = 4,
           color = "blue") +
  geom_segment(mapping = aes(x = tmp.x,
                             xend = tmp.x,
                             y = -3,
                             yend = tmp.y),
               size = 1,
               color = "blue") +
  geom_segment(mapping = aes(x = 0,
                             xend = tmp.x,
                             y = tmp.y,
                             yend = tmp.y),
               size = 1,
               color = "blue") +
  scale_x_continuous(breaks = seq(from = 0, to = 1, by = 0.1)) + 
  coord_cartesian(xlim = c(0, 1.05),
                  ylim = c(-3, 3),
                  expand = F)

# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

```
[1] 1.96
```

<img src="07-simulation1_files/figure-html/simulation1-14-1.png" width="672" />

### Computing probabilities 

#### Via probability distributions

Let's compute the probability of observing a particular value $x$ in a given range. 


```r
# tmp.lower = -1
# tmp.upper = 1

# tmp.lower = -2
# tmp.upper = 2

# tmp.lower = qnorm(0.001)
# tmp.upper = qnorm(0.95)

# tmp.lower = qnorm(0.05)
# tmp.upper = qnorm(0.999)

tmp.lower = qnorm(0.025)
tmp.upper = qnorm(0.975)

tmp.prob = pnorm(tmp.upper) - pnorm(tmp.lower)

ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) + 
  stat_function(fun = "dnorm",
                geom = "area",
                fill = "lightblue",
                xlim = c(tmp.lower, tmp.upper),
                color = "black",
                linetype = 2) +
  stat_function(fun = "dnorm",
                size = 1.5) +
  annotate(geom = "text",
           label = str_c(tmp.prob %>% round(2) * 100, "%"),
           x = 0,
           y = 0.2,
           hjust = 0.5,
           size = 10
           ) +
  coord_cartesian(xlim = c(-5, 5)) +
  scale_x_continuous(breaks = -5:5) +
  scale_y_continuous(expand = expand_scale(mult = c(0, 0.1))) 

# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/simulation1-15-1.png" width="672" />

We find that 95% of the density in the normal distribution is between -1.96 and 1.96. 

#### Via sampling 

We can also compute the probability of observing certain events using sampling. We first generate samples from the desired probability distribution, and then use these samples to compute our statistic of interest. 


```r
# let's compute the probability of observing a value within a certain range 
tmp.lower = -1.96
tmp.upper = 1.96

# make example reproducible
set.seed(1)

# generate some samples and store them in a data frame 
tmp.nsamples = 10000

df.samples = tibble(
  sample = 1:tmp.nsamples,
  value = rnorm(n = tmp.nsamples, mean = 0, sd = 1)
)

# compute the probability that s sample lies within the range of interest
tmp.prob = df.samples %>% 
  filter(value >= tmp.lower,
         value <= tmp.upper) %>% 
  summarize(prob = n()/tmp.nsamples)

# illustrate the result using a histogram 
ggplot(data = df.samples,
       mapping = aes(x = value)) + 
  geom_histogram(binwidth = 0.1,
                 color = "black",
                 fill = "lightblue") +
  scale_x_continuous(breaks = -4:4, labels = -4:4) +
  coord_cartesian(xlim = c(-4, 4), expand = F) +
  geom_vline(xintercept = tmp.lower,
             size = 1, 
             color = "red",
             linetype = 2) +
  geom_vline(xintercept = tmp.upper,
             size = 1, 
             color = "red",
             linetype = 2) +
  annotate(geom = "label",
           label = str_c(tmp.prob %>% round(3) * 100, "%"),
           x = 0,
           y = 200,
           hjust = 0.5,
           size = 10)

# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/simulation1-16-1.png" width="672" />

## Bayesian inference with the normal distribution

Let's consider the following scenario. You are helping out at a summer camp. This summer, two different groups of kids go to the same summer camp. The chess kids, and the basketball kids. The chess summer camp is not quite as popular as the basketball summer camp (shocking, I know!). In fact, twice as many children have signed up for the basketball camp. 

When signing up for the camp, the children were asked for some demographic information including their height in cm. Unsurprisingly, the basketball players tend to be taller on average than the chess players. In fact, the basketball players' height is approximately normally distributed with a mean of 180cm and a standard deviation of 10cm. For the chess players, the mean height is 170cm with a standard deviation of 8cm. 

At the camp site, a child walks over to you and asks you where their gym is. You gage that the child is around 175cm tall. Where should you direct the child to? To the basketball gym, or to the chess gym? 


```r
height = 175

# priors 
prior_basketball = 2/3 
prior_chess = 1/3 

# likelihood  
mean_basketball = 180
sd_basketball = 10

mean_chess = 170
sd_chess = 8

likelihood_basketball = dnorm(height, mean = mean_basketball, sd = sd_basketball)
likelihood_chess = dnorm(height, mean = mean_chess, sd = sd_chess)

# posterior
posterior_basketball = (likelihood_basketball * prior_basketball) / 
  ((likelihood_basketball * prior_basketball) + (likelihood_chess * prior_chess))

posterior_basketball %>% print()
```

```
[1] 0.631886
```

Let's do the same thing via sampling. 


```r
# number of kids 
tmp.nkids = 10000

# make reproducible 
set.seed(1)

# priors 
prior_basketball = 2/3 
prior_chess = 1/3 

# likelihood functions 
mean_basketball = 180
sd_basketball = 10

mean_chess = 170
sd_chess = 8

# data frame with the kids
df.camp = tibble(
  kid = 1:tmp.nkids,
  sport = sample(c("chess", "basketball"),
                 size = tmp.nkids,
                 replace = T,
                 prob = c(prior_chess, prior_basketball))) %>% 
  rowwise() %>% 
  mutate(height = ifelse(test = sport == "chess",
                         yes = rnorm(., mean = mean_chess, sd = sd_chess),
                         no = rnorm(., mean = mean_basketball, sd = sd_basketball))) %>% 
  ungroup

df.camp %>% print()
```

```
# A tibble: 10,000 x 3
     kid sport      height
   <int> <chr>       <dbl>
 1     1 basketball   165.
 2     2 basketball   163.
 3     3 basketball   191.
 4     4 chess        160.
 5     5 basketball   183.
 6     6 chess        164.
 7     7 chess        169.
 8     8 basketball   193.
 9     9 basketball   172.
10    10 basketball   177.
# … with 9,990 more rows
```

Now we have a data frame with kids whose height was randomly sampled depending on which sport they do. I've used the `sample()` function to assign a sport to each kid first using the `prob = ` argument to make sure that a kid is more likely to be assigned the sport "basketball" than "chess". 

Note that the solution above is not particularly efficient since it uses the `rowwise()` function to make sure that a different random value for height is drawn for each row. Running this code will get slow for large samples. A more efficient solution would be the following: 


```r
# number of kids 
tmp.nkids = 100000

# make reproducible 
set.seed(3)

df.camp2 = tibble(
  kid = 1:tmp.nkids,
  sport = sample(c("chess", "basketball"),
                 size = tmp.nkids,
                 replace = T,
                 prob = c(prior_chess, prior_basketball))) %>% 
  arrange(sport) %>% 
  mutate(height = c(rnorm(sum(sport == "basketball"), mean = mean_basketball, sd = sd_basketball),
                    rnorm(sum(sport == "chess"), mean = mean_chess, sd = sd_chess))
         )
```

In this solution, I take advantage of the fact that `rnorm()` is vectorized. That is, it can produce many random draws in one call. To make this work, I first arrange the data frame, and then draw the correct number of samples from each of the two distributions. This works fast, even if I'm drawing a large number of samples. 

How can we now use these samples to answer our question of interest? Let's see what doesn't work first: 


```r
tmp.height = 175

df.camp %>% 
  filter(height == tmp.height) %>% 
  count(sport) %>% 
  spread(sport, n) %>% 
  summarize(prob_basketball = basketball/(basketball + chess))
```

The reason this doesn't work is because none of our kids is exactly 175cm tall. Instead, we need to filter kids that are within a certain height range. 


```r
tmp.height = 175
tmp.margin = 1

df.camp %>% 
  filter(between(height,
          left = tmp.height - tmp.margin,
          right = tmp.height + tmp.margin)) %>% 
  count(sport) %>% 
  spread(sport, n) %>% 
  summarize(prob_basketball = basketball/(basketball + chess))
```

```
# A tibble: 1 x 1
  prob_basketball
            <dbl>
1           0.632
```

Here, I've used the `between()` function which is a shortcut for otherwise writing `x >= left & x <= right`. You can play around with the margin to see how the result changes. 

## Working with samples

### Understanding `density()`

First, let's calculate the density for a set of observations and store them in a data frame.


```r
# calculate density
observations = c(1, 1.2, 1.5, 2, 3)
bandwidth = 0.25 # bandwidth (= sd) of the Gaussian distribution 
tmp.density = density(observations,
        kernel = "gaussian",
        bw = bandwidth,
        n = 512)

# save density as data frame 
df.density = tibble(
  x = tmp.density$x,
  y = tmp.density$y
) 

df.density %>% 
  head() %>% 
  kable(digits = 3) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> x </th>
   <th style="text-align:right;"> y </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 0.250 </td>
   <td style="text-align:right;"> 0.004 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.257 </td>
   <td style="text-align:right;"> 0.004 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.264 </td>
   <td style="text-align:right;"> 0.005 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.271 </td>
   <td style="text-align:right;"> 0.005 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.277 </td>
   <td style="text-align:right;"> 0.005 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.284 </td>
   <td style="text-align:right;"> 0.006 </td>
  </tr>
</tbody>
</table>

Now, let's plot the density. 


```r
ggplot(data = df.density, aes(x = x, y = y)) +
  geom_line(size = 2) +
  geom_point(data = as.tibble(observations),
             mapping = aes(x = value, y = 0),
             size = 3)
```

```
Warning: `as.tibble()` is deprecated, use `as_tibble()` (but mind the new semantics).
This warning is displayed once per session.
```

<img src="07-simulation1_files/figure-html/simulation1-23-1.png" width="672" />

This density shows the sum of the densities of normal distributions that are centered at the observations with the specified bandwidth. 


```r
# add densities for the individual normal distributions
for (i in 1:length(observations)){
  df.density[[str_c("observation_",i)]] = dnorm(df.density$x, mean = observations[i], sd = bandwidth)
}

# sum densities
df.density = df.density %>%
  mutate(sum_norm = rowSums(select(., contains("observation_"))),
         y = y * length(observations))

df.density %>% 
  head() %>% 
  kable(digits = 3) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> x </th>
   <th style="text-align:right;"> y </th>
   <th style="text-align:right;"> observation_1 </th>
   <th style="text-align:right;"> observation_2 </th>
   <th style="text-align:right;"> observation_3 </th>
   <th style="text-align:right;"> observation_4 </th>
   <th style="text-align:right;"> observation_5 </th>
   <th style="text-align:right;"> sum_norm </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 0.250 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.018 </td>
   <td style="text-align:right;"> 0.001 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.019 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.257 </td>
   <td style="text-align:right;"> 0.021 </td>
   <td style="text-align:right;"> 0.019 </td>
   <td style="text-align:right;"> 0.001 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.021 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.264 </td>
   <td style="text-align:right;"> 0.023 </td>
   <td style="text-align:right;"> 0.021 </td>
   <td style="text-align:right;"> 0.001 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.022 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.271 </td>
   <td style="text-align:right;"> 0.024 </td>
   <td style="text-align:right;"> 0.023 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.024 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.277 </td>
   <td style="text-align:right;"> 0.027 </td>
   <td style="text-align:right;"> 0.024 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.026 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 0.284 </td>
   <td style="text-align:right;"> 0.029 </td>
   <td style="text-align:right;"> 0.026 </td>
   <td style="text-align:right;"> 0.002 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0.028 </td>
  </tr>
</tbody>
</table>

Now, let's plot the individual densities as well as the overall density.


```r
# add individual Gaussians
colors = c("blue", "green", "red", "purple", "orange")

# original density 
p = ggplot(data = df.density, aes(x = x, y = y)) +
  geom_line(size = 2)

# individual densities 
for (i in 1:length(observations)){
  p = p + stat_function(fun = "dnorm",
                        args = list(mean = observations[i], sd = bandwidth),
                        color = colors[i])
}

# individual observations 
p = p + geom_point(data = as.tibble(observations),
             mapping = aes(x = value, y = 0, color = factor(1:5)),
             size = 3,
             show.legend = F) +
  scale_color_manual(values = colors)

# sum of the individual densities
p = p +
  geom_line(data = df.density,
            aes(x = x, y = sum_norm),
            size = 1,
            color = "red",
            linetype = 2)
p # print the figure
```

<img src="07-simulation1_files/figure-html/simulation1-25-1.png" width="672" />

Here are the same results when specifying a different bandwidth: 


```r
# calculate density
observations = c(1, 1.2, 1.5, 2, 3)
bandwidth = 0.5 # bandwidth (= sd) of the Gaussian distribution 
tmp.density = density(observations,
        kernel = "gaussian",
        bw = bandwidth,
        n = 512)

# save density as data frame 
df.density = tibble(
  x = tmp.density$x,
  y = tmp.density$y
) 

# add densities for the individual normal distributions
for (i in 1:length(observations)){
  df.density[[str_c("observation_",i)]] = dnorm(df.density$x, mean = observations[i], sd = bandwidth)
}

# sum densities
df.density = df.density %>%
  mutate(sum_norm = rowSums(select(., contains("observation_"))),
         y = y * length(observations))

# original plot 
p = ggplot(data = df.density, aes(x = x, y = y)) +
  geom_line(size = 2) +
  geom_point(data = as.tibble(observations),
             mapping = aes(x = value, y = 0),
             size = 3)

# add individual Gaussians
for (i in 1:length(observations)){
  p = p + stat_function(fun = "dnorm", args = list(mean = observations[i], sd = bandwidth))
}

# add the sum of Gaussians
p = p +
  geom_line(data = df.density,
            aes(x = x, y = sum_norm),
            size = 1,
            color = "red",
            linetype = 2)
p
```

<img src="07-simulation1_files/figure-html/simulation1-26-1.png" width="672" />

### The `quantile()` function

The `quantile()` function allows us to compute different quantiles of a sample. Boxplots are based on the quantiles of a distribution. To better understand this function, let's compute our own boxplot. 


```r
tmp.samples = 1000

# make example reproducible 
set.seed(1)

# a sample from the normal distribution
df.quantile = tibble(
  sample = 1:tmp.samples,
  value = rnorm(n = tmp.samples))

df.quantile %>% 
  head(10) %>% 
kable(digits = 2) %>% 
kable_styling(bootstrap_options = "striped",
              full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> sample </th>
   <th style="text-align:right;"> value </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> -0.63 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0.18 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> -0.84 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1.60 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0.33 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> -0.82 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0.49 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0.74 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 0.58 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> -0.31 </td>
  </tr>
</tbody>
</table>

Let's draw a boxplot using ggplot. 


```r
ggplot(data = df.quantile,
       mapping = aes(x = "", y = value)) +
  geom_boxplot()
```

<img src="07-simulation1_files/figure-html/simulation1-28-1.png" width="672" />

Here is a reminder of what boxplots show from the help file of `geom_boxplot()`:

> The lower and upper hinges correspond to the first and third quartiles (the 25th and 75th percentiles). This differs slightly from the method used by the boxplot() function, and may be apparent with small samples. See boxplot.stats() for for more information on how hinge positions are calculated for boxplot().

> The upper whisker extends from the hinge to the largest value no further than 1.5 \* IQR from the hinge (where IQR is the inter-quartile range, or distance between the first and third quartiles). The lower whisker extends from the hinge to the smallest value at most 1.5 \* IQR of the hinge. Data beyond the end of the whiskers are called "outlying" points and are plotted individually.

So, let's compute the relevant values using the `quantile()` function.


```r
df.quantile_values = tibble(
  median = quantile(df.quantile$value, 0.5),
  quartile_first = quantile(df.quantile$value, 0.25),
  quartile_third = quantile(df.quantile$value, 0.75),
  iqr = quartile_third - quartile_first,
  hinge_upper = quartile_third + 1.5 * iqr,
  hinge_lower = quartile_first - 1.5 * iqr
)
```

Now, let's check whether our values are correct by plotting them on top of the boxplot. 


```r
# original boxplot 
ggplot(data = df.quantile,
       mapping = aes(x = 0, y = value)) +
  geom_boxplot() +
  geom_segment(x = -0.75,
               xend = -0.45,
               y = df.quantile_values$median,
               yend = df.quantile_values$median,
               arrow = arrow(type = "closed",
                             length = unit(0.5, "cm"))
               ) +
  annotate(geom = "text",
           label = "median",
           x = -0.8,
           y = df.quantile_values$median,
           hjust = 1,
           vjust = 0.5,
           size = 6) +
  geom_segment(x = -0.75,
               xend = -0.45,
               y = df.quantile_values$quartile_third,
               yend = df.quantile_values$quartile_third,
               arrow = arrow(type = "closed",
                             length = unit(0.5, "cm"))
               ) +
  annotate(geom = "text",
           label = "3rd quartile",
           x = -0.8,
           y = df.quantile_values$quartile_third,
           hjust = 1,
           vjust = 0.5,
           size = 6) +
  geom_segment(x = -0.75,
               xend = -0.05,
               y = df.quantile_values$hinge_upper,
               yend = df.quantile_values$hinge_upper,
               arrow = arrow(type = "closed",
                             length = unit(0.5, "cm"))
               ) +
  annotate(geom = "text",
           label = "upper hinge",
           x = -0.8,
           y = df.quantile_values$hinge_upper,
           hjust = 1,
           vjust = 0.5,
           size = 6) +
  coord_cartesian(xlim = c(-1.2, 0.5))
```

<img src="07-simulation1_files/figure-html/simulation1-30-1.png" width="672" />

Neat! Now we know how boxplots are made. 

We can also use the quantile function to create an inverse cumulative probability plot (i.e. the equivalent of what we get from `qnorm()` for the normal distribution). 


```r
df.plot = df.quantile$value %>% 
  quantile(probs = seq(0, 1, 0.01)) %>% 
  as_tibble() %>% 
  mutate(x = seq(0, n(), length.out = n()))
```

```
Warning: Calling `as_tibble()` on a vector is discouraged, because the behavior is likely to change in the future. Use `enframe(name = NULL)` instead.
This warning is displayed once per session.
```

```r
ggplot(data = df.plot,
       mapping = aes(x = x, y = value)) +
  geom_line()
```

<img src="07-simulation1_files/figure-html/simulation1-31-1.png" width="672" />

And we can calculate quantiles by hand in the following way: 


```r
tmp.samples = 1000

# make example reproducible 
set.seed(1)

# a sample from the normal distribution
df.quantile = tibble(
  sample = 1:tmp.samples,
  value = rnorm(n = tmp.samples))

# compute quantiles by hand 
df.quantile = df.quantile %>% 
  arrange(value) %>% 
  mutate(rank = row_number(),
         quantile = rank/tmp.samples)
```

To compute the quantiles by hand, I've sorted the data frame, ranked the values, and then computed the quantiles by normalizing the ranks (i.e. dividing by the sample size). 

Let's check whether we get roughly the same result with our hand-calculated quantiles as we do from the `quantile()` function. 


```r
# by hand 
df.quantile %>% 
  filter(rank %in% seq(from = 200, to = 800, by = 200)) %>% 
  pull(value)

# using quantile
quantile(df.quantile$value, probs = seq(0.2, 0.8, 0.2))
```

```
[1] -0.8848496 -0.2968686  0.2441649  0.8528150
       20%        40%        60%        80% 
-0.8815065 -0.2961539  0.2449833  0.8537340 
```

As we can see, the results are very similar. Not identical since the `quantile()` function uses an efficient algorithm for its calculations (see `help(quantile)`).

## Comparing probability distributions 

QQ plots, or quantile-quantile plots, are a good way of visually comparing two distributions. One common usage in statistics is to assess whether a variable is normally distributed. For example, let's say that we fit a regression model and want to now assess whether the residuals (i.e. the model errors) are normally distributed. (We will learn how to run regressions soon). Let's first just plot the residuals from the model we fit above. 


```r
df.residuals = tibble(
  residual = rnorm(n = 10000, mean = 0, sd = 10)
)

params = as.list(MASS::fitdistr(df.residuals$residual, "normal")$estimate) #fit a normal distribution to the residuals 

ggplot(data = df.residuals, aes(x = residual))+
  stat_density(geom = "line", aes(color = "green"), size = 1.5)+
  stat_function(fun = "dnorm", args = params, aes(color = "black"), size = 1.5)+
  scale_color_manual(values = c("black", "green"), labels = c("theoretical", "empirical"))+
  theme(legend.title = element_blank(),
        legend.position = c(0.9, 0.9))
```

<div class="figure">
<img src="07-simulation1_files/figure-html/simulation1-34-1.png" alt="Empirical distribution of residuals, and theoretical distribution." width="672" />
<p class="caption">(\#fig:simulation1-34)Empirical distribution of residuals, and theoretical distribution.</p>
</div>

Here, the empirical distribution of the errors and the theoretical normal distribution with a mean of 0 and a SD of 2 correspond very closely. Let's take a look at the corresponding QQ plot. 


```r
ggplot(data = df.residuals, aes(sample = residual)) +
  geom_abline(intercept = 0, slope = 1, linetype = 2) +
  geom_qq(distribution = "qnorm", dparams = params) +
  coord_cartesian(xlim = c(-40, 40), ylim = c(-40, 40))
```

<img src="07-simulation1_files/figure-html/simulation1-35-1.png" width="672" />

Note that the QQ plot is sensitive to the general shape of the distribution. 

I've used the `geom_qq()` and `geom_qq_line()` functions that are part of `ggplot`. By default, these functions assume a normal distribution as the theoretical distribution. This plot is just another way of showing the information in Figure \@ref(fig:simulation1-36). Intuitively, a QQ plot is built in the following way: imagine going with your finger from left to right along the x-axis on Figure \@ref(fig:simulation1-37), and then add a point on the QQ plot which captures the cumulative density for each distribution. 

Here are some more examples for what these plots would look like when comparing different theoretical distributions to the same empirical distribution. 


```r
# data frame with parameters saved in a list column 
df.parameters = tibble(
  parameters = list(
    params,
    list(mean = -10, sd = 10),
    list(mean = 10, sd = 10),
    list(mean = 0, sd = 3)
  )
)

# list container for plots
l.plots = list()

for (i in 1:nrow(df.parameters)){
  p1 = ggplot(data = df.residuals, aes(x = residual)) +
    stat_density(geom = "line", color = "green", size = 1.5) +
    stat_function(fun = "dnorm", args = df.parameters$parameters[[i]], color = "black", size = 1.5) +
    scale_y_continuous(limits = c(0, 0.15))
  
  p2 = ggplot(data = df.residuals, aes(sample = residual)) +
    geom_abline(intercept = 0, slope = 1, linetype = 2) +
    geom_qq(dparams = df.parameters$parameters[[i]]) +
    geom_qq_line(dparams = df.parameters$parameters[[i]]) +
    scale_x_continuous(limits = c(-40, 40))
  
  l.plots[[length(l.plots) + 1]] = p1
  l.plots[[length(l.plots) + 1]] = p2
}

# use patchwork for plotting 
l.plots[[1]] + 
l.plots[[2]] +
l.plots[[3]] +
l.plots[[4]] +
l.plots[[5]] +
l.plots[[6]] +
l.plots[[7]] +
l.plots[[8]] +
  plot_layout(ncol = 4, byrow = F) &
  theme(text = element_text(size = 16))
```

```
geom_path: Each group consists of only one observation. Do you need to
adjust the group aesthetic?
geom_path: Each group consists of only one observation. Do you need to
adjust the group aesthetic?
```

```r
# ggsave("figures/qqplots_normal.pdf", width = 10, height = 6)
```

<img src="07-simulation1_files/figure-html/simulation1-38-1.png" width="672" />

The line changes, but it's still a line. So the QQ plot helps us detect what kind of distribution the data follows. 

Now, let's see what happens if distributions don't have the same shape. 


```r
#let's generate some "empirical" data from a beta distribution 
set.seed(0)

df.plot = tibble(
  residual = rbeta(1000, shape1 = 5, shape2 = 5)
)

# data frame with parameters saved in a list column 
df.parameters = tibble(
  parameters = list(
    list(shape1 = 1, shape2 = 5),
    list(shape1 = 2, shape2 = 5),
    list(shape1 = 5, shape2 = 2),
    list(shape1 = 5, shape2 = 1)
  )
)

# list container for plots
l.plots = list()

for (i in 1:nrow(df.parameters)){
  p1 = ggplot(data = df.plot, aes(x = residual))+
    stat_density(geom = "line", color = "green", size = 1.5)+
    stat_function(fun = "dbeta", args = df.parameters$parameters[[i]], color = "black", size = 1.5) + 
    scale_y_continuous(limits = c(0, 3.5))
  
  p2 = ggplot(data = df.plot, aes(sample = residual))+
    geom_abline(intercept = 0, slope = 1, linetype = 2)+
    geom_qq(distribution = "qbeta", dparams = df.parameters$parameters[[i]]) +
    scale_x_continuous(limits = c(0, 1), breaks = seq(.25, .75, .25))
  
  l.plots[[length(l.plots) + 1]] = p1
  l.plots[[length(l.plots) + 1]] = p2
}

# use patchwork for plotting
l.plots[[1]] + 
l.plots[[2]] +
l.plots[[3]] +
l.plots[[4]] +
l.plots[[5]] +
l.plots[[6]] +
l.plots[[7]] +
l.plots[[8]] +
  plot_layout(ncol = 4, byrow = F) &
  theme(text = element_text(size = 16))
ggsave("figures/qqplots_beta.pdf", width = 10, height = 6)
```

<img src="07-simulation1_files/figure-html/simulation1-39-1.png" width="672" />

<div class="figure">
<img src="figures/qqplots.png" alt="QQ plots indicating different deviations from normality." width="90%" />
<p class="caption">(\#fig:simulation1-40)QQ plots indicating different deviations from normality.</p>
</div>

## Additional resources 

### Cheatsheets 

- [Probability cheatsheet](figures/probability.pdf)

### Datacamp 

- [Foundations of probability in R](https://www.datacamp.com/courses/foundations-of-probability-in-r)
