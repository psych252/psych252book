# Simulation 1

## Load packages and set plotting theme


``` r
library("knitr")
library("kableExtra")
library("MASS")
library("patchwork")
library("tidyverse")
```


``` r
theme_set(theme_classic() + #set the theme 
            theme(text = element_text(size = 20))) #set the default text size

opts_chunk$set(comment = "",
               fig.show = "hold")
```

## Sampling

### Drawing numbers from a vector


``` r
numbers = 1:3

numbers %>% 
  sample(size = 10,
         replace = T)
```

```
 [1] 3 2 2 2 1 1 2 3 3 2
```

Use the `prob = ` argument to change the probability with which each number should be drawn. 


``` r
numbers = 1:3

numbers %>% 
  sample(size = 10,
         replace = T,
         prob = c(0.8, 0.1, 0.1))
```

```
 [1] 2 1 1 1 1 1 1 1 1 1
```

Make sure to set the seed in order to make your code reproducible. The code chunk below may give a different outcome each time is run. 



``` r
numbers = 1:5

numbers %>% 
  sample(5)
```

```
[1] 3 4 5 2 1
```

The chunk below will produce the same outcome every time it's run. 


``` r
set.seed(1)

numbers = 1:5

numbers %>% 
  sample(5)
```

```
[1] 1 4 3 5 2
```

### Drawing rows from a data frame

Generate a data frame. 


``` r
set.seed(1)
n = 10
df.data = tibble(trial = 1:n,
                 stimulus = sample(x = c("flower", "pet"),
                                   size = n,
                                   replace = T),
                 rating = sample(x = 1:10,
                                 size = n,
                                 replace = T))
```

Sample a given number of rows. 


``` r
set.seed(1)

df.data %>% 
  slice_sample(n = 6, 
               replace = T)
```

```
# A tibble: 6 × 3
  trial stimulus rating
  <int> <chr>     <int>
1     9 pet           9
2     4 flower        5
3     7 flower       10
4     1 flower        3
5     2 pet           1
6     7 flower       10
```


``` r
set.seed(1)

df.data %>% 
  slice_sample(prop = 0.5)
```

```
# A tibble: 5 × 3
  trial stimulus rating
  <int> <chr>     <int>
1     9 pet           9
2     4 flower        5
3     7 flower       10
4     1 flower        3
5     2 pet           1
```

Note that there is a whole family of `slice()` functions in dplyr. Take a look at the help file here: 


``` r
help(slice)
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

Here's an easy way to plot distributions in `ggplot2` using the `stat_function()` function. We take a look at a normal distribution of height (in cm) with `mean = 180` and `sd = 10` (as this is the example we run with in class).


``` r
ggplot(data = tibble(height = c(150, 210)),
       mapping = aes(x = height)) +
  stat_function(fun = ~ dnorm(x = .,
                              mean = 180,
                              sd = 10))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-10-1.png" width="672" />

Note that the data frame I created with `tibble()` only needs to have the minimum and the maximum value of the x-range that we are interested in. Here, I chose `150` and `210` as the minimum and maximum, respectively (which is the mean +/- 3 standard deviations). 

The `stat_function()` is very flexible. We can define our own functions and plot these like here: 


``` r
# define the breakpoint function 
fun.breakpoint = function(x, breakpoint){
  x[x < breakpoint] = breakpoint
  return(x)
}

# plot the function
ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) +
  stat_function(fun = ~ fun.breakpoint(x = .,
                                       breakpoint = 2))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-11-1.png" width="672" />

Here, I defined a breakpoint function. If the value of `x` is below the breakpoint, `y` equals the value of the breakpoint. If the value of `x` is greater than the breakpoint, then `y` equals `x`. 


### Sampling from distributions

For each distribution, R provides a way of sampling random number from this distribution. For the normal distribution, we can use the `rnorm()` function to take random samples. 

So let's take some random samples and plot a histogram. 


``` r
# make this example reproducible 
set.seed(1)

# define how many samples to draw 
tmp.nsamples = 100

# make a data frame with the samples
df.plot = tibble(height = rnorm(n = tmp.nsamples,
                                mean = 180,
                                sd = 10))

# plot the samples using a histogram 
ggplot(data = df.plot,
       mapping = aes(x = height)) +
  geom_histogram(binwidth = 1,
                 color = "black",
                 fill = "lightblue") +
  scale_x_continuous(breaks = c(160, 180, 200)) +
  coord_cartesian(xlim = c(150, 210),
                  expand = F)

# remove all variables with tmp in their name 
rm(list = ls() %>% 
     str_subset(pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-12-1.png" width="672" />

Let's see how many samples it takes to closely approximate the shape of the normal distribution with our histogram of samples. 


``` r
# make this example reproducible 
set.seed(1)

# play around with this value
# tmp.nsamples = 100
tmp.nsamples = 10000
tmp.binwidth = 1

# make a data frame with the samples
df.plot = tibble(height = rnorm(n = tmp.nsamples,
                                mean = 180,
                                sd = 10)) 

# adjust the density of the normal distribution based on the samples and binwidth 
fun.dnorm = function(x, mean, sd, n, binwidth){
  dnorm(x = x, mean = mean, sd = sd) * n * binwidth
}

# plot the samples using a histogram 
ggplot(data = df.plot,
       mapping = aes(x = height)) +
  geom_histogram(binwidth = tmp.binwidth,
                 color = "black",
                 fill = "lightblue") +
  stat_function(fun = ~ fun.dnorm(x = .,
                                  mean = 180,
                                  sd = 10,
                                  n = tmp.nsamples,
                                  binwidth = tmp.binwidth),
                xlim = c(min(df.plot$height), max(df.plot$height)),
                linewidth = 2) +
  annotate(geom = "text",
           label = str_c("n = ", tmp.nsamples),
           x = -Inf,
           y = Inf,
           hjust = -0.1,
           vjust = 1.1,
           size = 10,
           family = "Courier New") +
  scale_x_continuous(breaks = c(160, 180, 200)) +
  coord_cartesian(xlim = c(150, 210),
                  expand = F)

# remove all variables with tmp in their name 
rm(list = ls() %>% 
     str_subset(pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-13-1.png" width="672" />
With 10,000 samples, our histogram of samples already closely resembles the theoretical shape of the normal distribution. 

To keep my environment clean, I've named the parameters `tmp.nsamples` and `tmp.binwidth` and then, at the end of the code chunk, I removed all variables from the environment that have "tmp." in their name using the `ls()` function (which prints out all variables in the environment as a vector), and the `str_subset()` function which filters out only those variables that contain the specified pattern.

### Understanding `density()`

First, let's calculate the density for a set of observations and store them in a data frame.


``` r
# calculate density
observations = c(1, 1.2, 1.5, 2, 3)
bandwidth = 0.25 # bandwidth (= sd) of the Gaussian distribution 
tmp.density = density(observations,
        kernel = "gaussian",
        bw = bandwidth,
        n = 512)

# save density as data frame 
df.density = tibble(x = tmp.density$x,
                    y = tmp.density$y) 

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
   <td style="text-align:right;"> 0.004 </td>
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


``` r
ggplot(data = df.density, 
       mapping = aes(x = x, y = y)) +
  geom_line(size = 2) +
  geom_point(data = enframe(observations),
             mapping = aes(x = value, y = 0),
             size = 3)
```

```
Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
ℹ Please use `linewidth` instead.
This warning is displayed once every 8 hours.
Call `lifecycle::last_lifecycle_warnings()` to see where this warning was generated.
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-15-1.png" width="672" />

This density shows the sum of the densities of normal distributions that are centered at the observations with the specified bandwidth. 


``` r
# add densities for the individual normal distributions
for (i in 1:length(observations)){
  df.density[[str_c("observation_",i)]] = dnorm(df.density$x,
                                                mean = observations[i],
                                                sd = bandwidth)
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
   <td style="text-align:right;"> 0.022 </td>
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
   <td style="text-align:right;"> 0.026 </td>
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


``` r
# colors of individual Gaussian distributions 
colors = c("blue", "green", "red", "purple", "orange")
bandwidth = 0.25

# original density 
p = ggplot(data = df.density, aes(x = x,
                                  y = y)) +
  geom_line(linewidth = 2)

# individual densities 
for (i in 1:length(observations)){
  p = p + stat_function(fun = dnorm,
                        args = list(mean = observations[i], sd = bandwidth),
                        color = colors[i])
}

# individual observations 
p = p + geom_point(data = enframe(observations),
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

<img src="07-simulation1_files/figure-html/unnamed-chunk-17-1.png" width="672" />

Here are the same results when specifying a different bandwidth: 


``` r
# colors of individual Gaussian distributions 
colors = c("blue", "green", "red", "purple", "orange")

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
  df.density[[str_c("observation_",i)]] = dnorm(df.density$x,
                                                mean = observations[i],
                                                sd = bandwidth)
}

# sum densities
df.density = df.density %>%
  mutate(sum_norm = rowSums(select(., contains("observation_"))),
         y = y * length(observations))

# original plot 
p = ggplot(data = df.density, aes(x = x, y = y)) +
  geom_line(linewidth = 2) +
  geom_point(data = enframe(observations),
             mapping = aes(x = value,
                           y = 0,
                           color = factor(1:5)),
             size = 3,
             show.legend = F) +
  scale_color_manual(values = colors)

# add individual Gaussians
for (i in 1:length(observations)){
  p = p + stat_function(fun = dnorm,
                        args = list(mean = observations[i], sd = bandwidth),
                        color = colors[i])
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

<img src="07-simulation1_files/figure-html/unnamed-chunk-18-1.png" width="672" />


### Cumulative probability distribution


``` r
ggplot(data = tibble(height = c(150, 210)),
       mapping = aes(x = height)) +
  stat_function(fun = ~ pnorm(q = ., 
                              mean = 180, 
                              sd = 10)) + 
  scale_x_continuous(breaks = c(160, 180, 200)) + 
  coord_cartesian(xlim = c(150, 210),
                  ylim = c(0, 1.05),
                  expand = F) + 
  labs(x = "height",
       y = "cumulative probability") 
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-19-1.png" width="672" />

Let's find the cumulative probability of a particular value. 


``` r
tmp.x = 190
tmp.y = pnorm(tmp.x, mean = 180, sd = 10)

print(tmp.y %>% round(3))
```

```
[1] 0.841
```

``` r
# draw the cumulative probability distribution and show the value
ggplot(data = tibble(height = c(150, 210)),
       mapping = aes(x = height)) +
  stat_function(fun = ~ pnorm(q = .,
                              mean = 180, 
                              sd = 10 )) +
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
  scale_x_continuous(breaks = c(160, 180, 200)) + 
  coord_cartesian(xlim = c(150, 210),
                  ylim = c(0, 1.05),
                  expand = F) + 
  labs(x = "height",
       y = "cumulative probability")
```

```
Warning in geom_segment(mapping = aes(x = tmp.x, xend = tmp.x, y = 0, yend = tmp.y), : All aesthetics have length 1, but the data has 2 rows.
ℹ Please consider using `annotate()` or provide this layer with data containing a single row.
```

```
Warning in geom_segment(mapping = aes(x = -5, xend = tmp.x, y = tmp.y, yend = tmp.y), : All aesthetics have length 1, but the data has 2 rows.
ℹ Please consider using `annotate()` or provide this layer with data containing a single row.
```

``` r
# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-20-1.png" width="672" />

Let's illustrate what this would look like using a normal density plot. 


``` r
ggplot(data = tibble(height = c(150, 210)),
       mapping = aes(x = height)) + 
  stat_function(fun = ~ dnorm(., mean = 180, sd = 10),
                geom = "area",
                fill = "lightblue",
                xlim = c(150, 190)) +
  stat_function(fun = ~ dnorm(., mean = 180, sd = 10),
                linewidth = 1.5) +
  scale_x_continuous(breaks = c(160, 180, 200)) + 
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  coord_cartesian(xlim = c(150, 210)) + 
  labs(x = "height", y = "density")
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-21-1.png" width="672" />

### Inverse cumulative distribution


``` r
ggplot(data = tibble(probability = c(0, 1)),
       mapping = aes(x = probability)) +
  stat_function(fun = ~ qnorm(p = ., 
                              mean = 180,
                              sd = 10)) + 
  scale_x_continuous(breaks = seq(from = 0, to = 1, by = 0.1)) + 
  scale_y_continuous(limits = c(160, 200)) + 
  coord_cartesian(xlim = c(0, 1.05),
                  expand = F) + 
  labs(y = "height", 
       x = "cumulative probability")
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-22-1.png" width="672" />

And let's compute the inverse cumulative probability for a particular value. 


``` r
tmp.x = 0.3
tmp.y = qnorm(tmp.x, mean = 180, sd = 10)

tmp.y %>% 
  round(3) %>% 
  print()
```

```
[1] 174.756
```

``` r
# draw the cumulative probability distribution and show the value
ggplot(data = tibble(probability = c(0, 1)),
       mapping = aes(x = probability)) +
  stat_function(fun = ~ qnorm(., mean = 180, sd = 10)) +
  annotate(geom = "point",
           x = tmp.x, 
           y = tmp.y,
           size = 4,
           color = "blue") +
  geom_segment(mapping = aes(x = tmp.x,
                             xend = tmp.x,
                             y = 160,
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
  scale_y_continuous(limits = c(160, 200)) + 
  coord_cartesian(xlim = c(0, 1.05),
                  expand = F) + 
  labs(x = "cumulative probability",
       y = "height")
```

```
Warning in geom_segment(mapping = aes(x = tmp.x, xend = tmp.x, y = 160, : All aesthetics have length 1, but the data has 2 rows.
ℹ Please consider using `annotate()` or provide this layer with data containing a single row.
```

```
Warning in geom_segment(mapping = aes(x = 0, xend = tmp.x, y = tmp.y, yend = tmp.y), : All aesthetics have length 1, but the data has 2 rows.
ℹ Please consider using `annotate()` or provide this layer with data containing a single row.
```

``` r
# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-23-1.png" width="672" />

### Computing probabilities

#### Via probability distributions

Let's compute the probability of observing a particular value $x$ in a given range. 


``` r
tmp.lower = 170
tmp.upper = 180

tmp.prob = pnorm(tmp.upper, mean = 180, sd = 10) - 
  pnorm(tmp.lower, mean = 180, sd = 10)

tmp.prob
```

```
[1] 0.3413447
```

``` r
ggplot(data = tibble(x = c(150, 210)),
       mapping = aes(x = x)) + 
  stat_function(fun = ~ dnorm(., mean = 180, sd = 10),
                geom = "area",
                fill = "lightblue",
                xlim = c(tmp.lower, tmp.upper),
                color = "black",
                linetype = 2) +
  stat_function(fun = ~ dnorm(., mean = 180, sd = 10),
                linewidth = 1.5) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  scale_x_continuous(breaks = c(160, 180, 200)) + 
  coord_cartesian(xlim = c(150, 210)) + 
  labs(x = "height",
       y = "density") 

# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-24-1.png" width="672" />

We find that ~34% of the heights are between 170 and 180 cm. 

#### Via sampling

We can also compute the probability of observing certain events using sampling. We first generate samples from the desired probability distribution, and then use these samples to compute our statistic of interest. 



``` r
# let's compute the probability of observing a value within a certain range 
tmp.lower = 170
tmp.upper = 180

# make example reproducible
set.seed(1)

# generate some samples and store them in a data frame 
tmp.nsamples = 10000

df.samples = tibble(height = rnorm(n = tmp.nsamples, mean = 180, sd = 10))

# compute the probability that sample lies within the range of interest
tmp.prob = df.samples %>% 
  filter(height >= tmp.lower,
         height <= tmp.upper) %>% 
  summarize(prob = n()/tmp.nsamples)

# illustrate the result using a histogram 
ggplot(data = df.samples,
       mapping = aes(x = height)) + 
  geom_histogram(binwidth = 1,
                 color = "black",
                 fill = "lightblue") +
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
           x = 175,
           y = 200,
           hjust = 0.5,
           size = 10) + 
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  labs(x = "height")

# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-25-1.png" width="672" />
## Pinguin exercise 

Assume that we have a population of penguins whose height is distribution according to a Gamma distribution with a `shape` parameter of 50, and `rate` parameter of 1. 

### Make the plot


``` r
ggplot(data = tibble(height = c(30, 70)),
       mapping = aes(x = height)) +
  stat_function(fun = ~ dgamma(.,
                               shape = 50,
                               rate = 1))
```

<img src="07-simulation1_files/figure-html/unnamed-chunk-26-1.png" width="672" />

### Analytic solutions

#### Question: A 60cm tall Penguin claims that no more than 10% are taller than her. Is she correct?


``` r
1 - pgamma(60, shape = 50, rate = 1)
```

```
[1] 0.08440668
```

Answer: Yes, she is correct. Only ~ 8.4% of Penguins are taller than her. 

#### Question:  Are there more penguins between 50 and 55cm or between 55 and 65cm?


``` r
first_range = pgamma(55, shape = 50, rate = 1) - pgamma(50, shape = 50, rate = 1)
second_range = pgamma(65, shape = 50, rate = 1) - pgamma(55, shape = 50, rate = 1)

first_range - second_range
```

```
[1] 0.04029452
```

Answer: There are 4% more Penguins between 50 and 55cm than between 55 and 65 cm. 

#### Question: What size is a Penguin who is taller than 75% of the rest?


``` r
qgamma(0.75, shape = 50, rate = 1)
```

```
[1] 54.57062
```

Answer: A Penguin who is ~54.6cm tall is taller than 75% of the rest. 

### Sampling solution

Let's just simulate a bunch of Penguins, yay! 


``` r
set.seed(1)
df.penguins = tibble(height = rgamma(n = 100000, shape = 50, rate = 1))
```
  
#### Question: A 60cm tall Penguin claims that no more than 10% are taller than her. Is she correct?


``` r
df.penguins %>% 
  summarize(probability = sum(height > 60) / n())
```

```
# A tibble: 1 × 1
  probability
        <dbl>
1      0.0835
```

Answer: Yes, she is correct. Only ~ 8.3% of Penguins are taller than her. 

#### Question: Are there more penguins between 50 and 55cm or between 55 and 65cm?


``` r
df.penguins %>% 
  summarize(probability = (sum(between(height, 50, 55)) - sum(between(height, 55, 65)))/n())
```

```
# A tibble: 1 × 1
  probability
        <dbl>
1      0.0387
```

Answer: There are 3.9% more Penguins between 50 and 55cm than between 55 and 65 cm. 

#### Question: What size is a Penguin who is taller than 75% of the rest?


``` r
df.penguins %>% 
  arrange(height) %>%
  slice_head(prop = 0.75) %>% 
  summarize(height = max(height))
```

```
# A tibble: 1 × 1
  height
   <dbl>
1   54.6
```

Answer: A Penguin who is ~54.6cm tall is taller than 75% of the rest.


## Bayesian inference with the normal distribution

Let's consider the following scenario. You are helping out at a summer camp. This summer, two different groups of kids go to the same summer camp. The chess kids, and the basketball kids. The chess summer camp is not quite as popular as the basketball summer camp (shocking, I know!). In fact, twice as many children have signed up for the basketball camp. 

When signing up for the camp, the children were asked for some demographic information including their height in cm. Unsurprisingly, the basketball players tend to be taller on average than the chess players. In fact, the basketball players' height is approximately normally distributed with a mean of 180cm and a standard deviation of 10cm. For the chess players, the mean height is 170cm with a standard deviation of 8cm. 

At the camp site, a child walks over to you and asks you where their gym is. You gage that the child is around 175cm tall. Where should you direct the child to? To the basketball gym, or to the chess gym? 

### Analytic solution


``` r
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

print(posterior_basketball)
```

```
[1] 0.631886
```

### Solution via sampling

Let's do the same thing via sampling. 


``` r
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
df.camp = tibble(kid = 1:tmp.nkids,
                 sport = sample(c("chess", "basketball"),
                                size = tmp.nkids,
                                replace = T,
                                prob = c(prior_chess, prior_basketball))) %>% 
  rowwise() %>% 
  mutate(height = ifelse(test = sport == "chess",
                         yes = rnorm(n = .,
                                     mean = mean_chess,
                                     sd = sd_chess),
                         no = rnorm(n = .,
                                    mean = mean_basketball,
                                    sd = sd_basketball))) %>% 
  ungroup

print(df.camp)
```

```
# A tibble: 10,000 × 3
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
# ℹ 9,990 more rows
```

Now we have a data frame with kids whose height was randomly sampled depending on which sport they do. I've used the `sample()` function to assign a sport to each kid first using the `prob = ` argument to make sure that a kid is more likely to be assigned the sport "basketball" than "chess". 

Note that the solution above is not particularly efficient since it uses the `rowwise()` function to make sure that a different random value for height is drawn for each row. Running this code will get slow for large samples. A more efficient solution would be the following: 


``` r
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
  mutate(height = c(rnorm(sum(sport == "basketball"),
                          mean = mean_basketball,
                          sd = sd_basketball),
                    rnorm(sum(sport == "chess"),
                          mean = mean_chess,
                          sd = sd_chess)))
```

In this solution, I take advantage of the fact that `rnorm()` is vectorized. That is, it can produce many random draws in one call. To make this work, I first arrange the data frame, and then draw the correct number of samples from each of the two distributions. This works fast, even if I'm drawing a large number of samples. 

How can we now use these samples to answer our question of interest? Let's see what doesn't work first: 


``` r
tmp.height = 175

df.camp %>% 
  filter(height == tmp.height) %>% 
  count(sport) %>% 
  pivot_wider(names_from = sport, values_from = n) %>% 
  summarize(prob_basketball = basketball/(basketball + chess))
```

The reason this doesn't work is because none of our kids is exactly 175cm tall. Instead, we need to filter kids that are within a certain height range. 


``` r
tmp.height = 175
tmp.margin = 1

df.camp %>% 
  filter(between(height,
                 left = tmp.height - tmp.margin,
                 right = tmp.height + tmp.margin)) %>% 
  count(sport) %>% 
  pivot_wider(names_from = sport,
              values_from = n) %>% 
  summarize(prob_basketball = basketball/(basketball + chess))
```

```
# A tibble: 1 × 1
  prob_basketball
            <dbl>
1           0.632
```

Here, I've used the `between()` function which is a shortcut for otherwise writing `x >= left & x <= right`. You can play around with the margin to see how the result changes. 

## Additional resources

### Datacamp

- [Foundations of probability in R](https://www.datacamp.com/courses/foundations-of-probability-in-r)
  
## Session info

Information about this R session including which version of R was used, and what packages were loaded. 


``` r
sessionInfo()
```

```
R version 4.4.1 (2024-06-14)
Platform: aarch64-apple-darwin20
Running under: macOS Sonoma 14.6

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
 [1] lubridate_1.9.3  forcats_1.0.0    stringr_1.5.1    dplyr_1.1.4     
 [5] purrr_1.0.2      readr_2.1.5      tidyr_1.3.1      tibble_3.2.1    
 [9] ggplot2_3.5.1    tidyverse_2.0.0  patchwork_1.2.0  MASS_7.3-61     
[13] kableExtra_1.4.0 knitr_1.48      

loaded via a namespace (and not attached):
 [1] sass_0.4.9        utf8_1.2.4        generics_0.1.3    xml2_1.3.6       
 [5] stringi_1.8.4     hms_1.1.3         digest_0.6.36     magrittr_2.0.3   
 [9] evaluate_0.24.0   grid_4.4.1        timechange_0.3.0  bookdown_0.40    
[13] fastmap_1.2.0     jsonlite_1.8.8    fansi_1.0.6       viridisLite_0.4.2
[17] scales_1.3.0      jquerylib_0.1.4   cli_3.6.3         crayon_1.5.3     
[21] rlang_1.1.4       munsell_0.5.1     withr_3.0.0       cachem_1.1.0     
[25] yaml_2.3.9        tools_4.4.1       tzdb_0.4.0        colorspace_2.1-0 
[29] vctrs_0.6.5       R6_2.5.1          lifecycle_1.0.4   pkgconfig_2.0.3  
[33] pillar_1.9.0      bslib_0.7.0       gtable_0.3.5      glue_1.7.0       
[37] systemfonts_1.1.0 highr_0.11        xfun_0.45         tidyselect_1.2.1 
[41] rstudioapi_0.16.0 farver_2.1.2      htmltools_0.5.8.1 labeling_0.4.3   
[45] rmarkdown_2.27    svglite_2.1.3     compiler_4.4.1   
```
