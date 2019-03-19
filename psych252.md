--- 
title: "Psych 252: Statistical Methods for Behavioral and Social Sciences"
author: "Tobias Gerstenberg"
date: "2019-03-19"
book_filename: "psych252"
language:
  ui:
    chapter_name: "Chapter "
delete_merged_file: true
output_dir: "docs"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
github-repo: psych252/psych252book
description: "Course notes for Psych 252."
---

# Preface {-}

This book contains the course notes for [Psych 252](https://psych252.github.io/). The book is not intended to be self-explanatory and instead should be used in combination with the course lectures. 

If you have any questions about the notes, please feel free to contact me at: gerstenberg@stanford.edu 




<!--chapter:end:index.Rmd-->

# Introduction

## Thanks 

Various people have helped in the process of putting together these materials (either knowingly, or unknowingly). Big thanks go to: 

- Alexandra Chouldechova
- Ben Baumer
- Benoit Monin
- Datacamp
- David Lagnado
- Ewart Thomas
- Henrik Singmann
- Julian Jara-Ettinger
- Kevin Smith
- Maarten Speekenbrink
- Matthew Kay
- Matthew Salganik
- Mika Braginsky 
- Mike Frank 
- Mine Çetinkaya-Rundel
- Patrick Mair
- Peter Cushner Mohanty
- Richard McElreath
- Russ Poldrack 
- Stephen Dewitt
- Tom Hardwicke
- Tristan Mahr

Special thanks also to my teaching assistants: 

- Andrew Lampinen
- Mona Rosenke 
- Shao-Fang (Pam) Wang

## List of R packages used in this book 


```r
# RMarkdown 
library("knitr")        # markdown things 
library("kableExtra")   # for nicely formatted tables

# Datasets 
library("gapminder")    # data available from Gapminder.org 
library("NHANES")       # data set 
library("titanic")      # titanic dataset

# Data manipulation
library("arrangements") # fast generators and iterators for permutations, combinations and partitions
library("magrittr")     # for wrangling
library("tidyverse")    # everything else

# Visualization
library("patchwork")    # making figure panels
library("cowplot")      # making figure panels
library("ggpol")        # for making fancy boxplots
library("ggridges")     # for making joyplots 
library("gganimate")    # for making animations
library("GGally")       # for pairs plot
library("ggrepel")      # for labels in ggplots
library("corrr")        # for calculating correlations between many variables
library("corrplot")     # for plotting correlations
library("DiagrammeR")   # for drawing diagrams

# Modeling 
library("afex")         # also for running ANOVAs
library("lme4")         # mixed effects models 
library("emmeans")      # comparing estimated marginal means 
library("broom")        # getting tidy model summaries
library("broom.mixed")  # getting tidy mixed model summaries
library("janitor")      # cleaning variable names 
library("car")          # for running ANOVAs
library("rstanarm")     # for Bayesian models
library("greta")        # Bayesian models
library("tidybayes")    # tidying up results from Bayesian models
library("boot")         # bootstrapping
library("modelr")       # cross-validation and bootstrapping
library("mediation")    # for mediation and moderation analysis 
library("multilevel")   # Sobel test
library("extraDistr")   # additional probability distributions
library("effects")      # for showing effects in linear, generalized linear, and other models
library("brms")         # Bayesian regression

# Misc 
library("tictoc")       # timing things
library("MASS")         # various useful functions (e.g. bootstrapped confidence intervals)
library("lsr")          # for computing effect size measures
library("extrafont")    # additional fonts
library("pwr")          # for power calculations
```


<!--chapter:end:01-introduction.Rmd-->

# Visualization 1

In this lecture, we will take a look at how to visualize data using the powerful [ggplot2](https://ggplot2.tidyverse.org/) package. We will use `ggplot2` a lot throughout the rest of the course! 

## Learning objectives 

- Get familiar with the RStudio interface.
- Take a look at some suboptimal plots, and think about how to make them better.
- Understand the general philosophy behind `ggplot2` -- a grammar of graphics. 
- Understand the mapping from data to geoms in `ggplot2`.
- Create informative figures using grouping and facets. 

## Load packages

Let's first load the packages that we need for this chapter.


```r
library("knitr")     # for rendering the RMarkdown file
library("tidyverse") # for plotting (and many more cool things we'll discover later)
```

The `tidyverse` is a collection of packages that includes `ggplot2`.

## Why visualize data?

> The greatest value of a picture is when it forces us to notice what we never expected to see. — John Tukey

> There is no single statistical tool that is as powerful as a well‐chosen graph. [@chambers1983graphical]

> ...make __both__ calculations __and__ graphs. Both sorts of output should be studied; each will contribute to understanding. [@anscombe1973american]

\begin{figure}
\includegraphics[width=36.56in]{figures/anscombe} \caption{Anscombe's quartet.}(\#fig:visualization1-02)
\end{figure}

Anscombe's quartet in Figure \@ref(fig:visualization1-01) (left side) illustrates the importance of visualizing data. Even though the datasets I-IV have the same summary statistics (mean, standard deviation, correlation), they are importantly different from each other. On the right side, we have four data sets with the same summary statistics that are very similar to each other.

\begin{figure}
\includegraphics[width=29.33in]{figures/correlations} \caption{The Pearson's $r$ correlation coefficient is the same for all of these datasets. Source: [Data Visualization -- A practical introduction by Kieran Healy](http://socviz.co/lookatdata.html#lookatdata)}(\#fig:visualization1-03)
\end{figure}

All the datasets in Figure \@ref(fig:visualization1-03) share the same correlation coefficient. However, again, they are very different from each other.

\begin{figure}
\includegraphics[width=68.71in]{figures/datasaurus_dozen} \caption{__The Datasaurus Dozen__. While different in appearance, each dataset has the same summary statistics to two decimal places (mean, standard deviation, and Pearson's correlation).}(\#fig:visualization1-04)
\end{figure}

The data sets in Figure \@ref(fig:visualization1-04) all share the same summary statistics. Clearly, the data sets are not the same though.

> __Tip__: Always plot the data first!

[Here](https://www.autodeskresearch.com/publications/samestats) is the paper from which I took Figure \@ref(fig:visualization1-02) and \@ref(fig:visualization1-04). It explains how the figures were generated and shows more examples for how summary statistics and some kinds of plots are insufficient to get a good sense for what's going on in the data.

![(\#fig:visualization1-05)Animation showing different data sets that all share the same summary statistics.](figures/data_dino.gif) 

### How _not_ to visualize data

Below are some examples of visualizations that could be improved. How would you make them better?

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/bad_plot1} 

}

\caption{Example of a bad plot. Source: [Data Visualization -- A practical introduction by Kieran Healy](http://socviz.co/lookatdata.html#lookatdata)}(\#fig:visualization1-06)
\end{figure}

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/bad_plot2} 

}

\caption{Another bad plot. Source: Google image search for 'bad graphs'}(\#fig:visualization1-07)
\end{figure}

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/bad_plot3} 

}

\caption{And another one. Source: [Bad graph wall of shame](http://bcuchta.com/wall_of_shame/)}(\#fig:visualization1-08)
\end{figure}

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/bad_plot4} 

}

\caption{And another one. Source: [Bad graph wall of shame](http://bcuchta.com/wall_of_shame/)}(\#fig:visualization1-09)
\end{figure}

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/bad_plot5} 

}

\caption{And another one. Source: [Bad graph wall of shame](http://bcuchta.com/wall_of_shame/)}(\#fig:visualization1-10)
\end{figure}

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/bad_plot6} 

}

\caption{The last one for now. Source: [Bad graph wall of shame](http://bcuchta.com/wall_of_shame/)}(\#fig:visualization1-11)
\end{figure}

### How to make it better

In this class, we you will learn how to use `ggplot2` to make nice figures. The `ggplot2` library provides a unified framework for making plots -- it defines a grammar of graphics according to which we construct figures step by step.

Instead of learning rigid rules for what makes for a good figure, you will learn how to make figures yourself, play around with things, and get a feeling for what works best.

## Setting up RStudio

\begin{figure}
\includegraphics[width=1\linewidth]{figures/r_preferences_general} \caption{General preferences.}(\#fig:visualization1-12)
\end{figure}

__Make sure that__:

- Restore .RData into workspace at startup is _unselected_
- Save workspace to .RData on exit is set to _Never_

\begin{figure}
\includegraphics[width=1\linewidth]{figures/r_preferences_code} \caption{Code window preferences.}(\#fig:visualization1-13)
\end{figure}

__Make sure that__:

- Soft-wrap R source files is _selected_

This way you don't have to scroll horizontally. At the same time, avoid writing long single lines of code. For example, instead of writing code like so:

```r
ggplot(data = diamonds, aes(x = cut, y = price)) +
  stat_summary(fun.y = "mean", geom = "bar", color = "black", fill = "lightblue", width = 0.85) +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange", size = 1.5) +
  labs(title = "Price as a function of quality of cut", subtitle = "Note: The price is in US dollars", tag = "A", x = "Quality of the cut", y = "Price")
```

You may want to write it this way instead:


```r
ggplot(data = diamonds, aes(x = cut, y = price)) +
  # display the means
  stat_summary(fun.y = "mean",
               geom = "bar",
               color = "black",
               fill = "lightblue",
               width = 0.85) +
  # display the error bars
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               size = 1.5) +
  # change labels
  labs(title = "Price as a function of quality of cut",
       subtitle = "Note: The price is in US dollars", # we might want to change this later
       tag = "A",
       x = "Quality of the cut",
       y = "Price")
```

This makes it much easier to see what's going on, and you can easily add comments to individual lines of code.

RStudio makes it easy to write nice code. It figures out where to put the next line of code when you press `ENTER`. And if things ever get messy, just select the code of interest and hit `cmd+i` to re-indent the code.

Here are some more resources with tips for how to write nice code in R:

- [Advanced R style guide](http://adv-r.had.co.nz/Style.html)

## Getting help

There are three simple ways to get help in R. You can either put a `?` in front of the function you'd like to learn more about, or use the `help()` function.


```r
?print
help("print")
```

>__Tip__: To see the help file, hover over a function (or dataset) with the mouse (or select the text) and then press `F1`.

I recommend using `F1` to get to help files -- it's the fastest way!

R help files can sometimes look a little cryptic. Most R help files have the following sections (copied from [here](https://www.dummies.com/programming/r/r-for-dummies-cheat-sheet/)):

---

__Title__: A one-sentence overview of the function.

__Description__: An introduction to the high-level objectives of the function, typically about one paragraph long.

__Usage__: A description of the syntax of the function (in other words, how the function is called). This is where you find all the arguments that you can supply to the function, as well as any default values of these arguments.

__Arguments__: A description of each argument. Usually this includes a specification of the class (for example, character, numeric, list, and so on). This section is an important one to understand, because arguments are frequently a cause of errors in R.

__Details__: Extended details about how the function works, provides longer descriptions of the various ways to call the function (if applicable), and a longer discussion of the arguments.

__Value__: A description of the class of the value returned by the function.

__See also__: Links to other relevant functions. In most of the R editors, you can click these links to read the Help files for these functions.

__Examples__: Worked examples of real R code that you can paste into your console and run.

---

Here is the help file for the `print()` function:

\begin{figure}
\includegraphics[width=42.22in]{figures/help_print} \caption{Help file for the print() function.}(\#fig:visualization1-17)
\end{figure}

## Data visualization using `ggplot2`

We will use the `ggplot2` package to visualize data. By the end of next class, you'll be able to make a figure like this:

![(\#fig:visualization1-18)What a nice figure!](figures/combined_plot.pdf) 

Now let's figure out how to get there.

### Setting up a plot

Let's first get some data.


```r
df.diamonds = diamonds
```

The `diamonds` dataset comes with the `ggplot2` package. We can get a description of the dataset by running the following command:


```r
?diamonds
```

Above, we assigned the `diamonds` dataset to the variable `df.diamonds` so that we can see it in the data explorer.

Let's take a look at the full dataset by clicking on it in the explorer.

>__Tip__: You can view a data frame by highlighting the text in the editor (or simply moving the mouse above the text), and then press `F2`.

The `df.diamonds` data frame contains information about almost 60,000 diamonds, including their `price`, `carat` value, size, etc. Let's use visualization to get a better sense for this dataset.
We start by setting up the plot. To do so, we pass a data frame to the function `ggplot()` in the following way.


```r
ggplot(data = df.diamonds)
```

![](02-visualization1_files/figure-latex/visualization1-21-1.pdf)<!-- --> 

This, by itself, won't do anything yet. We also need to specify what to plot.

Let's take a look at how much diamonds of different color cost. The help file says that diamonds labeled D have the best color, and diamonds labeled J the worst color. Let's make a bar plot that shows the average price of diamonds for different colors.

We do so via specifying a mapping from the data to the plot aesthetics with the function `aes()`. We need to tell `aes()` what we would like to display on the x-axis, and the y-axis of the plot.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = color, y = price))
```

![](02-visualization1_files/figure-latex/visualization1-22-1.pdf)<!-- --> 

Here, we specified that we want to plot `color` on the x-axis, and `price` on the y-axis. As you can see, `ggplot2` has already figured out how to label the axes. However, we still need to specify _how_ to plot it. Let's make a __bar graph__:


```r
ggplot(data = df.diamonds,
       mapping = aes(x = color, y = price)) +
  stat_summary(fun.y = "mean", geom = "bar")
```

![](02-visualization1_files/figure-latex/visualization1-23-1.pdf)<!-- --> 

Neat! Three lines of code produce an almost-publication-ready plot (to be published in the _Proceedings of Unnecessary Diamonds_)! Note how we used a `+` at the end of the first line of code to specify that there will be more. This is a very powerful idea underlying `ggplot2`. We can start simple and keep adding things to the plot step by step.

We used the `stat_summary()` function to define _what_ we want to plot (the "mean"), and _how_ (as a "bar" chart). Let's take a closer look at that function.


```r
help(stat_summary)
```

Not the the easiest help file ... We supplied two arguments to the function, `fun.y = ` and `geom = `.

1. The `fun.y` argument specifies _what_ function we'd like to apply to the data for each value of `x`. Here, we said that we would like to take the `mean` and we specified that as a string.
2. The `geom` (= geometric object) argument specifies _how_ we would like to plot the result, namely as a "bar" plot.

Instead of showing the "mean", we could also show the "median" instead.


```r
ggplot(data = df.diamonds, mapping = aes(x = color, y = price)) +
  stat_summary(fun.y = "median", geom = "bar")
```

![](02-visualization1_files/figure-latex/visualization1-25-1.pdf)<!-- --> 

And instead of making a bar plot, we could plot some points.


```r
ggplot(df.diamonds, aes(x = color, y = price)) +
  stat_summary(fun.y = "mean", geom = "point")
```

![](02-visualization1_files/figure-latex/visualization1-26-1.pdf)<!-- --> 

>__Tip__: Take a look [here](https://ggplot2.tidyverse.org/reference/#section-layer-geoms) to see what other geoms ggplot2 supports.

Somewhat surprisingly, diamonds with the best color (D) are not the most expensive ones. What's going on here? We'll need to do some more exploration to figure this out.

Note that in the last plot, I removed the `data = ` and `mapping = ` specifiers. These keywords are optional, and as long as we provide the arguments to the function in the correct order, we are ok. So, the following doesn't work:


```r
ggplot(aes(x = color, y = price), df.diamonds) +
  stat_summary(fun.y = "mean", geom = "point")
```

While this works:


```r
ggplot(mapping = aes(x = color, y = price), data = df.diamonds) +
  stat_summary(fun.y = "mean", geom = "point")
```

![](02-visualization1_files/figure-latex/visualization1-28-1.pdf)<!-- --> 

In general, it's good practice to include the specifiers -- particularly for functions that are not used all the time. If the same function is used multiple times throughout the script, I would suggest to use the specifiers first, and then it's ok to drop them later.

### Setting the default plot theme

Before moving one, let's set a different default theme for our plots. Personally, I'm not a big fan of the gray background and the white grid lines. Also, the default size of the text should be bigger. We can change the default theme using the `theme_set()` function like so:


```r
theme_set(
  theme_classic() + # set the theme
    theme(text = element_text(size = 20)) # set the default text size
)
```

From now onwards, all our plots will use what's specified in `theme_classic()`, and the default text size will be larger, too. For any individual plot, we can still override these settings.

### Scatter plot

I don't know much about diamonds, but I do know that diamonds with a higher `carat` value tend to be more expensive. `color` was a discrete variable with seven different values. `carat`, however, is a continuous variable. We want to see how the price of diamonds differs as a function of the `carat` value. Since we are interested in the relationship between two continuous variables, plotting a bar graph won't work. Instead, let's make a __scatter plot__. Let's put the `carat` value on the x-axis, and the `price` on the y-axis.


```r
ggplot(data = df.diamonds, mapping = aes(x = carat, y = price)) +
  geom_point()
```

![(\#fig:visualization1-30)Scatterplot.](02-visualization1_files/figure-latex/visualization1-30-1.pdf) 

Cool! That looks sensible. Diamonds with a higher `carat` value tend to have a higher `price`. Our dataset has 53940 rows. So the plot actually shows 53940 circles even though we can't see all of them since they overlap.

Let's make some progress on trying to figure out why the diamonds with the better color weren't the most expensive ones on average. We'll add some color to the scatter plot in Figure \@ref(fig:visualization-31). We color each of the points based on the diamond's color. To do so, we pass another argument to the aesthetics of the plot via `aes()`.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = carat,
                     y = price,
                     color = color)) +
  geom_point()
```

![(\#fig:visualization1-31)Scatterplot with color.](02-visualization1_files/figure-latex/visualization1-31-1.pdf) 

Aha! Now we've got some color. Notice how in Figure \@ref(fig:visualization-30) `ggplot2` added a legend for us, thanks! We'll see later how to play around with legends. Form just eye-balling the plot, it looks like the diamonds with the best `color` (D) tended to have a lower `carat` value, and the ones with the worst `color` (J), tended to have the highest carat values.

So this is why diamonds with better colors are less expensive -- these diamonds have a lower carat value overall.

There are many other things that we can define in `aes()`. Take a quick look at the vignette:


```r
vignette("ggplot2-specs")
```

#### Practice plot 1

Make a scatter plot that shows the relationship between the variables `depth` (on the x-axis), and `table` (on the y-axis). Take a look at the description for the `diamonds` dataset so you know what these different variables mean. Your plot should look like the one shown in Figure \@ref(fig:visualization1-34).


```r
# make practice plot 1 here
```


```r
include_graphics("figures/practice_plot1.png")
```

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/practice_plot1} 

}

\caption{Practice plot 1.}(\#fig:visualization1-34)
\end{figure}

### Line plot

What else do we know about the diamonds? We actually know the quality of how they were cut. The `cut` variable ranges from "Fair" to "Ideal". First, let's take a look at the relationship between `cut` and `price`. This time, we'll make a line plot instead of a bar plot (just because we can).


```r
ggplot(data = df.diamonds, mapping = aes(x = cut, y = price)) +
  stat_summary(fun.y = "mean", geom = "line")
```

```
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
```

![](02-visualization1_files/figure-latex/visualization1-35-1.pdf)<!-- --> 

Oops! All we did is that we replaced `x = color` with `x = cut`, and `geom = "bar"` with `geom = "line"`. However, the plot doesn't look like expected (i.e. there is no real plot). What happened here? The reason is that the line plot needs to know what points to connect. The error message tells us that each group consists of only one observation. Let's adjust the group asthetic to fix this.


```r
ggplot(data = df.diamonds, mapping = aes(x = cut, y = price, group = 1)) +
  stat_summary(fun.y = "mean", geom = "line")
```

![](02-visualization1_files/figure-latex/visualization1-36-1.pdf)<!-- --> 

By adding the parameter `group = 1` to `mapping = aes()`, we specify that we would like all the levels in `x = cut` to be treated as coming from the same group. The reason for this is that `cut` (our x-axis variable) is a factor (and not a numeric variable), so, by default, `ggplot2` tries to draw a separate line for each factor level. We'll learn more about grouping below (and about factors later).

Interestingly, there is no simple relationship between the quality of the cut and the price of the diamond. In fact, "Ideal" diamonds tend to be cheapest.

### Adding error bars

We often don't just want to show the means but also give a sense for how much the data varies. `ggplot2` has some convenient ways of specifying error bars. Let's take a look at how much `price` varies as a function of `clarity` (another variable in our `diamonds` data frame).


```r
ggplot(data = df.diamonds,
       mapping = aes(x = clarity, y = price)) +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange") + # plot bootstrapped error bars first
  stat_summary(fun.y = "mean",
               geom = "point") # add points with means
```

![(\#fig:visualization1-37)Relationship between diamond clarity and price. Error bars indicate 95% bootstrapped confidence intervals.](02-visualization1_files/figure-latex/visualization1-37-1.pdf) 

Here we have it. The average price of our diamonds for different levels of `clarity` together with bootstrapped 95% confidence intervals. How do we know that we have 95% confidence intervals? That's what `mean_cl_boot()` computes as a default. Let's take a look at that function:


```r
help(mean_cl_boot)
```

Remember that you can just select the text (or merely put the cursor over the word) and press `F1` to see the help. The help file tell us about the function `smean.cl.boot` in the `Hmisc` package. The `mean_cl_boot()` function is a version that works well with `ggplot2`. We see that this function takes as inputs, the confidence interval `conf.int`, the number of bootstrap samples `B`, and some other ones that we don't care about for now. So let's make the same plot again with 99.9% confidence intervals, and 2000 bootstrap samples.


```r
ggplot(data = df.diamonds, mapping = aes(x = clarity, y = price)) +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               fun.args = list(conf.int = .999, B = 2000)) + # plot bootstrapped error bars first
  stat_summary(fun.y = "mean",
               geom = "point") # add points with means
```

![(\#fig:visualization1-39)Relationship between diamond clarity and price. Error bars indicate 99% bootstrapped confidence intervals.](02-visualization1_files/figure-latex/visualization1-39-1.pdf) 

Note how the error bars are larger now in Figure Figure \@ref(fig:visualization-39) compared to Figure \@ref(fig:visualization-37)
. Note the somewhat peculiar way in which we supplied the parameters to the `mean_cl_boot` function. The `fun.args` argument takes in a list of arguments that it then passes on to the function `mean_cl_boot`.

#### Order matters

The order in which we add geoms to a ggplot matters! Generally, we want to plot error bars before the points that represent the means. To illustrate, let's set the color in which we show the means to "red".


```r
ggplot(df.diamonds, aes(x = clarity, y = price)) +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange") +
  stat_summary(fun.y = "mean", geom = "point", color = "red")
```

![(\#fig:visualization1-40)This figure looks good. Error bars and means are drawn in the correct order.](02-visualization1_files/figure-latex/visualization1-40-1.pdf) 

Figure \@ref(fig:visualization-38) looks good.


```r
# I've changed the order in which the means and error bars are drawn.
ggplot(df.diamonds, aes(x = clarity, y = price)) +
  stat_summary(fun.y = "mean", geom = "point", color = "red") +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange")
```

![(\#fig:visualization1-41)This figure looks good. Error bars and means are drawn in the correct order.](02-visualization1_files/figure-latex/visualization1-41-1.pdf) 

Figure \@ref(fig:visualization-39) doesn't look good. The error bars are on top of the points that represent the means.

One cool feature about using `stat_summary()` is that we did not have to change anything about the data frame that we used to make the plots. We directly used our raw data instead of having to make separate data frames that contain the relevant information (such as the means and the confidence intervals).

You may not remember exactly what confidence intervals actually are. Don't worry! We'll have a recap later in class.

Let's take a look at two more principles for plotting data that are extremely helpful: groups and facets. But before, another practice plot. 

#### Practice plot 2

Make a bar plot that shows the average `price` of diamonds (on the y-axis) as a function of their `clarity` (on the x-axis). Also add error bars. Your plot should look like the one shown in Figure \@ref(fig:visualization-41).


```r
# make practice plot 2 here
```


```r
include_graphics("figures/practice_plot2.png")
```

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/practice_plot2} 

}

\caption{Practice plot 2.}(\#fig:visualization1-43)
\end{figure}

### Grouping data

Grouping in `ggplot2` is a very powerful idea. It allows us to plot subsets of the data -- again without the need to make separate data frames first.

Let's make a plot that shows the relationship between `price` and `color` separately for the different qualities of `cut`.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = color,
                     y = price,
                     group = cut)) +
  stat_summary(fun.y = "mean", geom = "line")
```

![](02-visualization1_files/figure-latex/visualization1-44-1.pdf)<!-- --> 

Well, we got some separate lines here but we don't know which line corresponds to which cut. Let's add some color!


```r
ggplot(data = df.diamonds,
       mapping = aes(x = color,
                     y = price,
                     group = cut,
                     color = cut)) +
  stat_summary(fun.y = "mean",
               geom = "line",
               size = 2)
```

![](02-visualization1_files/figure-latex/visualization1-45-1.pdf)<!-- --> 

Nice! In addition to adding color, I've made the lines a little thicker here by setting the `size` argument to 2.

Grouping is very useful for bar plots. Let's take a look at how the average price of diamonds looks like taking into account both `cut` and `color` (I know -- exciting times!). Let's put the `color` on the x-axis and then group by the `cut`.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = color,
                     y = price,
                     group = cut,
                     color = cut)) +
  stat_summary(fun.y = "mean", geom = "bar")
```

![](02-visualization1_files/figure-latex/visualization1-46-1.pdf)<!-- --> 

That's a fail! Several things went wrong here. All the bars are gray and only their outline is colored differently. Instead we want the bars to have a different color. For that we need to specify the `fill` argument rather than the `color` argument! But things are worse. The bars currently are shown on top of each other. Instead, we'd like to put them next to each other. Here is how we can do that:


```r
ggplot(data = df.diamonds,
       mapping = aes(x = color,
                     y = price,
                     group = cut,
                     fill = cut)) +
  stat_summary(fun.y = "mean",
               geom = "bar",
               position = position_dodge()) +
  scale_fill_manual(values = c("lightblue", "blue", "orangered", "red", "black"))
```

![](02-visualization1_files/figure-latex/visualization1-47-1.pdf)<!-- --> 

Neato! We've changed the `color` argument to `fill`, and have added the `position = position_dodge()` argument to the `stat_summary()` call. This argument makes it such that the bars are nicely dodged next to each other. Let's add some error bars just for kicks.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = color,
                     y = price,
                     group = cut,
                     fill = cut)) +
  stat_summary(fun.y = "mean",
               geom = "bar",
               position = position_dodge(width = 0.9),
               color = "black") +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               position = position_dodge(width = 0.9))
```

![](02-visualization1_files/figure-latex/visualization1-48-1.pdf)<!-- --> 

Voila! Now with error bars. Note that we've added the `width = 0.9` argument to `position_dodge()`. Somehow R was complaining when this was not defined for geom "linerange". I've also added some outline to the bars by including the argument `color = "black"`. I think it looks nicer this way.

So, still somewhat surprisingly, diamonds with the worst color (J) are more expensive than dimanods with the best color (D), and diamonds with better cuts are not necessarily more expensive.

#### Practice plot 3

Recreate the plot shown in Figure \@ref(fig:visualization-48).


```r
# make practice plot 3 here
ggplot(diamonds, aes(x = color, y = price, group = clarity, color = clarity))+
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange", size = 1)+
  stat_summary(fun.y = "mean", geom = "line", size = 2)
```

![](02-visualization1_files/figure-latex/visualization1-49-1.pdf)<!-- --> 



```r
include_graphics("figures/practice_plot3.png")
```

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/practice_plot3} 

}

\caption{Practice plot 3.}(\#fig:visualization1-50)
\end{figure}

### Making facets

Having too much information in a single plot can be overwhelming. The previous plot is already pretty busy. Facets are a nice way of spliting up plots and showing information in separate panels.

Let's take a look at how wide these diamonds tend to be. The width in mm is given in the `y` column of the diamonds data frame. We'll make a histogram first. To make a histogram, the only aesthetic we needed to specify is `x`.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = y)) +
  geom_histogram()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](02-visualization1_files/figure-latex/visualization1-51-1.pdf)<!-- --> 

That looks bad! Let's pick a different value for the width of the bins in the histogram.


```r
ggplot(data = df.diamonds, mapping = aes(x = y)) +
  geom_histogram(binwidth = 0.1)
```

![](02-visualization1_files/figure-latex/visualization1-52-1.pdf)<!-- --> 

Still bad. There seems to be an outlier diamond that happens to be almost 60 mm wide, while most of the rest is much narrower. One option would be to remove the outlier from the data before plotting it. But generally, we don't want to make new data frames. Instead, let's just limit what data we want to show in the plot.


```r
ggplot(data = df.diamonds, mapping = aes(x = y)) +
  geom_histogram(binwidth = 0.1) +
  coord_cartesian(xlim = c(3, 10))
```

![](02-visualization1_files/figure-latex/visualization1-53-1.pdf)<!-- --> 

I've used the `coord_cartesian()` function to restrict the range of data to show by passing a minimum and maximum to the `xlim` argument. This looks better now.

Instead of histograms, we can also plot a density fitted to the distribution.


```r
ggplot(data = df.diamonds, mapping = aes(x = y)) +
  geom_density() +
  coord_cartesian(xlim = c(3, 10))
```

![](02-visualization1_files/figure-latex/visualization1-54-1.pdf)<!-- --> 

Looks pretty similar to our histogram above! Just like we can play around with the binwidth of the histogram, we can change the smoothing bandwidth of the kernel that is used to create the histogram. Here is a histogram with a much wider bandwidth:


```r
ggplot(data = df.diamonds, mapping = aes(x = y)) +
  geom_density(bw = 0.5) +
  coord_cartesian(xlim = c(3, 10))
```

![](02-visualization1_files/figure-latex/visualization1-55-1.pdf)<!-- --> 

We'll learn more about how these densities are determined later in class.

I promised that this section was about making facets, right? We're getting there! Let's first take a look at how wide diamonds of different `color` are. We can use grouping to make this happen.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = y,
                     group = color,
                     fill = color)) +
  geom_density(bw = 0.2, alpha = 0.2) +
  coord_cartesian(xlim = c(3, 10))
```

![](02-visualization1_files/figure-latex/visualization1-56-1.pdf)<!-- --> 

OK! That's a little tricky to tell apart. Notice that I've specified the `alpha` argument in the `geom_density()` function so that the densities in the front don't completely hide the densities in the back. But this plot still looks too busy. Instead of grouping, let's put the densities for the different colors, in separate panels. That's what facetting allows you to do.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = y, fill = color)) +
  geom_density(bw = 0.2) +
  facet_grid(cols = vars(color)) +
  coord_cartesian(xlim = c(3, 10))
```

![](02-visualization1_files/figure-latex/visualization1-57-1.pdf)<!-- --> 

Now we have the densities next to each other in separate panels. I've removed the `alpha` argument since the densities aren't overlapping anymore. To make the different panels, I used the `facet_grid()` function and specified that I want separate columns for the different colors (`cols = vars(color)`). What's the deal with `vars()`? Why couldn't we just write `facet_grid(cols = color)` instead? The short answer is: that's what the function wants. The long answer is: long. (We'll learn more about this later in the course.)

To show the facets in different rows instead of columns we simply replace `cols = vars(color)` with `rows = vars(color)`.


```r
ggplot(data = df.diamonds, mapping = aes(x = y, fill = color)) +
  geom_density(bw = 0.2) +
  facet_grid(rows = vars(color)) +
  coord_cartesian(xlim = c(3, 10))
```

![](02-visualization1_files/figure-latex/visualization1-58-1.pdf)<!-- --> 

Several aspects about this plot should be improved:

- the y-axis text is overlapping
- having both a legend and separate facet labels is redundant
- having separate fills is not really necessary here

So, what does this plot actually show us? Well, J-colored diamonds tend to be wider than D-colored diamonds. Fascinating!

Of course, we could go completely overboard with facets and groups. So let's do it! Let's look at how the average `price` (somewhat more interesting) varies as a function of `color`, `cut`, and `clarity`. We'll put color on the x-axis, and make separate rows for `cut` and columns for `clarity`.


```r
ggplot(data = df.diamonds,
       mapping = aes(y = price,
                     x = color,
                     fill = color)) +
  stat_summary(fun.y = "mean",
               geom = "bar",
               color = "black") +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange") +
  facet_grid(rows = vars(cut),
             cols = vars(clarity))
```

```
## Warning: Removed 5 rows containing missing values (geom_linerange).
```

![(\#fig:visualization1-59)A figure that is stretching it in terms of information.](02-visualization1_files/figure-latex/visualization1-59-1.pdf) 

Figure \@ref(fig:visualization-57) is stretching it in terms of how much information it presents. But it gives you a sense for how to combine the differnet bits and pieces we've learned so far.

#### Practice plot 4

Recreate the plot shown in Figure \@ref(fig:visualization-59).


```r
# make practice plot 4 here
ggplot(diamonds, aes(x = color, y = price, fill = cut))+
  stat_summary(fun.y = "mean",
               geom = "bar",
               position = position_dodge(width = 0.9),
               color = "black")+
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               position = position_dodge(width = 0.9),
               color = "black")+
  facet_grid(rows = vars(clarity)) +
  theme(axis.text.y = element_text(size = 10))
```

```
## Warning: Removed 5 rows containing missing values (geom_linerange).
```

![](02-visualization1_files/figure-latex/visualization1-60-1.pdf)<!-- --> 



```r
include_graphics("figures/practice_plot4.png")
```

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/practice_plot4} 

}

\caption{Practice plot 4.}(\#fig:visualization1-61)
\end{figure}

### Global, local, and setting `aes()`

`ggplot2` allows you to specify the plot aesthetics in different ways.


```r
ggplot(data = df.diamonds,
       mapping = aes(x = carat,
                     y = price,
                     color = color)) +
  geom_point() +
  geom_smooth(method = "lm", se = F)
```

![](02-visualization1_files/figure-latex/visualization1-62-1.pdf)<!-- --> 

Here, I've drawn a scatter plot of the relationship between `carat` and `price`, and I have added the best-fitting regression lines via the `geom_smooth(method = "lm")` call. (We will learn more about what these regression lines mean later in class.)

Because I have defined all the aesthetics at the top level (i.e. directly within the `ggplot()` function), the aesthetics apply to all the functions afterwards. Aesthetics defined in the `ggplot()` call are __global__. In this case, the `geom_point()` and the `geom_smooth()` functions. The `geom_smooth()` function produces separate best-fit regression lines for each different color.

But what if we only wanted to show one regression line instead that applies to all the data? Here is one way of doing so:


```r
ggplot(data = df.diamonds, mapping = aes(x = carat, y = price)) +
  geom_point(mapping = aes(color = color)) +
  geom_smooth(method = "lm")
```

![](02-visualization1_files/figure-latex/visualization1-63-1.pdf)<!-- --> 

Here, I've moved the color aesthetic into the `geom_point()` function call. Now, the `x` and `y` aesthetics still apply to both the `geom_point()` and the `geom_smooth()` function call (they are __global__), but the `color` aesthetic applies only to `geom_point()` (it is __local__). Alternatively, we can simply overwrite global aesthetics within local function calls.


```r
ggplot(data = df.diamonds, aes(x = carat, y = price, color = color)) +
  geom_point() +
  geom_smooth(method = "lm", color = "black")
```

![](02-visualization1_files/figure-latex/visualization1-64-1.pdf)<!-- --> 

Here, I've set `color = 'black'` within the `geom_smooth()` function, and now only one overall regression line is displayed since the global color aesthetic was overwritten in the local function call.

## Additional resources

### Cheatsheets

- [RStudio IDE](figures/rstudio-ide.pdf) --> information about RStudio
- [RMarkdown](figures/rmarkdown.pdf) --> information about writing in RMarkdown
- [RMarkdown reference](figures/rmarkdown-reference.pdf) --> RMarkdown reference sheet
- [Data visualization](figures/visualization-principles.pdf) --> general principles of effective graphic design
- [ggplot2](figures/data-visualization.pdf) --> specific information about ggplot

### Data camp courses

- [Introduction to R](https://www.datacamp.com/courses/free-introduction-to-r)
- [RStudio IDE 1](https://www.datacamp.com/courses/working-with-the-rstudio-ide-part-1)
- [RStudio IDE 2](https://www.datacamp.com/courses/working-with-the-rstudio-ide-part-2)
- [Communicating with data](https://www.datacamp.com/courses/communicating-with-data-in-the-tidyverse)
- [ggplot2 course 1](https://www.datacamp.com/courses/data-visualization-with-ggplot2-1)
- [ggplot2 course 2](https://www.datacamp.com/courses/data-visualization-with-ggplot2-2)

### Books and chapters

- [R graphics cookbook](http://www.cookbook-r.com/Graphs/) --> quick intro to the the most common graphs
- [R for Data Science book](http://r4ds.had.co.nz/)
	+ [Data visualization](http://r4ds.had.co.nz/data-visualisation.html)
	+ [Graphics for communication](http://r4ds.had.co.nz/graphics-for-communication.html)
- [Data Visualization -- A practical introduction (by Kieran Healy)](http://socviz.co/)
  + [Look at data](http://socviz.co/lookatdata.html#lookatdata)
  + [Make a plot](http://socviz.co/makeplot.html#makeplot)
  + [Show the right numbers](http://socviz.co/groupfacettx.html#groupfacettx)
- [Fundamentals of Data Visualization](https://serialmentor.com/dataviz/) --> very nice resource that goes beyond basic functionality of `ggplot` and focuses on how to make good figures (e.g. how to choose colors, axes, ...)

### Misc

- [ggplot2 extensions](http://www.ggplot2-exts.org/gallery/) --> gallery of ggplot2 extension packages
- [ggplot2 gui](https://github.com/dreamRs/esquisse) --> ggplot2 extension package
- [ggplot2 visualizations with code](http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html) --> gallery of plots with code
- [R Markdown in RStudio introduction](https://rmarkdown.rstudio.com/lesson-1.html)
- [R Markdown for class reports](http://www.stat.cmu.edu/~cshalizi/rmarkdown/)
- [knitr in a nutshell](https://kbroman.org/knitr_knutshell/)
- [styler](https://github.com/r-lib/styler) --> RStudio add-in that re-formats code

<!--chapter:end:02-visualization1.Rmd-->

# Visualization 2

In this lecture, we will lift our `ggplot2` skills to the next level! 

## Learning objectives 

- Deciding what plot is appropriate for what kind of data.  
- Customizing plots: Take a sad plot and make it better. 
- Saving plots. 
- Making figure panels. 
- Debugging. 
- Making animations. 
- Defining snippets. 

## Install and load packages, load data, set theme

Let's first install the new packages that you might not have yet. 



Note that the `patchwork` package is not on [CRAN](https://cran.r-project.org/) yet (where most of the R packages live), but we can install it directly from the [github repository](https://github.com/thomasp85/patchwork).

Now, let's load the packages that we need for this chapter. 


```r
library("knitr")         # for rendering the RMarkdown file
library("patchwork")     # for making figure panels
library("ggpol")         # for making fancy boxplots
library("ggridges")      # for making joyplots 
library("gganimate")     # for making animations
library("gapminder")     # data available from Gapminder.org 
library("tidyverse")     # for plotting (and many more cool things we'll discover later)
```

And let's load the diamonds data again. 


```r
df.diamonds = diamonds
```

Let's also set the default theme for the plots again. 


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Overview of different plot types for different things 

Different plots works best for different kinds of data. Let's take a look at some. 

### Proportions 

#### Stacked bar charts 


```r
ggplot(data = df.diamonds, aes(x = cut, y = stat(count), fill = color)) +
  geom_bar(color = "black")
```

![](03-visualization2_files/figure-latex/visualization2-05-1.pdf)<!-- --> 

This bar chart shows for the different cuts (x-axis), the number of diamonds of different color. To get these counts, I've used the `stat(count)` construction. 

Stacked bar charts give a good general impression of the data. However, it's difficult to precisely compare different proportions. 

#### Pie charts 

\begin{figure}

{\centering \includegraphics[width=0.9\linewidth]{figures/pie_chart} 

}

\caption{Finally a pie chart that makes sense.}(\#fig:visualization2-06)
\end{figure}

Pie charts have a bad reputation. And there are indeed a number of problems with pie charts: 

- proportions are difficult to compare 
- don't look good when there are many categories 


```r
ggplot(data = df.diamonds, mapping = aes(x = 1, y = stat(count / sum(count)), fill = cut)) +
  geom_bar() +
  coord_polar("y", start = 0) +
  theme_void()
```

![](03-visualization2_files/figure-latex/visualization2-07-1.pdf)<!-- --> 

We can create a pie chart with `ggplot2` by changing the coordinate system using `coord_polar()`. To get the frequency of the different categories, I used the `stat()` function. 

If we are interested in comparing proportions and we don't have too many data points, then tables are a good alternative to showing figures. 

### Comparisons 

Often we want to compare the data from many different conditions. And sometimes, it's also useful to get a sense for what the individual participant data look like. Here is a plot that achieves both. 


```r
ggplot(data = df.diamonds[1:150, ], mapping = aes(x = color, y = price)) +
  # individual data points (jittered horizontally)
  geom_point(alpha = 0.2,
             color = "blue",
             position = position_jitter(width = 0.1, height = 0),
             size = 2) +
  # error bars
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               color = "black",
               size = 1) +
  # means
  stat_summary(fun.y = "mean",
               geom = "point",
               shape = 21,
               fill = "yellow",
               color = "black",
               stroke = 2,
               size = 4) 
```

![(\#fig:visualization2-08)Price of differently colored diamonds. Red circles are means, black circles are individual data poins, and the error bars are 95% bootstrapped confidence intervals.](03-visualization2_files/figure-latex/visualization2-08-1.pdf) 

This plot shows means, bootstrapped confidence intervals, and individual data points. I've used two tricks to make the individual data points easier to see. 
1. I've set the `alpha` attribute to make the points somewhat transparent.
2. I've used the `position_jitter()` function to jitter the points horizontally.
3. I've used `shape = 21` for displaying the mean. For this circle shape, we can set a `color` and `fill` (see Figure \@ref(fig:visualization2-09))

![(\#fig:visualization2-09)Different shapes that can be used for plotting.](03-visualization2_files/figure-latex/visualization2-09-1.pdf) 

Note that I'm only plotting the first 150 entries of the data here by setting `data = df.diamonds[1:150,]` in `gpplot()`. 

#### Boxplots

Another way to get a sense for the distribution of the data is to use box plots.


```r
ggplot(data = df.diamonds[1:500,], mapping = aes(x = color, y = price)) +
  geom_boxplot()
```

![](03-visualization2_files/figure-latex/visualization2-10-1.pdf)<!-- --> 

What do boxplots show? Here adapted from `help(geom_boxplot())`:  

> The boxplots show the median as a horizontal black line. The lower and upper hinges correspond to the first and third quartiles (the 25th and 75th percentiles) of the data. The whiskers (= black vertical lines) extend from the top or bottom of the hinge by at most 1.5 * IQR (where IQR is the inter-quartile range, or distance between the first and third quartiles). Data beyond the end of the whiskers are called "outlying" points and are plotted individually.

Personally, I'm not a big fan of boxplots. Many data sets are consistent with the same boxplot. 

![(\#fig:visualization2-11)Box plot distributions. Source: https://www.autodeskresearch.com/publications/samestats](figures/boxplots.gif) 

Figure \@ref(fig:visualization2-11) shows three different distributions that each correspond to the same boxplot. 

If there is not too much data, I recommend to plot jittered individual data points instead. If you do have a lot of data points, then violin plots can be helpful. 

![(\#fig:visualization2-12, boxplot-violin)Boxplot distributions. Source: https://www.autodeskresearch.com/publications/samestats](figures/box_violin.gif) 

Figure \@ref(fig:visualization2-12) shows the same raw data represented as jittered dots, boxplots, and violin plots.  

The `ggpol` packages has a `geom_boxjitter()` function which displays a boxplot and the jittered data right next to each other. 


```r
set.seed(1) # used to make the example reproducible
ggplot(data = df.diamonds %>% sample_n(1000), mapping = aes(x = color, y = price)) +
  ggpol::geom_boxjitter(jitter.shape = 1,
                 jitter.color = "black", 
                 jitter.alpha = 0.2,
                 jitter.height = 0, 
                 jitter.width = 0.04,
                 outlier.color = NA, 
                 errorbar.draw = FALSE)+
  stat_summary(fun.y = "mean", geom = "point", shape = 21, color = "black", fill = "yellow", size = 4)
```

![](03-visualization2_files/figure-latex/visualization2-13-1.pdf)<!-- --> 

#### Violin plots

We make violin plots like so: 


```r
ggplot(data = df.diamonds, mapping = aes(x = color, y = price)) +
  geom_violin()
```

![](03-visualization2_files/figure-latex/visualization2-14-1.pdf)<!-- --> 

Violin plots are good for detecting bimodal distributions. They work well when: 

1. You have many data points. 
2. The data is continuous.

Violin plots don't work well for Likert-scale data (e.g. ratings on a discrete scale from 1 to 7). Here is a simple example: 


```r
set.seed(1)
data = data.frame(rating = sample(x = 1:7, prob = c(0.1, 0.4, 0.1, 0.1, 0.2, 0, 0.1), size = 500, replace = T))

ggplot(data = data, mapping = aes(x = "Likert", y = rating)) +
  geom_point(position = position_jitter(width = 0.05, height = 0.1), alpha = 0.05)+
  stat_summary(fun.y = "mean", geom = "point", shape = 21, fill = "blue", size = 5)
```

![](03-visualization2_files/figure-latex/visualization2-15-1.pdf)<!-- --> 

This represents a vase much better than it represents the data.

#### Joy plots

We can also show the distributions along the x-axis using the `geom_density_ridges()` function from the `ggridges` package. 


```r
ggplot(data = df.diamonds, mapping = aes(x = price, y = color)) +
  ggridges::geom_density_ridges(scale = 1.5)
```

```
## Picking joint bandwidth of 535
```

![](03-visualization2_files/figure-latex/visualization2-16-1.pdf)<!-- --> 

#### Practice plot

Try to make the plot shown in Figure \@ref(fig:practice-plot5). Here are some tips: 

- For the data argument in `ggplot()` use: `df.diamonds[1:1000, ]` (this selects the first 1000 rows).
- Note that the violin plots have different areas that reflect the number of observations. Take a look at `geom_violin()`'s help file to figure out how to set this. 
- Figure \@ref(fig:visualization2-08) will help you with figuring out the other components


```r
# make the plot here 
```

\begin{figure}
\includegraphics[width=33.33in]{figures/practice_plot5} \caption{Practice plot 5.}(\#fig:visualization2-18, practice-plot5)
\end{figure}

### Relationships 

#### Scatter plots

Scatter plots are great for looking at the relationship between two continuous variables. 


```r
ggplot(data = df.diamonds, mapping = aes(x = carat, y = price, color = color)) +
  geom_point()
```

![](03-visualization2_files/figure-latex/visualization2-19-1.pdf)<!-- --> 

#### Raster plots 

These are useful for looking how a variable of interest varies as a function of two other variables. For example, when we are trying to fit a model with two parameters, we might be interested to see how well the model does for different combinations of these two parameters. Here, we'll plot what `carat` values diamonds of different `color` and `clarity` have. 


```r
ggplot(data = df.diamonds, mapping = aes(x = color, y = clarity, z = carat)) +
  stat_summary_2d(fun = "mean", geom = "tile")
```

![](03-visualization2_files/figure-latex/visualization2-20-1.pdf)<!-- --> 

Not too bad. Let's add a few tweaks to make it look nicer. 


```r
ggplot(data = df.diamonds, mapping = aes(x = color, y = clarity, z = carat)) +
  stat_summary_2d(fun = "mean", geom = "tile", color = "black") +
  scale_fill_gradient(low = "white", high = "black") +
  labs(fill = "carat")
```

![](03-visualization2_files/figure-latex/visualization2-21-1.pdf)<!-- --> 

I've added some outlines to the tiles by specifying `color = "black"` in `geom_tile()` and I've changed the scale for the fill gradient. I've defined the color for the low value to be "white", and for the high value to be "black." Finally, I've changed the lower and upper limit of the scale via the `limits` argument. Looks much better now! We see that diamonds with clarity `I1` and color `J` tend to have the highest `carat` values on average. 

### Temporal data 

Line plots are a good choice for temporal data. Here, I'll use the `txhousing` data that comes with the `ggplot2` package. The dataset contains information about housing sales in Texas. 


```r
# ignore this part for now (we'll learn about data wrangling soon)
df.plot = txhousing %>% 
  filter(city %in% c("Dallas", "Fort Worth", "San Antonio", "Houston")) %>% 
  mutate(city = factor(city, levels = c("Dallas", "Houston", "San Antonio", "Fort Worth")))

ggplot(data = df.plot, mapping = aes(x = year, y = median, color = city, fill = city)) +
  stat_summary(fun.data = "mean_cl_boot", geom = "ribbon", alpha = 0.2, linetype = 0) +
  stat_summary(fun.y = "mean", geom = "line") +
  stat_summary(fun.y = "mean", geom = "point") 
```

![](03-visualization2_files/figure-latex/visualization2-22-1.pdf)<!-- --> 

Ignore the top part where I'm defining `df.plot` for now (we'll look into this in the next class). The other part is fairly straightforward. I've used `stat_summary()` three times: First, to define the confidence interval as a `geom = "ribbon"`. Second, to show the lines connecting the means, and third to put the means as data points points on top of the lines. 

Let's tweak the figure some more to make it look real good. 


```r
df.plot = txhousing %>% 
  filter(city %in% c("Dallas", "Fort Worth", "San Antonio", "Houston")) %>% 
  mutate(city = factor(city, levels = c("Dallas", "Houston", "San Antonio", "Fort Worth")))

df.text = df.plot %>% 
  filter(year == max(year)) %>% 
  group_by(city) %>% 
  summarize(year = mean(year) + 0.2, 
            median = mean(median))

ggplot(
  data = df.plot,
  mapping = aes(x = year, 
                y = median,
                color = city,
                fill = city)) +
  # draw dashed horizontal lines in the background
  geom_hline(yintercept = seq(from = 100000, to = 250000, by = 50000),
             linetype = 2,
             alpha = 0.2) + 
  # draw ribbon
  stat_summary(fun.data = mean_cl_boot,
               geom = "ribbon",
               alpha = 0.2,
               linetype = 0) +
  # draw lines connecting the means
  stat_summary(fun.y = "mean", geom = "line") +
  # draw means as points
  stat_summary(fun.y = "mean", geom = "point") +
  # add the city names
  geom_text(data = df.text,
            mapping = aes(label = city),
            hjust = 0,
            size = 5) + 
  # set the y-axis labels
  scale_y_continuous(breaks = seq(from = 100000, to = 250000, by = 50000),
                     labels = str_c("$", seq(from = 100, to = 250, by = 50), "K")) + 
  # set the x-axis labels
  scale_x_continuous(breaks = seq(from = 2000, to = 2015, by = 5)) +
  # set the limits for the coordinates
  coord_cartesian(xlim = c(1999, 2015),
                  clip = "off",
                  expand = F) + 
  # set the plot title and axes titles
  labs(title = "Change of median house sale price in Texas",
       x = "Year",
       y = "Median house sale price",
       fill = "",
       color = "") + 
  theme(title = element_text(size = 16),
        legend.position = "none",
        plot.margin = margin(r = 1, unit = "in"))
```

![](03-visualization2_files/figure-latex/visualization2-23-1.pdf)<!-- --> 

## Customizing plots 

So far, we've seen a number of different ways of plotting data. Now, let's look into how to customize the plots. For example, we may wanta to change the axis labels, add a title, increase the font size. `ggplot2` let's you customize almost anything. 

Let's start simple. 


```r
ggplot(data = df.diamonds, mapping = aes(x = cut, y = price)) +
  stat_summary(fun.y = "mean", geom = "bar", color = "black") +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange")
```

![](03-visualization2_files/figure-latex/visualization2-24-1.pdf)<!-- --> 

This plot shows the average price for diamonds with a different quality of the cut, as well as the bootstrapped confidence intervals. Here are some things we can do to make it look nicer. 


```r
ggplot(data = df.diamonds, mapping = aes(x = cut, y = price)) +
  # change color of the fill, make a little more space between bars by setting their width
  stat_summary(fun.y = "mean",
               geom = "bar",
               color = "black",
               fill = "lightblue",
               width = 0.85) + 
  # make error bars thicker
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               size = 1.5) + 
  # add a title, subtitle, and changed axis labels 
  labs(title = "Price as a function of quality of cut", 
    subtitle = "Note: The price is in US dollars",
    tag = "A",
    x = "Quality of the cut", 
    y = "Price") + 
  # adjust what to show on the y-axis
  scale_y_continuous(breaks = seq(from = 0, to = 4000, by = 2000),
                     labels = seq(from = 0, to = 4000, by = 2000)) + 
  # adjust the range of both axes
  coord_cartesian(xlim = c(0.25, 5.75),
                  ylim = c(0, 5000),
                  expand = F) + 
  theme(
    # adjust the text size 
    text = element_text(size = 20), 
    # add some space at top of x-title 
    axis.title.x = element_text(margin = margin(t = 0.2, unit = "inch")), 
    # add some space t the right of y-title
    axis.title.y = element_text(margin = margin(r = 0.1, unit = "inch")), 
    # add some space underneath the subtitle and make it gray
    plot.subtitle = element_text(margin = margin(b = 0.3, unit = "inch"),
                                 color = "gray70"),  
    # make the plot tag bold 
    plot.tag = element_text(face = "bold"), 
    # move the plot tag a little
    plot.tag.position = c(0.05, 0.99) 
  )
```

![](03-visualization2_files/figure-latex/visualization2-25-1.pdf)<!-- --> 

I've tweaked quite a few things here (and I've added comments to explain what's happening). Take a quick look at the `theme()` function to see all the things you can change. 

### Changing the order of things

Sometimes we don't have a natural ordering of our independent variable. In that case, it's nice to show the data in order. 


```r
ggplot(data = df.diamonds, mapping = aes(x = reorder(cut, price), y = price)) +
  stat_summary(fun.y = "mean",
               geom = "bar",
               color = "black",
               fill = "lightblue",
               width = 0.85) +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               size = 1.5) +
  labs(x = "cut")
```

![](03-visualization2_files/figure-latex/visualization2-26-1.pdf)<!-- --> 

The `reorder()` function helps us to do just that. Now, the results are ordered according to price. To show the results in descending order, I would simply need to write `reorder(cut, -price)` instead.

### Dealing with legends 

Legends form an important part of many figures. However, it is often better to avoid legends if possible, and directly label the data. This way, the reader doesn't have to look back and forth between the plot and the legend to understand what's going on. 

Here, we'll look into a few aspects that come up quite often. There are two main functions to manipulate legends with ggplot2 
1. `theme()` (there are a number of arguments starting with `legend.`)
2. `guide_legend()`

Let's make a plot with a legend. 


```r
ggplot(data = df.diamonds, mapping = aes(x = color, y = price, color = clarity)) +
  stat_summary(fun.y = "mean", geom = "point")
```

![](03-visualization2_files/figure-latex/visualization2-27-1.pdf)<!-- --> 

Let's move the legend to the bottom of the plot: 


```r
ggplot(data = df.diamonds, mapping = aes(x = color, y = price, color = clarity)) +
  stat_summary(fun.y = "mean", geom = "point") +
  theme(legend.position = "bottom")
```

![](03-visualization2_files/figure-latex/visualization2-28-1.pdf)<!-- --> 

Let's change a few more things in the legend using the `guides()` function: 

- have 3 rows 
- reverse the legend order 
- make the points in the legend larger 


```r
ggplot(data = df.diamonds, mapping = aes(x = color, y = price, color = clarity)) +
  stat_summary(fun.y = "mean", geom = "point", size = 2) +
  theme(legend.position = "bottom") +
  guides(
    color = guide_legend(
      nrow = 3, # 3 rows 
      reverse = TRUE, # reversed order 
      override.aes = list(size = 6) # point size 
    ) 
  )
```

![](03-visualization2_files/figure-latex/visualization2-29-1.pdf)<!-- --> 

### Choosing good colors

[Color brewer](http://colorbrewer2.org/) helps with finding colors that are colorblind safe and printfriendly. For more information on how to use color effectively see [here](http://socviz.co/refineplots.html#refineplots). 
### Customizing themes 

For a given project, I often want all of my plots to share certain visual features such as the font type, font size, how the axes are displayed, etc. Instead of defining these for each individual plot, I can set a theme at the beginning of my project so that it applies to all the plots in this file. To do so, I use the `theme_set()` command: 


```r
theme_set(
  theme_classic() + #classic theme
    theme(text = element_text(size = 20)) #text size 
)
```

Here, I've just defined that I want to use `theme_classic()` for all my plots, and that the text size should be 20. For any individual plot, I can still overwrite any of these defaults. 

## Saving plots 

To save plots, use the `ggsave()` command. Personally, I prefer to save my plots as pdf files. This way, the plot looks good no matter what size you need it to be. This means it'll look good both in presentations as well as in a paper. You can save the plot in any format that you like. 

I strongly recommend to use a relative path to specify where the figure should be saved. This way, if you are sharing the project with someone else via Stanford Box, Dropbox, or Github, they will be able to run the code without errors. 

Here is an example for how to save one of the plots that we've created above. 


```r
p1 = ggplot(data = df.diamonds, mapping = aes(x = cut, y = price)) +
  stat_summary(fun.y = "mean", geom = "bar", color = "black", fill = "lightblue") +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange", size = 1)
print(p1)
```

![](03-visualization2_files/figure-latex/visualization2-31-1.pdf)<!-- --> 

```r
p2 = ggplot(data = df.diamonds, mapping = aes(x = cut, y = price)) +
  stat_summary(fun.y = "mean", geom = "bar", color = "black", fill = "lightblue") +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange", size = 1)

ggsave(filename = "figures/diamond_plot.pdf", plot = p1, width = 8, height = 6)
```

Here, I'm saving the plot in the `figures` folder and it's name is `diamond_plot.pdf`. I also specify the width and height as the plot in inches (which is the default unit). 

## Creating figure panels 

Sometimes, we want to create a figure with several subfigures, each of which is labeled with a), b), etc. We have already learned how to make separate panels using `facet_wrap()` or `facet_grid()`. The R package `patchwork` makes it very easy to combine multiple plots. 

Let's combine a few plots that we've made above into one. 


```r
# first plot
p1 = ggplot(data = df.diamonds, mapping = aes(x = y, fill = color)) +
  geom_density(bw = 0.2, show.legend = F) +
  facet_grid(cols = vars(color)) +
  coord_cartesian(xlim = c(3, 10), expand = F) + #setting expand to FALSE removes any padding on x and y axes
  labs(title = "Width of differently colored diamonds",
    tag = "A")

# second plot
p2 = ggplot(data = df.diamonds, mapping = aes(x = color, y = clarity, z = carat)) +
  stat_summary_2d(fun = "mean", geom = "tile") +
  labs(title = "Carat values",
       subtitle = "For different color and clarity",
       x = 'width in mm',
       tag = "B")

# third plot
p3 = ggplot(data = df.diamonds, mapping = aes(x = cut, y = price)) +
  stat_summary(fun.y = "mean", geom = "bar", color = "black", fill = "lightblue", width = 0.85) +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange", size = 1.5) + 
  scale_x_discrete(labels = c('fair', 'good', 'very\ngood', 'premium', 'ideal')) +
  labs(
    title = "Price as a function of cut", 
    subtitle = "Note: The price is in US dollars",
    tag = "C",
    x = "Quality of the cut", 
    y = "Price") + 
  coord_cartesian(xlim = c(0.25, 5.75), ylim = c(0, 5000), expand = F)

# combine the plots
p1 + (p2 + p3) + 
  plot_layout(ncol = 1) & 
  theme_classic() & 
  theme(plot.tag = element_text(face = "bold", size = 20))
```

![](03-visualization2_files/figure-latex/visualization2-32-1.pdf)<!-- --> 

```r
# ggsave("figures/combined_plot.pdf", width = 10, height = 6)
```

Not a perfect plot yet, but you get the idea. To combine the plots, we defined that we would like p2 and p3 to be displayed in the same row using the `()` syntax. And we specified that we only want one column via the `plot_layout()` function. We also applied the same `theme_classic()` to all the plots using the `&` operator, and formatted how the plot tags should be displayed. For more info on how to use `patchwork`, take a look at the [readme](https://github.com/thomasp85/patchwork) on the github page. 

Other packages that provide additional functionality for combining multiple plots into one are 

- [`gridExtra`](https://cran.r-project.org/web/packages/gridExtra/index.html) and 
- [`cowplot`](https://cran.r-project.org/web/packages/cowplot/index.html). You can find more information on how to lay out multiple plots [here](https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html).

An alternative way for making these plots is to use Adobe Illustrator, Powerpoint, or Keynote. However, you want to make changing plots as easy as possible. Adobe Illustrator has a feature that allows you to link to files. This way, if you change the plot, the plot within the illustrator file gets updated automatically as well. 

If possible, it's __much__ better to do everything in R though so that your plot can easily be reproduced by someone else. 

## Peeking behind the scenes 

Sometimes it can be helpful for debugging to take a look behind the scenes. Silently, `ggplot()` computes a data frame based on the information you pass to it. We can take a look at the data frame that's underlying the plot. 


```r
p = ggplot(data = df.diamonds, mapping = aes(x = color, y = clarity, z = carat)) +
  stat_summary_2d(fun = "mean", geom = "tile", color = "black") +
  scale_fill_gradient(low = "white", high = "black")
print(p)
```

![](03-visualization2_files/figure-latex/visualization2-33-1.pdf)<!-- --> 

```r
build = ggplot_build(p)
df.plot_info = build$data[[1]]
dim(df.plot_info) # data frame dimensions
```

```
## [1] 56 18
```

I've called the `ggplot_build()` function on the ggplot2 object that we saved as `p`. I've then printed out the data associated with that plot object. The first thing we note about the data frame is how many entries it has, 56. That's good. This means there is one value for each of the 7 x 8 grids. The columns tell us what color was used for the `fill`, the `value` associated with each row, where each row is being displayed (`x` and `y`), etc.   

If a plot looks weird, it's worth taking a look behind the scenes. For example, something we thing we could have tried is the following (in fact, this is what I tried first): 


```r
p = ggplot(data = df.diamonds, mapping = aes(x = color, y = clarity, fill = carat)) +
  geom_tile(color = "black") +
  scale_fill_gradient(low = "white", high = "black")
print(p)
```

![](03-visualization2_files/figure-latex/visualization2-34-1.pdf)<!-- --> 

```r
build = ggplot_build(p)
df.plot_info = build$data[[1]]
dim(df.plot_info) # data frame dimensions
```

```
## [1] 53940    15
```

Why does this plot look different from the one before? What went wrong here? Notice that the data frame associated with the ggplot2 object has 53940 rows. So instead of plotting means here, we plotted all the individual data points. So what we are seeing here is just the top layer of many, many layers. 

## Making animations 

Animated plots can be a great way to illustrate your data in presentations. The R package `gganimate` lets you do just that. 

Here is an example showing how to use it. 


```r
ggplot(gapminder, mapping = aes(x = gdpPercap, y = lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  geom_text(data = gapminder %>% filter(country %in% c("United States", "China", "India")), 
            mapping = aes(label = country),
            color = "black",
            vjust = -0.75,
            show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10(breaks = c(1e3, 1e4, 1e5),
                labels = c("1,000", "10,000", "100,000")) +
  theme_classic() +
  theme(text = element_text(size = 23)) +
  # Here come the gganimate specific bits
  labs(title = "Year: {frame_time}", x = "GDP per capita", y = "life expectancy") +
  transition_time(year) +
  ease_aes("linear")
```

![](03-visualization2_files/figure-latex/visualization2-35-1.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-2.pdf)<!-- --> 

```
## Rendering [>--------------------------------------] at 9.8 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-3.pdf)<!-- --> 

```
## Rendering [=>-------------------------------------] at 9.6 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-4.pdf)<!-- --> 

```
## Rendering [=>-------------------------------------] at 8.9 fps ~ eta: 11s
```

![](03-visualization2_files/figure-latex/visualization2-35-5.pdf)<!-- --> 

```
## Rendering [=>-------------------------------------] at 9.1 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-6.pdf)<!-- --> 

```
## Rendering [==>--------------------------------------] at 9 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-7.pdf)<!-- --> 

```
## Rendering [==>------------------------------------] at 8.8 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-8.pdf)<!-- --> 

```
## Rendering [===>-----------------------------------] at 8.7 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-9.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-10.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-11.pdf)<!-- --> 

```
## Rendering [====>----------------------------------] at 8.6 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-12.pdf)<!-- --> 

```
## Rendering [====>----------------------------------] at 8.4 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-13.pdf)<!-- --> 

```
## Rendering [====>----------------------------------] at 8.5 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-14.pdf)<!-- --> 

```
## Rendering [=====>---------------------------------] at 8.4 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-15.pdf)<!-- --> 

```
## Rendering [=====>---------------------------------] at 8.5 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-16.pdf)<!-- --> 

```
## Rendering [======>--------------------------------] at 8.4 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-17.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-18.pdf)<!-- --> 

```
## Rendering [======>--------------------------------] at 8.5 fps ~ eta: 10s
```

![](03-visualization2_files/figure-latex/visualization2-35-19.pdf)<!-- --> 

```
## Rendering [=======>-------------------------------] at 8.6 fps ~ eta: 9s
```

![](03-visualization2_files/figure-latex/visualization2-35-20.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-21.pdf)<!-- --> 

```
## Rendering [========>------------------------------] at 8.7 fps ~ eta: 9s
```

![](03-visualization2_files/figure-latex/visualization2-35-22.pdf)<!-- --> 

```
## Rendering [========>------------------------------] at 8.8 fps ~ eta: 9s
```

![](03-visualization2_files/figure-latex/visualization2-35-23.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-24.pdf)<!-- --> 

```
## Rendering [=========>-----------------------------] at 8.9 fps ~ eta: 8s
```

![](03-visualization2_files/figure-latex/visualization2-35-25.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-26.pdf)<!-- --> 

```
## Rendering [==========>------------------------------] at 9 fps ~ eta: 8s
```

![](03-visualization2_files/figure-latex/visualization2-35-27.pdf)<!-- --> 

```
## Rendering [==========>----------------------------] at 9.1 fps ~ eta: 8s
```

![](03-visualization2_files/figure-latex/visualization2-35-28.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-29.pdf)<!-- --> 

```
## Rendering [===========>---------------------------] at 9.2 fps ~ eta: 8s
```

![](03-visualization2_files/figure-latex/visualization2-35-30.pdf)<!-- --> 

```
## Rendering [===========>---------------------------] at 9.2 fps ~ eta: 7s
```

![](03-visualization2_files/figure-latex/visualization2-35-31.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-32.pdf)<!-- --> 

```
## Rendering [============>--------------------------] at 9.3 fps ~ eta: 7s
```

![](03-visualization2_files/figure-latex/visualization2-35-33.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-34.pdf)<!-- --> 

```
## Rendering [=============>-------------------------] at 9.3 fps ~ eta: 7s
```

![](03-visualization2_files/figure-latex/visualization2-35-35.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-36.pdf)<!-- --> 

```
## Rendering [=============>-------------------------] at 9.4 fps ~ eta: 7s
```

![](03-visualization2_files/figure-latex/visualization2-35-37.pdf)<!-- --> 

```
## Rendering [==============>------------------------] at 9.4 fps ~ eta: 7s
```

![](03-visualization2_files/figure-latex/visualization2-35-38.pdf)<!-- --> 

```
## Rendering [===============>-------------------------] at 9 fps ~ eta: 7s
```

![](03-visualization2_files/figure-latex/visualization2-35-39.pdf)<!-- --> 

```
## Rendering [===============>-----------------------] at 9.1 fps ~ eta: 7s
```

![](03-visualization2_files/figure-latex/visualization2-35-40.pdf)<!-- --> 

```
## Rendering [===============>-----------------------] at 9.1 fps ~ eta: 6s
```

![](03-visualization2_files/figure-latex/visualization2-35-41.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-42.pdf)<!-- --> 

```
## Rendering [================>----------------------] at 9.2 fps ~ eta: 6s
```

![](03-visualization2_files/figure-latex/visualization2-35-43.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-44.pdf)<!-- --> 

```
## Rendering [=================>---------------------] at 9.2 fps ~ eta: 6s
```

![](03-visualization2_files/figure-latex/visualization2-35-45.pdf)<!-- --> 

```
## Rendering [=================>---------------------] at 9.3 fps ~ eta: 6s
```

![](03-visualization2_files/figure-latex/visualization2-35-46.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-47.pdf)<!-- --> 

```
## Rendering [==================>--------------------] at 9.3 fps ~ eta: 6s
```

![](03-visualization2_files/figure-latex/visualization2-35-48.pdf)<!-- --> 

```
## Rendering [==================>--------------------] at 9.4 fps ~ eta: 5s
```

![](03-visualization2_files/figure-latex/visualization2-35-49.pdf)<!-- --> 

```
## Rendering [===================>-------------------] at 9.4 fps ~ eta: 5s
```

![](03-visualization2_files/figure-latex/visualization2-35-50.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-51.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-52.pdf)<!-- --> 

```
## Rendering [====================>------------------] at 9.5 fps ~ eta: 5s
```

![](03-visualization2_files/figure-latex/visualization2-35-53.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-54.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-55.pdf)<!-- --> 

```
## Rendering [=====================>-----------------] at 9.5 fps ~ eta: 5s
```

![](03-visualization2_files/figure-latex/visualization2-35-56.pdf)<!-- --> 

```
## Rendering [=====================>-----------------] at 9.6 fps ~ eta: 4s
```

![](03-visualization2_files/figure-latex/visualization2-35-57.pdf)<!-- --> 

```
## Rendering [======================>----------------] at 9.6 fps ~ eta: 4s
```

![](03-visualization2_files/figure-latex/visualization2-35-58.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-59.pdf)<!-- --> 

```
## Rendering [======================>----------------] at 9.7 fps ~ eta: 4s
```

![](03-visualization2_files/figure-latex/visualization2-35-60.pdf)<!-- --> 

```
## Rendering [=======================>---------------] at 9.7 fps ~ eta: 4s
```

![](03-visualization2_files/figure-latex/visualization2-35-61.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-62.pdf)<!-- --> 

```
## Rendering [========================>--------------] at 9.7 fps ~ eta: 4s
```

![](03-visualization2_files/figure-latex/visualization2-35-63.pdf)<!-- --> 

```
## Rendering [========================>--------------] at 9.8 fps ~ eta: 4s
```

![](03-visualization2_files/figure-latex/visualization2-35-64.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-65.pdf)<!-- --> 

```
## Rendering [=========================>-------------] at 9.8 fps ~ eta: 3s
```

![](03-visualization2_files/figure-latex/visualization2-35-66.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-67.pdf)<!-- --> 

```
## Rendering [==========================>------------] at 9.9 fps ~ eta: 3s
```

![](03-visualization2_files/figure-latex/visualization2-35-68.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-69.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-70.pdf)<!-- --> 

```
## Rendering [===========================>-----------] at 9.9 fps ~ eta: 3s
```

![](03-visualization2_files/figure-latex/visualization2-35-71.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-72.pdf)<!-- --> 

```
## Rendering [============================>-----------] at 10 fps ~ eta: 3s
```

![](03-visualization2_files/figure-latex/visualization2-35-73.pdf)<!-- --> 

```
## Rendering [=============================>----------] at 10 fps ~ eta: 3s
```

![](03-visualization2_files/figure-latex/visualization2-35-74.pdf)<!-- --> 

```
## Rendering [=============================>----------] at 10 fps ~ eta: 2s
```

![](03-visualization2_files/figure-latex/visualization2-35-75.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-76.pdf)<!-- --> 

```
## Rendering [==============================>---------] at 10 fps ~ eta: 2s
```

![](03-visualization2_files/figure-latex/visualization2-35-77.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-78.pdf)<!-- --> 

```
## Rendering [===============================>--------] at 10 fps ~ eta: 2s
```

![](03-visualization2_files/figure-latex/visualization2-35-79.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-80.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-81.pdf)<!-- --> 

```
## Rendering [================================>-------] at 10 fps ~ eta: 2s
```

![](03-visualization2_files/figure-latex/visualization2-35-82.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-83.pdf)<!-- --> 

```
## Rendering [=================================>------] at 10 fps ~ eta: 2s
```

![](03-visualization2_files/figure-latex/visualization2-35-84.pdf)<!-- --> 

```
## Rendering [=================================>------] at 10 fps ~ eta: 1s
```

![](03-visualization2_files/figure-latex/visualization2-35-85.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-86.pdf)<!-- --> 

```
## Rendering [==================================>-----] at 10 fps ~ eta: 1s
```

![](03-visualization2_files/figure-latex/visualization2-35-87.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-88.pdf)<!-- --> 

```
## Rendering [===================================>----] at 10 fps ~ eta: 1s
```

![](03-visualization2_files/figure-latex/visualization2-35-89.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-90.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-91.pdf)<!-- --> 

```
## Rendering [====================================>---] at 10 fps ~ eta: 1s
```

![](03-visualization2_files/figure-latex/visualization2-35-92.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-93.pdf)<!-- --> 

```
## Rendering [=====================================>--] at 10 fps ~ eta: 1s
```

![](03-visualization2_files/figure-latex/visualization2-35-94.pdf)<!-- --> 

```
## Rendering [=====================================>--] at 10 fps ~ eta: 0s
```

![](03-visualization2_files/figure-latex/visualization2-35-95.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-96.pdf)<!-- --> 

```
## Rendering [======================================>-] at 10 fps ~ eta: 0s
```

![](03-visualization2_files/figure-latex/visualization2-35-97.pdf)<!-- --> ![](03-visualization2_files/figure-latex/visualization2-35-98.pdf)<!-- --> 

```
## Rendering [=======================================>] at 10 fps ~ eta: 0s
```

![](03-visualization2_files/figure-latex/visualization2-35-99.pdf)<!-- --> 

```
## Rendering [========================================] at 10 fps ~ eta: 0s
```

![](03-visualization2_files/figure-latex/visualization2-35-100.pdf)<!-- --> 

```r
# anim_save(filename = "figures/life_gdp_animation.gif") # to save the animation
```

This takes a while to run but it's worth the wait. The plot shows the relationship between GDP per capita (on the x-axis) and life expectancy (on the y-axis) changes across different years for the countries of different continents. The size of each dot represents the population size of the respective country. And different countries are shown in different colors. This animation is not super useful yet in that we don't know which continents and countries the different dots represent. I've added a label to the United States, China, and India. 

Note how little is required to define the `gganimate`-specific information! The `{frame_time}` variable changes the title for each frame. The `transition_time()` variable is set to `year`, and the kind of transition is set as 'linear' in `ease_aes()`. I've saved the animation as a gif in the figures folder. 
We won't have time to go into more detail here but I encourage you to play around with `gganimate`. It's fun, looks cool, and (if done well) makes for a great slide in your next presentation! 

## Shiny apps 

The package [`shiny`](https://shiny.rstudio.com/) makes it relatively easy to create interactive plots that can be hosted online. Here is a [gallery](https://shiny.rstudio.com/gallery/) with some examples. 

## Defining snippets 

Often, we want to create similar plots over and over again. One way to achieve this is by finding the original plot, copy and pasting it, and changing the bits that need changing. Another more flexible and faster way to do this is by using snippets. Snippets are short pieces of code that 

Here are some snippets I use: 


```r
snippet snbar
	ggplot(data = ${1:data}, mapping = aes(x = ${2:x}, y = ${3:y})) +
		stat_summary(fun.y = "mean", geom = "bar", color = "black") +
		stat_summary(fun.data = "mean_cl_boot", geom = "linerange")
		
snippet sngg
	ggplot(data = ${1:data}, mapping = aes(${2:aes})) +
		${0}

snippet sndf
	${1:data} = ${1:data} %>% 
		${0}
```

To make a bar plot, I now only need to type `snbar` and then hit TAB to activate the snippet. I can then cycle through the bits in the code that are marked with `${Number:word}` by hitting TAB again. 

In RStudio, you can change and add snippets by going to Tools --> Global Options... --> Code --> Edit Snippets. Make sure to set the tick mark in front of Enable Code Snippets (see Figure \@ref(fig:code-snippets)). 
). 


```r
include_graphics("figures/snippets.png")
```

\begin{figure}
\includegraphics[width=16.42in]{figures/snippets} \caption{Enable code snippets.}(\#fig:visualization2-37)
\end{figure}

To edit code snippets faster, run this command from the `usethis` package. Make sure to install the package first if you don't have it yet. 


```r
# install.packages("usethis")
usethis::edit_rstudio_snippets()
```

This command opens up a separate tab in RStudio called `r.snippets` so that you can make new snippets and adapt old ones more quickly. Take a look at the snippets that RStudio already comes with. And then, make some new ones! By using snippets you will be able to avoid typing the same code over and over again, and you won't have to memorize as much, too. 

## Additional resources 

### Cheatsheets 

- [shiny](figures/shiny.pdf) --> interactive plots 

### Data camp courses 

- [ggplot2 course 3](https://www.datacamp.com/courses/data-visualization-with-ggplot2-3)
- [shiny 1](https://www.datacamp.com/courses/building-web-applications-in-r-with-shiny)
- [shiny 2](https://www.datacamp.com/courses/building-web-applications-in-r-with-shiny-case-studies)

### Books and chapters

- [R for Data Science book](http://r4ds.had.co.nz/)
	+ [Data visualization](http://r4ds.had.co.nz/data-visualisation.html)
	+ [Graphics for communication](http://r4ds.had.co.nz/graphics-for-communication.html)
- [Data Visualization -- A practical introduction (by Kieran Healy)](http://socviz.co/)
  + [Refine your plots](http://socviz.co/refineplots.html#refineplots)

### Misc

- [ggplot2 extensions](http://www.ggplot2-exts.org/gallery/) --> gallery of ggplot2 extension packages 
- [ggplot2 gui](https://github.com/dreamRs/esquisse) --> ggplot2 extension package 
- [ggplot2 visualizations with code](http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html) --> gallery of plots with code
- [Color brewer](http://colorbrewer2.org/) --> for finding colors 
- [shiny apps examples](https://sites.psu.edu/shinyapps/) --> shiny apps examples that focus on statistics teaching (made by students at PennState) 

<!--chapter:end:03-visualization2.Rmd-->

# Data wrangling 1 

In this lecture, we will take a look at how to wrangle data using the [dplyr](https://ggplot2.dplyr.org/) package. Again, getting our data into shape is something we'll need to do throughout the course, so it's worth spending some time getting a good sense for how this works. The nice thing about R is that (thanks to the `tidyverse`), both visualization and data wrangling are particularly powerful. 

## Learning objectives 

- Review R basics (incl. variable modes, data types, operators, control flow, and functions). 
- Learn how the pipe operator `%>%` works. 
- See different ways for getting a sense of one's data. 
- Master key data manipulation verbs from the `dplyr` package (incl. `filter()`, `rename()`, `select()`, `mutate()`, and `arrange()`)

## Install packages 


```r
install.packages(c("skimr", "visdat", "summarytools", "DT"))
```


## Load packages 

Let's first load the packages that we need for this chapter. 


```r
library("knitr") # for rendering the RMarkdown file
library("tidyverse") # for data wrangling
```

## Some R basics 

To test your knowledge of the R basics, I recommend taking the free interactive tutorial on datacamp: [Introduction to R](https://www.datacamp.com/courses/free-introduction-to-r). Here, I will just give a very quick overview of some of the basics. 

### Modes 

Variables in R can have different modes. Table \@ref(tab:data-wrangling1-03) shows the most common ones. 

\begin{table}[t]

\caption{(\#tab:data-wrangling1-03)Most commonly used variable modes in R.}
\centering
\begin{tabular}{rl}
\toprule
name & example\\
\midrule
numeric & `1`, `3`, `48`\\
character & `'Steve'`, `'a'`, `'78'`\\
logical & `TRUE`, `FALSE`\\
not available & `NA`\\
\bottomrule
\end{tabular}
\end{table}

For characters you can either use `"` or `'`. R has a number of functions to convert a variable from one mode to another. `NA` is used for missing values.


```r
tmp1 = "1" # we start with a character
str(tmp1) 
```

```
##  chr "1"
```

```r
tmp2 = as.numeric(tmp1) # turn it into a numeric
str(tmp2) 
```

```
##  num 1
```

```r
tmp3 = as.factor(tmp2) # turn that into a factor
str(tmp3)
```

```
##  Factor w/ 1 level "1": 1
```

```r
tmp4 = as.character(tmp3) # and go full cycle by turning it back into a character
str(tmp4)
```

```
##  chr "1"
```

```r
identical(tmp1, tmp4) # checks whether tmp1 and tmp4 are the same
```

```
## [1] TRUE
```

The `str()` function displays the structure of an R object. Here, it shows us what mode the variable is. 

### Data types

R has a number of different data types. Table \@ref(tab:data-wrangling1-05) shows the ones you're most likely to come across (taken from [this source](https://www.statmethods.net/input/datatypes.html)): 

\begin{table}[t]

\caption{(\#tab:data-wrangling1-05)Most commonly used data types in R.}
\centering
\begin{tabular}{rl}
\toprule
name & description\\
\midrule
vector & list of values with of the same variable mode\\
factor & for ordinal variables\\
matrix & 2D data structure\\
array & same as matrix for higher dimensional data\\
data frame & similar to matrix but with column names\\
\addlinespace
list & flexible type that can contain different other variable types\\
\bottomrule
\end{tabular}
\end{table}

#### Vectors 

We build vectors using the concatenate function `c()`, and we use `[]` to access one or more elements of a vector.  


```r
numbers = c(1, 4, 5) # make a vector
numbers[2] # access the second element 
```

```
## [1] 4
```

```r
numbers[1:2] # access the first two elements
```

```
## [1] 1 4
```

```r
numbers[c(1, 3)] # access the first and last element
```

```
## [1] 1 5
```

In R (unlike in Python for example), 1 refers to the first element of a vector (or list). 

#### Matrix 

We build a matrix using the `matrix()` function, and we use `[]` to access its elements. 


```r
matrix = matrix(data = c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2)
matrix # the full matrix
```

```
##      [,1] [,2]
## [1,]    1    4
## [2,]    2    5
## [3,]    3    6
```

```r
matrix[1, 2] # element in row 1, column 2
```

```
## [1] 4
```

```r
matrix[1, ] # all elements in the first row 
```

```
## [1] 1 4
```

```r
matrix[ , 1] # all elements in the first column 
```

```
## [1] 1 2 3
```

```r
matrix[-1, ] # a matrix which excludes the first row
```

```
##      [,1] [,2]
## [1,]    2    5
## [2,]    3    6
```

Note how we use an empty placeholder to indicate that we want to select all the values in a row or column, and `-` to indicate that we want to remove something.

#### Array 

Arrays work the same was as matrices with data of more than two dimensions. 

#### Data frame 


```r
df = tibble(participant_id = c(1, 2, 3),
            participant_name = c("Leia", "Luke", "Darth")) # make the data frame 

df # the complete data frame
```

```
## # A tibble: 3 x 2
##   participant_id participant_name
##            <dbl> <chr>           
## 1              1 Leia            
## 2              2 Luke            
## 3              3 Darth
```

```r
df[1, 2] # a single element using numbers 
```

```
## # A tibble: 1 x 1
##   participant_name
##   <chr>           
## 1 Leia
```

```r
df$participant_id # all participants 
```

```
## [1] 1 2 3
```

```r
df[["participant_id"]] # same as before but using [[]] instead of $
```

```
## [1] 1 2 3
```

```r
df$participant_name[2] # name of the second participant
```

```
## [1] "Luke"
```

```r
df[["participant_name"]][2] # same as above
```

```
## [1] "Luke"
```

We'll use data frames a lot. Data frames are like a matrix with column names. Data frames are also more general than matrices in that different columns can have different modes. For example, one column might be a character, another one numeric, and another one a factor. 

Here we used the `tibble()` function to create the data frame. A `tibble` is almost the same as a data frame but it has better defaults for formatting output in the console (more information on tibbles is [here](http://r4ds.had.co.nz/tibbles.html)). 

#### Lists 


```r
l.mixed = list(number = 1, 
               character = "2", 
               factor = factor(3), 
               matrix = matrix(1:4, ncol = 2),
               df = tibble(x = c(1, 2), y = c(3, 4)))
l.mixed
```

```
## $number
## [1] 1
## 
## $character
## [1] "2"
## 
## $factor
## [1] 3
## Levels: 3
## 
## $matrix
##      [,1] [,2]
## [1,]    1    3
## [2,]    2    4
## 
## $df
## # A tibble: 2 x 2
##       x     y
##   <dbl> <dbl>
## 1     1     3
## 2     2     4
```

```r
# three different ways of accessing a list
l.mixed$character
```

```
## [1] "2"
```

```r
l.mixed[['character']]
```

```
## [1] "2"
```

```r
l.mixed[[2]] 
```

```
## [1] "2"
```

Lists are a very flexible data format. You can put almost anything in a list.

### Operators

Table \@ref(tab:data-wrangling1-10) shows the comparison operators that result in logical outputs. 

\begin{table}[t]

\caption{(\#tab:data-wrangling1-10)Table of comparison operators that result in boolean (TRUE/FALSE) outputs.}
\centering
\begin{tabular}{ll}
\toprule
symbol & name\\
\midrule
`==` & equal to\\
`!=` & not equal to\\
`>`, `<` & greater/less than\\
`>=`, `<=` & greater/less than or equal\\
`\&`, `|`, `!` & logical operators: and, or, not\\
\addlinespace
`\%in\%` & checks whether an element is in an object\\
\bottomrule
\end{tabular}
\end{table}


### Control flow 

#### if-then {#if-else}


```r
number = 3
if(number == 1){
  print("The number is 1.")
}else if (number == 2){
  print("The number is 2.")
}else{
  print("The number is neither 1 nor 2.")
}
```

```
## [1] "The number is neither 1 nor 2."
```

As a shorthand version, we can also use the `ifelse()` function like so: 


```r
number = 3
ifelse(test = number == 1, yes = "correct", no = "false")
```

```
## [1] "false"
```


#### for loop


```r
sequence = 1:10

for(i in 1:length(sequence)){
  print(i)
}
```

```
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
## [1] 6
## [1] 7
## [1] 8
## [1] 9
## [1] 10
```

#### while loop 


```r
number = 1 

while(number <= 10){
  print(number)
  number = number + 1
}
```

```
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
## [1] 6
## [1] 7
## [1] 8
## [1] 9
## [1] 10
```

### Functions 


```r
fun.add_two_numbers = function(a, b){
  x = a + b
  return(str_c("The result is ", x))
}

fun.add_two_numbers(1,2)
```

```
## [1] "The result is 3"
```

I've used the `str_c()` function here to concatenate the string with the number. (R converts the number `x` into a string for us.) Note, R functions can only return a single object. However, this object can be a list (which can contain anything). 

#### Some often used functions 

\begin{table}[t]

\caption{(\#tab:data-wrangling1-16)Some frequently used functions.}
\centering
\begin{tabular}{rl}
\toprule
name & description\\
\midrule
`length()` & length of an object\\
`dim()` & dimensions of an object (e.g. number of rows and columns)\\
`rm()  ` & remove an object\\
`seq()` & generate a sequence of numbers\\
`rep()` & repeat something n times\\
\addlinespace
`max()` & maximum\\
`min()` & minimum\\
`which.max()` & index of the maximum\\
`which.min()` & index of the maximum\\
`mean()` & mean\\
\addlinespace
`median()` & median\\
`sum()` & sum\\
`var()` & variance\\
`sd()` & standard deviation\\
\bottomrule
\end{tabular}
\end{table}

### The pipe operator `%>%` 

\begin{figure}
\includegraphics[width=0.8\linewidth]{figures/pipe} \caption{Inspiration for the `magrittr` package name.}(\#fig:data-wrangling1-17)
\end{figure}

\begin{figure}
\includegraphics[width=0.4\linewidth]{figures/magrittr} \caption{The `magrittr` package logo.}(\#fig:data-wrangling1-18)
\end{figure}

The pipe operator `%>%` is a special operator introduced in the `magrittr` package. It is used heavily in the tidyverse. The basic idea is simple: this operator allows us to "pipe" several functions into one long chain that matches the order in which we want to do stuff.  

Abstractly, the pipe operator does the following: 

> `f(x)` can be rewritten as `x %>% f()`

For example, in standard R, we would write: 


```r
x = 1:3

# standard R 
sum(x)
```

```
## [1] 6
```

With the pipe, we can rewrite this as: 


```r
x = 1:3

# with the pipe  
x %>% sum()
```

```
## [1] 6
```

This doesn't seem super useful yet, but just hold on a little longer. 

> `f(x, y)` can be rewritten as `x %>% f(y)`

So, we could rewrite the following standard R code ... 


```r
# rounding pi to 6 digits, standard R 
round(pi, digits = 6)
```

```
## [1] 3.141593
```

... by using the pipe: 


```r
# rounding pi to 6 digits, standard R 
pi %>% round(digits = 6)
```

```
## [1] 3.141593
```

Here is another example: 


```r
a = 3
b = 4
sum(a, b) # standard way 
```

```
## [1] 7
```

```r
a %>% sum(b) # the pipe way 
```

```
## [1] 7
```

The pipe operator inserts the result of the previous computation as a first element into the next computation. So, `a %>% sum(b)` is equivalent to `sum(a, b)`. We can also specify to insert the result at a different position via the `.` operator. For example:  


```r
a = 1
b = 10 
b %>% seq(from = a, to = .)
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

Here, I used the `.` operator to specify that I woud like to insert the result of `b` where I've put the `.` in the `seq()` function. 

> `f(x, y)` can be rewritten as `y %>% f(x, .)`

Still not to thrilled about the pipe? We can keep going though (and I'm sure you'll be convinced eventually.)

> `h(g(f(x)))` can be rewritten as `x %>% f() %>% g() %>% h()`

For example, consider that we want to calculate the root mean squared error (RMSE) between prediction and data. 

Here is how the RMSE is defined: 

$$
\text{RMSE} = \sqrt\frac{\sum_{i=1}^n(\hat{y}_i-y_i)^2}{n}
$$
where $\hat{y}_i$ denotes the prediction, and $y_i$ the actually observed value.

In base R, we would do the following. 


```r
data = c(1, 3, 4, 2, 5)
prediction = c(1, 2, 2, 1, 4)

# calculate root mean squared error
rmse = sqrt(mean((prediction-data)^2))
print(rmse)
```

```
## [1] 1.183216
```

Using the pipe operator makes the operation more intuitive: 


```r
data = c(1, 3, 4, 2, 5)
prediction = c(1, 2, 2, 1, 4)

# calculate root mean squared error the pipe way 
rmse = (prediction-data)^2 %>% 
  mean() %>% 
  sqrt() %>% 
  print() 
```

```
## [1] 1.183216
```

First, we calculate the squared error, then we take the mean, then the square root, and then print the result. 

The pipe operator `%>%` is similar to the `+` used in `ggplot2`. It allows us to take step-by-step actions in a way that fits the causal ordering of how we want to do things. 

> __Tip__: The keyboard shortcut for the pipe operator is:   
> `cmd/ctrl + shift + m`   
> __Definitely learn this one__ -- we'll use the pipe a lot!! 

> __Tip__: Code is generally easier to read when the pipe `%>%` is at the end of a line (just like the `+` in `ggplot2`).

A key advantage of using the pipe is that you don't have to save intermediate computations as new variables and this help to keep your environment nice and clean! 

#### Practice 1 

Let's practice the pipe operator. 


```r
# some numbers
x = seq(from = 1, to = 5, by = 1)
```


```r
# standard way
log(x)
```

```
## [1] 0.0000000 0.6931472 1.0986123 1.3862944 1.6094379
```

```r
# the pipe way (write your code underneath)
```


```r
# standard way
mean(round(sqrt(x), digits = 2))
```

```
## [1] 1.676
```

```r
# the pipe way (write your code underneath)
```

## Looking at data

The package `dplyr` which we loaded as part of the tidyverse, includes a data set with information about starwars characters. Let's store this as  `df.starwars`. 


```r
df.starwars = starwars
```

> Note: Unlike in other languages (such as Python or Matlab), a `.` in a variable name has no special meaning and can just be used as part of the name. I've used `df` here to indicate for myself that this variable is a data frame. 
Before visualizing the data, it's often useful to take a quick direct look at the data. 

There are several ways of taking a look at data in R. Personally, I like to look at the data within RStudio's data viewer. To do so, you can: 

- click on the `df.starwars` variable in the "Environment" tab  
- type `View(df.starwars)` in the console 
- move your mouse over (or select) the variable in the editor (or console) and hit `F2` 

I like the `F2` route the best as it's fast and flexible. 

Sometimes it's also helpful to look at data in the console instead of the data viewer. Particularly when the data is very large, the data viewer can be sluggish. 

Here are some useful functions: 

### `head()`

Without any extra arguments specified, `head()` shows the top six rows of the data. 


```r
head(df.starwars)
```

```
## # A tibble: 6 x 13
##   name  height  mass hair_color skin_color eye_color birth_year gender
##   <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
## 1 Luke~    172    77 blond      fair       blue            19   male  
## 2 C-3PO    167    75 <NA>       gold       yellow         112   <NA>  
## 3 R2-D2     96    32 <NA>       white, bl~ red             33   <NA>  
## 4 Dart~    202   136 none       white      yellow          41.9 male  
## 5 Leia~    150    49 brown      light      brown           19   female
## 6 Owen~    178   120 brown, gr~ light      blue            52   male  
## # ... with 5 more variables: homeworld <chr>, species <chr>, films <list>,
## #   vehicles <list>, starships <list>
```

### `glimpse()`

`glimpse()` is helpful when the data frame has many columns. The data is shown in a transposed way with columns as rows. 


```r
glimpse(df.starwars)
```

```
## Observations: 87
## Variables: 13
## $ name       <chr> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", ...
## $ height     <int> 172, 167, 96, 202, 150, 178, 165, 97, 183, 182, 188...
## $ mass       <dbl> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 8...
## $ hair_color <chr> "blond", NA, NA, "none", "brown", "brown, grey", "b...
## $ skin_color <chr> "fair", "gold", "white, blue", "white", "light", "l...
## $ eye_color  <chr> "blue", "yellow", "red", "yellow", "brown", "blue",...
## $ birth_year <dbl> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0...
## $ gender     <chr> "male", NA, NA, "male", "female", "male", "female",...
## $ homeworld  <chr> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alder...
## $ species    <chr> "Human", "Droid", "Droid", "Human", "Human", "Human...
## $ films      <list> [<"Revenge of the Sith", "Return of the Jedi", "Th...
## $ vehicles   <list> [<"Snowspeeder", "Imperial Speeder Bike">, <>, <>,...
## $ starships  <list> [<"X-wing", "Imperial shuttle">, <>, <>, "TIE Adva...
```

### `distinct()`

`distinct()` shows all the distinct values for a character or factor column. 


```r
df.starwars %>% 
  distinct(name)
```

```
## # A tibble: 87 x 1
##    name              
##    <chr>             
##  1 Luke Skywalker    
##  2 C-3PO             
##  3 R2-D2             
##  4 Darth Vader       
##  5 Leia Organa       
##  6 Owen Lars         
##  7 Beru Whitesun lars
##  8 R5-D4             
##  9 Biggs Darklighter 
## 10 Obi-Wan Kenobi    
## # ... with 77 more rows
```

### `count()`

`count()` shows a count of all the different distinct values in a column. 


```r
df.starwars %>% 
  count(gender)
```

```
## # A tibble: 5 x 2
##   gender            n
##   <chr>         <int>
## 1 <NA>              3
## 2 female           19
## 3 hermaphrodite     1
## 4 male             62
## 5 none              2
```

It's possible to do grouped counts by combining several variables.


```r
df.starwars %>% 
  count(species, gender) %>% 
  head(n = 10)
```

```
## # A tibble: 10 x 3
##    species  gender     n
##    <chr>    <chr>  <int>
##  1 <NA>     female     3
##  2 <NA>     male       2
##  3 Aleena   male       1
##  4 Besalisk male       1
##  5 Cerean   male       1
##  6 Chagrian male       1
##  7 Clawdite female     1
##  8 Droid    <NA>       3
##  9 Droid    none       2
## 10 Dug      male       1
```

### `datatable()`

For RMardkown files specifically, we can use the `datatable()` function from the `DT` package to get an interactive table widget.


```r
df.starwars %>% 
  DT::datatable()
```

![](04-data_wrangling1_files/figure-latex/data-wrangling1-36-1.pdf)<!-- --> 

### Other tools for taking a quick look at data 

#### `vis_dat()`

The `vis_dat()` function from the `visdat` package, gives a visual summary that makes it easy to see the variable types and whether there are missing values in the data. 


```r
visdat::vis_dat(df.starwars)
```

![](04-data_wrangling1_files/figure-latex/data-wrangling1-37-1.pdf)<!-- --> 

\begin{info}
When R loads packages, functions loaded in earlier packages are
overwritten by functions of the same name from later packages. This
means that the order in which packages are loaded matters. To make sure
that a function from the correct package is used, you can use the
\texttt{package\_name::function\_name()} construction. This way, the
\texttt{function\_name()} from the \texttt{package\_name} is used,
rather than the same function from a different package.

This is why, in general, I recommend to load the tidyverse package last
(since it contains a large number of functions that we use a lot).
\end{info}

#### `skim()`

The `skim()` function from the `skimr` package provides a nice overview of the data, separated by variable types. 


```r
# install.packages("skimr")
skimr::skim(df.starwars)
```

```
## Skim summary statistics
##  n obs: 87 
##  n variables: 13 
## 
## -- Variable type:character ------------------------------------------------
##    variable missing complete  n min max empty n_unique
##   eye_color       0       87 87   3  13     0       15
##      gender       3       84 87   4  13     0        4
##  hair_color       5       82 87   4  13     0       12
##   homeworld      10       77 87   4  14     0       48
##        name       0       87 87   3  21     0       87
##  skin_color       0       87 87   3  19     0       31
##     species       5       82 87   3  14     0       37
## 
## -- Variable type:integer --------------------------------------------------
##  variable missing complete  n   mean    sd p0 p25 p50 p75 p100     hist
##    height       6       81 87 174.36 34.77 66 167 180 191  264 ▁▁▁▂▇▃▁▁
## 
## -- Variable type:list -----------------------------------------------------
##   variable missing complete  n n_unique min_length median_length
##      films       0       87 87       24          1             1
##  starships       0       87 87       17          0             0
##   vehicles       0       87 87       11          0             0
##  max_length
##           7
##           5
##           2
## 
## -- Variable type:numeric --------------------------------------------------
##    variable missing complete  n  mean     sd p0  p25 p50  p75 p100
##  birth_year      44       43 87 87.57 154.69  8 35    52 72    896
##        mass      28       59 87 97.31 169.46 15 55.6  79 84.5 1358
##      hist
##  ▇▁▁▁▁▁▁▁
##  ▇▁▁▁▁▁▁▁
```

#### `dfSummary()`

The `summarytools` package is another great package for taking a look at the data. It renders a nice html output for the data frame including a lot of helpful information. You can find out more about this package [here](https://cran.r-project.org/web/packages/summarytools/vignettes/Introduction.html).


```r
df.starwars %>% 
  select_if(negate(is.list)) %>% # this removes all list columns (we'll learn about this later)
  summarytools::dfSummary() %>% 
  summarytools::view()
```

> Note: The summarytools::view() function will not show up here in the html. It generates a summary of the data that is displayed in the Viewer in RStudio. 

Once we've taken a look at the data, the next step would be to visualize relationships between variables of interest. 

### A quick note on naming things 

Personally, I like to name things in a (pretty) consistent way so that I have no trouble finding stuff even when I open up a project that I haven't worked on for a while. I try to use the following naming conventions: 

\begin{table}[t]

\caption{(\#tab:data-wrangling1-40)Some naming conventions I adopt to make my life easier.}
\centering
\begin{tabular}{rl}
\toprule
name & use\\
\midrule
df.thing & for data frames\\
l.thing & for lists\\
fun.thing & for functions\\
tmp.thing & for temporary variables\\
\bottomrule
\end{tabular}
\end{table}

## Wrangling data 

We use the functions in the package `dplyr` to manipulate our data. 

### filter() 

`filter()` lets us apply logical (and other) operators (see Table \@ref(tab:data-wrangling1-10)) to subset the data. Here, I've filtered out the male characters. 


```r
df.starwars %>% 
  filter(gender == 'male')
```

```
## # A tibble: 62 x 13
##    name  height  mass hair_color skin_color eye_color birth_year gender
##    <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
##  1 Luke~    172    77 blond      fair       blue            19   male  
##  2 Dart~    202   136 none       white      yellow          41.9 male  
##  3 Owen~    178   120 brown, gr~ light      blue            52   male  
##  4 Bigg~    183    84 black      light      brown           24   male  
##  5 Obi-~    182    77 auburn, w~ fair       blue-gray       57   male  
##  6 Anak~    188    84 blond      fair       blue            41.9 male  
##  7 Wilh~    180    NA auburn, g~ fair       blue            64   male  
##  8 Chew~    228   112 brown      unknown    blue           200   male  
##  9 Han ~    180    80 brown      fair       brown           29   male  
## 10 Gree~    173    74 <NA>       green      black           44   male  
## # ... with 52 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
```

We can combine multiple conditions in the same call. Here, I've filtered out male characters, whose height is greater than the median height (i.e. they are in the top 50 percentile), and whose mass was not `NA`. 


```r
df.starwars %>% 
  filter(gender == 'male',
         height > median(height, na.rm = T),
         !is.na(mass))
```

```
## # A tibble: 26 x 13
##    name  height  mass hair_color skin_color eye_color birth_year gender
##    <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
##  1 Dart~    202 136   none       white      yellow          41.9 male  
##  2 Bigg~    183  84   black      light      brown           24   male  
##  3 Obi-~    182  77   auburn, w~ fair       blue-gray       57   male  
##  4 Anak~    188  84   blond      fair       blue            41.9 male  
##  5 Chew~    228 112   brown      unknown    blue           200   male  
##  6 Boba~    183  78.2 black      fair       brown           31.5 male  
##  7 Bossk    190 113   none       green      red             53   male  
##  8 Qui-~    193  89   brown      fair       blue            92   male  
##  9 Nute~    191  90   none       mottled g~ red             NA   male  
## 10 Jar ~    196  66   none       orange     orange          52   male  
## # ... with 16 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
```

Many functions like `mean()`, `median()`, `var()`, `sd()`, `sum()` have the argument `na.rm` which is set to `FALSE` by default. I set the argument to `TRUE` here (or `T` for short), which means that the `NA` values are ignored, and the `median()` is calculated based on the remaning values.

You can use `,` and `&` interchangeably in `filter()`. Make sure to use parentheses when combining several logical operators to indicate which logical operation should be performed first: 


```r
df.starwars %>% 
  filter((skin_color %in% c("dark", "pale") | gender == "hermaphrodite") & height > 170)
```

```
## # A tibble: 10 x 13
##    name  height  mass hair_color skin_color eye_color birth_year gender
##    <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
##  1 Jabb~    175  1358 <NA>       green-tan~ orange           600 herma~
##  2 Land~    177    79 black      dark       brown             31 male  
##  3 Quar~    183    NA black      dark       brown             62 male  
##  4 Bib ~    180    NA none       pale       pink              NA male  
##  5 Mace~    188    84 none       dark       brown             72 male  
##  6 Ki-A~    198    82 white      pale       yellow            92 male  
##  7 Adi ~    184    50 none       dark       blue              NA female
##  8 Saes~    188    NA none       pale       orange            NA male  
##  9 Greg~    185    85 black      dark       brown             NA male  
## 10 Sly ~    178    48 none       pale       white             NA female
## # ... with 5 more variables: homeworld <chr>, species <chr>, films <list>,
## #   vehicles <list>, starships <list>
```

The starwars characters that have either a `"dark"` or a `"pale"` skin tone, or whose gender is `"hermaphrodite"`, and whose height is at least `170` cm. The `%in%` operator is useful when there are multiple options. Instead of `skin_color %in% c("dark", "pale")`, I could have also written `skin_color == "dark" | skin_color == "pale"` but this gets cumbersome as the number of options increases. 

### rename() 

`rename()` renames column names.


```r
df.starwars %>% 
  rename(person = name,
         mass_kg = mass)
```

```
## # A tibble: 87 x 13
##    person height mass_kg hair_color skin_color eye_color birth_year gender
##    <chr>   <int>   <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
##  1 Luke ~    172      77 blond      fair       blue            19   male  
##  2 C-3PO     167      75 <NA>       gold       yellow         112   <NA>  
##  3 R2-D2      96      32 <NA>       white, bl~ red             33   <NA>  
##  4 Darth~    202     136 none       white      yellow          41.9 male  
##  5 Leia ~    150      49 brown      light      brown           19   female
##  6 Owen ~    178     120 brown, gr~ light      blue            52   male  
##  7 Beru ~    165      75 brown      light      blue            47   female
##  8 R5-D4      97      32 <NA>       white, red red             NA   <NA>  
##  9 Biggs~    183      84 black      light      brown           24   male  
## 10 Obi-W~    182      77 auburn, w~ fair       blue-gray       57   male  
## # ... with 77 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
```

The new variable names goes on the LHS of the`=` sign, and the old name on the RHS.  

To rename all variables at the same time use `set_names()`: 


```r
df.starwars %>%
  set_names(letters[1:ncol(.)])  # renamed all variables to letters: a, b, ...
```

```
## # A tibble: 87 x 13
##    a          b     c d     e     f         g h     i     j     k     l    
##    <chr>  <int> <dbl> <chr> <chr> <chr> <dbl> <chr> <chr> <chr> <lis> <lis>
##  1 Luke ~   172    77 blond fair  blue   19   male  Tato~ Human <chr~ <chr~
##  2 C-3PO    167    75 <NA>  gold  yell~ 112   <NA>  Tato~ Droid <chr~ <chr~
##  3 R2-D2     96    32 <NA>  whit~ red    33   <NA>  Naboo Droid <chr~ <chr~
##  4 Darth~   202   136 none  white yell~  41.9 male  Tato~ Human <chr~ <chr~
##  5 Leia ~   150    49 brown light brown  19   fema~ Alde~ Human <chr~ <chr~
##  6 Owen ~   178   120 brow~ light blue   52   male  Tato~ Human <chr~ <chr~
##  7 Beru ~   165    75 brown light blue   47   fema~ Tato~ Human <chr~ <chr~
##  8 R5-D4     97    32 <NA>  whit~ red    NA   <NA>  Tato~ Droid <chr~ <chr~
##  9 Biggs~   183    84 black light brown  24   male  Tato~ Human <chr~ <chr~
## 10 Obi-W~   182    77 aubu~ fair  blue~  57   male  Stew~ Human <chr~ <chr~
## # ... with 77 more rows, and 1 more variable: m <list>
```

### select() 

`select()` allows us to select a subset of the columns in the data frame. 


```r
df.starwars %>% 
  select(name, height, mass)
```

```
## # A tibble: 87 x 3
##    name               height  mass
##    <chr>               <int> <dbl>
##  1 Luke Skywalker        172    77
##  2 C-3PO                 167    75
##  3 R2-D2                  96    32
##  4 Darth Vader           202   136
##  5 Leia Organa           150    49
##  6 Owen Lars             178   120
##  7 Beru Whitesun lars    165    75
##  8 R5-D4                  97    32
##  9 Biggs Darklighter     183    84
## 10 Obi-Wan Kenobi        182    77
## # ... with 77 more rows
```

We can select multiple columns using the `(from:to)` syntax: 


```r
df.starwars %>%  
  select(name:birth_year) # from name to birth_year
```

```
## # A tibble: 87 x 7
##    name           height  mass hair_color   skin_color eye_color birth_year
##    <chr>           <int> <dbl> <chr>        <chr>      <chr>          <dbl>
##  1 Luke Skywalker    172    77 blond        fair       blue            19  
##  2 C-3PO             167    75 <NA>         gold       yellow         112  
##  3 R2-D2              96    32 <NA>         white, bl~ red             33  
##  4 Darth Vader       202   136 none         white      yellow          41.9
##  5 Leia Organa       150    49 brown        light      brown           19  
##  6 Owen Lars         178   120 brown, grey  light      blue            52  
##  7 Beru Whitesun~    165    75 brown        light      blue            47  
##  8 R5-D4              97    32 <NA>         white, red red             NA  
##  9 Biggs Darklig~    183    84 black        light      brown           24  
## 10 Obi-Wan Kenobi    182    77 auburn, whi~ fair       blue-gray       57  
## # ... with 77 more rows
```

Or use a variable for column selection: 


```r
columns = c("name", "height", "species")

df.starwars %>% 
  select(one_of(columns)) # useful when using a variable for column selection
```

```
## # A tibble: 87 x 3
##    name               height species
##    <chr>               <int> <chr>  
##  1 Luke Skywalker        172 Human  
##  2 C-3PO                 167 Droid  
##  3 R2-D2                  96 Droid  
##  4 Darth Vader           202 Human  
##  5 Leia Organa           150 Human  
##  6 Owen Lars             178 Human  
##  7 Beru Whitesun lars    165 Human  
##  8 R5-D4                  97 Droid  
##  9 Biggs Darklighter     183 Human  
## 10 Obi-Wan Kenobi        182 Human  
## # ... with 77 more rows
```

We can also _deselect_ (multiple) columns:


```r
df.starwars %>% 
  select(-name, -(birth_year:vehicles))
```

```
## # A tibble: 87 x 6
##    height  mass hair_color    skin_color  eye_color starships
##     <int> <dbl> <chr>         <chr>       <chr>     <list>   
##  1    172    77 blond         fair        blue      <chr [2]>
##  2    167    75 <NA>          gold        yellow    <chr [0]>
##  3     96    32 <NA>          white, blue red       <chr [0]>
##  4    202   136 none          white       yellow    <chr [1]>
##  5    150    49 brown         light       brown     <chr [0]>
##  6    178   120 brown, grey   light       blue      <chr [0]>
##  7    165    75 brown         light       blue      <chr [0]>
##  8     97    32 <NA>          white, red  red       <chr [0]>
##  9    183    84 black         light       brown     <chr [1]>
## 10    182    77 auburn, white fair        blue-gray <chr [5]>
## # ... with 77 more rows
```

And select columns by partially matching the column name:


```r
df.starwars %>% 
  select(contains("_")) # every column that contains the character "_"
```

```
## # A tibble: 87 x 4
##    hair_color    skin_color  eye_color birth_year
##    <chr>         <chr>       <chr>          <dbl>
##  1 blond         fair        blue            19  
##  2 <NA>          gold        yellow         112  
##  3 <NA>          white, blue red             33  
##  4 none          white       yellow          41.9
##  5 brown         light       brown           19  
##  6 brown, grey   light       blue            52  
##  7 brown         light       blue            47  
##  8 <NA>          white, red  red             NA  
##  9 black         light       brown           24  
## 10 auburn, white fair        blue-gray       57  
## # ... with 77 more rows
```


```r
df.starwars %>% 
  select(starts_with("h")) # every column that starts with an "h"
```

```
## # A tibble: 87 x 3
##    height hair_color    homeworld
##     <int> <chr>         <chr>    
##  1    172 blond         Tatooine 
##  2    167 <NA>          Tatooine 
##  3     96 <NA>          Naboo    
##  4    202 none          Tatooine 
##  5    150 brown         Alderaan 
##  6    178 brown, grey   Tatooine 
##  7    165 brown         Tatooine 
##  8     97 <NA>          Tatooine 
##  9    183 black         Tatooine 
## 10    182 auburn, white Stewjon  
## # ... with 77 more rows
```

We can also use `select()` to reorder the columns: 


```r
# useful trick for changing the column order, now eye_color is at the beginning
df.starwars %>% 
  select(eye_color, everything())
```

```
## # A tibble: 87 x 13
##    eye_color name  height  mass hair_color skin_color birth_year gender
##    <chr>     <chr>  <int> <dbl> <chr>      <chr>           <dbl> <chr> 
##  1 blue      Luke~    172    77 blond      fair             19   male  
##  2 yellow    C-3PO    167    75 <NA>       gold            112   <NA>  
##  3 red       R2-D2     96    32 <NA>       white, bl~       33   <NA>  
##  4 yellow    Dart~    202   136 none       white            41.9 male  
##  5 brown     Leia~    150    49 brown      light            19   female
##  6 blue      Owen~    178   120 brown, gr~ light            52   male  
##  7 blue      Beru~    165    75 brown      light            47   female
##  8 red       R5-D4     97    32 <NA>       white, red       NA   <NA>  
##  9 brown     Bigg~    183    84 black      light            24   male  
## 10 blue-gray Obi-~    182    77 auburn, w~ fair             57   male  
## # ... with 77 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
```

Here, I've moved the `eye_color` column to the beginning of the data frame. `everything()` is a helper function which selects all the columns. 


```r
df.starwars %>% 
  select(-eye_color, everything(), eye_color) # move eye_color to the end
```

```
## # A tibble: 87 x 13
##    name  height  mass hair_color skin_color birth_year gender homeworld
##    <chr>  <int> <dbl> <chr>      <chr>           <dbl> <chr>  <chr>    
##  1 Luke~    172    77 blond      fair             19   male   Tatooine 
##  2 C-3PO    167    75 <NA>       gold            112   <NA>   Tatooine 
##  3 R2-D2     96    32 <NA>       white, bl~       33   <NA>   Naboo    
##  4 Dart~    202   136 none       white            41.9 male   Tatooine 
##  5 Leia~    150    49 brown      light            19   female Alderaan 
##  6 Owen~    178   120 brown, gr~ light            52   male   Tatooine 
##  7 Beru~    165    75 brown      light            47   female Tatooine 
##  8 R5-D4     97    32 <NA>       white, red       NA   <NA>   Tatooine 
##  9 Bigg~    183    84 black      light            24   male   Tatooine 
## 10 Obi-~    182    77 auburn, w~ fair             57   male   Stewjon  
## # ... with 77 more rows, and 5 more variables: species <chr>,
## #   films <list>, vehicles <list>, starships <list>, eye_color <chr>
```

Here, I've moved `eye_color` to the end. Note that I had to deselect it first. 

We can select columns based on their data type using `select_if()`. 


```r
df.starwars %>% 
  select_if(is.numeric) # just select numeric columns
```

```
## # A tibble: 87 x 3
##    height  mass birth_year
##     <int> <dbl>      <dbl>
##  1    172    77       19  
##  2    167    75      112  
##  3     96    32       33  
##  4    202   136       41.9
##  5    150    49       19  
##  6    178   120       52  
##  7    165    75       47  
##  8     97    32       NA  
##  9    183    84       24  
## 10    182    77       57  
## # ... with 77 more rows
```

The following selects all columns that are not numeric: 


```r
df.starwars %>% 
  select_if(~ !is.numeric(.)) # selects all columns that are not numeric
```

```
## # A tibble: 87 x 10
##    name  hair_color skin_color eye_color gender homeworld species films
##    <chr> <chr>      <chr>      <chr>     <chr>  <chr>     <chr>   <lis>
##  1 Luke~ blond      fair       blue      male   Tatooine  Human   <chr~
##  2 C-3PO <NA>       gold       yellow    <NA>   Tatooine  Droid   <chr~
##  3 R2-D2 <NA>       white, bl~ red       <NA>   Naboo     Droid   <chr~
##  4 Dart~ none       white      yellow    male   Tatooine  Human   <chr~
##  5 Leia~ brown      light      brown     female Alderaan  Human   <chr~
##  6 Owen~ brown, gr~ light      blue      male   Tatooine  Human   <chr~
##  7 Beru~ brown      light      blue      female Tatooine  Human   <chr~
##  8 R5-D4 <NA>       white, red red       <NA>   Tatooine  Droid   <chr~
##  9 Bigg~ black      light      brown     male   Tatooine  Human   <chr~
## 10 Obi-~ auburn, w~ fair       blue-gray male   Stewjon   Human   <chr~
## # ... with 77 more rows, and 2 more variables: vehicles <list>,
## #   starships <list>
```

Note that I used `~` here to indicate that I'm creating an anonymous function to check whether column type is numeric. A one-sided formula (expression beginning with `~`) is interpreted as `function(x)`, and wherever `x` would go in the function is represented by `.`.

So, I could write the same code like so: 


```r
df.starwars %>% 
  select_if(function(x) !is.numeric(x)) # selects all columns that are not numeric
```

```
## # A tibble: 87 x 10
##    name  hair_color skin_color eye_color gender homeworld species films
##    <chr> <chr>      <chr>      <chr>     <chr>  <chr>     <chr>   <lis>
##  1 Luke~ blond      fair       blue      male   Tatooine  Human   <chr~
##  2 C-3PO <NA>       gold       yellow    <NA>   Tatooine  Droid   <chr~
##  3 R2-D2 <NA>       white, bl~ red       <NA>   Naboo     Droid   <chr~
##  4 Dart~ none       white      yellow    male   Tatooine  Human   <chr~
##  5 Leia~ brown      light      brown     female Alderaan  Human   <chr~
##  6 Owen~ brown, gr~ light      blue      male   Tatooine  Human   <chr~
##  7 Beru~ brown      light      blue      female Tatooine  Human   <chr~
##  8 R5-D4 <NA>       white, red red       <NA>   Tatooine  Droid   <chr~
##  9 Bigg~ black      light      brown     male   Tatooine  Human   <chr~
## 10 Obi-~ auburn, w~ fair       blue-gray male   Stewjon   Human   <chr~
## # ... with 77 more rows, and 2 more variables: vehicles <list>,
## #   starships <list>
```

We can rename some of the columns using `select()` like so: 


```r
df.starwars %>% 
  select(person = name, height, mass_kg = mass)
```

```
## # A tibble: 87 x 3
##    person             height mass_kg
##    <chr>               <int>   <dbl>
##  1 Luke Skywalker        172      77
##  2 C-3PO                 167      75
##  3 R2-D2                  96      32
##  4 Darth Vader           202     136
##  5 Leia Organa           150      49
##  6 Owen Lars             178     120
##  7 Beru Whitesun lars    165      75
##  8 R5-D4                  97      32
##  9 Biggs Darklighter     183      84
## 10 Obi-Wan Kenobi        182      77
## # ... with 77 more rows
```

For more details, take a look at the help file for `select()`, and this [this great tutorial](https://suzan.rbind.io/2018/01/dplyr-tutorial-1/) in which I learned about some of the more advanced ways of using `select()`. 

### mutate() 

`mutate()` is used to change exisitng columns or make new ones. 


```r
df.starwars %>% 
  mutate(height = height / 100, # to get height in meters
         bmi = mass / (height^2)) %>% # bmi = kg / (m^2)
  select(name, height, mass, bmi)
```

```
## # A tibble: 87 x 4
##    name               height  mass   bmi
##    <chr>               <dbl> <dbl> <dbl>
##  1 Luke Skywalker       1.72    77  26.0
##  2 C-3PO                1.67    75  26.9
##  3 R2-D2                0.96    32  34.7
##  4 Darth Vader          2.02   136  33.3
##  5 Leia Organa          1.5     49  21.8
##  6 Owen Lars            1.78   120  37.9
##  7 Beru Whitesun lars   1.65    75  27.5
##  8 R5-D4                0.97    32  34.0
##  9 Biggs Darklighter    1.83    84  25.1
## 10 Obi-Wan Kenobi       1.82    77  23.2
## # ... with 77 more rows
```

Here, I've calculated the bmi for the different starwars characters. I first mutated the height variable by going from cm to m, and then created the new column "bmi".

A useful helper function for `mutate()` is `ifelse()` which is a shorthand for the if-else control flow (Section \@ref(if-else)). Here is an example: 


```r
df.starwars %>% 
  mutate(height_categorical = ifelse(height > median(height, na.rm = T), 'tall', 'short')) %>% 
  select(name, contains("height"))
```

```
## # A tibble: 87 x 3
##    name               height height_categorical
##    <chr>               <int> <chr>             
##  1 Luke Skywalker        172 short             
##  2 C-3PO                 167 short             
##  3 R2-D2                  96 short             
##  4 Darth Vader           202 tall              
##  5 Leia Organa           150 short             
##  6 Owen Lars             178 short             
##  7 Beru Whitesun lars    165 short             
##  8 R5-D4                  97 short             
##  9 Biggs Darklighter     183 tall              
## 10 Obi-Wan Kenobi        182 tall              
## # ... with 77 more rows
```

`ifelse()` works in the following way: we first specify the condition, then what should be returned if the condition is true, and finally what should be returned otherwise. The more verbose version of the statement above would be: `ifelse(test = height > median(height, na.rm = T), yes = 'tall', no = 'short')` 

There are a number of variants of the `mutate()` function. Let's take a look at them. 

#### mutate_at()

With `mutate_at()`, we can mutate several columns at the same time. 


```r
df.starwars %>% 
  mutate_at(.vars = vars(height, mass, birth_year), .funs = "scale")
```

```
## # A tibble: 87 x 13
##    name  height[,1] mass[,1] hair_color skin_color eye_color birth_year[,1]
##    <chr>      <dbl>    <dbl> <chr>      <chr>      <chr>              <dbl>
##  1 Luke~    -0.0678  -0.120  blond      fair       blue              -0.443
##  2 C-3PO    -0.212   -0.132  <NA>       gold       yellow             0.158
##  3 R2-D2    -2.25    -0.385  <NA>       white, bl~ red               -0.353
##  4 Dart~     0.795    0.228  none       white      yellow            -0.295
##  5 Leia~    -0.701   -0.285  brown      light      brown             -0.443
##  6 Owen~     0.105    0.134  brown, gr~ light      blue              -0.230
##  7 Beru~    -0.269   -0.132  brown      light      blue              -0.262
##  8 R5-D4    -2.22    -0.385  <NA>       white, red red               NA    
##  9 Bigg~     0.249   -0.0786 black      light      brown             -0.411
## 10 Obi-~     0.220   -0.120  auburn, w~ fair       blue-gray         -0.198
## # ... with 77 more rows, and 6 more variables: gender <chr>,
## #   homeworld <chr>, species <chr>, films <list>, vehicles <list>,
## #   starships <list>
```

In `vars()` I've specified what variables to mutate, I've passed the function name `"scale"` to the `.funs` argument. Here, I've z-scored `height`, `mass`, and `birth_year` using the `scale()` function. Note that I wrote the function without `()`. The `.funs` argument expects a list of functions that can be specified by: 

- their name, "mean"
- the function itself, `mean`
- a call to the function with `.` as a dummy argument, `~ mean(.)` (note the `~` before the function call).

Within `vars()`, we can use the same helper functions for selecting columns that we've seen above for `select()`. 

We can also use names to create new columns:


```r
df.starwars %>% 
  mutate_at(vars(height, mass, birth_year), .funs = list(z = "scale")) %>% 
  select(name, contains("height"), contains("mass"), contains("birth_year"))
```

```
## # A tibble: 87 x 7
##    name    height height_z[,1]  mass mass_z[,1] birth_year birth_year_z[,1]
##    <chr>    <int>        <dbl> <dbl>      <dbl>      <dbl>            <dbl>
##  1 Luke S~    172      -0.0678    77    -0.120        19             -0.443
##  2 C-3PO      167      -0.212     75    -0.132       112              0.158
##  3 R2-D2       96      -2.25      32    -0.385        33             -0.353
##  4 Darth ~    202       0.795    136     0.228        41.9           -0.295
##  5 Leia O~    150      -0.701     49    -0.285        19             -0.443
##  6 Owen L~    178       0.105    120     0.134        52             -0.230
##  7 Beru W~    165      -0.269     75    -0.132        47             -0.262
##  8 R5-D4       97      -2.22      32    -0.385        NA             NA    
##  9 Biggs ~    183       0.249     84    -0.0786       24             -0.411
## 10 Obi-Wa~    182       0.220     77    -0.120        57             -0.198
## # ... with 77 more rows
```

As we can see, new columns were created with `_z` added to the end of the column name. 

And we can apply several functions at the same time. 


```r
df.starwars %>% 
  mutate_at(vars(height, mass, birth_year),
            list(z = "scale",
                 centered = ~ scale(., scale = FALSE))) %>% 
  select(name, contains("height"), contains("mass"), contains("birth_year"))
```

```
## # A tibble: 87 x 10
##    name  height height_z[,1] height_centered~  mass mass_z[,1]
##    <chr>  <int>        <dbl>            <dbl> <dbl>      <dbl>
##  1 Luke~    172      -0.0678            -2.36    77    -0.120 
##  2 C-3PO    167      -0.212             -7.36    75    -0.132 
##  3 R2-D2     96      -2.25             -78.4     32    -0.385 
##  4 Dart~    202       0.795             27.6    136     0.228 
##  5 Leia~    150      -0.701            -24.4     49    -0.285 
##  6 Owen~    178       0.105              3.64   120     0.134 
##  7 Beru~    165      -0.269             -9.36    75    -0.132 
##  8 R5-D4     97      -2.22             -77.4     32    -0.385 
##  9 Bigg~    183       0.249              8.64    84    -0.0786
## 10 Obi-~    182       0.220              7.64    77    -0.120 
## # ... with 77 more rows, and 4 more variables: mass_centered[,1] <dbl>,
## #   birth_year <dbl>, birth_year_z[,1] <dbl>,
## #   birth_year_centered[,1] <dbl>
```

Here, I've created z-scored and centered (i.e. only subtracted the mean but didn't divide by the standard deviation) versions of the `height`, `mass`, and `birth_year` columns in one go. 

#### mutate_all()

`mutate_all()` is used to mutate all columns in a data frame.  


```r
df.starwars %>% 
  select(height, mass) %>%
  mutate_all("as.character") # transform all columns to characters
```

```
## # A tibble: 87 x 2
##    height mass 
##    <chr>  <chr>
##  1 172    77   
##  2 167    75   
##  3 96     32   
##  4 202    136  
##  5 150    49   
##  6 178    120  
##  7 165    75   
##  8 97     32   
##  9 183    84   
## 10 182    77   
## # ... with 77 more rows
```

Here, I've selected some columns first, and then changed the mode to character in each of them. 

Like we've seen with `mutate_at()`, you can add a name in the `mutate_all()` function call to make new columns instead of replacing the existing ones. 


```r
df.starwars %>% 
  select(height, mass) %>%
  mutate_all(.funs = list(char = "as.character")) # make new character columns
```

```
## # A tibble: 87 x 4
##    height  mass height_char mass_char
##     <int> <dbl> <chr>       <chr>    
##  1    172    77 172         77       
##  2    167    75 167         75       
##  3     96    32 96          32       
##  4    202   136 202         136      
##  5    150    49 150         49       
##  6    178   120 178         120      
##  7    165    75 165         75       
##  8     97    32 97          32       
##  9    183    84 183         84       
## 10    182    77 182         77       
## # ... with 77 more rows
```

#### mutate_if()

`mutate_if()` can sometimes come in handy. For example, the following code changes all the numeric columns to character columns:


```r
df.starwars %>% 
  mutate_if(.predicate = is.numeric, .funs = "as.character")
```

```
## # A tibble: 87 x 13
##    name  height mass  hair_color skin_color eye_color birth_year gender
##    <chr> <chr>  <chr> <chr>      <chr>      <chr>     <chr>      <chr> 
##  1 Luke~ 172    77    blond      fair       blue      19         male  
##  2 C-3PO 167    75    <NA>       gold       yellow    112        <NA>  
##  3 R2-D2 96     32    <NA>       white, bl~ red       33         <NA>  
##  4 Dart~ 202    136   none       white      yellow    41.9       male  
##  5 Leia~ 150    49    brown      light      brown     19         female
##  6 Owen~ 178    120   brown, gr~ light      blue      52         male  
##  7 Beru~ 165    75    brown      light      blue      47         female
##  8 R5-D4 97     32    <NA>       white, red red       <NA>       <NA>  
##  9 Bigg~ 183    84    black      light      brown     24         male  
## 10 Obi-~ 182    77    auburn, w~ fair       blue-gray 57         male  
## # ... with 77 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
```

Or we can round all the numeric columns: 


```r
df.starwars %>% 
  mutate_if(.predicate = is.numeric, .funs = "round")
```

```
## # A tibble: 87 x 13
##    name  height  mass hair_color skin_color eye_color birth_year gender
##    <chr>  <dbl> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
##  1 Luke~    172    77 blond      fair       blue              19 male  
##  2 C-3PO    167    75 <NA>       gold       yellow           112 <NA>  
##  3 R2-D2     96    32 <NA>       white, bl~ red               33 <NA>  
##  4 Dart~    202   136 none       white      yellow            42 male  
##  5 Leia~    150    49 brown      light      brown             19 female
##  6 Owen~    178   120 brown, gr~ light      blue              52 male  
##  7 Beru~    165    75 brown      light      blue              47 female
##  8 R5-D4     97    32 <NA>       white, red red               NA <NA>  
##  9 Bigg~    183    84 black      light      brown             24 male  
## 10 Obi-~    182    77 auburn, w~ fair       blue-gray         57 male  
## # ... with 77 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
```

### arrange() 

`arrange()` allows us to sort the values in a data frame by one or more column entries. 


```r
df.starwars %>% 
  arrange(hair_color, desc(height))
```

```
## # A tibble: 87 x 13
##    name  height  mass hair_color skin_color eye_color birth_year gender
##    <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
##  1 Mon ~    150  NA   auburn     fair       blue            48   female
##  2 Wilh~    180  NA   auburn, g~ fair       blue            64   male  
##  3 Obi-~    182  77   auburn, w~ fair       blue-gray       57   male  
##  4 Bail~    191  NA   black      tan        brown           67   male  
##  5 Greg~    185  85   black      dark       brown           NA   male  
##  6 Bigg~    183  84   black      light      brown           24   male  
##  7 Boba~    183  78.2 black      fair       brown           31.5 male  
##  8 Quar~    183  NA   black      dark       brown           62   male  
##  9 Jang~    183  79   black      tan        brown           66   male  
## 10 Land~    177  79   black      dark       brown           31   male  
## # ... with 77 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
```

Here, I've sorted the data frame first by `hair_color`, and then by `height`. I've used the `desc()` function to sort `height` in descending order. Bail Prestor Organa is the tallest black character in starwars. 

### Practice 2 

Compute the body mass index for `male` characters who are `human`.

- select only the columns you need 
- filter out only the rows you need 
- make the new variable with the body mass index 
- arrange the data frame starting with the highest body mass index 


```r
# write your code here 
```

## Additional resources 

### Cheatsheets 

- [base R](figures/base-r.pdf) --> summary of how to use base R (we will mostly use the tidyverse but it's still important to know how to do things in base R)
- [data transformation](figures/data-transformation.pdf) --> transforming data using `dplyr`

### Data camp courses

- [cleaning data](https://www.datacamp.com/courses/importing-cleaning-data-in-r-case-studies)
- [dplyr](https://www.datacamp.com/courses/dplyr-data-manipulation-r-tutorial)
- [tidyverse](https://www.datacamp.com/courses/introduction-to-the-tidyverse)

### Books and chapters

- [Chapters 9-15 in "R for Data Science"](https://r4ds.had.co.nz/wrangle-intro.html)
- [Chapter 5 in "Data Visualization - A practical introduction"](http://socviz.co/workgeoms.html#workgeoms)

<!--chapter:end:04-data_wrangling1.Rmd-->

# Data wrangling 2 

In this session, we will continue to learn about wrangling data. Some of the functions that I'll introduce in this session are a little tricky to master. Like learning a new language, it takes some time to get fluent. However, it's worth investing the time. 

## Learning objectives 

- Learn how to group and summarize data using `group_by()` and `summarize()`. 
- Learn how to deal with missing data entries `NA`. 
- Get familiar with how to reshape data using `gather()`, `spread()`, `separate()` and `unite()`.
- Learn the basics of how to join multiple data frames with a focus on `left_join()`. 
- Master how to _read_ and _save_ data. 

## Load packages 

Let's first load the packages that we need for this chapter. 


```r
library("knitr") # for rendering the RMarkdown file
library("tidyverse") # for data wrangling 
```

## Wrangling data (continued)

### Summarizing data 

Let's first load the `starwars` data set again: 


```r
df.starwars = starwars
```

A particularly powerful way of interating with data is by grouping and summarizing it. `summarize()` returns a single value for each summary that we ask for: 


```r
df.starwars %>% 
  summarize(height_mean = mean(height, na.rm = T),
            height_max = max(height, na.rm = T),
            n = n())
```

```
## # A tibble: 1 x 3
##   height_mean height_max     n
##         <dbl>      <int> <int>
## 1        174.        264    87
```

Here, I computed the mean height, the maximum height, and the total number of observations (using the function `n()`). 
Let's say we wanted to get a quick sense for how tall starwars characters from different species are. To do that, we combine grouping with summarizing: 


```r
df.starwars %>% 
  group_by(species) %>% 
  summarize(height_mean = mean(height, na.rm = T))
```

```
## # A tibble: 38 x 2
##    species   height_mean
##    <chr>           <dbl>
##  1 <NA>              160
##  2 Aleena             79
##  3 Besalisk          198
##  4 Cerean            198
##  5 Chagrian          196
##  6 Clawdite          168
##  7 Droid             140
##  8 Dug               112
##  9 Ewok               88
## 10 Geonosian         183
## # ... with 28 more rows
```

I've first used `group_by()` to group our data frame by the different species, and then used `summarize()` to calculate the mean height of each species.

It would also be useful to know how many observations there are in each group. 


```r
df.starwars %>% 
  group_by(species) %>% 
  summarize(height_mean = mean(height, na.rm = T), 
            group_size = n()) %>% 
  arrange(desc(group_size)) 
```

```
## # A tibble: 38 x 3
##    species  height_mean group_size
##    <chr>          <dbl>      <int>
##  1 Human           177.         35
##  2 <NA>            160           5
##  3 Droid           140           5
##  4 Gungan          209.          3
##  5 Kaminoan        221           2
##  6 Mirialan        168           2
##  7 Twi'lek         179           2
##  8 Wookiee         231           2
##  9 Zabrak          173           2
## 10 Aleena           79           1
## # ... with 28 more rows
```

Here, I've used the `n()` function to get the number of observations in each group, and then I've arranged the data frame according to group size in descending order. 

Note that `n()` always yields the number of observations in each group. If we don't group the data, then we get the overall number of observations in our data frame (i.e. the number of rows). 

So, Humans are the largest group in our data frame, followed by Droids (who are considerably smaller) and Gungans (who would make for good Basketball players). 

Sometimes `group_by()` is also useful without summarizing the data. For example, we often want to z-score (i.e. normalize) data on the level of individual participants. To do so, we first group the data on the level of participants, and then use `mutate()` to scale the data. Here is an example: 


```r
# first let's generate some random data 
df.summarize = tibble(
  participant = rep(1:3, each = 5),
  judgment = sample(0:100, size = 15, replace = TRUE)
) %>% 
  print()
```

```
## # A tibble: 15 x 2
##    participant judgment
##          <int>    <int>
##  1           1       42
##  2           1       91
##  3           1       26
##  4           1       35
##  5           1       30
##  6           2       28
##  7           2       51
##  8           2       35
##  9           2       66
## 10           2       64
## 11           3       85
## 12           3       29
## 13           3      100
## 14           3       55
## 15           3       75
```


```r
df.summarize %>%   
  group_by(participant) %>% # group by participants
  mutate(judgment_zscored = scale(judgment)) %>% # z-score data on individual participant level 
  ungroup() %>% # ungroup the data frame
  head(n = 10) # print the top 10 rows 
```

```
## # A tibble: 10 x 3
##    participant judgment judgment_zscored
##          <int>    <int>            <dbl>
##  1           1       42           -0.106
##  2           1       91            1.74 
##  3           1       26           -0.709
##  4           1       35           -0.370
##  5           1       30           -0.558
##  6           2       28           -1.22 
##  7           2       51            0.129
##  8           2       35           -0.812
##  9           2       66            1.01 
## 10           2       64            0.895
```

First, I've generated some random data using the repeat function `rep()` for making a `participant` column, and the `sample()` function to randomly choose values from a range between 0 and 100 with replacement. (We will learn more about these functions later when we look into how to simulate data.) I've then grouped the data by participant, and used the scale function to z-score the data. 

> __TIP__: Don't forget to `ungroup()` your data frame. Otherwise, any subsequent operations are applied per group. 

Sometimes, I want to run operations on each row, rather than per column. For example, let's say that I wanted each character's average combined height and mass. 

Let's see first what doesn't work: 


```r
df.starwars %>% 
  mutate(mean_height_mass = mean(c(height, mass), na.rm = T)) %>% 
  select(name, height, mass, mean_height_mass)
```

```
## # A tibble: 87 x 4
##    name               height  mass mean_height_mass
##    <chr>               <int> <dbl>            <dbl>
##  1 Luke Skywalker        172    77             142.
##  2 C-3PO                 167    75             142.
##  3 R2-D2                  96    32             142.
##  4 Darth Vader           202   136             142.
##  5 Leia Organa           150    49             142.
##  6 Owen Lars             178   120             142.
##  7 Beru Whitesun lars    165    75             142.
##  8 R5-D4                  97    32             142.
##  9 Biggs Darklighter     183    84             142.
## 10 Obi-Wan Kenobi        182    77             142.
## # ... with 77 more rows
```

Note that all the values are the same. The value shown here is just the mean of all the values in `height` and `mass`.


```r
df.starwars %>% 
  select(height, mass) %>% 
  unlist() %>% # turns the data frame into a vector
  mean(na.rm = T) 
```

```
## [1] 141.8886
```

To get the mean by row, we can either spell out the arithmetic


```r
df.starwars %>% 
  mutate(mean_height_mass = (height + mass) / 2) %>% # here, I've replaced the mean() function  
  select(name, height, mass, mean_height_mass)
```

```
## # A tibble: 87 x 4
##    name               height  mass mean_height_mass
##    <chr>               <int> <dbl>            <dbl>
##  1 Luke Skywalker        172    77            124. 
##  2 C-3PO                 167    75            121  
##  3 R2-D2                  96    32             64  
##  4 Darth Vader           202   136            169  
##  5 Leia Organa           150    49             99.5
##  6 Owen Lars             178   120            149  
##  7 Beru Whitesun lars    165    75            120  
##  8 R5-D4                  97    32             64.5
##  9 Biggs Darklighter     183    84            134. 
## 10 Obi-Wan Kenobi        182    77            130. 
## # ... with 77 more rows
```

or use the `rowwise()` helper function which is like `group_by()` but treats each row like a group: 


```r
df.starwars %>% 
  rowwise() %>% # now, each row is treated like a separate group 
  mutate(mean_height_mass = mean(c(height, mass), na.rm = T)) %>% 
  ungroup() %>% 
  select(name, height, mass, mean_height_mass)
```

```
## # A tibble: 87 x 4
##    name               height  mass mean_height_mass
##    <chr>               <int> <dbl>            <dbl>
##  1 Luke Skywalker        172    77            124. 
##  2 C-3PO                 167    75            121  
##  3 R2-D2                  96    32             64  
##  4 Darth Vader           202   136            169  
##  5 Leia Organa           150    49             99.5
##  6 Owen Lars             178   120            149  
##  7 Beru Whitesun lars    165    75            120  
##  8 R5-D4                  97    32             64.5
##  9 Biggs Darklighter     183    84            134. 
## 10 Obi-Wan Kenobi        182    77            130. 
## # ... with 77 more rows
```

#### Practice 1 

Find out what the average `height` and `mass` (as well as the standard deviation) is from different `species` in different `homeworld`s. Why is the standard deviation `NA` for many groups?  


```r
# write your code here 
```

Who is the tallest member of each species? What eye color do they have? The `top_n()` function or the `row_number()` function (in combination with `filter()`) will be useful here. 


```r
# write your code here 
```

### Reshaping data 

We want our data frames to be tidy. What's tidy? 

1. Each variable must have its own column.
2. Each observation must have its own row.
3. Each value must have its own cell.

For more information on tidy data frames see the [Tidy data](http://r4ds.had.co.nz/tidy-data.html) chapter in Hadley Wickham's R for Data Science book. 

> "Happy families are all alike; every unhappy family is unhappy in its own way." –– Leo Tolstoy

> "Tidy datasets are all alike, but every messy dataset is messy in its own way." –– Hadley Wickham

Let's first generate a data set that is _not_ tidy. 


```r
# construct data frame 
df.reshape = tibble(
  participant = c(1, 2),
  observation_1 = c(10, 25),
  observation_2 = c(100, 63),
  observation_3 = c(24, 45)) %>% 
  print()
```

```
## # A tibble: 2 x 4
##   participant observation_1 observation_2 observation_3
##         <dbl>         <dbl>         <dbl>         <dbl>
## 1           1            10           100            24
## 2           2            25            63            45
```

Here, I've generated data from two participants with three observations. This data frame is not tidy since each row contains more than a single observation. Data frames that have one row per participant but many observations are called _wide_ data frames. 

We can make it tidy using the `gather()` function. 


```r
df.reshape.long = df.reshape %>% 
  gather(key = "index", value = "rating", -participant) %>%
  arrange(participant) %>% 
  print()
```

```
## # A tibble: 6 x 3
##   participant index         rating
##         <dbl> <chr>          <dbl>
## 1           1 observation_1     10
## 2           1 observation_2    100
## 3           1 observation_3     24
## 4           2 observation_1     25
## 5           2 observation_2     63
## 6           2 observation_3     45
```

`df.reshape.long` now contains one observation in each row. Data frames with one row per observation are called _long_ data frames. 

The `gather()` function takes four arguments: 

1. the data which I've passed to it via the pipe `%>%` 
2. a name for the `key` column which will contain the column names of the original data frame
3. a name for the `value` column which will contain the values that were spread across different columns in the original data frame
4. a specification for which columns we want to gather -- here I've specified that we want to gather the values from all columns except the `participant` column

`spread()` is the counterpart of `gather()`. We can use it to go from a data frame that is in _long_ format, to a data frame that's in _wide_ format, like so: 


```r
df.reshape.wide = df.reshape.long %>% 
  spread(key = index, value = rating) %>% 
  print()
```

```
## # A tibble: 2 x 4
##   participant observation_1 observation_2 observation_3
##         <dbl>         <dbl>         <dbl>         <dbl>
## 1           1            10           100            24
## 2           2            25            63            45
```

For my data, I often have a wide data frame that contains demographic information about participants, and a long data frame that contains participants' responses in the experiment. In Section \@ref(joining-multiple-data-frames), we will learn how to combine information from multiple data frames (with potentially different formats).

Here is a slightly more advanced example that involves reshaping a data frame. Let's consider that we have the following data frame to start with: 


```r
# construct data frame 
df.reshape2 = tibble(
  participant = c(1, 2),
  stimulus_1 = c("flower", "car"),
  observation_1 = c(10, 25),
  stimulus_2 = c("house", "flower"),
  observation_2 = c(100, 63),
  stimulus_3 = c("car", "house"),
  observation_3 = c(24, 45)
) %>% 
  print()
```

```
## # A tibble: 2 x 7
##   participant stimulus_1 observation_1 stimulus_2 observation_2 stimulus_3
##         <dbl> <chr>              <dbl> <chr>              <dbl> <chr>     
## 1           1 flower                10 house                100 car       
## 2           2 car                   25 flower                63 house     
## # ... with 1 more variable: observation_3 <dbl>
```

Now, the data frame contains in each row, which stimuli a participant saw, and what rating she gave. Each of the two participants saw a picture of a flower, car, and house, and rated how much they liked the picture on a scale from 0 to 100. The order at which the pictures were presented was randomized between participants. I will use a combination of `gather()`, `separate()`, and `spread()` to turn this into a data frame in long format. 


```r
df.reshape2 %>% 
  gather(key = "index", value = "value", -participant) %>% 
  separate(col = index, into = c("index", "order"), sep = "_") %>% 
  spread(key = index, value = value) %>% 
  mutate_at(vars(order, observation), ~ as.numeric(.)) %>% 
  select(participant, order, stimulus, rating = observation)
```

```
## # A tibble: 6 x 4
##   participant order stimulus rating
##         <dbl> <dbl> <chr>     <dbl>
## 1           1     1 flower       10
## 2           1     2 house       100
## 3           1     3 car          24
## 4           2     1 car          25
## 5           2     2 flower       63
## 6           2     3 house        45
```

Voilà! Getting the desired data frame involved a few new tricks. Let's take it step by step. 

First, I use `gather()` to make a long table. 


```r
df.reshape2 %>% 
  gather(key = "index", value = "value", -participant)
```

```
## # A tibble: 12 x 3
##    participant index         value 
##          <dbl> <chr>         <chr> 
##  1           1 stimulus_1    flower
##  2           2 stimulus_1    car   
##  3           1 observation_1 10    
##  4           2 observation_1 25    
##  5           1 stimulus_2    house 
##  6           2 stimulus_2    flower
##  7           1 observation_2 100   
##  8           2 observation_2 63    
##  9           1 stimulus_3    car   
## 10           2 stimulus_3    house 
## 11           1 observation_3 24    
## 12           2 observation_3 45
```

However, I want to have the information about the stimulus and the observation in the same row. That is, I want to see what rating a participant gave to the flower stimulus, for example. To get there, I separate the `index` column into two separate columns using the `separate()` function. 


```r
df.reshape2 %>% 
  gather(key = "index", value = "value", -participant) %>%
  separate(col = index, into = c("index", "order"), sep = "_")
```

```
## # A tibble: 12 x 4
##    participant index       order value 
##          <dbl> <chr>       <chr> <chr> 
##  1           1 stimulus    1     flower
##  2           2 stimulus    1     car   
##  3           1 observation 1     10    
##  4           2 observation 1     25    
##  5           1 stimulus    2     house 
##  6           2 stimulus    2     flower
##  7           1 observation 2     100   
##  8           2 observation 2     63    
##  9           1 stimulus    3     car   
## 10           2 stimulus    3     house 
## 11           1 observation 3     24    
## 12           2 observation 3     45
```

The `separate()` function takes four arguments: 

1. the data which I've passed to it via the pipe `%>%` 
2. the name of the column `col` which we want to separate
3. the names of the columns `into` into which we want to separate the original column 
4. the separator `sep` that we want to use to split the columns. 

Note, like `gather()` and `spread()`, there is a partner for `separate()`, too. It's called `unite()` and it allows you to combine several columns into one. 

Now, I can use the `spread()` function to make a separate column for each entry in `index` that contains the values in `value`. 


```r
df.reshape2 %>% 
  gather(key = "index", value = "value", -participant) %>% 
  separate(index, into = c("index", "order"), sep = "_") %>% 
  spread(index, value)
```

```
## # A tibble: 6 x 4
##   participant order observation stimulus
##         <dbl> <chr> <chr>       <chr>   
## 1           1 1     10          flower  
## 2           1 2     100         house   
## 3           1 3     24          car     
## 4           2 1     25          car     
## 5           2 2     63          flower  
## 6           2 3     45          house
```

That's pretty much it. Now, each row contains information about the order in which a stimulus was presented, what the stimulus was, and the judgment that a participant made in this trial. 


```r
df.reshape2 %>% 
  gather(key = "index", value = "value", -participant) %>% 
  separate(index, into = c("index", "order"), sep = "_") %>% 
  spread(index,value) %>% 
  mutate_at(vars(order, observation), ~ as.numeric(.)) %>% 
  select(participant, order, stimulus, rating = observation)
```

```
## # A tibble: 6 x 4
##   participant order stimulus rating
##         <dbl> <dbl> <chr>     <dbl>
## 1           1     1 flower       10
## 2           1     2 house       100
## 3           1     3 car          24
## 4           2     1 car          25
## 5           2     2 flower       63
## 6           2     3 house        45
```

The rest is familiar. I've used `mutate_at()` to turn `order` and `observation` into numeric columns, `select()` to change the order of the columns (and renamed the `observation` column to `rating` along the way), and `arrange()` to sort the data frame by `participant` and `order`. 

Sometimes, we may have a data frame where data is recorded in a long string. 


```r
df.reshape3 = tibble(
  participant = 1:2,
  judgments = c("10, 4, 12, 15", "3, 4")
) %>% 
  print()
```

```
## # A tibble: 2 x 2
##   participant judgments    
##         <int> <chr>        
## 1           1 10, 4, 12, 15
## 2           2 3, 4
```

Here, I've created a data frame with data from two participants. For whatever reason, we have four judgments from participant 1 and only two judgments from participant 2 (data is often messy in real life, too!). 

We can use the `separate_rows()` function to turn this into a tidy data frame in long format. 


```r
df.reshape3 %>% 
  separate_rows(judgments)
```

```
## # A tibble: 6 x 2
##   participant judgments
##         <int> <chr>    
## 1           1 10       
## 2           1 4        
## 3           1 12       
## 4           1 15       
## 5           2 3        
## 6           2 4
```

Getting familiar with `gather()` and `spread()` takes some time plus trial and error. So don't be discouraged if you don't get what you want straight away. Once you've mastered these functions, they will make it much easier to get your data frames into shape. 

After having done some transformations like this, it's worth checking that nothing went wrong. I often compare a few values in the transformed and original data frame to make sure everything is legit. 

#### Practice 2 

Load this data frame first.


```r
df.practice2 = tibble(
  participant = 1:10,
  initial = c("AR", "FA", "IR", "NC", "ER", "PI", "DH", "CN", "WT", "JD"), 
  judgment_1 = c(12, 13, 1, 14, 5, 6, 12, 41, 100, 33),
  judgment_2 = c(2, 20, 10, 89, 94, 27, 29, 19, 57, 74),
  judgment_3 = c(2, 20, 10, 89, 94, 27, 29, 19, 57, 74)
)
```

- Make the `df.practice2` data framey tidy (by turning into a long format).
- Compute the z-score of each participants' judgments (using the `scale()` function).
- Calculate the mean and standard deviation of each participants' z-scored judgments. 
- Notice anything interesting? Think about what [z-scoring](https://www.statisticshowto.datasciencecentral.com/probability-and-statistics/z-score/) does ... 


```r
# write your code here 
```

### Joining multiple data frames 

It's nice to have all the information we need in a single, tidy data frame. We have learned above how to go from a single untidy data frame to a tidy one. However, often our situation to start off with is even worse. The information we need sits in several, messy data frames. 

For example, we may have one data frame `df.stimuli` with information about each stimulus, and then have another data frame with participants' responses `df.responses` that only contains a stimulus index but no other infromation about the stimuli. 


```r
set.seed(1) # setting random seed to make this example reproducible

# data frame with stimulus information
df.stimuli = tibble(
  index = 1:5,
  height = c(2, 3, 1, 4, 5),
  width = c(4, 5, 2, 3, 1),
  n_dots = c(12, 15, 5, 13, 7),
  color = c("green", "blue", "white", "red", "black")
) %>% 
  print()
```

```
## # A tibble: 5 x 5
##   index height width n_dots color
##   <int>  <dbl> <dbl>  <dbl> <chr>
## 1     1      2     4     12 green
## 2     2      3     5     15 blue 
## 3     3      1     2      5 white
## 4     4      4     3     13 red  
## 5     5      5     1      7 black
```

```r
# data frame with participants' responses 
df.responses = tibble(
  participant = rep(1:3, each = 5),
  index = rep(1:5, 3), 
  response = sample(0:100, size = 15, replace = TRUE) # randomly sample 15 values from 0 to 100
) %>% 
  print()
```

```
## # A tibble: 15 x 3
##    participant index response
##          <int> <int>    <int>
##  1           1     1       26
##  2           1     2       37
##  3           1     3       57
##  4           1     4       91
##  5           1     5       20
##  6           2     1       90
##  7           2     2       95
##  8           2     3       66
##  9           2     4       63
## 10           2     5        6
## 11           3     1       20
## 12           3     2       17
## 13           3     3       69
## 14           3     4       38
## 15           3     5       77
```

The `df.stimuli` data frame contains an `index`, information about the `height`, and `width`, as well as the number of `dots`, and their `color`. Let's imagine that participants had to judge how much they liked each image from a scale of 0 ("not liking this dot pattern at all") to 100 ("super thrilled about this dot pattern"). 

Let's say that I now wanted to know what participants' average response for the differently colored dot patterns are. Here is how I would do this: 


```r
df.responses %>% 
  left_join(df.stimuli %>%
              select(index, color),
            by = "index") %>% 
  group_by(color) %>% 
  summarize(response_mean = mean(response))
```

```
## # A tibble: 5 x 2
##   color response_mean
##   <chr>         <dbl>
## 1 black          34.3
## 2 blue           49.7
## 3 green          45.3
## 4 red            64  
## 5 white          64
```

Let's take it step by step. The key here is to add the information from the `df.stimuli` data frame to the `df.responses` data frame. 


```r
df.responses %>% 
  left_join(df.stimuli %>% 
              select(index, color),
            by = "index")
```

```
## # A tibble: 15 x 4
##    participant index response color
##          <int> <int>    <int> <chr>
##  1           1     1       26 green
##  2           1     2       37 blue 
##  3           1     3       57 white
##  4           1     4       91 red  
##  5           1     5       20 black
##  6           2     1       90 green
##  7           2     2       95 blue 
##  8           2     3       66 white
##  9           2     4       63 red  
## 10           2     5        6 black
## 11           3     1       20 green
## 12           3     2       17 blue 
## 13           3     3       69 white
## 14           3     4       38 red  
## 15           3     5       77 black
```

I've joined the `df.stimuli` table in which I've only selected the `index` and `color` column, with the `df.responses` table, and specified the `index` column as the one by which the tables should be joined. This is the only column that both of the data frames have in common. 

To specify multiple columns by which we would like to join tables, we specify the `by` argument as follows: `by = c("one_column", "another_column")`. 

Sometimes, the tables I want to join don't have any column names in common. In that case, we can tell the `left_join()` function which column pair(s) should be used for joining. 


```r
df.responses %>% 
  rename(stimuli = index) %>% # I've renamed the index column to stimuli
  left_join(df.stimuli %>% 
              select(index, color),
            by = c("stimuli" = "index")) 
```

```
## # A tibble: 15 x 4
##    participant stimuli response color
##          <int>   <int>    <int> <chr>
##  1           1       1       26 green
##  2           1       2       37 blue 
##  3           1       3       57 white
##  4           1       4       91 red  
##  5           1       5       20 black
##  6           2       1       90 green
##  7           2       2       95 blue 
##  8           2       3       66 white
##  9           2       4       63 red  
## 10           2       5        6 black
## 11           3       1       20 green
## 12           3       2       17 blue 
## 13           3       3       69 white
## 14           3       4       38 red  
## 15           3       5       77 black
```

Here, I've first renamed the index column (to create the problem) and then used the `by = c("stimuli" = "index")` construction (to solve the problem). 

In my experience, it often takes a little bit of playing around to make sure that the data frames were joined as intended. One very good indicator is the row number of the initial data frame, and the joined one. For a `left_join()`, most of the time, we want the row number of the original data frame ("the one on the left") and the joined data frame to be the same. If the row number changed, something probably went wrong. 

Take a look at the `join` help file to see other operations for combining two or more data frames into one (make sure to look at the one from the `dplyr` package). 

#### Practice 3

Load these three data frames first: 


```r
set.seed(1)

df.judgments = tibble(
  participant = rep(1:3, each = 5),
  stimulus = rep(c("red", "green", "blue"), 5),
  judgment = sample(0:100, size = 15, replace = T)
)

df.information = tibble(
  number = seq(from = 0, to = 100, length.out = 5),
  color = c("red", "green", "blue", "black", "white")
)
```

Create a new data frame called `df.join` that combines the information from both `df.judgments` and `df.information`. Note that column with the colors is called `stimulus` in `df.judgments` and `color` in `df.information`. At the end, you want a data frame that contains the following columns: `participant`, `stimulus`, `number`, and `judgment`. 


```r
# write your code here
```



### Dealing with missing data 

There are two ways for data to be missing. 

- __implicit__: data is not present in the table 
- __explicit__: data is flagged with `NA`

We can check for explicit missing values using the `is.na()` function like so: 


```r
tmp.na = c(1, 2, NA, 3)
is.na(tmp.na)
```

```
## [1] FALSE FALSE  TRUE FALSE
```

I've first created a vector `tmp.na` with a missing value at index 3. Calling the `is.na()` function on this vector yields a logical vector with `FALSE` for each value that is not missing, and `TRUE` for each missing value.

Let's say that we have a data frame with missing values and that we want to replace those missing values with something else. Let's first create a data frame with missing values. 


```r
df.missing = tibble(x = c(1, 2, NA),
                 y = c("a", NA, "b"))
print(df.missing)
```

```
## # A tibble: 3 x 2
##       x y    
##   <dbl> <chr>
## 1     1 a    
## 2     2 <NA> 
## 3    NA b
```

We can use the `replace_na()` function to replace the missing values with something else. 


```r
df.missing %>% 
  mutate(x = replace_na(x, replace = 0),
         y = replace_na(y, replace = "unknown"))
```

```
## # A tibble: 3 x 2
##       x y      
##   <dbl> <chr>  
## 1     1 a      
## 2     2 unknown
## 3     0 b
```

We can also remove rows with missing values using the `drop_na()` function. 


```r
df.missing %>% 
  drop_na()
```

```
## # A tibble: 1 x 2
##       x y    
##   <dbl> <chr>
## 1     1 a
```

If we only want to drop values from specific columns, we can specify these columns within the `drop_na()` function call. So, if we only want to drop rows that have missing values in the `x` column, we can write: 


```r
df.missing %>% 
  drop_na(x)
```

```
## # A tibble: 2 x 2
##       x y    
##   <dbl> <chr>
## 1     1 a    
## 2     2 <NA>
```

To make the distinction between implicit and explicit missing values more concrete, let's consider the following example (taken from [here](https://r4ds.had.co.nz/tidy-data.html#missing-values-3)): 


```r
df.stocks = tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
```

There are two missing values in this dataset:

- The return for the fourth quarter of 2015 is explicitly missing, because the cell where its value should be instead contains `NA`.
- The return for the first quarter of 2016 is implicitly missing, because it simply does not appear in the dataset.

We can use the `complete()` function to turn implicit missing values explicit: 


```r
df.stocks %>% 
  complete(year, qtr)
```

```
## # A tibble: 8 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4  NA   
## 5  2016     1  NA   
## 6  2016     2   0.92
## 7  2016     3   0.17
## 8  2016     4   2.66
```

Note how now, the data frame contains an additional row in which `year = 2016`, `qtr = 1` and `return = NA` even though we didn't originally specify this. 

We can also directly tell the `complete()` function to replace the `NA` values via passing a list to its `fill` argument like so: 


```r
df.stocks %>% 
  complete(year, qtr, fill = list(return = 0))
```

```
## # A tibble: 8 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4   0   
## 5  2016     1   0   
## 6  2016     2   0.92
## 7  2016     3   0.17
## 8  2016     4   2.66
```

This specifies that we would like to replace any `NA` in the `return` column with `0`. Again, if we had multiple columns with `NA`s, we could speficy for each column separately how to replace it. 

## Reading in data 

So far, we've used data sets that already came with the packages we've loaded. In the visualization chapters, we used the `diamonds` data set from the `ggplot2` package, and in the data wrangling chapters, we used the `starwars` data set from the `dplyr` package. 


\begin{tabular}{r|l|l}
\hline
file type & platform & description\\
\hline
`csv` & general & medium-size data frames\\
\hline
`RData` & R & saving the results of intensive computations\\
\hline
`xls` & excel & people who use excel\\
\hline
`json` & general & more complex data structures\\
\hline
`feather` & python \& R & fast interaction between R and python\\
\hline
\end{tabular}


The `foreign` [package](https://cran.r-project.org/web/packages/foreign/index.html) helps with importing data that was saved in SPSS, Stata, or Minitab. 

For data in a json format, I highly recommend the `tidyjson` [package](https://github.com/sailthru/tidyjson).  

### csv

I've stored some data files in the `data/` subfolder. Let's first read a csv (= **c**omma-**s**eparated-**v**alue) file. 


```r
df.csv = read_csv("data/movies.csv")
```

```
## Parsed with column specification:
## cols(
##   title = col_character(),
##   genre = col_character(),
##   director = col_character(),
##   year = col_double(),
##   duration = col_double(),
##   gross = col_double(),
##   budget = col_double(),
##   cast_facebook_likes = col_double(),
##   votes = col_double(),
##   reviews = col_double(),
##   rating = col_double()
## )
```

The `read_csv()` function gives us information about how each column was parsed. Here, we have some columns that are characters (such as `title` and `genre`), and some columns that are numeric (such as `year` and `duration`). Note that it says `double()` in the specification but double and numeric are identical.  

And let's take a quick peek at the data: 


```r
df.csv %>% glimpse()
```

```
## Observations: 2,961
## Variables: 11
## $ title               <chr> "Over the Hill to the Poorhouse", "The Bro...
## $ genre               <chr> "Crime", "Musical", "Comedy", "Comedy", "C...
## $ director            <chr> "Harry F. Millarde", "Harry Beaumont", "Ll...
## $ year                <dbl> 1920, 1929, 1933, 1935, 1936, 1937, 1939, ...
## $ duration            <dbl> 110, 100, 89, 81, 87, 83, 102, 226, 88, 14...
## $ gross               <dbl> 3000000, 2808000, 2300000, 3000000, 163245...
## $ budget              <dbl> 100000, 379000, 439000, 609000, 1500000, 2...
## $ cast_facebook_likes <dbl> 4, 109, 995, 824, 352, 229, 2509, 1862, 11...
## $ votes               <dbl> 5, 4546, 7921, 13269, 143086, 133348, 2918...
## $ reviews             <dbl> 2, 107, 162, 164, 331, 349, 746, 863, 252,...
## $ rating              <dbl> 4.8, 6.3, 7.7, 7.8, 8.6, 7.7, 8.1, 8.2, 7....
```

The data frame contains a bunch of movies with information about their genre, director, rating, etc. 

The `readr` package (which contains the `read_csv()` function) has a number of other functions for reading data. Just type `read_` in the console below and take a look at the suggestions that autocomplete offers. 

### RData 

RData is a data format native to R. Since this format can only be read by R, it's not a good format for sharing data. However, it's a useful format that allows us to flexibly save and load R objects. For example, consider that we always start our script by reading in and structuring data, and that this takes quite a while. One thing we can do is to save the output of intermediate steps as an RData object, and then simply load this object (instead of re-running the whole routine every time). 

We read (or load) an RData file in the following way:


```r
load("data/test.RData", verbose = TRUE)
```

```
## Loading objects:
##   df.test
```

I've set the `verbose = ` argument to `TRUE` here so that the `load()` function tells me what objects it added to the environment. This is useful for checking whether existing objects were overwritten. 

## Saving data 

### csv 

To save a data frame as a csv file, we simply write: 


```r
df.test = tibble(
  x = 1:3,
  y = c("test1", "test2", "test3")
)

write_csv(df.test, path = "data/test.csv")
```

Just like for reading in data, the `readr` package has a number of other functions for saving data. Just type `write_` in the console below and take a look at the autocomplete suggestions.

### RData 

To save objects as an RData file, we write: 


```r
save(df.test, file = "data/test.RData")
```

We can add multiple objects simply by adding them at the beginning, like so: 


```r
save(df.test, df.starwars, file = "data/test_starwars.RData")
```

## Additional resources 

### Cheatsheets 

- [wrangling data](figures/data-wrangling.pdf) --> wrangling data using `dplyr` and `tidyr`
- [importing & saving data](figures/data-import.pdf) --> importing and saving data with `readr`

### Data camp courses 

- [Joining tables](https://www.datacamp.com/courses/joining-data-in-r-with-dplyr)
- [writing functions](https://www.datacamp.com/courses/writing-functions-in-r)
- [importing data 1](https://www.datacamp.com/courses/importing-data-in-r-part-1)
- [importing data 2](https://www.datacamp.com/courses/importing-data-in-r-part-2)

### Books and chapters

- [Chapters 17-21 in R for Data Science](https://r4ds.had.co.nz/program-intro.html)
- [Exploratory data analysis](https://bookdown.org/rdpeng/exdata/)
- [R programming for data science](https://bookdown.org/rdpeng/rprogdatascience/)

### Tutorials 

- __Joining data__:
  - [Two-table verbs](https://dplyr.tidyverse.org/articles/two-table.html)
  - [Tutorial by Jenny Bryan](http://stat545.com/bit001_dplyr-cheatsheet.html)
- [tidyexplain](https://github.com/gadenbuie/tidyexplain): Animations that illustrate how `gather()`, `spread()`, `left_join()`, etc. work

<!--chapter:end:05-data_wrangling2.Rmd-->

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

<!--chapter:end:06-probability.Rmd-->

# Simulation 1 

## Load packages and set plotting theme  




```r
library("knitr")
library("kableExtra")
library("MASS")
library("patchwork")
library("extrafont")
library("tidyverse")
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Working with distributions 

Every distribution that R handles has four functions. There is a root name, for example, the root name for the normal distribution is `norm`. This root is prefixed by one of the letters here:

\begin{table}[H]
\centering
\begin{tabular}{l|l|l}
\hline
letter & description & example\\
\hline
`d` & for "\_\_density\_\_", the density function (probability function (for \_discrete\_ variables) or probability density function (for \_continuous\_ variables)) & `dnorm()`\\
\hline
`p` & for "\_\_probability\_\_", the cumulative distribution function & `pnorm()`\\
\hline
`q` & for "\_\_quantile\_\_", the inverse cumulative distribution function & `qnorm()`\\
\hline
`r` & for "\_\_random\_\_", a random variable having the specified distribution & `rnorm()`\\
\hline
\end{tabular}
\end{table}


For the normal distribution, these functions are `dnorm`, `pnorm`, `qnorm`, and `rnorm`. For the binomial distribution, these functions are `dbinom`, `pbinom`, `qbinom`, and `rbinom`. And so forth.

You can get more info about the distributions that come with R via running `help(Distributions)` in your console. If you need a distribution that doesn't already come with R, then take a look [here](https://cran.r-project.org/web/views/Distributions.html) for many more distributions that can be loaded with different R packages. 

### Plotting distributions 

Here's an easy way to plot distributions in `ggplot2` using the `stat_function()` function. 


```r
ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) +
  stat_function(fun = "dnorm")
```

![](07-simulation1_files/figure-latex/simulation1-05-1.pdf)<!-- --> 

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

![](07-simulation1_files/figure-latex/simulation1-06-1.pdf)<!-- --> 

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
```

![](07-simulation1_files/figure-latex/simulation1-07-1.pdf)<!-- --> 

```r
# remove all variables with tmp in their name 
rm(list = ls() %>% str_subset(pattern = "tmp."))
```

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
```

![](07-simulation1_files/figure-latex/simulation1-08-1.pdf)<!-- --> 

```r
# remove all variables with tmp in their name 
rm(list = ls() %>% str_subset(pattern = "tmp."))
```

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
```

![](07-simulation1_files/figure-latex/simulation1-09-1.pdf)<!-- --> 

```r
# remove all variables with tmp in their name 
rm(list = ls() %>% str_subset(pattern = "tmp."))
```

With 10,000 samples, our histogram of samples already closely resembles the theoretical shape of the normal distribution. 

### Cumulative probability distribution


```r
ggplot(data = tibble(x = c(-5, 5)),
       mapping = aes(x = x)) +
  stat_function(fun = "pnorm",
                args = list(mean = 0,
                            sd = 1))
```

![](07-simulation1_files/figure-latex/simulation1-10-1.pdf)<!-- --> 

Let's find the cumulative probability of a particular value. 


```r
tmp.x = 1
tmp.y = pnorm(tmp.x, mean = 0, sd = 1)

print(tmp.y %>% round(3))
```

```
## [1] 0.841
```

```r
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
```

![](07-simulation1_files/figure-latex/simulation1-11-1.pdf)<!-- --> 

```r
# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

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

![](07-simulation1_files/figure-latex/simulation1-12-1.pdf)<!-- --> 

### Inverse cumulative distribution 


```r
ggplot(data = tibble(x = c(0, 1)),
       mapping = aes(x = x)) +
  stat_function(fun = "qnorm",
                args = list(mean = 0,
                            sd = 1))
```

![](07-simulation1_files/figure-latex/simulation1-13-1.pdf)<!-- --> 

And let's compute the inverse cumulative probability for a particular value. 


```r
# tmp.x = 0.841
tmp.x = 0.975
tmp.y = qnorm(tmp.x, mean = 0, sd = 1)

print(tmp.y %>% round(3))
```

```
## [1] 1.96
```

```r
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
```

![](07-simulation1_files/figure-latex/simulation1-14-1.pdf)<!-- --> 

```r
# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

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
```

![](07-simulation1_files/figure-latex/simulation1-15-1.pdf)<!-- --> 

```r
# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

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
```

![](07-simulation1_files/figure-latex/simulation1-16-1.pdf)<!-- --> 

```r
# remove all variables with tmp in their name 
rm(list = str_subset(string = ls(), pattern = "tmp."))
```

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
## [1] 0.631886
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
## # A tibble: 10,000 x 3
##      kid sport      height
##    <int> <chr>       <dbl>
##  1     1 basketball   165.
##  2     2 basketball   163.
##  3     3 basketball   191.
##  4     4 chess        160.
##  5     5 basketball   183.
##  6     6 chess        164.
##  7     7 chess        169.
##  8     8 basketball   193.
##  9     9 basketball   172.
## 10    10 basketball   177.
## # ... with 9,990 more rows
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
## # A tibble: 1 x 1
##   prob_basketball
##             <dbl>
## 1           0.632
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

\begin{table}[H]
\centering
\begin{tabular}{r|r}
\hline
x & y\\
\hline
0.250 & 0.004\\
\hline
0.257 & 0.004\\
\hline
0.264 & 0.005\\
\hline
0.271 & 0.005\\
\hline
0.277 & 0.005\\
\hline
0.284 & 0.006\\
\hline
\end{tabular}
\end{table}

Now, let's plot the density. 


```r
ggplot(data = df.density, aes(x = x, y = y)) +
  geom_line(size = 2) +
  geom_point(data = as.tibble(observations),
             mapping = aes(x = value, y = 0),
             size = 3)
```

```
## Warning: `as.tibble()` is deprecated, use `as_tibble()` (but mind the new semantics).
## This warning is displayed once per session.
```

![](07-simulation1_files/figure-latex/simulation1-23-1.pdf)<!-- --> 

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

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r|r|r|r|r}
\hline
x & y & observation\_1 & observation\_2 & observation\_3 & observation\_4 & observation\_5 & sum\_norm\\
\hline
0.250 & 0.019 & 0.018 & 0.001 & 0 & 0 & 0 & 0.019\\
\hline
0.257 & 0.021 & 0.019 & 0.001 & 0 & 0 & 0 & 0.021\\
\hline
0.264 & 0.023 & 0.021 & 0.001 & 0 & 0 & 0 & 0.022\\
\hline
0.271 & 0.024 & 0.023 & 0.002 & 0 & 0 & 0 & 0.024\\
\hline
0.277 & 0.027 & 0.024 & 0.002 & 0 & 0 & 0 & 0.026\\
\hline
0.284 & 0.029 & 0.026 & 0.002 & 0 & 0 & 0 & 0.028\\
\hline
\end{tabular}
\end{table}

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

![](07-simulation1_files/figure-latex/simulation1-25-1.pdf)<!-- --> 

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

![](07-simulation1_files/figure-latex/simulation1-26-1.pdf)<!-- --> 

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

\begin{table}[H]
\centering
\begin{tabular}{r|r}
\hline
sample & value\\
\hline
1 & -0.63\\
\hline
2 & 0.18\\
\hline
3 & -0.84\\
\hline
4 & 1.60\\
\hline
5 & 0.33\\
\hline
6 & -0.82\\
\hline
7 & 0.49\\
\hline
8 & 0.74\\
\hline
9 & 0.58\\
\hline
10 & -0.31\\
\hline
\end{tabular}
\end{table}

Let's draw a boxplot using ggplot. 


```r
ggplot(data = df.quantile,
       mapping = aes(x = "", y = value)) +
  geom_boxplot()
```

![](07-simulation1_files/figure-latex/simulation1-28-1.pdf)<!-- --> 

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

![](07-simulation1_files/figure-latex/simulation1-30-1.pdf)<!-- --> 

Neat! Now we know how boxplots are made. 

We can also use the quantile function to create an inverse cumulative probability plot (i.e. the equivalent of what we get from `qnorm()` for the normal distribution). 


```r
df.plot = df.quantile$value %>% 
  quantile(probs = seq(0, 1, 0.01)) %>% 
  as_tibble() %>% 
  mutate(x = seq(0, n(), length.out = n()))
```

```
## Warning: Calling `as_tibble()` on a vector is discouraged, because the behavior is likely to change in the future. Use `enframe(name = NULL)` instead.
## This warning is displayed once per session.
```

```r
ggplot(data = df.plot,
       mapping = aes(x = x, y = value)) +
  geom_line()
```

![](07-simulation1_files/figure-latex/simulation1-31-1.pdf)<!-- --> 

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
```

```
## [1] -0.8848496 -0.2968686  0.2441649  0.8528150
```

```r
# using quantile
quantile(df.quantile$value, probs = seq(0.2, 0.8, 0.2))
```

```
##        20%        40%        60%        80% 
## -0.8815065 -0.2961539  0.2449833  0.8537340
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

![(\#fig:simulation1-34)Empirical distribution of residuals, and theoretical distribution.](07-simulation1_files/figure-latex/simulation1-34-1.pdf) 

Here, the empirical distribution of the errors and the theoretical normal distribution with a mean of 0 and a SD of 2 correspond very closely. Let's take a look at the corresponding QQ plot. 


```r
ggplot(data = df.residuals, aes(sample = residual)) +
  geom_abline(intercept = 0, slope = 1, linetype = 2) +
  geom_qq(distribution = "qnorm", dparams = params) +
  coord_cartesian(xlim = c(-40, 40), ylim = c(-40, 40))
```

![](07-simulation1_files/figure-latex/simulation1-35-1.pdf)<!-- --> 

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
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
```

![](07-simulation1_files/figure-latex/simulation1-38-1.pdf)<!-- --> 

```r
# ggsave("figures/qqplots_normal.pdf", width = 10, height = 6)
```

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
```

![](07-simulation1_files/figure-latex/simulation1-39-1.pdf)<!-- --> 

```r
ggsave("figures/qqplots_beta.pdf", width = 10, height = 6)
```

\begin{figure}
\includegraphics[width=0.9\linewidth]{figures/qqplots} \caption{QQ plots indicating different deviations from normality.}(\#fig:simulation1-40)
\end{figure}

## Additional resources 

### Cheatsheets 

- [Probability cheatsheet](figures/probability.pdf)

### Datacamp 

- [Foundations of probability in R](https://www.datacamp.com/courses/foundations-of-probability-in-r)

<!--chapter:end:07-simulation1.Rmd-->

# Simulation 2 

In which we figure out some key statistical concepts through simulation and plotting. On the menu we have: 

- Central limit theorem 
- Sampling distributions 
- p-value
- Confidence interval

## Load packages and set plotting theme  




```r
library("knitr")      # for knitting RMarkdown 
library("NHANES")     # data set 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## The central limit theorem 

> The Central Limit Theorem (CLT) states that the sample mean of a sufficiently large number of independent and identically distributed (i.i.d.) random variables is approximately normally distributed. The larger the sample, the better the approximation.  The theorem is a key ("central") concept in probability theory because it implies that statistical methods that work for normal distributions can be applicable to many problems involving other types of distributions.

Here are some nice interactive illustrations of the CLT: 

- [seeing-theory.brown.edu](https://seeing-theory.brown.edu/probability-distributions/index.html#section3)
- [http://mfviz.com/central-limit/](http://mfviz.com/central-limit/)

### Population distribution 

Let's first put the information we need for our population distribution in a data frame. 


```r
# the distribution from which we want to sample (aka the heavy metal distribution)
df.population = tibble(
  numbers = 1:6,
  probability = c(1/3, 0, 1/6, 1/6, 0, 1/3)
)
```

And then let's plot it: 


```r
# plot the distribution 
ggplot(data = df.population,
       mapping = aes(x = numbers,
                     y = probability)) +
  geom_bar(stat = "identity",
           fill = "lightblue",
           color = "black") +
  scale_x_continuous(breaks = df.population$numbers,
                     labels = df.population$numbers,
                     limits = c(0.1, 6.9)) +
  coord_cartesian(expand = F)
```

![](08-simulation2_files/figure-latex/simulation2-05-1.pdf)<!-- --> 

Here are the true mean and standard deviation of our population distribution: 


```r
# mean and standard deviation (see: https://nzmaths.co.nz/category/glossary/standard-deviation-discrete-random-variable)

df.population %>% 
  summarize(population_mean = sum(numbers * probability),
            population_sd = sqrt(sum(numbers^2 * probability) - population_mean^2)) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r}
\hline
population\_mean & population\_sd\\
\hline
3.5 & 2.06\\
\hline
\end{tabular}
\end{table}

### Distribution of a single sample 

Let's draw a single sample of size $n = 40$ from the population distribution and plot it: 


```r
# make example reproducible 
set.seed(1)

# set the sample size
sample_size = 40 

# create data frame 
df.sample = sample(df.population$numbers, 
         size = sample_size, 
         replace = T,
         prob = df.population$probability) %>% 
  enframe(name = "draw", value = "number")

# draw a plot of the sample
ggplot(data = df.sample,
       mapping = aes(x = number, y = stat(density))) + 
  geom_histogram(binwidth = 0.5, 
                 fill = "lightblue",
                 color = "black") +
  scale_x_continuous(breaks = min(df.sample$number):max(df.sample$number)) + 
  scale_y_continuous(expand = expand_scale(mult = c(0, 0.01)))
```

![](08-simulation2_files/figure-latex/simulation2-07-1.pdf)<!-- --> 

Here are the sample mean and standard deviation:


```r
# print out sample mean and standard deviation 
df.sample %>% 
  summarize(sample_mean = mean(number),
            sample_sd = sd(number)) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r}
\hline
sample\_mean & sample\_sd\\
\hline
3.73 & 2.05\\
\hline
\end{tabular}
\end{table}

### The sampling distribution

And let's now create the sampling distribution (making the unrealistic assumption that we know the population distribution). 


```r
# make example reproducible 
set.seed(1)

# parameters 
sample_size = 40 # size of each sample
sample_n = 10000 # number of samples 

# define a function that draws samples from a discrete distribution
fun.draw_sample = function(sample_size, distribution){
  x = sample(distribution$numbers,
       size = sample_size,
       replace = T,
       prob = distribution$probability)
  return(x)
}

# generate many samples 
samples = replicate(n = sample_n,
                    fun.draw_sample(sample_size, df.population))

# set up a data frame with samples 
df.sampling_distribution = matrix(samples, ncol = sample_n) %>%
  as_tibble() %>%
  set_names(str_c(1:ncol(.))) %>%
  gather("sample", "number") %>% 
  mutate(sample = as.numeric(sample)) %>% 
  group_by(sample) %>% 
  mutate(draw = 1:n()) %>% 
  select(sample, draw, number) %>% 
  ungroup()
```

```
## Warning: `as_tibble.matrix()` requires a matrix with column names or a `.name_repair` argument. Using compatibility `.name_repair`.
## This warning is displayed once per session.
```

```r
# turn the data frame into long format and calculate the means of each sample
df.sampling_distribution_means = df.sampling_distribution %>% 
  group_by(sample) %>% 
  summarize(mean = mean(number)) %>% 
  ungroup()
```

And plot it: 


```r
# plot a histogram of the means with density overlaid 
ggplot(data = df.sampling_distribution_means %>% 
         sample_frac(size = 1, replace = T),
       mapping = aes(x = mean)) + 
  geom_histogram(aes(y = stat(density)),
                 binwidth = 0.05, 
                 fill = "lightblue",
                 color = "black") +
  stat_density(bw = 0.1,
               size = 2,
               geom = "line"
               ) + 
  scale_y_continuous(expand = expand_scale(mult = c(0, 0.01)))
```

![](08-simulation2_files/figure-latex/simulation2-10-1.pdf)<!-- --> 

That's the central limit theorem in action! Even though our population distribution was far from normal (and much more heavy-metal like), the means of that distribution are normally distributed. 

And here are the mean and standard deviation of the sampling distribution: 


```r
# print out sampling distribution mean and standard deviation 
df.sampling_distribution_means %>% 
  summarize(sampling_distribution_mean = mean(mean),
            sampling_distribution_sd = sd(mean)) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r}
\hline
sampling\_distribution\_mean & sampling\_distribution\_sd\\
\hline
3.5 & 0.33\\
\hline
\end{tabular}
\end{table}

Here is a data frame that I've used for illustrating the idea behind how a sampling distribution is constructed from the population distribution. 


```r
# data frame for illustration in class 
df.sampling_distribution %>% 
  filter(sample <= 10, draw <= 4) %>% 
  spread(draw, number) %>% 
  set_names(c("sample", str_c("draw_", 1:(ncol(.)-1)))) %>% 
  mutate(sample_mean = rowMeans(.[, -1])) %>% 
    head(10) %>% 
    kable(digits = 2) %>% 
    kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r|r|r}
\hline
sample & draw\_1 & draw\_2 & draw\_3 & draw\_4 & sample\_mean\\
\hline
1 & 1 & 6 & 6 & 4 & 4.25\\
\hline
2 & 3 & 6 & 3 & 6 & 4.50\\
\hline
3 & 6 & 3 & 6 & 1 & 4.00\\
\hline
4 & 4 & 6 & 6 & 1 & 4.25\\
\hline
5 & 1 & 4 & 6 & 3 & 3.50\\
\hline
6 & 1 & 1 & 6 & 1 & 2.25\\
\hline
7 & 1 & 6 & 4 & 1 & 3.00\\
\hline
8 & 1 & 6 & 4 & 6 & 4.25\\
\hline
9 & 6 & 1 & 6 & 4 & 4.25\\
\hline
10 & 1 & 1 & 4 & 1 & 1.75\\
\hline
\end{tabular}
\end{table}

#### Bootstrapping a sampling distribution

Of course, in actuality, we never have access to the population distribution. We try to infer characteristics of that distribution (e.g. its mean) from our sample. So using the population distribution to create a sampling distribution is sort of cheating -- helpful cheating though since it gives us a sense for the relationship between population, sample, and sampling distribution. 

It urns out that we can approximate the sampling distribution only using our actual sample. The idea is to take the sample that we drew, and generate new samples from it by drawing with replacement. Essentially, we are treating our original sample like the population from which we are generating random samples to derive the sampling distribution. 


```r
# make example reproducible 
set.seed(1)

# how many bootstrapped samples shall we draw? 
n_samples = 1000

# generate a new sample from the original one by sampling with replacement
func.bootstrap = function(df){
  df %>% 
    sample_frac(size = 1, replace = T) %>% 
    summarize(mean = mean(number)) %>% 
    pull(mean)
}

# data frame with bootstrapped results 
df.bootstrap = tibble(
  bootstrap = 1:n_samples, 
  average = replicate(n = n_samples, func.bootstrap(df.sample))
)
```

Let's plot the bootstrapped sampling distribution: 


```r
# plot the bootstrapped sampling distribution
ggplot(data = df.bootstrap, aes(x = average)) +
  geom_histogram(aes(y = stat(density)),
                 color = "black",
                 fill = "lightblue",
                 binwidth = 0.05) + 
  stat_density(geom = "line",
               size = 1.5,
               bw = 0.1) +
  labs(x = "mean") +
  scale_y_continuous(expand = expand_scale(mult = c(0, 0.01)))
```

![](08-simulation2_files/figure-latex/simulation2-14-1.pdf)<!-- --> 

And let's calculate the mean and standard deviation: 


```r
# print out sampling distribution mean and standard deviation 
df.sampling_distribution_means %>% 
  summarize(bootstrapped_distribution_mean = mean(mean),
            bootstrapped_distribution_sd = sd(mean)) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r}
\hline
bootstrapped\_distribution\_mean & bootstrapped\_distribution\_sd\\
\hline
3.5 & 0.33\\
\hline
\end{tabular}
\end{table}

Neat, as we can see, the mean and standard deviation of the bootstrapped sampling distribution are very close to the sampling distribution that we generated from the population distribution. 

### Exploring the CLT 

#### Distribution of height 

In order for the CLT to apply, the following have to hold (approximately): 

- sufficiently large number of variables that affect the outcome 
- the variables are idependent and identically distributed 
- the variables contribute additively, and none of the variables affects the outcome much more strongly than the rest 

Let's take a look at a situation where the CLT breaks down. We use survey data collected by the US National Center for Health Statistics (NCHS). The data is from 2009-2012. You can get more information about the NHANES data set by running `help(NHANES)`. 

Let's load the data set into our environment first.


```r
df.nhanes = NHANES %>% 
  clean_names() %>% 
  distinct(id, .keep_all = T) #drop duplicates
```

Let's now plot a density of the distribution of womens' height 


```r
df.plot = df.nhanes %>% 
  drop_na(height) %>% # remove missing values
  filter(
    age >= 18, # only look at adults 
    gender == "female"
    ) 
  
ggplot(data = df.plot, 
       mapping = aes(x = height)) +
  geom_density(size = 1,
               fill = "red",
               alpha = 0.5,
               kernel = "gaussian",
               bw = 2) +
  stat_function(fun = "dnorm",
                color = "red",
                args = list(mean = mean(df.plot$height),
                            sd = sd(df.plot$height)),
                size = 2) +
  labs(title = "Women's height") +
  coord_cartesian(expand = F, clip = "off")
```

![](08-simulation2_files/figure-latex/simulation2-17-1.pdf)<!-- --> 

Women's height in the `NHANES` data set is approximately normally distributed. 


```r
df.plot = df.nhanes %>% 
  drop_na(height) %>% # remove missing values
  filter(
    age >= 18, # only look at adults 
    gender == "male"
    ) 
  
ggplot(data = df.plot, 
       mapping = aes(x = height)) +
  geom_density(size = 1,
               fill = "blue",
               alpha = 0.5,
               kernel = "gaussian",
               bw = 2) +
  stat_function(fun = "dnorm",
                color = "blue",
                args = list(mean = mean(df.plot$height),
                            sd = sd(df.plot$height)),
                size = 2) +
  labs(title = "Men's height") +
  coord_cartesian(expand = F, clip = "off")
```

![](08-simulation2_files/figure-latex/simulation2-18-1.pdf)<!-- --> 

The same is true for men's height.


```r
df.plot = df.nhanes %>% 
  drop_na(height) %>% # remove missing values
  filter(
    age >= 18 # only look at adults
    ) 

ggplot(data = df.plot, 
       mapping = aes(x = height))+
  geom_density(size = 1,
               fill = "gray50",
               alpha = 0.5,
               kernel = "gaussian",
               bw = 2)+
  stat_function(fun = "dnorm",
                color = "black",
                args = list(mean = mean(df.plot$height),
                            sd = sd(df.plot$height)),
                size = 2)+
  labs(title = "Adults' height") +
  coord_cartesian(expand = F, clip = "off")
```

![](08-simulation2_files/figure-latex/simulation2-19-1.pdf)<!-- --> 

However, adults' height is not quite normally distributed. Note that the distribution is too flat in the middle.  


```r
df.plot = df.nhanes %>% 
  drop_na(height) %>% # remove missing values
  filter(
    age >= 18
    )

ggplot(data = df.plot, aes(x = height, group = gender, fill = gender))+
  geom_density(size = 1, 
               alpha = 0.5,
               kernel = "gaussian",
               bw = 2)+
  stat_function(fun = "dnorm", color = "blue", 
                args = df.plot %>% 
                  filter(gender == "male") %>% 
                  summarise(mean = mean(height),
                            sd = sd(height)) %>% 
                  as.list(),
                size = 2)+
  stat_function(fun = "dnorm", color = "red", 
                args = df.plot %>% 
                  filter(gender == "female") %>% 
                  summarise(mean = mean(height),
                            sd = sd(height)) %>% 
                  as.list(),
                size = 2)+
  labs(title = "Adults' height (separated by gender)")+
  theme(legend.position = c(0.9, 0.8))
```

![](08-simulation2_files/figure-latex/simulation2-20-1.pdf)<!-- --> 

The fact that adults' height overall is not normally distributed is because there is a single factor (gender) that accounts for much of the variation. 

#### Testing the limits 

How do sample size and the number of samples affect what the sampling distribution looks like? Here are some simulations. Feel free to play around with: 

- the population distributions to sample from
- the sample size for each sample 
- the number of samples


```r
ggplot(data = tibble(x = c(0, 20)), aes(x = x)) +
  stat_function(fun = "dnorm",
                args = list(mean = 10,
                            sd = 5),
                size = 1,
                color = "red") +
  stat_function(fun = "dunif",
                args = list(min = 0,
                            max = 20),
                size = 1,
                color = "green") +
  stat_function(fun = "dexp",
                args = list(rate = 0.1),
                size = 1,
                color = "blue") +
  annotate(geom = "text",
           label = "normal",
           x = 0,
           y = .03,
           hjust = 0,
           color = "red",
           size = 6) +
  annotate(geom = "text",
           label = "uniform",
           x = 0,
           y = .055,
           hjust = 0,
           color = "green",
           size = 6) +
  annotate(geom = "text",
           label = "exponential",
           x = 0,
           y = .105,
           hjust = 0,
           color = "blue",
           size = 6)
```

![](08-simulation2_files/figure-latex/simulation2-21-1.pdf)<!-- --> 



```r
# Parameters for the simulation
n_samples = c(10, 100, 1000, 10000)
sample_size = c(5, 10, 25, 100)
distributions = c("normal", "uniform", "exponential")

# take samples (of size n) from specified distribution and calculate the mean 
fun.sample_mean = function(n, distribution){
  if (distribution == "normal"){
    tmp = rnorm(n, mean = 10, sd = 5)
  }else if (distribution == "uniform"){
    tmp = runif(n, min = 0, max = 20) 
  }else if (distribution == "exponential"){
    tmp = rexp(n, rate = 0.1)
  }
  return(mean(tmp)) 
}

df.central_limit = tibble()

for (i in 1:length(n_samples)){
  for (j in 1:length(sample_size)){
    for (k in 1:length(distributions)){
      # calculate sample mean 
      sample_mean = replicate(n_samples[i], 
                              fun.sample_mean(sample_size[j],
                                              distributions[k]))
      df.tmp = tibble(n_samples = n_samples[i], 
                       sample_size = sample_size[j],
                       distribution = distributions[k],
                       mean_value = list(sample_mean))
      df.central_limit = rbind(df.central_limit, df.tmp)
    }
  }
}

# transform from list column
df.plot = df.central_limit %>% 
  unnest() %>% 
  mutate(sample_size = str_c("sample size = ", sample_size),
         sample_size = factor(sample_size,
                              levels = str_c("sample size = ", c(5, 10, 25, 100))),
         n_samples = str_c("n samples = ", n_samples),
         distribution = factor(distribution,
                               levels = c("normal", "uniform", "exponential"))
         )
  
# densities of sample means 
ggplot(df.plot, aes(x = mean_value, color = distribution))+
  stat_density(geom = "line", position = "identity")+
  facet_grid(n_samples ~ sample_size, scales = "free")+
  scale_x_continuous(breaks = c(0, 10, 20))+
  coord_cartesian(xlim = c(0, 20))+
  labs(x = "sample mean")+
  theme(
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    strip.text.y = element_text(size = 6),
    strip.text.x = element_text(size = 8),
    legend.position = "bottom",
    panel.background = element_rect(color = "black")
    )
```

![](08-simulation2_files/figure-latex/simulation2-22-1.pdf)<!-- --> 

No matter where we start, as long as we draw samples that are independent and identically distributed, and these samples combine in an additive way, we end up with a normal distribution (note that this takes considerably longer when we start with an exponential distribution -- shown in blue -- compared to the other population distributions).

## Understanding p-values 

> The p-value is the probability of finding the observed, or more extreme, results when the null hypothesis ($H_0$) is true.

$$
\text{p-value = p(observed or more extreme sample statistic} | H_{0}=\text{true})
$$
What we are really interested in is the probability of a hypothesis given the data. However, frequentist statistics doesn't give us this probability -- we'll get to Bayesian statistics later in the course. 

Instead, we define a null hypothesis, construct a sampling distribution that tells us what we would expect the test statistic of interest to look like if the null hypothesis were true. We reject the null hypothesis in case our observed data would be unlikely if the null hypothesis were true. 

An intutive way for illustrating (this rather unintuitive procedure) is the permutation test. 

### Permutation test 

Let's start by generating some random data from two different normal distributions (simulating a possible experiment). 


```r
# make example reproducible 
set.seed(1)

# generate data from two conditions 
df.permutation = tibble(
  control = rnorm(25, mean = 5.5, sd = 2),
  experimental = rnorm(25, mean = 4.5, sd = 1.5)
) %>% 
  gather("condition", "performance")
```

Here is a summary of how each group performed: 


```r
df.permutation %>% 
  group_by(condition) %>%
  summarize(mean = mean(performance),
            sd = sd(performance)) %>%
  gather("statistic", "value", - condition) %>%
  spread(condition, value) %>%
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{l|r|r}
\hline
statistic & control & experimental\\
\hline
mean & 5.84 & 4.55\\
\hline
sd & 1.90 & 1.06\\
\hline
\end{tabular}
\end{table}

Let's plot the results: 


```r
ggplot(data = df.permutation, 
       mapping = aes(x = condition, y = performance)) +
  geom_point(position = position_jitter(height = 0, width = 0.1),
             alpha = 0.5) + 
  stat_summary(fun.data = mean_cl_boot, 
               geom = "linerange", 
               size = 1) +
  stat_summary(fun.y = "mean", 
               geom = "point", 
               shape = 21, 
               color = "black", 
               fill = "white", 
               size = 4) +
  scale_y_continuous(breaks = 0:10,
                     labels = 0:10,
                     limits = c(0, 10))
```

![](08-simulation2_files/figure-latex/simulation2-25-1.pdf)<!-- --> 

We are interested in the difference in the mean performance between the two groups: 


```r
# calculate the difference between conditions
difference_actual = df.permutation %>% 
  group_by(condition) %>% 
  summarize(mean = mean(performance)) %>% 
  pull(mean) %>% 
  diff()
```

The difference in the mean rating between the control and experimental condition is -1.2889834. Is this difference between conditions statistically significant? What we are asking is: what are the chances that a result like this (or more extreme) could have come about due to chance? 

Let's answer the question using simulation. Here is the main idea: imagine that we were very sloppy in how we recorded the data, and now we don't remember anymore which participants were in the controld condition and which ones were in experimental condition (we still remember though, that we tested 25 participants in each condition). 


```r
set.seed(0)
df.permutation = df.permutation %>% 
  mutate(permutation = sample(condition)) #randomly assign labels

df.permutation %>% 
  group_by(permutation) %>% 
  summarize(mean = mean(performance),
            sd = sd(performance)) %>% 
  ungroup() %>% 
  summarize(diff = diff(mean))
```

```
## # A tibble: 1 x 1
##      diff
##     <dbl>
## 1 -0.0223
```

Here, the difference between the two conditions is 0.0223078224988722.

After randomly shuffling the condition labels, this is how the results would look like: 


```r
ggplot(data = df.permutation, aes(x = permutation, y = performance))+
  geom_point(aes(color = condition), position = position_jitter(height = 0, width = 0.1)) +
  stat_summary(fun.data = mean_cl_boot, geom = 'linerange', size = 1) +
  stat_summary(fun.y = "mean", geom = 'point', shape = 21, color = "black", fill = "white", size = 4) + 
  scale_y_continuous(breaks = 0:10,
                     labels = 0:10,
                     limits = c(0, 10))
```

![](08-simulation2_files/figure-latex/simulation2-28-1.pdf)<!-- --> 

The idea is now that, similar to bootstrapping above, we can get a sampling distribution of the difference in the means between the two conditions (assuming that the null hypothesis were true), by randomly shuffling the labels and calculating the difference in means (and doing this many times). What we get is a distribution of the differences we would expect, if there was no effect of condition. 


```r
set.seed(1)

n_permutations = 500

# permutation function
func_permutations = function(df){
  df %>%
    mutate(condition = sample(condition)) %>% #we randomly shuffle the condition labels
    group_by(condition) %>%
    summarize(mean = mean(performance)) %>%
    pull(mean) %>%
    diff()
}

# data frame with permutation results 
df.permutations = tibble(
  permutation = 1:n_permutations, 
  mean_difference = replicate(n = n_permutations, func_permutations(df.permutation))
)

#plot the distribution of the differences 
ggplot(data = df.permutations, aes(x = mean_difference)) +
  geom_histogram(aes(y = stat(density)),
                 color = "black",
                 fill = "lightblue",
                 binwidth = 0.05) + 
  stat_density(geom = "line",
               size = 1.5,
               bw = 0.2) +
  geom_vline(xintercept = difference_actual, color = "red", size = 2) +
  labs(x = "difference between means") +
  scale_x_continuous(breaks = seq(-1.5, 1.5, 0.5),
                     labels = seq(-1.5, 1.5, 0.5),
                     limits = c(-2, 2)) +
  coord_cartesian(expand = F, clip = "off")
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

![](08-simulation2_files/figure-latex/simulation2-29-1.pdf)<!-- --> 

And we can then simply calculate the p-value by using some basic data wrangling (i.e. finding the proportion of differences that were as or more extreme than the one we observed).


```r
#calculate p-value of our observed result
df.permutations %>% 
  summarize(p_value = sum(mean_difference <= difference_actual)/n())
```

```
## # A tibble: 1 x 1
##   p_value
##     <dbl>
## 1   0.006
```


## Confidence intervals 

The definition of the confidence interval is the following: 

> “If we were to repeat the experiment over and over, then 95% of the time the confidence intervals contain the true mean.” 

If we assume normally distributed data (and a large enough sample size), then we can calculate the confidence interval on the estimate of the mean in the following way: $\overline X \pm Z \frac{s}{\sqrt{n}}$, where $Z$ equals the value of the standard normal distribution for the desired level of confidence. 

For smaller sample sizes, we can use the $t$-distribution instead with $n-1$ degrees of freedom. For larger $n$ the $t$-distribution closely approximates the normal distribution. 

So let's run a a simulation to check whether the definition of the confidence interval seems right. We will use our heavy metal distribution from above, take samples from the distribution, calculate the mean and confidende interval, and check how often the true mean of the population ($M = 3.5$) is contained within the confidence interval. 


```r
# make example reproducible 
set.seed(1)

# parameters 
sample_size = 25 # size of each sample
sample_n = 20 # number of samples 
confidence_level = 0.95 # desired level of confidence 

# define a function that draws samples and calculates means and CIs
fun.confidence = function(sample_size, distribution){
  df = tibble(
    values = sample(distribution$numbers,
                    size = sample_size,
                    replace = T,
                    prob = distribution$probability)) %>% 
    summarize(mean = mean(values),
              sd = sd(values),
              n = n(),
              # confidence interval assuming a normal distribution 
              # error = qnorm(1-(1-confidence_level)*2) * sd / sqrt(n),
              # assuming a t-distribution (more conservative, appropriate for smaller
              # sample sizes)
              error = qt(1-(1-confidence_level)/2, df = n-1) * sd / sqrt(n),
              conf_low = mean - error,
              conf_high = mean + error)
  return(df)
}

# build data frame of confidence intervals 
df.confidence = tibble()
for(i in 1:sample_n){
  df.tmp = fun.confidence(sample_size, df.population)
  df.confidence = df.confidence %>% 
    bind_rows(df.tmp)
}

# code which CIs contain the true value, and which ones don't 
population_mean = 3.5
df.confidence = df.confidence %>% 
  mutate(sample = 1:n(),
         conf_index = ifelse(conf_low > population_mean | conf_high < population_mean,
                             'outside',
                             'inside'))

# plot the result
ggplot(data = df.confidence, aes(x = sample, y = mean, color = conf_index))+
  geom_hline(yintercept = 3.5, color = "red")+
  geom_point()+
  geom_linerange(aes(ymin = conf_low, ymax = conf_high))+
  coord_flip()+
  scale_color_manual(values = c("black", "red"), labels = c("inside", "outside"))+
  theme(axis.text.y = element_text(size = 12),
        legend.position = "none")
```

![](08-simulation2_files/figure-latex/simulation2-31-1.pdf)<!-- --> 

So, out of the 20 samples that we drew the 95% confidence interval of 1 sample did not contain the true mean. That makes sense! 

Feel free to play around with the code above. For example, change the sample size, the number of samples, the confidence level.  

## Additional resources 

### Datacamp 

- [Foundations of Inference](https://www.datacamp.com/courses/foundations-of-inference)

<!--chapter:end:08-simulation2.Rmd-->

# Modeling data

## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("magrittr")   # for wrangling
library("patchwork")  # for making figure panels
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Things that came up in class 

### Calculating RMSE using `magrittr` verbs

Here is how we can calculate the root mean squared error using the pipe all the way through. Note that you have to load the `magrittr` package in order for this to work. 


```r
data = c(1, 3, 4, 2, 5)
prediction = c(1, 2, 2, 1, 4)

# calculate root mean squared error the pipe way 
rmse = prediction %>% 
  subtract(data) %>% 
  raise_to_power(2) %>% 
  mean() %>% 
  sqrt() %>% 
  print() 
```

```
## [1] 1.183216
```

### Relationship between probability and likelihood 


```r
margin = 1
point = 0

ggplot(data = tibble(x = c(-3, 3)),
            mapping = aes(x = x)) + 
  stat_function(fun = "dnorm",
                geom = "area", 
                xlim = c(point - margin, point + margin),
                fill = "red", 
                alpha = 0.5) + 
  stat_function(fun = "dnorm",
                size = 1) +
  labs(y = "density") +
  scale_x_continuous(breaks = -2:2,
                     expand = c(0, 0)) +
  scale_y_continuous(expand = expand_scale(add = c(0.001, 0.1)))
```

![(\#fig:modeling-04-likelihood1)Probability is the area under the curve of the density](09-modeling_data_files/figure-latex/modeling-04-likelihood1-1.pdf) 



```r
point = 0
param_mean = 1
param_sd = 1

ggplot(data = tibble(x = c(-3, 3)),
       mapping = aes(x = x)) + 
  stat_function(fun = "dnorm",
                size = 1,
                args = list(mean = param_mean,
                            sd = param_sd)) +
  geom_segment(aes(
    x = point,
    y = 0,
    xend = point,
    yend = dnorm(point, mean = param_mean, sd = param_sd)),
    color = "red",
    size = 1
  ) +
  geom_segment(aes(
    x = -3, 
    y = dnorm(point, mean = param_mean, sd = param_sd),
    xend = point,
    yend = dnorm(point, mean = param_mean, sd = param_sd)),
    color = "red",
    size = 1) +
  geom_point(x = point,
             y = dnorm(point, mean = param_mean, sd = param_sd),
             shape = 21,
             fill = "red",
             size = 4) +
  labs(y = "density") +
  scale_x_continuous(breaks = -2:2,
                     expand = c(0, 0)) +
  scale_y_continuous(expand = expand_scale(add = c(0.001, 0.1)))
```

![(\#fig:modeling-05-likelihood2)Likelihood is a particular value.](09-modeling_data_files/figure-latex/modeling-05-likelihood2-1.pdf) 


```r
point = 1

p1 = ggplot(data = tibble(x = c(-3, 3)),
            mapping = aes(x = x)) + 
  stat_function(fun = "dnorm",
                geom = "area", 
                xlim = c(-3, point),
                fill = "red", 
                alpha = 0.5) +
  stat_function(fun = "dnorm",
                size = 1) +
  geom_point(x = point,
             y = dnorm(point),
             shape = 21,
             fill = "red",
             size = 3) +
  labs(y = "density") +
  scale_x_continuous(breaks = -2:2,
                     expand = c(0, 0)) +
  scale_y_continuous(expand = expand_scale(add = c(0.001, 0.1)))

p2 = ggplot(data = tibble(x = c(-3, 3)),
            mapping = aes(x = x)) + 
  stat_function(fun = "pnorm",
                size = 1) + 
  geom_segment(mapping = aes(x = -3, 
                             y = pnorm(point),
                             xend = point,
                             yend = pnorm(point)),
               color = "red",
               size = 1) + 
  geom_point(x = point,
             y = pnorm(point),
             shape = 21,
             fill = "red",
             size = 3) +
  labs(y = "cum prob") +
  scale_x_continuous(breaks = -2:2,
                     expand = c(0, 0)) +
  scale_y_continuous(breaks = c(0, 0.5, 1),
                     expand = expand_scale(add = c(0.01, 0.1)))

p1 + p2 +
  plot_layout(ncol = 1)
```

![(\#fig:modeling-06-likelihood3)Relationship between density and cumulative probability distribution.](09-modeling_data_files/figure-latex/modeling-06-likelihood3-1.pdf) 


```r
point = 0

p1 = ggplot(data = tibble(x = c(-3, 3)),
            mapping = aes(x = x)) + 
  geom_segment(mapping = aes(x = -3, 
                             y = dnorm(point),
                             xend = point,
                             yend = dnorm(point)),
               color = "red",
               size = 1) + 
  stat_function(fun = "dnorm",
                size = 1) +
  geom_point(x = point,
             y = dnorm(point),
             shape = 21,
             fill = "red",
             size = 3) +
  labs(y = "density") +
  scale_x_continuous(breaks = -2:2,
                     expand = c(0, 0)) +
  scale_y_continuous(expand = expand_scale(add = c(0.001, 0.1)))

p2 = ggplot(data = tibble(x = c(-3, 3)),
            mapping = aes(x = x)) + 
  stat_function(fun = "pnorm",
                size = 1) + 
  geom_abline(slope = dnorm(point),
              intercept = pnorm(point) - dnorm(point) * point,
              color = "red",
              size = 1) +
  geom_point(x = point,
             y = pnorm(point),
             shape = 21,
             fill = "red",
             size = 3) +
  labs(y = "cum prob") +
  scale_x_continuous(breaks = -2:2,
                     expand = c(0, 0)) +
  scale_y_continuous(breaks = c(0, 0.5, 1),
                     expand = expand_scale(add = c(0.01, 0.1)))

p1 + p2 +
  plot_layout(ncol = 1)
```

![(\#fig:modeling-07-likelihood4)The density is the first derivative of the cumulative probability distribution. The likelihood is the value of the slope in the cumulative probability distribution.](09-modeling_data_files/figure-latex/modeling-07-likelihood4-1.pdf) 


```r
margin = 0.1
point_blue = -1
point_red = 0

ggplot(data = tibble(x = c(-3, 3)),
            mapping = aes(x = x)) + 
  stat_function(fun = "dnorm",
                geom = "area", 
                xlim = c(point_red - margin, point_red + margin),
                fill = "red", 
                alpha = 0.5) + 
  stat_function(fun = "dnorm",
                geom = "area", 
                xlim = c(point_blue - margin, point_blue + margin),
                fill = "blue", 
                alpha = 0.5) + 
  stat_function(fun = "dnorm",
                size = 1) +
  geom_segment(mapping = aes(x = -3, 
                             y = dnorm(point_red),
                             xend = point_red,
                             yend = dnorm(point_red)),
               color = "red",
               size = 1) +
  geom_segment(mapping = aes(x = -3, 
                             y = dnorm(point_blue),
                             xend = point_blue,
                             yend = dnorm(point_blue)),
               color = "blue",
               size = 1) + 
  geom_point(x = point_red,
             y = dnorm(point_red),
             shape = 21,
             fill = "red",
             size = 4) +
  geom_point(x = point_blue,
             y = dnorm(point_blue),
             shape = 21,
             fill = "blue",
             size = 4) +
  labs(y = "density") +
  scale_x_continuous(breaks = -2:2,
                     expand = c(0, 0)) +
  scale_y_continuous(expand = expand_scale(add = c(0.001, 0.1)))
```

![(\#fig:modeling-08-likelihood5)The relative likelihood of two observations is the same as the relative probability of two areas under the curve as the margin of these areas goes to 0.](09-modeling_data_files/figure-latex/modeling-08-likelihood5-1.pdf) 

```r
(pnorm(point_red + margin) - pnorm(point_red - margin)) / 
  (pnorm(point_blue + margin) - pnorm(point_blue - margin)) 
```

```
## [1] 1.64598
```

```r
dnorm(point_red) / dnorm(point_blue)
```

```
## [1] 1.648721
```

## Modeling data 

### Simplicity vs. accuracy trade-off 


```r
# make example reproducible 
set.seed(1)

n_samples = 20 # sample size 
n_parameters = 15 # number of parameters in the polynomial regression

# generate data 
df.data = tibble(
  x = runif(n_samples, min = 0, max = 10), 
  y = 10 + 3 * x + 3 * x^2 + rnorm(n_samples, sd = 20)
)
 
# plot a fit to the data
ggplot(data = df.data,
       mapping = aes(x = x,
                     y = y)) +
  geom_point(size = 3) +
  # geom_hline(yintercept = mean(df.data$y), color = "blue") +
  geom_smooth(method = "lm", se = F,
              formula = y ~ poly(x, degree = n_parameters, raw = TRUE)) +
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank())
```

![(\#fig:modeling-09)Tradeoff between fit and model simplicity.](09-modeling_data_files/figure-latex/modeling-09-1.pdf) 


```r
# make example reproducible 
set.seed(1)
# n_samples = 20
n_samples = 3

df.pre = tibble(
  x = runif(n_samples, min = 0, max = 10), 
  y = 2 * x + rnorm(n_samples, sd = 1)
)

# plot a fit to the data
ggplot(data = df.pre,
       mapping = aes(x = x,
                     y = y)) +
  geom_point(size = 3) +
  # geom_hline(yintercept = mean(df.pre$y), color = "blue") +
  geom_smooth(method = "lm", se = F,
              formula = y ~ poly(x, 1, raw=TRUE)) +
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank())
```

![(\#fig:modeling-10)Figure that I used to illustrate that fitting more data points with fewer parameter is more impressive.](09-modeling_data_files/figure-latex/modeling-10-1.pdf) 

### Error definitions and best estimators

Let's start with some simple data:


```r
df.data = tibble(
  observation = 1:5,
  value = c(1, 3, 5, 9, 14)
)
```

And plot the data


```r
ggplot(data = df.data,
       mapping = aes(x = "1",
                     y = value)) + 
  geom_point(size = 3) + 
  scale_y_continuous(breaks = seq(0, 16, 2),
                     limits = c(0, 16)) +
  theme(panel.grid.major.y = element_line(color = "gray80", linetype = 2),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        text = element_text(size = 24))
```

![](09-modeling_data_files/figure-latex/modeling-12-1.pdf)<!-- --> 

This is what the sum of absolute errors looks like for a given `value_predicted`. 


```r
value_predicted = 7

df.data = df.data %>% 
  mutate(prediction = value_predicted,
         error_absolute = abs(prediction - value))

ggplot(data = df.data,
       mapping = aes(x = observation, 
                     y = value)) + 
  geom_segment(mapping = aes(x = observation,
                             xend = observation,
                             y = value_predicted,
                             yend = value
                             ),
               color = "blue",
               size = 1) +
  geom_line(data = tibble(x = c(1, 5),
                   y = value_predicted),
            mapping = aes(x = x,
                y = y),
            size = 1,
            color = "green") +
  geom_point(size = 4) +
  annotate(x = 1,
           y = 15.5,
           geom = "text",
           label = str_c("Prediction = ", value_predicted),
           size = 8,
           hjust = 0,
           vjust = 1,
           color = "green") +
  annotate(x = 1,
           y = 13.5,
           geom = "text",
           label = str_c("Sum of absolute errors = ", sum(df.data$error_absolute)),
           size = 8,
           hjust = 0,
           vjust = 1,
           color = "blue") +
  annotate(x = 5,
           y = value_predicted,
           geom = "text",
           label = parse(text = str_c("{hat(Y)","==b[0]}==", value_predicted)),
           hjust = -0.1,
           size = 8) +
  scale_x_continuous(breaks = df.data$observation,
                     labels = parse(text = str_c('e[',df.data$observation,']', "==", df.data$error_absolute)),
                     limits = c(1, 6)) +
  scale_y_continuous(breaks = seq(0, 16, 2),
                     limits = c(0, 16)) +
  theme(panel.grid.major.y = element_line(color = "gray80", linetype = 2),
        axis.title.x = element_blank(),
        text = element_text(size = 24))
```

![(\#fig:modeling-13)Sum of absolute errors.](09-modeling_data_files/figure-latex/modeling-13-1.pdf) 

Play around with the code below to see how using (1) the sum of absolute errors, or (2) the sum of squared errors affects what estimate minimizes the error. 


```r
value_predicted = seq(0, 50, 0.1)
# value_predicted = seq(0, 10, 1)

df.data = tibble(
  observation = 1:5,
  value = c(1, 3, 5, 9, 140)
)

# function that calculates the sum absolute error
fun.sum_absolute_error = function(prediction){
  x = df.data$value
  sum_absolute_error = sum(abs(x-prediction))
  return(sum_absolute_error)
}

# function that calculates the sum squared error
fun.sum_squared_error = function(prediction){
  x = df.data$value
  sum_squared_error = sum((x-prediction)^2)
  return(sum_squared_error)
}

df.model = tibble(
  estimate = value_predicted,
  sum_absolute_error = map_dbl(value_predicted, fun.sum_absolute_error),
  sum_squared_error = map_dbl(value_predicted, fun.sum_squared_error)
)

ggplot(data = df.model,
       mapping = aes(x = estimate,
                     # y = sum_absolute_error)) +
                     y = sum_squared_error)) +
  geom_line(size = 1) +
  # labs(y = "Sum absolute error")
  labs(y = "Sum of squared errors")
```

![](09-modeling_data_files/figure-latex/modeling-14-1.pdf)<!-- --> 

\begin{table}[H]
\centering
\begin{tabular}{l|l}
\hline
Error definition & Best estimator\\
\hline
Count of errors & Mode = most frequent value\\
\hline
Sum of absolute errors & Median = middle observation of all values\\
\hline
Sum of squared errors & Mean = average of all values\\
\hline
\end{tabular}
\end{table}


```r
mu = 0 
sigma = 1

mean = mu
median = mu
mode = mu

ggplot(data = tibble(x = c(-3, 3)),
            mapping = aes(x = x)) + 
  stat_function(fun = "dnorm",
                size = 1) +
  geom_segment(aes(x = median,
                   xend = median,
                   y = dnorm(median),
                   yend = 0),
               color = "green",
               size = 2) +
  geom_segment(aes(x = mode,
                   xend = mode,
                   y = dnorm(mode),
                   yend = 0),
               color = "red",
               size = 2) +
  geom_segment(aes(x = mean,
                   xend = mean,
                   y = dnorm(mean),
                   yend = 0),
               color = "blue",
               size = 2) +
  labs(y = "density") +
  scale_x_continuous(breaks = -2:2,
                     expand = c(0, 0)) +
  scale_y_continuous(expand = expand_scale(add = c(0.001, 0.1)))
```

![(\#fig:modeling-16)Mean, median, and mode on the normal distribution.](09-modeling_data_files/figure-latex/modeling-16-1.pdf) 


```r
rate = 1 

mean = rate
median = rate * log(2)
mode = 0

ggplot(data = tibble(x = c(-0.1, 3)),
            mapping = aes(x = x)) + 
  stat_function(fun = "dexp",
                size = 1) +
  geom_segment(aes(x = median,
                   xend = median,
                   y = dexp(median),
                   yend = 0),
               color = "green",
               size = 2) +
  geom_segment(aes(x = mode,
                   xend = mode,
                   y = dexp(mode),
                   yend = 0),
               color = "red",
               size = 2) +
  geom_segment(aes(x = mean,
                   xend = mean,
                   y = dexp(mean),
                   yend = 0),
               color = "blue",
               size = 2) +
  labs(y = "density") +
  scale_x_continuous(breaks = 0:2,
                     expand = c(0, 0)) +
  scale_y_continuous(expand = expand_scale(add = c(0.001, 0.1)))
```

![(\#fig:modeling-17)Mean, median, and mode on the exponential distribution.](09-modeling_data_files/figure-latex/modeling-17-1.pdf) 

### Sampling distributions for median and mean 


```r
# make example reproducible 
set.seed(1)

sample_size = 40 # size of each sample
sample_n = 1000 # number of samples 

# draw sample
fun.draw_sample = function(sample_size, distribution){
  x = 50 + rnorm(sample_size)
  return(x)
}

# generate many samples 
samples = replicate(n = sample_n,
                    fun.draw_sample(sample_size, df.population))

# set up a data frame with samples 
df.sampling_distribution = matrix(samples, ncol = sample_n) %>%
  as_tibble(.name_repair = "minimal") %>%
  set_names(str_c(1:ncol(.))) %>%
  gather("sample", "number") %>% 
  mutate(sample = as.numeric(sample)) %>% 
  group_by(sample) %>% 
  mutate(draw = 1:n()) %>% 
  select(sample, draw, number) %>% 
  ungroup()

# turn the data frame into long format and calculate the means of each sample
df.sampling_distribution_means = df.sampling_distribution %>% 
  group_by(sample) %>% 
  summarize(mean = mean(number),
            median = median(number)) %>% 
  ungroup() %>% 
  gather("index", "value", -sample)
```

And plot it: 


```r
# plot a histogram of the means with density overlaid 

ggplot(data = df.sampling_distribution_means,
       mapping = aes(x = value, color = index)) + 
  stat_density(bw = 0.1,
               size = 2,
               geom = "line") + 
  scale_y_continuous(expand = expand_scale(mult = c(0, 0.01)))
```

![](09-modeling_data_files/figure-latex/modeling-19-1.pdf)<!-- --> 

## Hypothesis testing: "One-sample t-test" 


```r
df.internet = read_table2(file = "data/internet_access.txt") %>% 
  clean_names()
```

```
## Parsed with column specification:
## cols(
##   State = col_character(),
##   Internet = col_double(),
##   College = col_double(),
##   Auto = col_double(),
##   Density = col_double()
## )
```


```r
df.internet %>% 
  mutate(i = 1:n()) %>% 
  select(i, internet, everything()) %>% 
  head(10) %>% 
  kable(digits = 1) %>% 
  kable_styling(bootstrap_options = "striped",
              full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|l|r|r|r}
\hline
i & internet & state & college & auto & density\\
\hline
1 & 79.0 & AK & 28.0 & 1.2 & 1.2\\
\hline
2 & 63.5 & AL & 23.5 & 1.3 & 94.4\\
\hline
3 & 60.9 & AR & 20.6 & 1.7 & 56.0\\
\hline
4 & 73.9 & AZ & 27.4 & 1.3 & 56.3\\
\hline
5 & 77.9 & CA & 31.0 & 0.8 & 239.1\\
\hline
6 & 79.4 & CO & 37.8 & 1.0 & 48.5\\
\hline
7 & 77.5 & CT & 37.2 & 1.0 & 738.1\\
\hline
8 & 74.5 & DE & 29.8 & 1.1 & 460.8\\
\hline
9 & 74.3 & FL & 27.2 & 1.2 & 350.6\\
\hline
10 & 72.2 & GA & 28.3 & 1.1 & 168.4\\
\hline
\end{tabular}
\end{table}



```r
# parameters per model 
pa = 1
pc = 0 

df.model = df.internet %>%
  select(internet, state) %>%
  mutate(i = 1:n(),
         compact_b = 75,
         augmented_b = mean(internet),
         compact_se = (internet - compact_b)^2,
         augmented_se = (internet - augmented_b)^2) %>%
  select(i, state, internet, contains("compact"), contains("augmented"))

df.model %>%
  summarize(augmented_sse = sum(augmented_se),
            compact_sse = sum(compact_se),
            pre = 1 - augmented_sse / compact_sse,
            f = (pre / (pa - pc)) / ((1 - pre) / (nrow(df.model) - pa)),
            p_value = 1 - pf(f, pa - pc, nrow(df.model) - 1),
            mean = mean(internet),
            sd = sd(internet)) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r|r|r|r}
\hline
augmented\_sse & compact\_sse & pre & f & p\_value & mean & sd\\
\hline
1355.028 & 1595.71 & 0.1508305 & 8.703441 & 0.0048592 & 72.806 & 5.258673\\
\hline
\end{tabular}
\end{table}



```r
df1 = 1
df2 = 49

ggplot(data = tibble(x = c(0, 10)),
       mapping = aes(x = x)) + 
  # stat_function(fun = "df",
  #               geom = "area",
  #               fill = "red",
  #               alpha = 0.5,
  #               args = list(df1 = df1,
  #                           df2 = df2),
  #               size = 1,
  #               xlim = c(qf(0.95, df1 = df1, df2 = df2), 10)
  #               ) + 
  stat_function(fun = "df",
                args = list(df1 = df1,
                            df2 = df2),
                size = 0.5) + 
  scale_y_continuous(expand = expand_scale(add = c(0.001, 0.1))) +
  labs(y = "density")
```

![(\#fig:modeling-23)The F distribution](09-modeling_data_files/figure-latex/modeling-23-1.pdf) 

We've implemented a one sample t-test (compare the p-value here to the one I computed above using PRE and the F statistic).


```r
t.test(df.internet$internet, mu = 75)
```

```
## 
## 	One Sample t-test
## 
## data:  df.internet$internet
## t = -2.9502, df = 49, p-value = 0.004859
## alternative hypothesis: true mean is not equal to 75
## 95 percent confidence interval:
##  71.3115 74.3005
## sample estimates:
## mean of x 
##    72.806
```

## Additional resources 

### Reading 

- Judd, C. M., McClelland, G. H., & Ryan, C. S. (2011). Data analysis: A model comparison approach. Routledge. --> Chapters 1--4

### Datacamp 

- [Foundations of Inference](https://www.datacamp.com/courses/foundations-of-inference)

<!--chapter:end:09-modeling_data.Rmd-->

# Linear model 1

## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")    # for tidying up linear models 
library("tidyverse")  # for wrangling, plotting, etc. 
```

## Things that came up in class 

### Building a sampling distribution of PRE 

Here is the general procedure for building a sampling distribution of the proportinal reduction of error (PRE). In this instance, I compare the following two models 

- Model C (compact): $Y_i = 75 + \epsilon_i$
- Model A (augmented): $Y_i = \overline Y + \epsilon_i$

whereby I assume that $\epsilon_i \sim \mathcal{N}(0, \sigma)$.

For this example, I assume that I know the population distribution. I first draw a sample from that distribution, and then calculate PRE. 


```r
# make example reproducible
set.seed(1)

# set the sample size 
sample_size = 50 

# draw sample from the population distribution (I've fixed sigma -- the standard deviation
# of the population distribution to be 5)
df.sample = tibble(
  observation = 1:sample_size,
  value = 75 + rnorm(sample_size, mean = 0, sd = 5)
)

# calculate SSE for each model, and then PRE based on that 
df.summary = df.sample %>% 
  mutate(compact = 75,
         augmented = mean(value)) %>% 
  summarize(sse_compact = sum((value - compact)^2),
            sse_augmented = sum((value - augmented)^2),
            pre = 1 - (sse_augmented/sse_compact))
```

To generate the sampling distribution, I assume that the null hypothesis is true, and then take a look at what values for PRE we could expect by chance for our given sample size. 


```r
# simulation parameters
n_samples = 1000
sample_size = 50 
mu = 75 # true mean of the distribution 
sigma = 5 # true standard deviation of the errors 

# function to draw samples from the population distribution 
fun.draw_sample = function(sample_size, sigma){
  sample = mu + rnorm(sample_size, mean = 0, sd = sigma)
  return(sample)
}

# draw samples
samples = n_samples %>% 
  replicate(fun.draw_sample(sample_size, sigma)) %>% 
  t() # transpose the resulting matrix (i.e. flip rows and columns)

# put samples in data frame and compute PRE 
df.samples = samples %>% 
  as_tibble(.name_repair = "unique") %>% 
  mutate(sample = 1:n()) %>% 
  gather("index", "value", -sample) %>% 
  mutate(compact = mu) %>% 
  group_by(sample) %>% 
  mutate(augmented = mean(value)) %>% 
  summarize(sse_compact = sum((value - compact)^2),
            sse_augmented = sum((value - augmented)^2),
            pre = 1 - sse_augmented/sse_compact)
            

# plot the sampling distribution for PRE 
ggplot(data = df.samples,
       mapping = aes(x = pre)) +
  stat_density(geom = "line")
```

![](10-linear_model1_files/figure-latex/linear-model1-03-1.pdf)<!-- --> 

```r
# calculate the p-value for our sample 
df.samples %>% 
  summarize(p_value = sum(pre >= df.summary$pre)/n())
```

```
## # A tibble: 1 x 1
##   p_value
##     <dbl>
## 1   0.394
```

Some code I wrote to show a subset of the samples. 


```r
samples %>% 
  as_tibble(.name_repair = "unique") %>% 
  mutate(sample = 1:n()) %>% 
  gather("index", "value", -sample) %>% 
  mutate(compact = mu) %>% 
  group_by(sample) %>% 
  mutate(augmented = mean(value)) %>% 
  ungroup() %>% 
  mutate(index = str_extract(index, pattern = "\\-*\\d+\\.*\\d*"),
         index = as.numeric(index)) %>% 
  filter(index < 6) %>% 
  arrange(sample, index) %>% 
    head(15) %>% 
    kable(digits = 2) %>% 
    kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r|r}
\hline
sample & index & value & compact & augmented\\
\hline
1 & 1 & 76.99 & 75 & 75.59\\
\hline
1 & 2 & 71.94 & 75 & 75.59\\
\hline
1 & 3 & 76.71 & 75 & 75.59\\
\hline
1 & 4 & 69.35 & 75 & 75.59\\
\hline
1 & 5 & 82.17 & 75 & 75.59\\
\hline
2 & 1 & 71.90 & 75 & 74.24\\
\hline
2 & 2 & 75.21 & 75 & 74.24\\
\hline
2 & 3 & 70.45 & 75 & 74.24\\
\hline
2 & 4 & 75.79 & 75 & 74.24\\
\hline
2 & 5 & 71.73 & 75 & 74.24\\
\hline
3 & 1 & 77.25 & 75 & 75.38\\
\hline
3 & 2 & 74.91 & 75 & 75.38\\
\hline
3 & 3 & 73.41 & 75 & 75.38\\
\hline
3 & 4 & 70.35 & 75 & 75.38\\
\hline
3 & 5 & 67.56 & 75 & 75.38\\
\hline
\end{tabular}
\end{table}

### Correlation 


```r
# make example reproducible 
set.seed(1)

n_samples = 20

# create correlated data
df.correlation = tibble(
  x = runif(n_samples, min = 0, max = 100),
  y = x + rnorm(n_samples, sd = 15)
)

# plot the data
ggplot(data = df.correlation,
       mapping = aes(x = x,
                     y = y)) + 
  geom_point(size = 2) +
  labs(x = "chocolate",
       y = "happiness")
```

![](10-linear_model1_files/figure-latex/linear-model1-05-1.pdf)<!-- --> 

#### Variance 

Variance is the average squared difference between each data point and the mean: 

- $Var(Y) = \frac{\sum_{i = 1}^n(Y_i - \overline Y)^2}{n-1}$


```r
# make example reproducible 
set.seed(1)

# generate random data
df.variance = tibble(
  x = 1:10,
  y = runif(10, min = 0, max = 1)
)

# plot the data
ggplot(data = df.variance,
       mapping = aes(x = x,
                     y = y)) + 
  geom_segment(aes(x = x,
                   xend = x,
                   y = y,
                   yend = mean(df.variance$y))) +
  geom_point(size = 3) +
  geom_hline(yintercept = mean(df.variance$y),
             color = "blue") +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank()
        )
```

![](10-linear_model1_files/figure-latex/linear-model1-06-1.pdf)<!-- --> 

#### Covariance 

Covariance is defined in the following way: 

- $Cov(X,Y) = \sum_{i=1}^n\frac{(X_i-\overline X)(Y_i-\overline Y)}{n-1}$


```r
# make example reproducible 
set.seed(1)

# generate random data
df.covariance = tibble(
  x = runif(20, min = 0, max = 1),
  y = x + rnorm(x, mean = 0.5, sd = 0.25)
)

# plot the data
ggplot(df.covariance,
       aes(x = x, y = y)) +
  geom_point(size = 3) +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())
```

![](10-linear_model1_files/figure-latex/linear-model1-07-1.pdf)<!-- --> 

Add lines for $\overline X$ and $\overline Y$ to the data:


```r
ggplot(df.covariance,
       aes(x = x, y = y)) +
  geom_hline(yintercept = mean(df.covariance$y),
             color = "red",
             size = 1) +
  geom_vline(xintercept = mean(df.covariance$x),
             color = "red",
             size = 1) +
  geom_point(size = 3) +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank())
```

![](10-linear_model1_files/figure-latex/linear-model1-08-1.pdf)<!-- --> 

Illustrate how covariance is computed by drawing the distance to $\overline X$ and $\overline Y$ for three data points:


```r
df.plot = df.covariance %>% 
  mutate(covariance = (x-mean(x)) *( y-mean(y))) %>% 
  arrange(abs(covariance)) %>% 
  mutate(color = NA)

mean_xy = c(mean(df.covariance$x), mean(df.covariance$y))

df.plot$color[1] = 1
df.plot$color[10] = 2
df.plot$color[19] = 3

ggplot(df.plot,
       aes(x = x, y = y, color = as.factor(color))) +
  geom_segment(data = df.plot %>% 
                 filter(color == 1),
               mapping = aes(x = x,
                   xend = mean_xy[1],
                   y = y,
                   yend = y),
               size = 1) + 
  geom_segment(data = df.plot %>% 
                 filter(color == 1),
               mapping = aes(x = x,
                   xend = x,
                   y = y,
                   yend = mean_xy[2]),
               size = 1) + 
  geom_segment(data = df.plot %>% 
                 filter(color == 2),
               mapping = aes(x = x,
                   xend = mean_xy[1],
                   y = y,
                   yend = y),
               size = 1) + 
  geom_segment(data = df.plot %>% 
                 filter(color == 2),
               mapping = aes(x = x,
                   xend = x,
                   y = y,
                   yend = mean_xy[2]),
               size = 1) + 
  geom_segment(data = df.plot %>% 
                 filter(color == 3),
               mapping = aes(x = x,
                   xend = mean_xy[1],
                   y = y,
                   yend = y),
               size = 1) + 
  geom_segment(data = df.plot %>% 
                 filter(color == 3),
               mapping = aes(x = x,
                   xend = x,
                   y = y,
                   yend = mean_xy[2]),
               size = 1) + 
  geom_hline(yintercept = mean_xy[2],
             color = "red",
             size = 1) +
  geom_vline(xintercept = mean_xy[1],
             color = "red",
             size = 1) +
  geom_point(size = 3) +
  theme(axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "none")
```

![](10-linear_model1_files/figure-latex/linear-model1-09-1.pdf)<!-- --> 

#### Spearman's rank order correlation

Spearman's $\rho$ captures the extent to which the relationship between two variables is monotonic.


```r
# create data frame with data points and ranks 
df.ranking = tibble(
  x = c(1.2, 2.5, 4.5),
  y = c(2.2, 1, 3.3),
  label = str_c("(", x, ", ", y, ")"),
  x_rank = dense_rank(x),
  y_rank = dense_rank(y),
  label_rank = str_c("(", x_rank, ", ", y_rank, ")")
)

# plot the data (and show their ranks)
ggplot(df.ranking,
       aes(x = x, y = y)) +
  geom_point(size = 3) +
  geom_text(aes(label = label),
            hjust = -0.2,
            vjust = 0,
            size = 6) +
  geom_text(aes(label = label_rank),
            hjust = -0.4,
            vjust = 2,
            size = 6,
            color = "red") +
  coord_cartesian(xlim = c(1, 6),
                  ylim = c(0, 4))
```

![](10-linear_model1_files/figure-latex/linear-model1-10-1.pdf)<!-- --> 

Show that Spearman's $\rho$ is equivalent to Pearson's $r$ applied to ranked data.


```r
# data set
df.spearman = df.correlation %>% 
  mutate(x_rank = dense_rank(x),
         y_rank = dense_rank(y))

# correlation
df.spearman %>% 
  summarize(r = cor(x, y, method = "pearson"),
            spearman = cor(x, y, method = "spearman"),
            r_ranks = cor(x_rank, y_rank))
```

```
## # A tibble: 1 x 3
##       r spearman r_ranks
##   <dbl>    <dbl>   <dbl>
## 1 0.851    0.836   0.836
```

```r
# plot
ggplot(df.spearman,
       aes(x = x_rank, y = y_rank)) +
  geom_point(size = 3) +
  scale_x_continuous(breaks = 1:20) +
  scale_y_continuous(breaks = 1:20) +
  theme(axis.text = element_text(size = 10))
```

![](10-linear_model1_files/figure-latex/linear-model1-11-1.pdf)<!-- --> 

```r
# show some of the data and ranks 
df.spearman %>% 
  head(10) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
              full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r}
\hline
x & y & x\_rank & y\_rank\\
\hline
26.55 & 49.23 & 5 & 10\\
\hline
37.21 & 43.06 & 6 & 7\\
\hline
57.29 & 47.97 & 10 & 8\\
\hline
90.82 & 57.60 & 18 & 11\\
\hline
20.17 & 37.04 & 3 & 6\\
\hline
89.84 & 89.16 & 17 & 19\\
\hline
94.47 & 94.22 & 19 & 20\\
\hline
66.08 & 80.24 & 12 & 16\\
\hline
62.91 & 75.23 & 11 & 14\\
\hline
6.18 & 15.09 & 1 & 2\\
\hline
\end{tabular}
\end{table}

Comparison between $r$ and $\rho$ for a given data set: 


```r
# data set
df.example = tibble(
  x = 1:10,
  y = c(-10, 2:9, 20)
) %>% 
  mutate(x_rank = dense_rank(x),
         y_rank = dense_rank(y))

# correlation
df.example %>% 
  summarize(r = cor(x, y, method = "pearson"),
            spearman = cor(x, y, method = "spearman"),
            r_ranks = cor(x_rank, y_rank))
```

```
## # A tibble: 1 x 3
##       r spearman r_ranks
##   <dbl>    <dbl>   <dbl>
## 1 0.878    1.000   1.000
```

```r
# plot
ggplot(df.example,
       # aes(x = x_rank, y = y_rank)) + # see the ranked data 
       aes(x = x, y = y)) + # see the original data
  geom_point(size = 3) +
  theme(axis.text = element_text(size = 10))
```

![](10-linear_model1_files/figure-latex/linear-model1-12-1.pdf)<!-- --> 

Another example


```r
# make example reproducible 
set.seed(1)

# data set
df.example2 = tibble(
  x = c(1, rnorm(8, mean = 5, sd = 1),  10),
  y = c(-10, rnorm(8, sd = 1), 20)
) %>% 
  mutate(x_rank = dense_rank(x),
         y_rank = dense_rank(y))

# correlation
df.example2 %>% 
  summarize(r = cor(x, y, method = "pearson"),
            spearman = cor(x, y, method = "spearman"),
            r_ranks = cor(x_rank, y_rank))
```

```
## # A tibble: 1 x 3
##       r spearman r_ranks
##   <dbl>    <dbl>   <dbl>
## 1 0.919    0.467   0.467
```

```r
# plot
ggplot(df.example2,
       # aes(x = x_rank, y = y_rank)) + # see the ranked data 
       aes(x = x, y = y)) + # see the original data
  geom_point(size = 3) +
  theme(axis.text = element_text(size = 10))
```

![](10-linear_model1_files/figure-latex/linear-model1-13-1.pdf)<!-- --> 

## Regression 


```r
# make example reproducible 
set.seed(1)

# set the sample size
n_samples = 10

# generate correlated data
df.regression = tibble(
  chocolate = runif(n_samples, min = 0, max = 100),
  happiness = chocolate * 0.5 + rnorm(n_samples, sd = 15)
)

# plot the data 
ggplot(data = df.regression,
       aes(x = chocolate,
           y = happiness)) +
  geom_point(size = 3)
```

![](10-linear_model1_files/figure-latex/linear-model1-14-1.pdf)<!-- --> 

### Define and fit the models

Define and fit the compact model (Model C): $Y_i = \beta_0 + \epsilon_i$


```r
# fit the compact model
lm.compact = lm(happiness ~ 1, data = df.regression)

# store the results of the model fit in a data frame
df.compact = tidy(lm.compact)

# plot the data with model prediction
ggplot(data = df.regression,
       aes(x = chocolate,
           y = happiness)) +
  geom_hline(yintercept = df.compact$estimate,
             color = "blue",
              size = 1) +
  geom_point(size = 3) 
```

![](10-linear_model1_files/figure-latex/linear-model1-15-1.pdf)<!-- --> 

Define and fit the augmented model (Model A): $Y_i = \beta_0 + \beta_1 X_{1i} + \epsilon_i$


```r
# fit the augmented model
lm.augmented = lm(happiness ~ chocolate, data = df.regression)

# store the results of the model fit in a data frame
df.augmented = tidy(lm.augmented)

# plot the data with model prediction
ggplot(data = df.regression,
       aes(x = chocolate,
           y = happiness)) +
  geom_abline(intercept = df.augmented$estimate[1],
              slope = df.augmented$estimate[2],
             color = "red",
              size = 1) +
  geom_point(size = 3) 
```

![](10-linear_model1_files/figure-latex/linear-model1-16-1.pdf)<!-- --> 

### Calculate the sum of squared errors of each model

Illustration of the residuals for the compact model:  


```r
# fit the model 
lm.compact = lm(happiness ~ 1, data = df.regression)

# store the model information
df.compact_summary = tidy(lm.compact)

# create a data frame that contains the residuals 
df.compact_model = augment(lm.compact) %>% 
  clean_names() %>% 
  left_join(df.regression)
```

```
## Joining, by = "happiness"
```

```r
# plot model prediction with residuals
ggplot(data = df.compact_model,
       aes(x = chocolate,
           y = happiness)) +
  geom_hline(yintercept = df.compact_summary$estimate,
             color = "blue",
              size = 1) +
  geom_segment(aes(xend = chocolate,
                   yend = df.compact_summary$estimate),
               color = "blue") + 
  geom_point(size = 3) 
```

![](10-linear_model1_files/figure-latex/linear-model1-17-1.pdf)<!-- --> 

```r
# calculate the sum of squared errors
df.compact_model %>% 
  summarize(SSE = sum(resid^2))
```

```
## # A tibble: 1 x 1
##     SSE
##   <dbl>
## 1 5215.
```

Illustration of the residuals for the augmented model:  


```r
# fit the model 
lm.augmented = lm(happiness ~ chocolate, data = df.regression)

# store the model information
df.augmented_summary = tidy(lm.augmented)

# create a data frame that contains the residuals 
df.augmented_model = augment(lm.augmented) %>% 
  clean_names() %>% 
  left_join(df.regression)
```

```
## Joining, by = c("happiness", "chocolate")
```

```r
# plot model prediction with residuals
ggplot(data = df.augmented_model,
       aes(x = chocolate,
           y = happiness)) +
  geom_abline(intercept = df.augmented_summary$estimate[1],
              slope = df.augmented_summary$estimate[2],
             color = "red",
              size = 1) +
  geom_segment(aes(xend = chocolate,
                   yend = fitted),
               color = "red") + 
  geom_point(size = 3) 
```

![](10-linear_model1_files/figure-latex/linear-model1-18-1.pdf)<!-- --> 

```r
# calculate the sum of squared errors
df.augmented_model %>% 
  summarize(SSE = sum(resid^2))
```

```
## # A tibble: 1 x 1
##     SSE
##   <dbl>
## 1 2397.
```

Calculate the F-test to determine whether PRE is significant. 


```r
pc = 1 # number of parameters in the compact model  
pa = 2 # number of parameters in the augmented model  
n = 10 # number of observations

# SSE of the compact model 
sse_compact = df.compact_model %>% 
  summarize(SSE = sum(resid^2))

# SSE of the augmented model
sse_augmented = df.augmented_model %>% 
  summarize(SSE = sum(resid^2))

# Proportional reduction of error 
pre = as.numeric(1 - (sse_augmented/sse_compact))

# F-statistic 
f = (pre/(pa-pc))/((1-pre)/(n-pa))

# p-value
p_value = 1-pf(f, df1 = pa-pc, df2 = n-pa)

print(p_value)
```

```
## [1] 0.01542156
```

F-distribution with a red line indicating the calculated F-statistic.


```r
ggplot(data = tibble(x = c(0, 10)),
       mapping = aes(x = x)) +
  stat_function(fun = "df",
                args = list(df1 = pa-pc,
                            df2 = n-pa),
                size = 1) +
  geom_vline(xintercept = f,
             color = "red",
             size = 1)
```

![](10-linear_model1_files/figure-latex/linear-model1-20-1.pdf)<!-- --> 

The short version of doing what we did above :) 


```r
anova(lm.compact, lm.augmented)
```

```
## Analysis of Variance Table
## 
## Model 1: happiness ~ 1
## Model 2: happiness ~ chocolate
##   Res.Df    RSS Df Sum of Sq      F  Pr(>F)  
## 1      9 5215.0                              
## 2      8 2396.9  1    2818.1 9.4055 0.01542 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

## Credit example

Let's load the credit card data: 


```r
df.credit = read_csv("data/credit.csv") %>% 
  rename(index = X1) %>% 
  clean_names()
```

```
## Warning: Missing column names filled in: 'X1' [1]
```

```
## Parsed with column specification:
## cols(
##   X1 = col_double(),
##   Income = col_double(),
##   Limit = col_double(),
##   Rating = col_double(),
##   Cards = col_double(),
##   Age = col_double(),
##   Education = col_double(),
##   Gender = col_character(),
##   Student = col_character(),
##   Married = col_character(),
##   Ethnicity = col_character(),
##   Balance = col_double()
## )
```

Here is a short description of the variables:

\begin{table}[H]
\centering
\begin{tabular}{l|l}
\hline
variable & description\\
\hline
income & in thousand dollars\\
\hline
limit & credit limit\\
\hline
rating & credit rating\\
\hline
cards & number of credit cards\\
\hline
age & in years\\
\hline
education & years of education\\
\hline
gender & male or female\\
\hline
student & student or not\\
\hline
married & married or not\\
\hline
ethnicity & African American, Asian, Caucasian\\
\hline
balance & average credit card debt\\
\hline
\end{tabular}
\end{table}

Scatterplot of the relationship between `income` and `balance`.


```r
ggplot(data = df.credit,
       mapping = aes(x = income,
                     y = balance)) + 
  geom_point(alpha = 0.3) +
  coord_cartesian(xlim = c(0, max(df.credit$income)))
```

![](10-linear_model1_files/figure-latex/linear-model1-24-1.pdf)<!-- --> 

To make the model intercept interpretable, we can center the predictor variable by subtracting the mean from each value.


```r
df.plot = df.credit %>% 
  mutate(income_centered = income - mean(income)) %>% 
  select(balance, income, income_centered)

fit = lm(balance ~ 1 + income_centered, data = df.plot)

ggplot(data = df.plot,
       mapping = aes(x = income_centered,
                     y = balance)) + 
  geom_vline(xintercept = 0,
             linetype = 2,
             color = "black") +
  geom_hline(yintercept = mean(df.plot$balance),
             color = "red") +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = F) +
  scale_color_manual(values = c("black", "red"))
```

![](10-linear_model1_files/figure-latex/linear-model1-25-1.pdf)<!-- --> 

```r
  # coord_cartesian(xlim = c(0, max(df.plot$income_centered)))
```

Let's fit the model and take a look at the model summary: 


```r
fit = lm(balance ~ 1 + income, data = df.credit) 

fit %>% 
  summary()
```

```
## 
## Call:
## lm(formula = balance ~ 1 + income, data = df.credit)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -803.64 -348.99  -54.42  331.75 1100.25 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 246.5148    33.1993   7.425  6.9e-13 ***
## income        6.0484     0.5794  10.440  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 407.9 on 398 degrees of freedom
## Multiple R-squared:  0.215,	Adjusted R-squared:  0.213 
## F-statistic:   109 on 1 and 398 DF,  p-value: < 2.2e-16
```


Here, I double check that I understand how the statistics about the residuals are calculated that the model summary gives me.  


```r
fit %>% 
  augment() %>% 
  clean_names() %>% 
  summarize(
    min = min(resid),
    first_quantile = quantile(resid, 0.25),
    median = median(resid),
    third_quantile = quantile(resid, 0.75),
    max = max(resid),
    rmse = sqrt(mean(resid^2))
  )
```

```
## # A tibble: 1 x 6
##     min first_quantile median third_quantile   max  rmse
##   <dbl>          <dbl>  <dbl>          <dbl> <dbl> <dbl>
## 1 -804.          -349.  -54.4           332. 1100.  407.
```

Here is a plot of the residuals. Residual plots are important for checking whether any of the linear model assumptions have been violated. 


```r
fit %>% 
  augment() %>% 
  clean_names() %>% 
  ggplot(aes(x = fitted,
             y = resid)) + 
  geom_hline(yintercept = 0,
             color = "blue") +
  geom_point(alpha = 0.3)
```

![](10-linear_model1_files/figure-latex/linear-model1-28-1.pdf)<!-- --> 

We can use the `glance()` function from the `broom` package to print out model statistics. 


```r
fit %>% 
  glance() %>% 
    kable(digits = 2) %>% 
    kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r|r|r|r|r|r|r|r}
\hline
r.squared & adj.r.squared & sigma & statistic & p.value & df & logLik & AIC & BIC & deviance & df.residual\\
\hline
0.21 & 0.21 & 407.86 & 108.99 & 0 & 2 & -2970.95 & 5947.89 & 5959.87 & 66208745 & 398\\
\hline
\end{tabular}
\end{table}

Let's test whether income is a significant predictor of balance in the credit data set. 


```r
# fitting the compact model 
fit_c = lm(formula = balance ~ 1,
           data = df.credit)

# fitting the augmented model
fit_a = lm(formula = balance ~ 1 + income,
           data = df.credit)

# run the F test 
anova(fit_c, fit_a)
```

```
## Analysis of Variance Table
## 
## Model 1: balance ~ 1
## Model 2: balance ~ 1 + income
##   Res.Df      RSS Df Sum of Sq      F    Pr(>F)    
## 1    399 84339912                                  
## 2    398 66208745  1  18131167 108.99 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Let's print out the paramters of the augmented model with confidence intervals: 


```r
fit_a %>% 
  tidy(conf.int = T) %>% 
    kable(digits = 2) %>% 
    kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{l|r|r|r|r|r|r}
\hline
term & estimate & std.error & statistic & p.value & conf.low & conf.high\\
\hline
(Intercept) & 246.51 & 33.20 & 7.43 & 0 & 181.25 & 311.78\\
\hline
income & 6.05 & 0.58 & 10.44 & 0 & 4.91 & 7.19\\
\hline
\end{tabular}
\end{table}

We can use `augment()` with the `newdata = ` argument to get predictions about new data from our fitted model: 


```r
augment(fit, newdata = tibble(income = 130))
```

```
## # A tibble: 1 x 3
##   income .fitted .se.fit
##    <dbl>   <dbl>   <dbl>
## 1    130   1033.    53.2
```

Here is a plot of the model with confidence interval (that captures our uncertainty in the intercept and slope of the model) and the predicted `balance` value for an `income` of 130:


```r
ggplot(data = df.credit,
       mapping = aes(x = income,
                     y = balance)) + 
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm") +
  annotate(geom = "point",
           color = "red",
           size = 5,
           x = 130,
           y = predict(fit, newdata = tibble(income = 130))) +
  coord_cartesian(xlim = c(0, max(df.credit$income)))
```

![](10-linear_model1_files/figure-latex/linear-model1-33-1.pdf)<!-- --> 


Finally, let's take a look at how the residuals are distributed. 


```r
# get the residuals 
df.plot = fit_a %>% 
  augment() %>% 
  clean_names()

# plot a quantile-quantile plot 
ggplot(df.plot, aes(sample = resid)) +
  geom_qq_line() +
  geom_qq()
```

![](10-linear_model1_files/figure-latex/linear-model1-34-1.pdf)<!-- --> 

```r
# and a density of the residuals
ggplot(df.plot, aes(x = resid)) +
  stat_density(geom = "line")
```

![](10-linear_model1_files/figure-latex/linear-model1-34-2.pdf)<!-- --> 

Not quite as normally distributed as we would hope. We learn what to do if some of the assumptions of the linear model are violated later in class. 

## Additional resources 

### Datacamp 

- [Statistical modeling 1](https://www.datacamp.com/courses/statistical-modeling-in-r-part-1)
- [Statistical modeling 2](https://www.datacamp.com/courses/statistical-modeling-in-r-part-2)
- [Correlation and regression](https://www.datacamp.com/courses/correlation-and-regression)

### Misc 

- [Spurious correlations](http://www.tylervigen.com/spurious-correlations)

<!--chapter:end:10-linear_model1.Rmd-->

# Linear model 2



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")      # for tidying up linear models 
library("corrr")      # for calculating correlations between many variables
library("corrplot")   # for plotting correlations
library("GGally")     # for running ggpairs() function
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Load data sets 

Let's load the data sets that we'll explore in this class: 


```r
# credit data set
df.credit = read_csv("data/credit.csv") %>% 
  rename(index = X1) %>% 
  clean_names()

# advertising data set 
df.ads = read_csv("data/advertising.csv") %>% 
  clean_names() %>% 
  rename(index = x1)
```

\begin{table}[H]
\centering
\begin{tabular}{l|l}
\hline
variable & description\\
\hline
income & in thousand dollars\\
\hline
limit & credit limit\\
\hline
rating & credit rating\\
\hline
cards & number of credit cards\\
\hline
age & in years\\
\hline
education & years of education\\
\hline
gender & male or female\\
\hline
student & student or not\\
\hline
married & married or not\\
\hline
ethnicity & African American, Asian, Caucasian\\
\hline
balance & average credit card debt\\
\hline
\end{tabular}
\end{table}

## Things that came up in class

Can the density at a given point be greater than 1? Yes, since it's the area under the curve that has to sum to 1. Here is the density plot for a uniform distribution (note that the density is 1 uniformly).


```r
# play around with this value to see how the density changes
tmp.max = 5

ggplot(data = tibble(x = c(0, tmp.max)),
       mapping = aes(x = x)) + 
  stat_function(fun = "dunif",
                geom = "area",
                fill = "lightblue",
                size = 1,
                args = list(min = 0,
                            max = tmp.max)) +
  stat_function(fun = "dunif",
                size = 1,
                args = list(min = 0,
                            max = tmp.max)) +
  coord_cartesian(xlim = c(0, tmp.max),
                  ylim = c(0, 6),
                  expand = F)
```

![](11-linear_model2_files/figure-latex/linear-model2-06-1.pdf)<!-- --> 

And here is the density plot for a beta distribution:


```r
# play around with these parameters
tmp.shape1 = 1
tmp.shape2 = 2

ggplot(data = tibble(x = c(0, 1)),
       mapping = aes(x = x)) + 
  stat_function(fun = "dbeta",
                args = list(shape1 = tmp.shape1,
                            shape2 = tmp.shape2),
                geom = "area",
                fill = "lightblue",
                size = 1) +
  stat_function(fun = "dbeta",
                args = list(shape1 = tmp.shape1,
                            shape2 = tmp.shape2),
                size = 1) +
  coord_cartesian(xlim = c(0, 1),
                  ylim = c(0, 3),
                  expand = F)
```

![](11-linear_model2_files/figure-latex/linear-model2-07-1.pdf)<!-- --> 

## Multiple continuous variables 

Let's take a look at a case where we have multiple continuous predictor variables. In this case, we want to make sure that our predictors are not too highly correlated with each other (as this makes the interpration of how much each variable explains the outcome difficult). So we first need to explore the pairwise correlations between variables. 

### Explore correlations 

The `corrr` package is great for exploring correlations between variables. To find out more how `corrr` works, take a look at this vignette: 


```r
vignette(topic = "using-corrr",
         package = "corrr")
```

Here is an example that illustrates some of the key functions in the `corrr` package (using the advertisement data): 


```r
df.ads %>% 
  select_if(is.numeric) %>% 
  correlate(quiet = T) %>% 
  shave() %>%
  fashion()
```

```
##     rowname index   tv radio newspaper sales
## 1     index                                 
## 2        tv   .02                           
## 3     radio  -.11  .05                      
## 4 newspaper  -.15  .06   .35                
## 5     sales  -.05  .78   .58       .23
```

#### Visualize correlations

##### Correlations with the dependent variable


```r
df.credit %>% 
  select_if(is.numeric) %>%
  correlate(quiet = T) %>%
  select(rowname, income) %>% 
  mutate(rowname = reorder(rowname, income)) %>%
  drop_na() %>% 
  ggplot(aes(x = rowname, 
             y = income,
             fill = income)) +
  geom_hline(yintercept = 0) +
  geom_col(color = "black",
           show.legend = F) + 
  scale_fill_gradient2(low = "indianred2",
                       mid = "white",
                       high = "skyblue1",
                       limits = c(-1, 1)) + 
  coord_flip() +
  theme(axis.title.y = element_blank())
```

![(\#fig:linear-model2-10)Bar plot illustrating how strongly different variables correlate with income.](11-linear_model2_files/figure-latex/linear-model2-10-1.pdf) 

##### All pairwise correlations


```r
tmp = df.credit %>%
  select_if(is.numeric) %>%
  correlate(diagonal = 0,
            quiet = T) %>%
  rearrange() %>%
  column_to_rownames() %>%
  as.matrix() %>%
  corrplot()
```

![](11-linear_model2_files/figure-latex/linear-model2-11-1.pdf)<!-- --> 


```r
df.ads %>%
  select(-index) %>% 
  ggpairs()
```

![(\#fig:linear-model2-12)Pairwise correlations with scatter plots, correlation values, and densities on the diagonal.](11-linear_model2_files/figure-latex/linear-model2-12-1.pdf) 

With some customization: 


```r
df.ads %>% 
  select(-index) %>%
  ggpairs(lower = list(continuous = wrap("points",
                                         alpha = 0.3)),
          upper = list(continuous = wrap("cor", size = 8))) + 
  theme(panel.grid.major = element_blank())
```

![(\#fig:linear-model2-13)Pairwise correlations with scatter plots, correlation values, and densities on the diagonal (customized).](11-linear_model2_files/figure-latex/linear-model2-13-1.pdf) 

### Multipe regression

Now that we've explored the correlations, let's have a go at the multiple regression. 

#### Visualization

We'll first take another look at the pairwise relationships: 


```r
tmp.x = "tv"
# tmp.x = "radio"
# tmp.x = "newspaper"
# tmp.y = "radio"
tmp.y = "radio"
# tmp.y = "tv"

ggplot(df.ads, 
       aes_string(x = tmp.x, y = tmp.y)) + 
  stat_smooth(method = "lm",
              color = "black",
              fullrange = T) +
  geom_point(alpha = 0.3) +
  annotate(geom = "text",
           x = -Inf, 
           y = Inf,
           hjust = -0.5,
           vjust = 1.5,
           label = str_c("r = ", cor(df.ads[[tmp.x]], df.ads[[tmp.y]]) %>% 
                           round(2) %>%  # round 
                           str_remove("^0+") # remove 0
                         ),
           size = 8) +
  theme(text = element_text(size = 30))
```

![](11-linear_model2_files/figure-latex/linear-model2-14-1.pdf)<!-- --> 

TV ads and radio ads aren't correlated. Yay! 

#### Fitting, hypothesis testing, evaluation

Let's see whether adding radio ads is worth it (over and above having TV ads).


```r
# fit the models 
fit_c = lm(sales ~ 1 + tv, data = df.ads)
fit_a = lm(sales ~ 1 + tv + radio, data = df.ads)

# do the F test
anova(fit_c, fit_a)
```

```
## Analysis of Variance Table
## 
## Model 1: sales ~ 1 + tv
## Model 2: sales ~ 1 + tv + radio
##   Res.Df     RSS Df Sum of Sq      F    Pr(>F)    
## 1    198 2102.53                                  
## 2    197  556.91  1    1545.6 546.74 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

It's worth it! 

Let's evaluate how well the model actually does. We do this by taking a look at the residual plot, and check whether the residuals are normally distributed.


```r
tmp.fit = lm(sales ~ 1 + tv + radio, data = df.ads)

df.plot = tmp.fit %>% 
  augment() %>% 
  clean_names() 

# residual plot
ggplot(df.plot, 
       aes(x = fitted, 
           y = resid)) + 
  geom_point()
```

![](11-linear_model2_files/figure-latex/linear-model2-16-1.pdf)<!-- --> 

```r
# density of residuals 
ggplot(df.plot, 
       aes(x = resid)) + 
  stat_density(geom = "line")
```

![](11-linear_model2_files/figure-latex/linear-model2-16-2.pdf)<!-- --> 

```r
# QQ plot 
ggplot(df.plot,
       aes(sample = resid)) + 
  geom_qq() + 
  geom_qq_line() 
```

![](11-linear_model2_files/figure-latex/linear-model2-16-3.pdf)<!-- --> 

There is a slight non-linear trend in the residuals. We can also see that the residuals aren't perfectly normally distributed. We'll see later what we can do about this ... 

Let's see how well the model does overall: 


```r
fit_a %>% 
  glance() %>% 
    kable(digits = 3) %>% 
    kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r|r|r|r|r|r|r|r}
\hline
r.squared & adj.r.squared & sigma & statistic & p.value & df & logLik & AIC & BIC & deviance & df.residual\\
\hline
0.897 & 0.896 & 1.681 & 859.618 & 0 & 3 & -386.197 & 780.394 & 793.587 & 556.914 & 197\\
\hline
\end{tabular}
\end{table}

As we can see, the model almost explains 90% of the variance. That's very decent! 

#### Visualizing the model fits 

Here is a way of visualizing how both tv ads and radio ads affect sales: 


```r
df.plot = lm(sales ~ 1 + tv + radio, data =  df.ads) %>% 
  augment() %>% 
  clean_names()

df.tidy = lm(sales ~ 1 + tv + radio, data =  df.ads) %>% 
  tidy()

ggplot(df.plot, aes(x = radio, y = sales, color = tv)) + 
  geom_point() +
  scale_color_gradient(low = "gray80", high = "black") +
  theme(legend.position = c(0.1, 0.8))
```

![](11-linear_model2_files/figure-latex/linear-model2-18-1.pdf)<!-- --> 

We used color here to encode TV ads (and the x-axis for the radio ads). 

In addition, we might want to illustrate what relationship between radio ads and sales the model predicts for three distinct values for TV ads. Like so: 


```r
df.plot = lm(sales ~ 1 + tv + radio, data =  df.ads) %>% 
  augment() %>% 
  clean_names()

df.tidy = lm(sales ~ 1 + tv + radio, data =  df.ads) %>% 
  tidy()

ggplot(df.plot, aes(x = radio, y = sales, color = tv)) + 
  geom_point() +
  geom_abline(intercept = df.tidy$estimate[1] + df.tidy$estimate[2] * 200,
              slope = df.tidy$estimate[3]) +
  geom_abline(intercept = df.tidy$estimate[1] + df.tidy$estimate[2] * 100,
              slope = df.tidy$estimate[3]) +
  geom_abline(intercept = df.tidy$estimate[1] + df.tidy$estimate[2] * 0,
              slope = df.tidy$estimate[3]) +
  scale_color_gradient(low = "gray80", high = "black") +
  theme(legend.position = c(0.1, 0.8))
```

![](11-linear_model2_files/figure-latex/linear-model2-19-1.pdf)<!-- --> 

#### Interpreting the model fits

Fitting the augmented model yields the following estimates for the coefficients in the model: 


```r
fit_a %>% 
  tidy(conf.int = T) %>% 
    head(10) %>% 
    kable(digits = 2) %>% 
    kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{l|r|r|r|r|r|r}
\hline
term & estimate & std.error & statistic & p.value & conf.low & conf.high\\
\hline
(Intercept) & 2.92 & 0.29 & 9.92 & 0 & 2.34 & 3.50\\
\hline
tv & 0.05 & 0.00 & 32.91 & 0 & 0.04 & 0.05\\
\hline
radio & 0.19 & 0.01 & 23.38 & 0 & 0.17 & 0.20\\
\hline
\end{tabular}
\end{table}

#### Standardizing the predictors

One thing we can do to make different predictors more comparable is to standardize them. 


```r
df.ads = df.ads %>% 
  mutate_at(vars(tv, radio), funs(scaled = scale(.)[,]))
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
df.ads %>% 
  select(-newspaper) %>%
  head(10) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r|r|r}
\hline
index & tv & radio & sales & tv\_scaled & radio\_scaled\\
\hline
1 & 230.1 & 37.8 & 22.1 & 0.97 & 0.98\\
\hline
2 & 44.5 & 39.3 & 10.4 & -1.19 & 1.08\\
\hline
3 & 17.2 & 45.9 & 9.3 & -1.51 & 1.52\\
\hline
4 & 151.5 & 41.3 & 18.5 & 0.05 & 1.21\\
\hline
5 & 180.8 & 10.8 & 12.9 & 0.39 & -0.84\\
\hline
6 & 8.7 & 48.9 & 7.2 & -1.61 & 1.73\\
\hline
7 & 57.5 & 32.8 & 11.8 & -1.04 & 0.64\\
\hline
8 & 120.2 & 19.6 & 13.2 & -0.31 & -0.25\\
\hline
9 & 8.6 & 2.1 & 4.8 & -1.61 & -1.43\\
\hline
10 & 199.8 & 2.6 & 10.6 & 0.61 & -1.39\\
\hline
\end{tabular}
\end{table}

We can standardize (z-score) variables using the `scale()` function.


```r
# tmp.variable = "tv"
tmp.variable = "tv_scaled" 

ggplot(df.ads,
       aes_string(x = tmp.variable)) +
  stat_density(geom = "line",
               size = 1) + 
  annotate(geom = "text", 
           x = median(df.ads[[tmp.variable]]),
           y = -Inf,
           label = str_c("sd = ", sd(df.ads[[tmp.variable]]) %>% round(2)),
           size = 10,
           vjust = -1,
           hjust = 0.5
           ) + 
annotate(geom = "text", 
           x = median(df.ads[[tmp.variable]]),
           y = -Inf,
           label = str_c("mean = ", mean(df.ads[[tmp.variable]]) %>% round(2)),
           size = 10,
           vjust = -3,
         hjust = 0.5
           )
```

![](11-linear_model2_files/figure-latex/linear-model2-22-1.pdf)<!-- --> 

Scaling a variable leaves the distribution intact, but changes the mean to 0 and the SD to 1. 

## One categorical variable

Let's compare a compact model that only predicts the mean, with a model that uses the student variable as an additional predictor. 


```r
# fit the models
fit_c = lm(balance ~ 1, data = df.credit)
fit_a = lm(balance ~ 1 + student, data = df.credit)

# run the F test 
anova(fit_c, fit_a)
```

```
## Analysis of Variance Table
## 
## Model 1: balance ~ 1
## Model 2: balance ~ 1 + student
##   Res.Df      RSS Df Sum of Sq      F    Pr(>F)    
## 1    399 84339912                                  
## 2    398 78681540  1   5658372 28.622 1.488e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
fit_a %>% 
  summary()
```

```
## 
## Call:
## lm(formula = balance ~ 1 + student, data = df.credit)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -876.82 -458.82  -40.87  341.88 1518.63 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   480.37      23.43   20.50  < 2e-16 ***
## studentYes    396.46      74.10    5.35 1.49e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 444.6 on 398 degrees of freedom
## Multiple R-squared:  0.06709,	Adjusted R-squared:  0.06475 
## F-statistic: 28.62 on 1 and 398 DF,  p-value: 1.488e-07
```

The `summary()` shows that it's worth it: the augmented model explains a signifcant amount of the variance (i.e. it significantly reduces the proportion in error PRE). 

### Visualization of the model predictions

Let's visualize the model predictions. Here is the compact model: 


```r
ggplot(df.credit,
       aes(x = index, 
           y = balance)) +
  geom_hline(yintercept = mean(df.credit$balance),
             size = 1) +
  geom_segment(aes(xend = index,
                   yend = mean(df.credit$balance)),
               alpha = 0.1) +
  geom_point(alpha = 0.5) 
```

![](11-linear_model2_files/figure-latex/linear-model2-24-1.pdf)<!-- --> 

It just predicts the mean (the horizontal black line). The vertical lines from each data point to the mean illustrate the residuals. 

And here is the augmented model:


```r
df.fit = fit_a %>% 
  tidy() %>% 
  mutate(estimate = round(estimate,2))

ggplot(df.credit,
       aes(x = index, 
           y = balance,
           color = student)) +
  geom_hline(yintercept = df.fit$estimate[1],
             size = 1,
             color = "#E41A1C") +
  geom_hline(yintercept = df.fit$estimate[1] + df.fit$estimate[2],
             size = 1,
             color = "#377EB8") +
  geom_segment(data = df.credit %>%
                 filter(student == "No"),
                 aes(xend = index,
                   yend = df.fit$estimate[1]),
               alpha = 0.1,
               color = "#E41A1C") +
  geom_segment(data = df.credit %>%
                 filter(student == "Yes"),
                 aes(xend = index,
                   yend = df.fit$estimate[1] + df.fit$estimate[2]),
               alpha = 0.1,
               color = "#377EB8") +
  geom_point(alpha = 0.5) +
  scale_color_brewer(palette = "Set1") +
  guides(color = guide_legend(reverse = T))
```

![](11-linear_model2_files/figure-latex/linear-model2-25-1.pdf)<!-- --> 

Note that this model predicts two horizontal lines. One for students, and one for non-students. 

Let's make simple plot that shows the means of both groups with bootstrapped confidence intervals. 


```r
ggplot(data = df.credit,
       mapping = aes(x = student, y = balance, fill = student)) + 
  stat_summary(fun.y = "mean",
               geom = "bar",
               color = "black",
               show.legend = F) +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               size = 1) +
  scale_fill_brewer(palette = "Set1")
```

![](11-linear_model2_files/figure-latex/linear-model2-26-1.pdf)<!-- --> 

And let's double check that we also get a signifcant result when we run a t-test instead of our model comparison procedure: 


```r
t.test(x = df.credit$balance[df.credit$student == "No"],
       y = df.credit$balance[df.credit$student == "Yes"])
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  df.credit$balance[df.credit$student == "No"] and df.credit$balance[df.credit$student == "Yes"]
## t = -4.9028, df = 46.241, p-value = 1.205e-05
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -559.2023 -233.7088
## sample estimates:
## mean of x mean of y 
##  480.3694  876.8250
```

### Dummy coding 

When we put a variable in a linear model that is coded as a character or as a factor, R automatically recodes this variable using dummy coding. It uses level 1 as the reference category for factors, or the value that comes first in the alphabet for characters. 


```r
df.credit %>% 
  select(income, student) %>% 
  mutate(student_dummy = ifelse(student == "No", 0, 1))%>% 
    head(10) %>% 
    kable(digits = 2) %>% 
    kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|l|r}
\hline
income & student & student\_dummy\\
\hline
14.89 & No & 0\\
\hline
106.03 & Yes & 1\\
\hline
104.59 & No & 0\\
\hline
148.92 & No & 0\\
\hline
55.88 & No & 0\\
\hline
80.18 & No & 0\\
\hline
21.00 & No & 0\\
\hline
71.41 & No & 0\\
\hline
15.12 & No & 0\\
\hline
71.06 & Yes & 1\\
\hline
\end{tabular}
\end{table}

### Reporting the results

To report the results, we could show a plot like this:  


```r
df.plot = df.credit

ggplot(df.plot,
       aes(x = student,
           y = balance)) +
  geom_point(alpha = 0.1,
             position = position_jitter(height = 0, width = 0.1)) +
  stat_summary(fun.data = "mean_cl_boot",
               geom = "linerange",
               size = 1) +
  stat_summary(fun.y = "mean",
               geom = "point",
               size = 4)
```

![](11-linear_model2_files/figure-latex/linear-model2-29-1.pdf)<!-- --> 

And then report the means and standard deviations together with the result of our signifance test: 


```r
df.credit %>% 
  group_by(student) %>% 
  summarize(mean = mean(balance),
            sd = sd(balance)) %>% 
  mutate_if(is.numeric, funs(round(., 2)))
```

```
## # A tibble: 2 x 3
##   student  mean    sd
##   <chr>   <dbl> <dbl>
## 1 No       480.  439.
## 2 Yes      877.  490
```

## One continuous and one categorical variable

Now let's take a look at a case where we have one continuous and one categorical predictor variable. Let's first formulate and fit our models: 


```r
# fit the models
fit_c = lm(balance ~ 1 + income, df.credit)
fit_a = lm(balance ~ 1 + income + student, df.credit)

# run the F test 
anova(fit_c, fit_a)
```

```
## Analysis of Variance Table
## 
## Model 1: balance ~ 1 + income
## Model 2: balance ~ 1 + income + student
##   Res.Df      RSS Df Sum of Sq      F    Pr(>F)    
## 1    398 66208745                                  
## 2    397 60939054  1   5269691 34.331 9.776e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

We see again that it's worth it. The augmented model explains significantly more variance than the compact model. 

### Visualization of the model predictions

Let's visualize the model predictions again. Let's start with the compact model: 


```r
df.augment = fit_c %>% 
  augment() %>% 
  clean_names()

ggplot(df.augment,
       aes(x = income,
           y = balance)) + 
  geom_smooth(method = "lm", se = F, color = "black") +
  geom_segment(aes(xend = income,
                   yend = fitted),
               alpha = 0.3) +
  geom_point(alpha = 0.3)
```

![](11-linear_model2_files/figure-latex/linear-model2-32-1.pdf)<!-- --> 

This time, the compact model still predicts just one line (like above) but note that this line is not horizontal anymore. 


```r
df.tidy = fit_a %>% 
  tidy() %>% 
  mutate(estimate = round(estimate,2))

df.augment = fit_a %>% 
  augment() %>% 
  clean_names()

ggplot(df.augment,
       aes(x = income,
           y = balance,
           group = student,
           color = student)) + 
  geom_segment(data = df.augment %>% 
                 filter(student == "No"),
               aes(xend = income,
                   yend = fitted),
               color = "#E41A1C",
               alpha = 0.3) +
  geom_segment(data = df.augment %>% 
                 filter(student == "Yes"),
               aes(xend = income,
                   yend = fitted),
               color = "#377EB8",
               alpha = 0.3) +
  geom_abline(intercept = df.tidy$estimate[1],
              slope = df.tidy$estimate[2],
              color = "#E41A1C",
              size = 1) +
  geom_abline(intercept = df.tidy$estimate[1] + df.tidy$estimate[3],
              slope = df.tidy$estimate[2],
              color = "#377EB8",
              size = 1) +
  geom_point(alpha = 0.3) +
  scale_color_brewer(palette = "Set1") +
  theme(legend.position = c(0.1, 0.9)) +
  guides(color = guide_legend(reverse = T))
```

![](11-linear_model2_files/figure-latex/linear-model2-33-1.pdf)<!-- --> 

The augmented model predicts two lines again, each with the same slope (but the intercept differs).

## Interactions

Let's check whether there is an interaction between how income affects balance for students vs. non-students. 

### Visualization

Let's take a look at the data first. 


```r
ggplot(data = df.credit,
       mapping = aes(x = income,
                     y = balance,
                     group = student,
                     color = student)) +
  geom_smooth(method = "lm", se = F) + 
  geom_point(alpha = 0.3) +
  scale_color_brewer(palette = "Set1") +
  theme(legend.position = c(0.1, 0.9)) +
  guides(color = guide_legend(reverse = T))
```

![](11-linear_model2_files/figure-latex/linear-model2-34-1.pdf)<!-- --> 

Note that we just specified here that we want to have a linear model (via `geom_smooth(method = "lm")`). By default, `ggplot2` assumes that we want a model that includes interactions. We can see this by the fact that two fitted lines are not parallel. 

But is the interaction in the model worth it? That is, does a model that includes an interaction explain significantly more variance in the data, than a model that does not have an interaction. 

### Hypothesis test 

Let's check: 


```r
# fit models 
fit_c = lm(formula = balance ~ income + student, data = df.credit)
fit_a = lm(formula = balance ~ income * student, data = df.credit)

# F-test 
anova(fit_c, fit_a)
```

```
## Analysis of Variance Table
## 
## Model 1: balance ~ income + student
## Model 2: balance ~ income * student
##   Res.Df      RSS Df Sum of Sq      F Pr(>F)
## 1    397 60939054                           
## 2    396 60734545  1    204509 1.3334 0.2489
```

Nope, not worth it! The F-test comes out non-significant. 

## Additional resources 

### Datacamp 

- [Statistical modeling 1](https://www.datacamp.com/courses/statistical-modeling-in-r-part-1)
- [Statistical modeling 2](https://www.datacamp.com/courses/statistical-modeling-in-r-part-2)
- [Correlation and regression](https://www.datacamp.com/courses/correlation-and-regression)

### Misc 

- [Nice review of multiple regression in R](https://bookdown.org/roback/bookdown-bysh/ch-MLRreview.html)

<!--chapter:end:11-linear_model2.Rmd-->

# Linear model 3



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")      # for tidying up linear models 
library("car")        # for running ANOVAs
library("afex")       # also for running ANOVAs
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

\begin{table}[H]
\centering
\begin{tabular}{r|l|l|l|r}
\hline
participant & skill & hand & limit & balance\\
\hline
1 & expert & bad & fixed & 4.00\\
\hline
2 & expert & bad & fixed & 5.55\\
\hline
26 & expert & bad & none & 5.52\\
\hline
27 & expert & bad & none & 8.28\\
\hline
51 & expert & neutral & fixed & 11.74\\
\hline
52 & expert & neutral & fixed & 10.04\\
\hline
76 & expert & neutral & none & 21.55\\
\hline
77 & expert & neutral & none & 3.12\\
\hline
101 & expert & good & fixed & 10.86\\
\hline
102 & expert & good & fixed & 8.68\\
\hline
\end{tabular}
\end{table}

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

![](12-linear_model3_files/figure-latex/linear-model3-06-1.pdf)<!-- --> 

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

![](12-linear_model3_files/figure-latex/linear-model3-09-1.pdf)<!-- --> 

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

![](12-linear_model3_files/figure-latex/linear-model3-10-1.pdf)<!-- --> 

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

![](12-linear_model3_files/figure-latex/linear-model3-11-1.pdf)<!-- --> 

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

\begin{table}[H]
\centering
\begin{tabular}{r|l|r|r|r}
\hline
participant & hand & hand\_neutral & hand\_good & balance\\
\hline
31 & bad & 0 & 0 & 12.22\\
\hline
46 & bad & 0 & 0 & 12.06\\
\hline
50 & bad & 0 & 0 & 16.68\\
\hline
76 & neutral & 1 & 0 & 21.55\\
\hline
87 & neutral & 1 & 0 & 20.89\\
\hline
89 & neutral & 1 & 0 & 25.63\\
\hline
127 & good & 0 & 1 & 26.99\\
\hline
129 & good & 0 & 1 & 21.36\\
\hline
283 & good & 0 & 1 & 22.48\\
\hline
\end{tabular}
\end{table}

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

![](12-linear_model3_files/figure-latex/linear-model3-18-1.pdf)<!-- --> 

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

![](12-linear_model3_files/figure-latex/linear-model3-19-1.pdf)<!-- --> 

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

![](12-linear_model3_files/figure-latex/linear-model3-22-1.pdf)<!-- --> 

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

\begin{table}[H]
\centering
\begin{tabular}{l|l|r}
\hline
condition & treatment & rating\\
\hline
A & 1 & 11.87\\
\hline
A & 2 & 15.92\\
\hline
A & 1 & 10.82\\
\hline
A & 2 & 22.98\\
\hline
B & 1 & 21.87\\
\hline
B & 2 & 5.92\\
\hline
B & 1 & 20.82\\
\hline
B & 2 & 12.98\\
\hline
\end{tabular}
\end{table}

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

![](12-linear_model3_files/figure-latex/linear-model3-25-1.pdf)<!-- --> 

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

<!--chapter:end:12-linear_model3.Rmd-->

# Linear model 4



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")      # for tidying up linear models 
library("afex")       # for running ANOVAs
library("emmeans")    # for calculating constrasts
library("car")        # for calculating ANOVAs
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

![](13-linear_model4_files/figure-latex/linear-model4-07-1.pdf)<!-- --> 

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

![](13-linear_model4_files/figure-latex/linear-model4-08-1.pdf)<!-- --> 

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

![](13-linear_model4_files/figure-latex/linear-model4-09-1.pdf)<!-- --> 

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

![](13-linear_model4_files/figure-latex/linear-model4-12-1.pdf)<!-- --> 

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
##   variance_total variance_skill variance_hand variance_hand_s~
##            <dbl>          <dbl>         <dbl>            <dbl>
## 1          7580.           39.3         2559.             229.
## # ... with 1 more variable: variance_residual <dbl>
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

![](13-linear_model4_files/figure-latex/linear-model4-19-1.pdf)<!-- --> 

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

![](13-linear_model4_files/figure-latex/linear-model4-22-1.pdf)<!-- --> 

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

![](13-linear_model4_files/figure-latex/linear-model4-23-1.pdf)<!-- --> 

Results figure


```r
df.contrast %>% 
  ggplot(aes(x = group, y = performance)) + 
  geom_point(alpha = 0.3, position = position_jitter(width = 0.1, height = 0)) +
  stat_summary(fun.data = "mean_cl_boot", geom = "linerange", size = 1) + 
  stat_summary(fun.y = "mean", geom = "point", shape = 21, fill = "white", size = 3)
```

![](13-linear_model4_files/figure-latex/linear-model4-24-1.pdf)<!-- --> 

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

<!--chapter:end:13-linear_model4.Rmd-->

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
## Parsed with column specification:
## cols(
##   skill = col_double(),
##   hand = col_double(),
##   limit = col_double(),
##   balance = col_double()
## )
```

```r
df.credit = read_csv("data/credit.csv") %>% 
  rename(index = X1) %>% 
  clean_names()
```

```
## Warning: Missing column names filled in: 'X1' [1]
```

```
## Parsed with column specification:
## cols(
##   X1 = col_double(),
##   Income = col_double(),
##   Limit = col_double(),
##   Rating = col_double(),
##   Cards = col_double(),
##   Age = col_double(),
##   Education = col_double(),
##   Gender = col_character(),
##   Student = col_character(),
##   Married = col_character(),
##   Ethnicity = col_character(),
##   Balance = col_double()
## )
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

![](14-power_analysis_files/figure-latex/power-analysis-05-1.pdf)<!-- --> 

## Effect sizes

### eta-squared and partial eta-squared

One-way ANOVA: 


```r
fit = lm(formula = balance ~ hand, 
         data = df.poker)

# use function
etaSquared(fit)
```

```
##         eta.sq eta.sq.part
## hand 0.3311076   0.3311076
```

```r
# compute by hand 
fit %>% 
  anova %>% 
  tidy() %>% 
  pull(sumsq) %>% 
  divide_by(sum(.)) %>% 
  magrittr::extract(1)
```

```
## [1] 0.3311076
```

Two-way ANOVA: 


```r
fit = lm(formula = balance ~ hand * skill, 
         data = df.poker)

# use function
etaSquared(fit)
```

```
##                 eta.sq eta.sq.part
## hand       0.331107585 0.343119717
## skill      0.005191225 0.008123029
## hand:skill 0.029817351 0.044925866
```

```r
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
```

```
## [1] 0.8916607
```

```r
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
## [1] 0.8916607
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
## 
##      proportion power calculation for binomial distribution (arcsine transformation) 
## 
##               h = 0.5235988
##               n = 22.55126
##       sig.level = 0.05
##           power = 0.8
##     alternative = greater
```


```r
pwr.p.test(h = ES.h(p1 = 0.75, p2 = 0.50), 
           sig.level = 0.05, 
           power = 0.80, 
           alternative = "greater") %>% 
  plot() +
  theme(title = element_text(size = 16))
```

![](14-power_analysis_files/figure-latex/power-analysis-10-1.pdf)<!-- --> 

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
```

![](14-power_analysis_files/figure-latex/power-analysis-11-1.pdf)<!-- --> 

```r
# based on simulations
df.plot %>%
  filter(p == 0.75, near(power, 0.8, tol = 0.02))
```

```
## # A tibble: 0 x 3
## # ... with 3 variables: n <dbl>, p <fct>, power <dbl>
```

```r
# analytic solution
pwr.p.test(h = ES.h(0.5, 0.75),
           power = 0.8,
           alternative = "two.sided")
```

```
## 
##      proportion power calculation for binomial distribution (arcsine transformation) 
## 
##               h = 0.5235988
##               n = 28.62923
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
```

## Additional resources 

- [Getting started with `pwr`](https://cran.r-project.org/web/packages/pwr/vignettes/pwr-vignette.html)
- [Visualize power](https://rpsychologist.com/d3/NHST/)
- [Calculating and reporting effect sizes to facilitate cumulative science: a practical primer for t-tests and ANOVAs](https://www.frontiersin.org/articles/10.3389/fpsyg.2013.00863/full)


<!--chapter:end:14-power_analysis.Rmd-->

# Bootstrapping

This chapter was written by Andrew Lampinen. 



## Load packages and set plotting theme  


```r
library("boot")      # for bootstrapping
library("patchwork") # for making figure panels
library("tidyverse") # for data wrangling etc.
```


```r
theme_set(
  theme_classic() #set the theme 
)
```

## What's wrong with parametric tests?

### T-tests on non-normal distributions

Let's see some examples! One common non-normal distribution is the *log-normal* distribution, i.e. a distribution that is normal after you take its logarithm. Many natural processes have distributions like this. One of particular interest to us is reaction times.


```r
num_points = 1e4
parametric_plotting_data = tibble(
  distribution = rep(c("Normal", "Log-normal"), each = num_points),
  value = c(
    rnorm(num_points, 0, 1), # normal
    exp(rnorm(num_points, 0, 1)) - exp(1 / 2)
  )
) %>%
  mutate(distribution = factor(distribution, levels = c("Normal", "Log-normal")))
```

Let's see how violating the assumption of normality changes the results of `t.test`. We'll compare two situations 

Valid: comparing two normally distributed populations with equal means but unequal variances.

Invalid: comparing two log-normally distributed populations with equal means but unequal variances.


```r
ggplot(parametric_plotting_data, aes(x = value, color = distribution)) +
  geom_density(bw = 0.5, size = 1) +
  geom_vline(
    data = parametric_plotting_data %>%
      group_by(distribution) %>%
      summarize(mean_value = mean(value), sd_value = sd(value)),
    aes(xintercept = mean_value, color = distribution),
    linetype = 2, size = 1
  ) +
  xlim(-5, 20) +
  facet_grid(~distribution, scales = "free") +
  guides(color = F) +
  scale_color_brewer(palette = "Accent")
```

```
## Warning: Removed 7 rows containing non-finite values (stat_density).
```

![](15-bootstrapping_files/figure-latex/bootstrapping-05-1.pdf)<!-- --> 


```r
ggsave("figures/log_normal_dists.png", width=5, height=3)
```

```
## Warning: Removed 7 rows containing non-finite values (stat_density).
```


```r
gen_data_and_test = function(num_observations_per) {
  x = rnorm(num_observations_per, 0, 1.1)
  y = rnorm(num_observations_per, 0, 1.1)

  pnormal = t.test(x, y, var.equal = T)$p.value

  # what if the data are log-normally distributed?
  x = exp(rnorm(num_observations_per, 0, 1.1))
  y = exp(rnorm(num_observations_per, 0, 1.1))

  pnotnormal = t.test(x, y, var.equal = T)$p.value
  return(c(pnormal, pnotnormal))
}

parametric_issues_demo = function(num_tests, num_observations_per) {
  replicate(num_tests, gen_data_and_test(num_observations_per))
}
```


```r
set.seed(0) # ensures we get the same results each time we run it

num_tests = 1000 # how many datasets to generate/tests to run
num_observations_per = 20 # how many obsservations in each dataset

parametric_issues_results = parametric_issues_demo(num_tests=num_tests, 
                                                   num_observations_per=num_observations_per)

parametric_issues_d = data.frame(valid_tests = parametric_issues_results[1,],
                                 invalid_tests = parametric_issues_results[2,],
                                 iteration=1:num_tests) %>%
  gather(type, p_value, contains("tests")) %>%
  mutate(is_significant = p_value < 0.05)

# Number significant results with normally distributed data
sum(parametric_issues_results[1,] < 0.05)
```

```
## [1] 41
```

```r
# number of significant results with log-normally distributed data
sum(parametric_issues_results[2,] < 0.05)
```

```
## [1] 25
```
 

```r
ggplot(parametric_issues_d, aes(x=type, fill=is_significant)) +
  geom_bar(stat="count", color="black") +
  scale_fill_brewer(palette="Set1") +
  labs(title="Parametric t-test")
```

![](15-bootstrapping_files/figure-latex/bootstrapping-09-1.pdf)<!-- --> 

That's a non-trivial reduction in power from a misspecified model! (~80% to ~54%).


```r
boot_mean_diff_test = function(x, y) {
  obs_t = t.test(x, y)$statistic
  boot_iterate = function(x, y, indices) { # indices is a dummy here
    x_samp = sample(x, 
                    length(x), 
                    replace=T)
    y_samp = sample(y, 
                    length(y), 
                    replace=T)
    mean_diff = mean(y_samp) - mean(x_samp)
    return(mean_diff)
  }
  boots = boot(data = c(x, y), boot_iterate, R=500)
  #  boots = replicate(100, boot_iterate(x, y))
  #  quants = quantile(boots, probs=c(0.025, 0.975))
  quants = boot.ci(boots)$bca[4:5]
  return(sign(quants[1]) == sign(quants[2]))
}
```

(Omitted because with these small sample sizes bootstrapping is problematic -- permutations are better)


```r
# gen_data_and_boot_test = function(num_observations_per) {
# x = rnorm(num_observations_per, 0, 1.1)
# y = rnorm(num_observations_per, 0, 1.1)
# 
# pnormal = boot_mean_diff_test(x, y)
# 
# # what if the data are log-normally distributed?
# x = exp(rnorm(num_observations_per, 0, 1.1))
# y = exp(rnorm(num_observations_per, 1, 1.1))
# 
# pnotnormal = boot_mean_diff_test(x, y)
# return(c(pnormal, pnotnormal))
# }
# 
# boot_results = replicate(num_tests, gen_data_and_boot_test(num_observations_per))
# sum(boot_results[1,])
# sum(boot_results[2,])
```

While the bootstrap **actually loses power** relative to a perfectly specified model, it is much more **robust** to changes in the assumptions of that model, and so it **retains more power when assumptions are violated**.
 


```r
perm_mean_diff_test = function(x, y) {
  obs_t = t.test(x, y)$statistic
  combined_data = c(x, y)
  n_combined = length(combined_data)
  n_x = length(x)
  perm_iterate = function(x, y) {
    perm = sample(n_combined)
    x_samp = combined_data[perm[1:n_x]]
    y_samp = combined_data[perm[-(1:n_x)]]
    this_t = t.test(x_samp, y_samp)$statistic
    return(this_t)
  }
  perms = replicate(500, perm_iterate(x, y))
  quants = quantile(perms, probs=c(0.025, 0.975))
  return(obs_t < quants[1] | obs_t > quants[2])
}
```


```r
# this could be much more efficient
gen_data_and_norm_and_perm_test = function(num_observations_per) {
  d = data.frame(distribution=c(),
                 null_true=c(),
                 parametric=c(),
                 permutation=c()) 
    
  # normally distributed 
  ## null
  x = rnorm(num_observations_per, 0, 1.1)
  y = rnorm(num_observations_per, 0, 1.1)
  
  sig_par = t.test(x, y)$p.value < 0.05
  sig_perm = perm_mean_diff_test(x, y)
  d = bind_rows(d, 
                data.frame(distribution="Normal",
                           null_true=T,
                           parametric=sig_par,
                           permutation=sig_perm))
  
  ## non-null
  x = rnorm(num_observations_per, 0, 1.1)
  y = rnorm(num_observations_per, 1, 1.1)
  
  sig_par = t.test(x, y)$p.value < 0.05
  sig_perm = perm_mean_diff_test(x, y)
  d = bind_rows(d, 
                data.frame(distribution="Normal",
                           null_true=F,
                           parametric=sig_par,
                           permutation=sig_perm))
  
  # what if the data are log-normally distributed?
  ## null
  x = exp(rnorm(num_observations_per, 0, 1.1))
  y = exp(rnorm(num_observations_per, 0, 1.1))
  
  sig_par = t.test(x, y)$p.value < 0.05
  sig_perm = perm_mean_diff_test(x, y)
  d = bind_rows(d, 
                data.frame(distribution="Log-normal",
                           null_true=T,
                           parametric=sig_par,
                           permutation=sig_perm))
  
  ## non-null
  x = exp(rnorm(num_observations_per, 0, 1.1))
  y = exp(rnorm(num_observations_per, 1, 1.1))
  
  sig_par = t.test(x, y)$p.value < 0.05
  sig_perm = perm_mean_diff_test(x, y)
  d = bind_rows(d, 
                data.frame(distribution="Log-normal",
                           null_true=F,
                           parametric=sig_par,
                           permutation=sig_perm))
  
  return(d)
}
num_tests = 100

perm_results = replicate(num_tests, gen_data_and_norm_and_perm_test(num_observations_per),
                         simplify=F) %>%
  bind_rows()
```


```r
perm_results = perm_results %>%
  gather(test_type, significant, parametric, permutation) %>%
  mutate(distribution=factor(distribution, levels=c("Normal", "Log-normal")),
         null_true=ifelse(null_true, 
                          "Null True",
                          "Alternative True"))
```


```r
ggplot(perm_results %>%
  filter(null_true == "Alternative True"), aes(x = test_type, fill = significant)) +
  geom_bar(stat = "count", color = "black") +
  scale_fill_brewer(palette = "Set1") +
  facet_grid(null_true ~ distribution) +
  geom_hline(
    data = data.frame(
      null_true = "Alternative True",
      alpha = num_tests * 0.8
    ),
    mapping = aes(yintercept = alpha),
    linetype = 2,
    size = 1,
    alpha = 0.5
  ) +
  labs(x = "Test type", y = "Percent") +
  scale_y_continuous(
    breaks = c(0, 0.8, 1) * num_tests,
    labels = paste(c(0, 80, 100), "%", sep = "")
  )
```

![](15-bootstrapping_files/figure-latex/bootstrapping-15-1.pdf)<!-- --> 


```r
ggsave("figures/perm_test.png", width=5, height=3)
```


```r
perm_results %>% 
  group_by(test_type, distribution, null_true) %>%
  summarize(pct_significant = sum(significant)/n())
```

```
## # A tibble: 8 x 4
## # Groups:   test_type, distribution [4]
##   test_type   distribution null_true        pct_significant
##   <chr>       <fct>        <chr>                      <dbl>
## 1 parametric  Normal       Alternative True            0.75
## 2 parametric  Normal       Null True                   0.07
## 3 parametric  Log-normal   Alternative True            0.53
## 4 parametric  Log-normal   Null True                   0.02
## 5 permutation Normal       Alternative True            0.76
## 6 permutation Normal       Null True                   0.07
## 7 permutation Log-normal   Alternative True            0.68
## 8 permutation Log-normal   Null True                   0.03
```

### Non-IID noise and linear models


```r
num_points = 500
true_intercept = 0
true_slope = 1.
set.seed(0)
parametric_ci_data = data.frame(IV = rep(runif(num_points,  -1, 1), 2),
                                type = rep(c("IID Error", "Non-IID Error"), each=num_points),
                                error = rep(rnorm(num_points, 0, 1), 2)) %>%
  mutate(DV = ifelse(
    type == "IID Error",
    true_slope*IV + error,
    true_slope*IV + 2*abs(IV)*error)) # error increases proportional to distance from 0 on the IV
```


```r
ggplot(
  parametric_ci_data,
  aes(x = IV, y = DV, color = type)
) +
  geom_point(alpha = 0.5) +
  geom_smooth(
    method = "lm", se = T, color = "black",
    size = 1.5, level = 0.9999
  ) + # inflating the confidence bands a bit
  # to show their distribution is similar
  scale_color_brewer(palette = "Accent") +
  facet_wrap(~type) +
  guides(color = F)
```

![](15-bootstrapping_files/figure-latex/bootstrapping-19-1.pdf)<!-- --> 


```r
ggsave("figures/error_dist_non_null.png", width=5, height=3)
```

C.f. Anscombe's quartet, etc.


```r
summary(lm(DV ~ IV, parametric_ci_data %>% filter(type=="IID Error")))
```

```
## 
## Call:
## lm(formula = DV ~ IV, data = parametric_ci_data %>% filter(type == 
##     "IID Error"))
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -2.7575 -0.6600 -0.0231  0.6768  3.2956 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -0.03103    0.04379  -0.709    0.479    
## IV           1.11977    0.07739  14.470   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.9791 on 498 degrees of freedom
## Multiple R-squared:  0.296,	Adjusted R-squared:  0.2946 
## F-statistic: 209.4 on 1 and 498 DF,  p-value: < 2.2e-16
```

```r
summary(lm(DV ~ IV, parametric_ci_data %>% filter(type=="Non-IID Error")))
```

```
## 
## Call:
## lm(formula = DV ~ IV, data = parametric_ci_data %>% filter(type == 
##     "Non-IID Error"))
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.0872 -0.4030  0.0441  0.5100  3.4718 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -0.05623    0.04928  -1.141    0.254    
## IV           1.22127    0.08708  14.024   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.102 on 498 degrees of freedom
## Multiple R-squared:  0.2831,	Adjusted R-squared:  0.2817 
## F-statistic: 196.7 on 1 and 498 DF,  p-value: < 2.2e-16
```


```r
ex2_lm_bootstrap_CIs = function(data, R = 1000) {
  lm_results = summary(lm(DV ~ IV, data = data))$coefficients
  bootstrap_coefficients = function(data, indices) {
    linear_model = lm(DV ~ IV,
      data = data[indices, ]
    ) # will select a bootstrap sample of the data
    return(linear_model$coefficients)
  }

  boot_results = boot(
    data = data,
    statistic = bootstrap_coefficients,
    R = R
  )
  boot_intercept_CI = boot.ci(boot_results, index = 1, type = "bca")
  boot_slope_CI = boot.ci(boot_results, index = 2, type = "bca")
  return(data.frame(
    intercept_estimate = lm_results[1, 1],
    intercept_SE = lm_results[1, 2],
    slope_estimate = lm_results[2, 1],
    slope_SE = lm_results[2, 2],
    intercept_boot_CI_low = boot_intercept_CI$bca[4],
    intercept_boot_CI_hi = boot_intercept_CI$bca[5],
    slope_boot_CI_low = boot_slope_CI$bca[4],
    slope_boot_CI_hi = boot_slope_CI$bca[5]
  ))
}
```


```r
set.seed(0) # for bootstraps
coefficient_CI_data = parametric_ci_data %>%
  group_by(type) %>%
  do(ex2_lm_bootstrap_CIs(.)) %>%
  ungroup() 
```


```r
coefficient_CI_data = coefficient_CI_data %>%
  gather(variable, value, -type) %>%
  separate(variable, c("parameter", "measurement"), extra = "merge") %>%
  spread(measurement, value) %>%
  mutate(
    parametric_CI_low = estimate - 1.96 * SE,
    parametric_CI_hi = estimate + 1.96 * SE
  ) %>%
  gather(CI_type, value, contains("CI")) %>%
  separate(CI_type, c("CI_type", "high_or_low"), extra = "merge") %>%
  spread(high_or_low, value) %>%
  mutate(CI_type = factor(CI_type))
```


```r
plot_coefficient_CI_data = function(coefficient_CI_data, errorbar_width = 0.5) {
  p = ggplot(data = coefficient_CI_data, aes(x = parameter, color = CI_type, y = estimate, ymin = CI_low, ymax = CI_hi)) +
    geom_hline(
      data = data.frame(
        parameter = c("intercept", "slope"),
        estimate = c(true_intercept, true_slope)
      ),
      mapping = aes(yintercept = estimate),
      linetype = 3
    ) +
    geom_point(size = 2, position = position_dodge(width = 0.2)) +
    geom_errorbar(position = position_dodge(width = 0.2), width = errorbar_width) +
    facet_grid(~type) +
    scale_y_continuous(breaks = c(0, 0.5, 1), limits = c(-0.2, 1.5)) +
    scale_color_brewer(palette = "Dark2", drop = F)
}
```


```r
plot_coefficient_CI_data(coefficient_CI_data)
ggsave("figures/error_dist_CI_example.png", width = 5, height = 3)

plot_coefficient_CI_data(
  coefficient_CI_data %>%
    filter(CI_type == "parametric"), 0.25)

ggsave("figures/error_dist_CI_example_parametric_only.png", width = 5, height = 3)
```

Challenge Q: Why isn't the error on the intercept changed in the scaling error case?

This can result in CIs which aren't actually at the nominal confidence level! And since CIs are equivalent to t-tests in this setting, this can also increase false positive rates.
(Also equivalent to Bayesian CrIs.)



```r
num_points = 200
true_intercept = 0
true_slope = 0.
set.seed(0)
parametric_ci_data = data.frame(IV = rep(runif(num_points,  -1, 1), 2),
                                type = rep(c("IID Error", "Non-IID Error"), each=num_points),
                                error = rep(rnorm(num_points, 0, 1), 2)) %>%
  mutate(DV = ifelse(
    type == "IID Error",
    true_slope*IV + error,
    true_slope*IV + 2*abs(IV)*error)) # error increases proportional to distance from 0 on the IV
```


```r
ggplot(
  parametric_ci_data,
  aes(x = IV, y = DV, color = type)
) +
  geom_point(alpha = 0.5) +
  geom_smooth(
    method = "lm", se = T, color = "black",
    size = 1.5, level = 0.9999
  ) + # inflating the confidence bands a bit
  # to show their distribution is similar
  scale_color_brewer(palette = "Accent") +
  facet_wrap(~type) +
  guides(color = F)
```

![](15-bootstrapping_files/figure-latex/bootstrapping-28-1.pdf)<!-- --> 


```r
ggsave("figures/error_dist_null.png", width=5, height=3)
```


```r
error_dist_null_sample = function(num_points) {
  true_intercept = 0
  true_slope = 0
  # We'll sample only for the scaling error case, we know IID works
  this_data = data.frame(IV = runif(num_points, -1, 1),
                         error = rnorm(num_points, 0, 1)) %>%
    mutate(DV = true_slope * IV + 2 * abs(IV) * error) # error increases proportional to distance from 0 on the IV
  
  coefficient_CI_data = ex2_lm_bootstrap_CIs(this_data,
                                             R = 200) # take fewer bootstrap samples, to speed things up
  
  coefficient_CI_data = coefficient_CI_data %>%
    gather(variable, value) %>%
    separate(variable, c("parameter", "measurement"), extra = "merge") %>%
    spread(measurement, value) %>%
    mutate(parametric_CI_low = estimate - 1.96 * SE,
           parametric_CI_hi = estimate + 1.96 * SE) %>%
    gather(CI_type, value, contains("CI")) %>%
    separate(CI_type, c("CI_type", "high_or_low"), extra = "merge") %>%
    spread(high_or_low, value) %>%
    mutate(significant = sign(CI_hi) == sign(CI_low)) %>%
    select(parameter, CI_type, significant)
  return(list(coefficient_CI_data))
}
```


```r
num_simulations = 100
num_points = 200
set.seed(0)
noise_dist_simulation_results = replicate(num_simulations, error_dist_null_sample(num_points)) %>%
  bind_rows()
```


```r
ggplot(noise_dist_simulation_results, aes(x = CI_type, fill = significant)) +
  geom_bar(stat = "count", color = "black") +
  scale_fill_brewer(palette = "Set1", direction = -1) +
  facet_wrap(~parameter) +
  scale_y_continuous(breaks = c(0, 0.05 * num_simulations, num_simulations),
                     labels = c("0%", expression(Nominal ~ alpha), "100%")) +
  labs(x = "Test type",
       y = "Proportion significant") +
  geom_hline(yintercept = 0.05 * num_simulations, linetype = 2)
```

![](15-bootstrapping_files/figure-latex/bootstrapping-32-1.pdf)<!-- --> 


```r
ggsave("figures/error_dist_proportion_significant.png", width=5, height=3)
```


```r
noise_dist_simulation_results %>%
  count(parameter, CI_type, significant) %>%
  mutate(prop=n/num_simulations)
```

```
## # A tibble: 8 x 5
##   parameter CI_type    significant     n  prop
##   <chr>     <chr>      <lgl>       <int> <dbl>
## 1 intercept boot       FALSE          97  0.97
## 2 intercept boot       TRUE            3  0.03
## 3 intercept parametric FALSE          97  0.97
## 4 intercept parametric TRUE            3  0.03
## 5 slope     boot       FALSE          98  0.98
## 6 slope     boot       TRUE            2  0.02
## 7 slope     parametric FALSE          88  0.88
## 8 slope     parametric TRUE           12  0.12
```

False positive rate nearly triples for the parametric model!

### Density estimate conceptual plot


```r
density_similarity_conceptual_plot_data = expand.grid(
  x = seq(0, 4, 0.01),
  y = seq(0, 4, 0.01)
) %>%
  mutate(
    population_1 = exp(-((x - 2)^2 + (y - 3)^2) / 8) * exp(-((x - 2 / y)^2 + (y - 1 / x)^2) / 2), # These are definitely not proper distributions
    population_2 = exp(-((x)^2 + (y)^2) / 8) * exp(-((x / 2)^2 + (y / 2 - 1 / x)^2) / 2)
  ) %>%
  gather(population, value, contains("population"))
```


```r
ggplot(
  density_similarity_conceptual_plot_data,
  aes(x = x, y = y, z = value, color = population)
) +
  geom_contour(size = 1, bins = 8) +
  scale_color_brewer(palette = "Dark2") +
  facet_wrap(~population) +
  labs(x = "Feature 1", y = "Feature 2") +
  guides(color = F)
```

![](15-bootstrapping_files/figure-latex/bootstrapping-36-1.pdf)<!-- --> 


```r
ggsave("figures/conceptual_density_plot.png", width=5, height=3)
```

## Bootstrap resampling

### Demo

```r
num_points = 100
true_intercept = 0
true_slope = 1.
set.seed(2) # I p-hacked the shit out of this demo to make the ideas more clear
parametric_ci_data = data.frame(
  IV = rep(runif(num_points, -1, 1), 2),
  type = rep(c("IID Error", "Scaling Error"), each = num_points),
  error = rep(rnorm(num_points, 0, 1), 2)
) %>%
  mutate(DV = ifelse(
    type == "IID Error",
    true_slope * IV + error,
    true_slope * IV + 2 * abs(IV) * error
  )) # error increases proportional to distance from 0 on the IV
```


```r
p = ggplot(parametric_ci_data,
           aes(x = IV, y = DV)) +
  geom_point(alpha = 0.25) +
  geom_smooth(method = "lm", se = F, color = "black",
              size = 1.5) +
  facet_wrap(~type)
p
```

![](15-bootstrapping_files/figure-latex/bootstrapping-39-1.pdf)<!-- --> 


```r
ggsave("figures/bootstrap_demo_0.png", width=5, height=3)
```


```r
set.seed(15) # See above RE: p-hacking
samp_1_indices = sample(2:num_points, num_points, replace = T)
samp_1 = parametric_ci_data[c(samp_1_indices, samp_1_indices + num_points), ] # take the same rows from each type of data

set.seed(2) # See above RE: p-hacking
samp_2_indices = sample(1:num_points, num_points, replace = T)
samp_2 = parametric_ci_data[c(samp_2_indices, samp_2_indices + num_points), ]

many_samples_indices = sample(1:num_points, 8 * num_points, replace = T)
many_samples = bind_rows(
  samp_1 %>%
    mutate(sample = 1),
  samp_2 %>% mutate(sample = 2),
  parametric_ci_data[c(many_samples_indices, many_samples_indices + num_points), ] %>%
    mutate(sample = rep(rep(3:10, each = num_points), 2))
)
```


```r
p +
  geom_point(
    data = samp_1,
    aes(color = NA), color = "red", alpha = 0.5
  )
```

![](15-bootstrapping_files/figure-latex/bootstrapping-42-1.pdf)<!-- --> 


```r
ggsave("figures/bootstrap_demo_1.png", width=5, height=3)
```


```r
p +
  geom_point(
    data = samp_1,
    aes(color = NA), color = "red", alpha = 0.5
  ) +
  geom_smooth(
    data = samp_1,
    method = "lm", se = F, color = "red",
    size = 1.5
  )
```

![](15-bootstrapping_files/figure-latex/bootstrapping-44-1.pdf)<!-- --> 


```r
ggsave("figures/bootstrap_demo_2.png", width=5, height=3)
```


```r
p + 
  geom_point(data=samp_2,
             aes(color=NA), color="red", alpha=0.5) 
```

![](15-bootstrapping_files/figure-latex/bootstrapping-46-1.pdf)<!-- --> 


```r
ggsave("figures/bootstrap_demo_3.png", width=5, height=3)
```



```r
p +
  geom_point(
    data = samp_2,
    aes(color = NA), color = "red", alpha = 0.5
  ) +
  geom_smooth(
    data = samp_2,
    method = "lm", se = F, color = "red",
    size = 1.5
  )
```

![](15-bootstrapping_files/figure-latex/bootstrapping-48-1.pdf)<!-- --> 


```r
ggsave("figures/bootstrap_demo_4.png", width=5, height=3)
```


```r
p +
  geom_smooth(
    data = many_samples,
    aes(group = sample),
    method = "lm", se = F,
    size = 1.5,
    color = "red"
  )
```

![](15-bootstrapping_files/figure-latex/bootstrapping-50-1.pdf)<!-- --> 


```r
ggsave("figures/bootstrap_demo_5.png", width=5, height=3)
```

## Applications

### Bootstrap confidence intervals


```r
num_top_points = 23
num_mid_points = 4
num_outlier_points = 2
max_score = 100
set.seed(0)
test_score_data = data.frame(
  score = c(rbinom(num_top_points, max_score, 0.9999),
            rbinom(num_mid_points, max_score, 0.97),
            sample(0:max_score, num_outlier_points, replace = T)),
  type = "Observed sample"
)
```


```r
get_mean_score = function(data, indices) {
  return(mean(data[indices,]$score))
}

bootstrap_results = boot(test_score_data, get_mean_score, R=100)
bootstrap_CIs = boot.ci(bootstrap_results)
```

```
## Warning in boot.ci(bootstrap_results): bootstrap variances needed for
## studentized intervals
```

```
## Warning in norm.inter(t, adj.alpha): extreme order statistics used as
## endpoints
```

```r
bootstrap_CIs
```

```
## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
## Based on 100 bootstrap replicates
## 
## CALL : 
## boot.ci(boot.out = bootstrap_results)
## 
## Intervals : 
## Level      Normal              Basic         
## 95%   ( 86.52, 102.43 )   ( 88.40, 103.45 )  
## 
## Level     Percentile            BCa          
## 95%   (84.75, 99.81 )   (84.00, 99.68 )  
## Calculations and Intervals on Original Scale
## Some basic intervals may be unstable
## Some percentile intervals may be unstable
## Warning : BCa Intervals used Extreme Quantiles
## Some BCa intervals may be unstable
```


```r
test_summary_data = test_score_data %>%
  summarise(
    mean = mean(score),
    se = sd(score) / sqrt(n()),
    parametric_CI_low = mean - 1.96 * se,
    parametric_CI_high = mean + 1.96 * se
  )

test_score_data = test_score_data %>%
  bind_rows(
    data.frame(score = bootstrap_results$t, type = "Boot. sampling dist.")
  ) %>%
  mutate(type = factor(type, levels = c("Observed sample", "Boot. sampling dist.")))
```

```
## Warning in bind_rows_(x, .id): Unequal factor levels: coercing to character
```

```
## Warning in bind_rows_(x, .id): binding character and factor vector,
## coercing into character vector

## Warning in bind_rows_(x, .id): binding character and factor vector,
## coercing into character vector
```

```r
test_summary_data = test_summary_data %>%
  mutate(
    type = factor("Boot. sampling dist.", levels = levels(test_score_data$type)),
    percentile_CI_low = bootstrap_CIs$percent[4],
    percentile_CI_high = bootstrap_CIs$percent[5],
    bca_CI_low = bootstrap_CIs$bca[4],
    bca_CI_high = bootstrap_CIs$bca[5]
  ) %>%
  gather(CI_type, value, contains("CI")) %>%
  separate(CI_type, c("CI_type", "endpoint"), extra = "merge") %>%
  spread(endpoint, value) %>%
  mutate(
    y = c(170, 210, 190),
    CI_type = factor(CI_type, levels = c("parametric", "percentile", "bca"), labels = c("Normal", "Boot: %", "Boot: BCA"))
  )
```


```r
ggplot(test_summary_data %>%
  filter(CI_type != "Boot: BCA"), aes(x = score)) +
  geom_histogram(
    data = test_score_data,
    binwidth = 1
  ) +
  geom_point(
    mapping = aes(x = mean, y = y, color = CI_type),
    size = 2
  ) +
  geom_errorbarh(
    mapping = aes(y = y, color = CI_type, xmin = CI_low, x = NULL, xmax = CI_high),
    size = 1,
    position = position_dodge()
  ) +
  facet_grid(type ~ ., scales = "free_y") +
  scale_color_brewer(palette = "Dark2") +
  guides(color = guide_legend(title = "CI"))
```

```
## Warning: position_dodge requires non-overlapping x intervals
```

![](15-bootstrapping_files/figure-latex/bootstrapping-55-1.pdf)<!-- --> 


```r
ggsave("figures/bootstrap_CI_0.png", width=5, height=3)
```

```
## Warning: position_dodge requires non-overlapping x intervals
```


```r
ggplot(test_summary_data, aes(x = score)) +
  geom_histogram(
    data = test_score_data,
    binwidth = 1
  ) +
  geom_point(
    mapping = aes(x = mean, y = y, color = CI_type),
    size = 2
  ) +
  geom_errorbarh(
    mapping = aes(y = y, color = CI_type, xmin = CI_low, x = NULL, xmax = CI_high),
    size = 1,
    position = position_dodge()
  ) +
  facet_grid(type ~ ., scales = "free_y") +
  scale_color_brewer(palette = "Dark2") +
  guides(color = guide_legend(title = "CI"))
```

```
## Warning: position_dodge requires non-overlapping x intervals
```

![](15-bootstrapping_files/figure-latex/bootstrapping-57-1.pdf)<!-- --> 

```r
ggsave("figures/bootstrap_CI_1.png", width = 5, height = 3)
```

```
## Warning: position_dodge requires non-overlapping x intervals
```

### Bootstrap (& permutation) hypothesis tests


```r
num_flips = 20
true_heads_prob = 0.9
set.seed(2)
flips = rbinom(num_flips, 1, true_heads_prob)
flip_data = data.frame(flip_result = factor(flips, labels = c("Tails", "Heads")))
```


```r
flip_data_plot = ggplot(data = flip_data, aes(x = flips, fill = flips)) +
  geom_dotplot(binwidth = 0.03) +
  scale_x_continuous(
    breaks = c(0, 1),
    labels = c("tails", "heads")
  ) +
  scale_y_continuous(breaks = c()) +
  labs(x = "Flip result", y = "")
```


```r
get_mean_heads = function(data, indices) {
  return(mean(data[indices, "flip_result"] == "Heads"))
}

set.seed(0)
bootstrap_results = boot(flip_data, get_mean_heads, R = 20000)
bootstrap_CIs = boot.ci(bootstrap_results)
```

```
## Warning in boot.ci(bootstrap_results): bootstrap variances needed for
## studentized intervals
```

```r
bootstrap_CIs
```

```
## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
## Based on 20000 bootstrap replicates
## 
## CALL : 
## boot.ci(boot.out = bootstrap_results)
## 
## Intervals : 
## Level      Normal              Basic         
## 95%   ( 0.6940,  1.0061 )   ( 0.7000,  1.0000 )  
## 
## Level     Percentile            BCa          
## 95%   ( 0.70,  1.00 )   ( 0.55,  0.95 )  
## Calculations and Intervals on Original Scale
```


```r
flip_boot_plot = ggplot(
  data = data.frame(mean_flips = bootstrap_results$t),
  aes(x = mean_flips)
) +
  geom_histogram(binwidth = 0.05) +
  xlim(0, 1) +
  geom_vline(
    xintercept = 0.5,
    color = "red",
    size = 1.1
  ) +
  annotate("text",
    label = "Null value",
    color = "red",
    x = 0.43, y = 2500,
    angle = 90,
    size = 4
  ) +
  annotate("text",
    label = "95% CI",
    color = "blue",
    x = 0.75, y = 5400,
    size = 4
  ) +
  geom_errorbarh(aes(
    xmin = bootstrap_CIs$bca[4],
    xmax = bootstrap_CIs$bca[5],
    y = 5100
  ),
  color = "blue",
  size = 1.1,
  height = 200
  ) +
  labs(x = "Boot. sampling dist.")

flip_boot_plot
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

![](15-bootstrapping_files/figure-latex/bootstrapping-61-1.pdf)<!-- --> 


```r
flip_data_plot + 
  flip_boot_plot +
  plot_layout()
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

![](15-bootstrapping_files/figure-latex/bootstrapping-62-1.pdf)<!-- --> 

```r
ggsave("figures/bootstrap_test.png", width = 5, height = 2.5)
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```


```r
bootstrap_CIs = boot.ci(bootstrap_results, conf = 0.999)
```

```
## Warning in boot.ci(bootstrap_results, conf = 0.999): bootstrap variances
## needed for studentized intervals
```

```
## Warning in norm.inter(t, adj.alpha): extreme order statistics used as
## endpoints
```

```r
flip_boot_plot = ggplot(
  data = data.frame(mean_flips = bootstrap_results$t),
  aes(x = mean_flips)
) +
  geom_histogram(binwidth = 0.05) +
  xlim(0, 1) +
  geom_vline(
    xintercept = 0.5,
    color = "red",
    size = 1.1
  ) +
  annotate("text",
    label = "Null value",
    color = "red",
    x = 0.43, y = 2500,
    angle = 90,
    size = 4
  ) +
  annotate("text",
    label = "99.9% CI",
    color = "blue",
    x = 0.75, y = 5400,
    size = 4
  ) +
  geom_errorbarh(aes(
    xmin = bootstrap_CIs$bca[4],
    xmax = bootstrap_CIs$bca[5],
    y = 5100
  ),
  color = "blue",
  size = 1.1,
  height = 200
  ) +
  labs(x = "Boot. sampling dist.")

flip_boot_plot
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

![](15-bootstrapping_files/figure-latex/bootstrapping-63-1.pdf)<!-- --> 


```r
flip_data_plot + flip_boot_plot +
  plot_layout()
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

![](15-bootstrapping_files/figure-latex/bootstrapping-64-1.pdf)<!-- --> 

```r
ggsave("figures/bootstrap_test_999.png", width=5, height=2.5)
```

```
## Warning: Removed 2 rows containing missing values (geom_bar).
```

<!--chapter:end:15-bootstrapping.Rmd-->

# Model comparison



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")      # for tidying up linear models 
library("pwr")        # for power analysis 
library("cowplot")    # for figure panels
library("modelr")     # for cross-validation
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Determining sample size 

### `pwr` package

Let's figure out how many participants we would need to get a power of $1-\beta = 0.8$ for testing an alternative hypothesis $H_1$ according to which a coin is biased to come up heads with $p = 0.75$ against a null hypothesis $H_0$ according to which the coin is far $p = 0.5$. Let's set our desired alpha level to $\alpha = .05$ and considered a one-tailed test. I'll use the `"pwr"` library to do determine the sample size. 


```r
pwr.p.test(h = ES.h(p1 = 0.75, p2 = 0.50),
           sig.level = 0.05,
           power = 0.80,
           alternative = "greater")
```

```
## 
##      proportion power calculation for binomial distribution (arcsine transformation) 
## 
##               h = 0.5235988
##               n = 22.55126
##       sig.level = 0.05
##           power = 0.8
##     alternative = greater
```

I first calculated the effect size using the `ES.h()` function providing the two proportions as arguments. Take a look at the help file for `ES.h()` to figure see how it's calculated. In short, the effect treats differences in proportions that are close to 0.5 different from ones that are close to the endpoints of the scale (i.e. 0 or 1). Intuitively, it's more impressive to change a probability from 0.9 to 1 than it would be to change a probability from 0.5 to 0.6. The effect size captures this. We find that to reach a power of 0.8 at a $\alpha = .05$ assuming a one-tailed test, we would need to run $n = 23$ participants. 

The `"pwr"` package also makes plots to illustrate how power changes with sample size: 


```r
pwr.p.test(h = ES.h(p1 = 0.75, p2 = 0.50), 
           sig.level = 0.05, 
           power = 0.80, 
           alternative = "greater") %>% 
  plot() +
  theme(title = element_text(size = 16))
```

![](16-model_comparison_files/figure-latex/model-comparison-05-1.pdf)<!-- --> 

### `map()`

The family of `map()` functions comes with the `"purrr"` package which is loaded as part of the tidyverse. It's a powerful function that allows us to avoid writing for-loops. Using the `map()` function makes otherwise complex procedures much simpler, allows for code that's easier to read, and that's much faster to run. 

Her are some examples of how `map()` works: 


```r
# using the formula notation with ~ 
map(.x = 1:3, .f = ~ .x^2)

# the same computation using an anonymous function
map(.x = 1:3, .f = function(.x) .x^2)

# outputs a vector
map_dbl(.x = 1:3, .f = ~ .x^2)

# using a function
square = function(x){x^2}
map_dbl(1:3, square)

# with multiple arguments
map2_dbl(.x = 1:3, .y = 1:3, .f = ~ .x * .y)
```

I encourage you to take a look at the purrr cheatsheet, as well as skimming the datacamp courses on functional programming (see [Additional Resources](#additional-resources) below). Mastering `map()` is a key step to becoming an R power user :) 

### via simulation

#### simple example 

Let's start with a simple example. We want to determine what power we have to correctly reject the $H_0$ according to which the coin is fair, for $H_1: p = 0.75$ with $\alpha = 0.05$ (one-tailed) and a sample size of $n = 10$.

Let's see: 


```r
# make example reproducible 
set.seed(1)

# parameters
p1 = 0.5
p2 = 0.75
alpha = 0.05
n_simulations = 100 
n = 10 

# set up the simulation grid 
df.pwr = crossing(sample_size = n,
                  n_simulations = 1:n_simulations,
                  p1 = p1,
                  p2 = p2,
                  alpha = alpha)

# draw random samples from the binomial distribution 
df.pwr = df.pwr %>% 
  mutate(n_heads = rbinom(n = n(),
                          size = sample_size, 
                          prob = p2))

# apply binomial test for each simulation and extract p-value 
df.pwr = df.pwr %>% 
  group_by(n_simulations) %>% 
  nest() %>% 
  mutate(binom_test = map(data, ~ binom.test(x = .$n_heads,
                                             n = .$sample_size,
                                             p = 0.5,
                                             alternative = "greater")),
         p_value = map(binom_test, ~ .$p.value))

# calculate the proportion with which the H0 would be rejected (= power)

df.pwr %>% 
  summarize(power = sum(p_value < .05) /n())
```

```
## # A tibble: 1 x 1
##   power
##   <dbl>
## 1  0.18
```

So, the results of this example show, that with $n = 10$ participants, we only have a power of .18 to reject the null hypothesis $H_0: p = 0.5$ when the alternative hypothesis $H_1: p = 0.75$ is true. Not an experiment we should run ... 


#### more advanced example

This more advanced example, which we discussed in class, calculates power for a different sample sizes (from $n = 10$ to $n = 50$), and for different alternative hypotheses $H_1: p = 0.75$, $H_1: p = 0.8$, and $H_1: p = 0.85$. I then figure out for what n we would get a power of 0.8 assuming $H_1: p = 0.75$. Otherwise, the procedure is identical to the simple example above. 


```r
# make reproducible 
set.seed(1)

# number of simulations
n_simulations = 200

# run simulation
df.power = crossing(n = seq(10, 50, 1),
                    simulation = 1:n_simulations,
                    p = c(0.75, 0.8, 0.85)) %>%
  mutate(index = 1:n()) %>% # add an index column
  mutate(response = rbinom(n = n(), size = n, prob = p)) %>% # generate random data
  group_by(index, simulation, p) %>% 
  nest() %>% # put data in list column
  mutate(fit = map(data, 
                   ~ binom.test(x = .$response, # define formula
                          n = .$n,
                          p = 0.5,
                          alternative = "greater")),
         p.value = map_dbl(fit, ~ .$p.value)) %>% # run binomial test and extract p-value
  unnest(data) %>% 
  select(-fit)
```

Let's visualze the relationship between power and sample size for the three alternative hypotheses:


```r
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
```

![](16-model_comparison_files/figure-latex/model-comparison-09-1.pdf)<!-- --> 

```r
# find optimal n based on simulations
df.plot %>%
  filter(p == 0.75, near(power, 0.8, tol = 0.01))
```

```
## # A tibble: 1 x 3
##       n p     power
##   <dbl> <fct> <dbl>
## 1    27 0.75  0.795
```

Let's compare with the solution that the `pwr` package gives.


```r
# analytic solution
pwr.p.test(h = ES.h(p1 = 0.75, p2 = 0.5),
           power = 0.8,
           sig.level = 0.05,
           alternative = "greater")
```

```
## 
##      proportion power calculation for binomial distribution (arcsine transformation) 
## 
##               h = 0.5235988
##               n = 22.55126
##       sig.level = 0.05
##           power = 0.8
##     alternative = greater
```

Pretty close! To get more accuracy in our simulation, we would simply need to increase the number of simulated statistical tests we perform to calculate power. 

## Model comparison 

In general, we want our models to explain the data we observed, and correctly predict future data. Often, there is a trade-off between how well the model fits the data we have (e.g. how much of the variance it explains), and how well the model will predict future data. If our model is too complex, then it will not only capture the systematicity in the data but also fit to the noise in the data. If our mdoel is too simple, however, it will not capture some of the systematicity that's actually present in the data. The goal, as always in statistical modeling, is to find a model that finds the sweet spot between simplicity and complexity. 

### Fitting vs. predicting

Let's illustrate the trad-off between complexity and simplicty for fitting vs. prediction. We generate data from a model of the following form: 

$$
Y_i = \beta_0 + \beta_1 \cdot X_i + \beta_2 + X_i^2 + \epsilon_i
$$
where 

$$
\epsilon_i \sim \mathcal{N}(\text{mean} = 0, ~\text{sd} = 20)
$$
Here, I'll use the following parameters: $\beta_0 = 10$, $\beta_1 = 3$, and $\beta_2 = 2$ to generate the data:


```r
set.seed(1)

n_plots = 3
n_samples = 20 # sample size 
n_parameters = c(1:4, seq(7, 19, length.out = 5)) # number of parameters in the polynomial regression

# generate data 
df.data = tibble(
  x = runif(n_samples, min = 0, max = 10), 
  y = 10 + 3 * x + 3 * x^2 + rnorm(n_samples, sd = 20)
)

# plotting function
plot_fit = function(i){
  # calculate RMSE
  rmse = lm(formula = y ~ poly(x, degree = i, raw = TRUE),
            data = df.data) %>% 
    augment() %>% 
    summarize(rmse = .resid^2 %>% 
                mean() %>% 
                sqrt() %>% 
                round(2))
    
  # make a plot
  ggplot(data = df.data,
             mapping = aes(x = x,
                           y = y)) +
    geom_point(size = 2) +
    geom_smooth(method = "lm", se = F,
                formula = y ~ poly(x, degree = i, raw = TRUE)) +
    annotate(geom = "text",
             x = Inf,
             y = -Inf,
             label = str_c("RMSE = ", rmse),
             hjust = 1.1,
             vjust = -0.3) + 
    theme(axis.ticks = element_blank(),
          axis.title = element_blank(),
          axis.text = element_blank())
}

# save plots in a list
l.p = map(n_parameters, plot_fit)

# make figure panel 
plot_grid(plotlist = l.p, ncol = 3)
```

```
## Warning in predict.lm(model, newdata = data.frame(x = xseq), se.fit = se, :
## prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, newdata = data.frame(x = xseq), se.fit = se, :
## prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, newdata = data.frame(x = xseq), se.fit = se, :
## prediction from a rank-deficient fit may be misleading
```

![](16-model_comparison_files/figure-latex/model-comparison-11-1.pdf)<!-- --> 

As we can see, RMSE becomes smaller and smaller the more parameters the model has to fit the data. But how does the RMSE look like for new data that is generated from the same underlying ground truth? 


```r
set.seed(1)

n_plots = 3
n_samples = 20 # sample size 
n_parameters = c(1:4, seq(7, 19, length.out = 5)) # number of parameters in the polynomial regression

# generate data 
df.data = tibble(
  x = runif(n_samples, min = 0, max = 10), 
  y = 10 + 3 * x + 3 * x^2 + rnorm(n_samples, sd = 20)
)

# generate some more data 
df.more_data = tibble(
  x = runif(50, min = 0, max = 10), 
  y = 10 + 3 * x + 3 * x^2 + rnorm(50, sd = 20)
)

# list for plots 
l.p = list()

# plotting function
plot_fit = function(i){
  # calculate RMSE for fitted data 
  fit = lm(formula = y ~ poly(x, degree = i, raw = TRUE),
            data = df.data)
  
  rmse = fit %>% 
    augment() %>% 
    summarize(rmse = .resid^2 %>% 
                mean() %>% 
                sqrt() %>% 
                round(2))
  
  # calculate RMSE for new data 
  rmse_new = fit %>% 
    augment(newdata = df.more_data) %>% 
    summarize(rmse = (y - .fitted)^2 %>% 
                mean() %>% 
                sqrt() %>% 
                round(2))
    
  # make a plot
  ggplot(data = df.data,
             mapping = aes(x = x,
                           y = y)) +
    geom_point(size = 2) +
    geom_point(data = df.more_data,
               size = 2, 
               color = "red") +
    geom_smooth(method = "lm", se = F,
                formula = y ~ poly(x, degree = i, raw = TRUE)) +
    annotate(geom = "text",
             x = Inf,
             y = -Inf,
             label = str_c("RMSE = ", rmse),
             hjust = 1.1,
             vjust = -0.3) + 
    annotate(geom = "text",
             x = Inf,
             y = -Inf,
             label = str_c("RMSE = ", rmse_new),
             hjust = 1.1,
             vjust = -2,
             color = "red") + 
    theme(axis.ticks = element_blank(),
          axis.title = element_blank(),
          axis.text = element_blank())
}

# map over the parameters
l.p = map(n_parameters, plot_fit)

# make figure panel 
plot_grid(plotlist = l.p, ncol = 3)
```

```
## Warning in predict.lm(model, newdata = data.frame(x = xseq), se.fit = se, :
## prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, newdata = data.frame(x = xseq), se.fit = se, :
## prediction from a rank-deficient fit may be misleading

## Warning in predict.lm(model, newdata = data.frame(x = xseq), se.fit = se, :
## prediction from a rank-deficient fit may be misleading
```

![](16-model_comparison_files/figure-latex/model-comparison-12-1.pdf)<!-- --> 

The RMSE in black shows the root mean squared error for the data that the model was fit on. The RMSE in red shows the RMSE on the new data. As you can see, the complex models do really poorly. They overfit the noise in the original data which leads to make poor predictions for new data. The simplest model (with two parameters) doesn't do particularly well either since it misses out on the quadratic trend in the data. Both the model with the quadratic term (top middle) and a model that includes a cubic term (top right) provide a good balance -- their RMSE on the new data is lowest. 

Let's generate another data set: 


```r
# make example reproducible 
set.seed(1)

# parameters
sample_size = 100
b0 = 1
b1 = 2
b2 = 3
sd = 0.5

# sample
df.data = tibble(
  participant = 1:sample_size,
  x = runif(sample_size, min = 0, max = 1),
  y = b0 + b1*x + b2*x^2 + rnorm(sample_size, sd = sd)
) 
```

And plot it: 


```r
ggplot(data = df.data,
       mapping = aes(x = x,
                    y = y)) + 
  geom_smooth(method = "lm",
              formula = y ~ x + I(x^2)) +
  geom_point()
```

![](16-model_comparison_files/figure-latex/model-comparison-14-1.pdf)<!-- --> 

### F-test 

Let's fit three models of increasing complexity to the data. The model which fits the way in which the data were generated has the following form: 

$$
\widehat Y_i = b_0 + b_1 \cdot X_i + b_2 \cdot X_i^2
$$


```r
# fit models to the data 
fit_simple = lm(y ~ 1 + x, data = df.data)
fit_correct = lm(y ~ 1 + x + I(x^2), data = df.data)
fit_complex = lm(y ~ 1 + x + I(x^2) + I(x^3), data = df.data)

# compare the models using an F-test 
anova(fit_simple, fit_correct)
```

```
## Analysis of Variance Table
## 
## Model 1: y ~ 1 + x
## Model 2: y ~ 1 + x + I(x^2)
##   Res.Df    RSS Df Sum of Sq      F    Pr(>F)    
## 1     98 25.297                                  
## 2     97 21.693  1    3.6039 16.115 0.0001175 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
anova(fit_correct, fit_complex)
```

```
## Analysis of Variance Table
## 
## Model 1: y ~ 1 + x + I(x^2)
## Model 2: y ~ 1 + x + I(x^2) + I(x^3)
##   Res.Df    RSS Df Sum of Sq      F Pr(>F)
## 1     97 21.693                           
## 2     96 21.643  1  0.050399 0.2236 0.6374
```

The F-test tells us that `fit_correct` explains significantly more variance than `fit_simple`, whereas `fit_complex` doesn't explain significantly more variance than `fit_correct`. 

But, as discussed in class, there are many situations in which we cannot use the F-test to compare models. Namely, whenever we want to compare unnested models where one models does not include all the predictors of the other model. But, we can still use cross-validation in this case. 

Let's take a look.

### Cross-validation 

Cross-validation is a powerful technique for finding the sweet spot between simplicity and complexity. Moreover, we can use cross-validation to compare models that we cannot compare using the F-test approach that we've been using up until now. 

There are many different kinds of cross-validation. All have the same idea in common though: 

- we first fit the model to a subset of the data, often called _training data_ 
- and then check how well the model captures the held-out data, often called _test data_

Different versions of cross-validation differ in how the training and test data sets are defined. We'll look at three different cross-validation techniques: 

1. Leave-on-out cross-validation
2. k-fold cross-validation
3. Monte Carlo cross-validation 

#### Leave-one-out cross-validation 

I've used code similar to this one to illustrate how LOO works in class. Here is a simple data set with 9 data points. We fit 9 models, where for each model, the training set includes one of the data points, and then we look at how well the model captures the held-out data point. We can then characterize the model's performance by calculating the mean squared error across the 9 runs. 


```r
# make example reproducible 
set.seed(1)

# sample
df.loo = tibble(
  x = 1:9,
  y = c(5, 2, 4, 10, 3, 4, 10, 2, 8)
) 

df.loo_cross = df.loo %>% 
  crossv_loo() %>% 
  mutate(fit = map(train, ~ lm(y ~ x, data = .)),
         tidy = map(fit, tidy)) %>% 
  unnest(tidy)

# original plot 
df.plot = df.loo %>% 
  mutate(color = 1)

# fit to all data except one 
fun.cv_plot = function(data_point){
  
  # determine which point to leave out 
  df.plot$color[data_point] = 2
  
  # fit 
  df.fit = df.plot %>% 
    filter(color != 2) %>% 
    lm(y ~ x, data = .) %>% 
    augment(newdata = df.plot[df.plot$color == 2,]) %>% 
    clean_names()
  
  p = ggplot(df.plot,
             aes(x, y, color = as.factor(color))) + 
    geom_segment(aes(xend = x,
                     yend = fitted),
                 data = df.fit,
                 color = "red",
                 size = 1) +
    geom_point(size = 2) +
    geom_smooth(method = "lm", se = F, color = "black", fullrange = T,
                data = df.plot %>% filter(color != 2))  +
    scale_color_manual(values = c("black", "red")) + 
    theme(legend.position = "none",
          axis.title = element_blank(),
          axis.ticks = element_blank(),
          axis.text = element_blank())
  return(p)
}

# save plots in list 
l.plots = map(1:9, fun.cv_plot)

# make figure panel 
plot_grid(plotlist = l.plots, ncol = 3)
```

![](16-model_comparison_files/figure-latex/model-comparison-16-1.pdf)<!-- --> 

As you can see, the regression line changes quite a bit depending on which data point is in the test set. 

Now, let's use LOO to evaluate the models on the data set I've created above: 


```r
# fit the models and calculate the RMSE for each model on the test set 
df.cross = df.data %>% 
  crossv_loo() %>% # function which generates training and test data sets 
  mutate(model_simple = map(train, ~ lm(y ~ 1 + x, data = .)),
         model_correct = map(train, ~ lm(y ~ 1 + x + I(x^2), data = .)),
         model_complex = map(train, ~ lm(y ~ 1 + x + I(x^2) + I(x^3), data = .))) %>% 
  gather("model", "fit", contains("model")) %>% 
  mutate(rmse = map2_dbl(fit, test, rmse))

# show the average RMSE for each model 
df.cross %>% 
  group_by(model) %>% 
  summarize(mean_rmse = mean(rmse) %>% round(3))
```

```
## # A tibble: 3 x 2
##   model         mean_rmse
##   <chr>             <dbl>
## 1 model_complex     0.382
## 2 model_correct     0.378
## 3 model_simple      0.401
```

As we can see, the `model_correct` has the lowest average RMSE on the test data. 

One downside with LOO is that it becomes unfeasible when the number of data points is very large, as the number of cross validation runs equals the number of data points. The next cross-validation procedures help in this case. 

#### k-fold cross-validation 

For k-fold cross-validation, we split the data set in k folds, and then use k-1 folds as the training set, and the remaining fold as the test set. 

The code is almost identical as before. Instead of `crossv_loo()`, we use the `crossv_kfold()` function instead and say how many times we want to "fold" the data. 


```r
# crossvalidation scheme 
df.cross = df.data %>% 
  crossv_kfold(k = 10) %>% 
  mutate(model_simple = map(train, ~ lm(y ~ 1 + x, data = .)),
         model_correct = map(train, ~ lm(y ~ 1 + x + I(x^2), data = .)),
         model_complex = map(train, ~ lm(y ~ 1 + x + I(x^2) + I(x^3), data = .))) %>% 
  gather("model", "fit", contains("model")) %>% 
  mutate(rsquare = map2_dbl(fit, test, rsquare))

df.cross %>% 
  group_by(model) %>% 
  summarize(median_rsquare = median(rsquare))
```

```
## # A tibble: 3 x 2
##   model         median_rsquare
##   <chr>                  <dbl>
## 1 model_complex          0.907
## 2 model_correct          0.906
## 3 model_simple           0.884
```

Note, for this example, I've calculated $R^2$ (the variance explained by each model) instead of RMSE -- just to show you that you can do this, too. Often it's useful to do both: show how well the model correlates, but also show the error. 

#### Monte Carlo cross-validation 

Finally, let's consider another very flexible version of cross-validation. For this version of cross-validation, we determine how many random splits into training set and test set we would like to do, and what proportion of the data should be in the test set. 


```r
# crossvalidation scheme 
df.cross = df.data %>% 
  crossv_mc(n = 50, test = 0.5) %>% # number of samples, and percentage of test 
  mutate(model_simple = map(train, ~ lm(y ~ 1 + x, data = .x)),
         model_correct = map(train, ~ lm(y ~ 1 + x + I(x^2), data = .x)),
         model_complex = map(train, ~ lm(y ~ 1 + x + I(x^2) + I(x^3), data = .))) %>% 
  gather("model", "fit", contains("model")) %>% 
  mutate(rmse = map2_dbl(fit, test, rmse))

df.cross %>% 
  group_by(model) %>% 
  summarize(mean_rmse = mean(rmse))
```

```
## # A tibble: 3 x 2
##   model         mean_rmse
##   <chr>             <dbl>
## 1 model_complex     0.493
## 2 model_correct     0.485
## 3 model_simple      0.513
```

In this example, I've asked for $n = 50$ splits and for each split, half of the data was in the training set, and half of the data in the test set. 

### Bootstrap 

We can also use the `modelr` package for bootstrapping. The idea is the same as when we did cross-validation. We create a number of data sets from our original data set. Instead of splitting the data set in a training and test data set, for bootstrapping, we sample values from the original data set with replacement. Doing so, we can, for example, calculate the confidence interval of different statistics of interest. 

Here is an example for how to boostrap confidence intervals for a mean. 


```r
# make example reproducible 
set.seed(1)

sample_size = 10 

# sample
df.data = tibble(
  participant = 1:sample_size,
  x = runif(sample_size, min = 0, max = 1)
) 

# mean of the actual sample
mean(df.data$x)
```

```
## [1] 0.5515139
```

```r
# bootstrap to get confidence intervals around the mean 
df.data %>%
  bootstrap(n = 1000) %>% # create 1000 boostrapped samples
  mutate(estimate = map_dbl(strap, ~ mean(.$data$x[.$idx]))) %>% # get the sample mean
  summarize(mean = mean(estimate),
            low = quantile(estimate, 0.025), # calculate the 2.5 / 97.5 percentiles
            high = quantile(estimate, 0.975))
```

```
## # A tibble: 1 x 3
##    mean   low  high
##   <dbl> <dbl> <dbl>
## 1 0.545 0.367 0.725
```

Note the somewhat weird construction `~ mean(.$data$x[.$idx]))`. This is just because the `bootstrap` function stores the information about each boostrapped data set in that way. Each boostrapped sample simply points to the original data set, and then uses a different set of indices `idx` to indicate which values from the original data set it sampled (with replacement). 

### AIC and BIC 

The Akaike Information Criterion (AIC) and the Bayesian Information Criterion (BIC) are defined as follows: 

$$
\text{AIC} = 2k-2\ln(\hat L)
$$

$$
\text{BIC} = \ln(n)k-2\ln(\hat L)
$$

where $k$ is the number of parameters in the model, $n$ is the number of observations, and $\hat L$ is the maximized value of the likelihood function of the model. Both AIC and BIC trade off model fit (as measured by the maximum likelihood of the data $\hat L$) and the number of parameters in the model. 

Calculating AIC and BIC in R is straightforward. We simply need to fit a linear model, and then call the `AIC()` or `BIC()` functions on the fitted model like so: 


```r
set.seed(0)

# let's generate some data 
df.example = tibble(
  x = runif(20, min = 0, max = 1),
  y = 1 + 3 * x + rnorm(20, sd = 2)
)

# fit a linear model 
fit = lm(formula = y ~ 1 + x,
         data = df.example)

# get AIC 
AIC(fit)
```

```
## [1] 75.47296
```

```r
# get BIC
BIC(fit)
```

```
## [1] 78.46016
```

We can also just use the `broom` package to get that information: 


```r
fit %>% 
  glance()
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared sigma statistic p.value    df logLik   AIC   BIC
##       <dbl>         <dbl> <dbl>     <dbl>   <dbl> <int>  <dbl> <dbl> <dbl>
## 1     0.255         0.214  1.45      6.16  0.0232     2  -34.7  75.5  78.5
## # ... with 2 more variables: deviance <dbl>, df.residual <int>
```

Both AIC and BIC take the number of parameters and the model's likelihood into account. BIC additionally considers the number of observations. But how is the likelihood of a linear model determined? 

Let's visualize the data first: 


```r
# plot the data with a linear model fit  
ggplot(df.example,
       aes(x, y)) + 
  geom_point(size = 2) +
  geom_smooth(method = "lm", color = "black")
```

![](16-model_comparison_files/figure-latex/model-comparison-23-1.pdf)<!-- --> 

Now, let's take a look at the residuals by plotting the fitted values on the x axis, and the residuals on the y axis. 


```r
# residual plot 
df.plot = df.example %>% 
  lm(y ~ x, data = .) %>% 
  augment() %>% 
  clean_names()

ggplot(df.plot,
       aes(fitted, resid)) + 
  geom_point(size = 2)
```

![](16-model_comparison_files/figure-latex/model-comparison-24-1.pdf)<!-- --> 

Remember that the linear model makes the assumption that the residuals are normally distributed with mean 0 (which is always the case if we fit a linear model) and some fitted standard deviation. In fact, the standard deviation of the normal distribution is fitted such that the overall likelihood of the data is maximized. 

Let's make a plot that shows a normal distribution alongside the residuals: 


```r
# define a normal distribution 
df.normal = tibble(
  y = seq(-5, 5, 0.1),
  x = dnorm(y, sd = 2) + 3.9
)

# show the residual plot together with the normal distribution
df.plot %>% 
  ggplot(aes(x = fitted, y = resid)) + 
  geom_point() +
  geom_path(data = df.normal,
            aes(x = x, y = y),
            size = 2)
```

![](16-model_comparison_files/figure-latex/model-comparison-25-1.pdf)<!-- --> 

To determine the likelihood of the data given the model $\hat L$, we now calculate the likelihood of each point (with the `dnorm()` function), and then multiply the likelihood of each data point to get the overall likelihood. We can simply multiply the data points since we also assume that the data points are independent. 
Instead of multiplying likelihoods, we often sum the log likelihoods instead. This is because if we multiply many small values, the overall value gets to close to 0 so that computers get confused. By taking logs instead, we avoid these nasty precision errors. 

To better understand AIC and BIC, let's calculate them by hand: 


```r
# we first get the estimate of the standard deviation of the residuals 
sigma = fit %>% 
  glance() %>% 
  pull(sigma)

# then we calculate the log likelihood of the model 
log_likelihood = fit %>% 
  augment() %>% 
  mutate(likelihood = dnorm(.resid, sd = sigma)) %>% 
  summarize(logLik = sum(log(likelihood))) %>% 
  as.numeric()

# then we calculate AIC and BIC using the formulas introduced above
aic = 2*3 - 2 * log_likelihood
bic = log(nrow(df.example)) * 3 - 2 * log_likelihood

print(aic)
```

```
## [1] 75.58017
```

```r
print(bic)
```

```
## [1] 78.56737
```

Cool! The values are the same as when we use the `glance()` function like so (except for a small difference due to rounding): 


```r
fit %>% 
  glance() %>% 
  select(AIC, BIC)
```

```
## # A tibble: 1 x 2
##     AIC   BIC
##   <dbl> <dbl>
## 1  75.5  78.5
```

#### log() is your friend 


```r
ggplot(data = tibble(x = c(0, 1)),
       mapping = aes(x = x)) + 
  stat_function(fun = "log",
                size = 1) +
  labs(x = "probability",
       y = "log(probability)") +
  theme(axis.text = element_text(size = 24),
        axis.title = element_text(size = 26))
```

![](16-model_comparison_files/figure-latex/model-comparison-28-1.pdf)<!-- --> 


## Additional resources 

### Cheatsheet 

- [purrr]("figures/purrr.pdf")

### Datacamp course

- [Foundations of Functional Programming with purrr](https://www.datacamp.com/courses/foundations-of-functional-programming-with-purrr)
- [Intermediate functional programming with purrr](https://www.datacamp.com/courses/intermediate-functional-programming-with-purrr)

### Reading 

- [R for Data Science: Chapter 25](https://r4ds.had.co.nz/many-models.html)

### Misc 

- [G*Power 3.1](http://www.gpower.hhu.de/): Software for power calculations

<!--chapter:end:16-model_comparison.Rmd-->

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
## 
## Call:
## lm(formula = y ~ 1 + x1 + x2, data = df.data)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -0.9290 -0.3084 -0.0716  0.2676  1.1659 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   0.9953     0.1395   7.133 1.77e-10 ***
## x1            0.4654     0.1817   2.561  0.01198 *  
## x2            0.5072     0.1789   2.835  0.00558 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.4838 on 97 degrees of freedom
## Multiple R-squared:  0.1327,	Adjusted R-squared:  0.1149 
## F-statistic: 7.424 on 2 and 97 DF,  p-value: 0.001
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

![](17-linear_mixed_effects_models1_files/figure-latex/lmer1-05-1.pdf)<!-- --> 

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
## Analysis of Variance Table
## 
## Model 1: y ~ 1
## Model 2: y ~ 1 + x1 + x2
##   Res.Df    RSS Df Sum of Sq      F Pr(>F)   
## 1     99 26.175                              
## 2     97 22.700  2    3.4746 7.4236  0.001 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
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
## Analysis of Variance Table
## 
## Model 1: y ~ 1 + x2
## Model 2: y ~ 1 + x1 + x2
##   Res.Df    RSS Df Sum of Sq     F  Pr(>F)  
## 1     98 24.235                             
## 2     97 22.700  1    1.5347 6.558 0.01198 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
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
```

```
## [1] "t_value: 2.56085255904998"
```

```r
# square root of f_value 
print(str_c("sqrt of f_value: ", sqrt(f_value)))
```

```
## [1] "sqrt of f_value: 2.56085255904998"
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
## Warning: `data_frame()` is deprecated, use `tibble()`.
## This warning is displayed once per session.
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

![](17-linear_mixed_effects_models1_files/figure-latex/lmer1-10-1.pdf)<!-- --> 

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
```

```
## 
## Call:
## lm(formula = value ~ condition, data = df.original)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -2.4100 -0.5530  0.1945  0.5685  1.4578 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept)   0.1905     0.2025   0.941    0.353
## condition2    0.1994     0.2864   0.696    0.491
## 
## Residual standard error: 0.9058 on 38 degrees of freedom
## Multiple R-squared:  0.01259,	Adjusted R-squared:  -0.0134 
## F-statistic: 0.4843 on 1 and 38 DF,  p-value: 0.4907
```

```r
t.test(df.original$value[df.original$condition == "1"],
       df.original$value[df.original$condition == "2"],
       alternative = "two.sided",
       paired = F
)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  df.original$value[df.original$condition == "1"] and df.original$value[df.original$condition == "2"]
## t = -0.69595, df = 37.99, p-value = 0.4907
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.7792396  0.3805339
## sample estimates:
## mean of x mean of y 
## 0.1905239 0.3898767
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
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ condition + (1 | participant)
##    Data: df.original
## 
## REML criterion at convergence: 17.3
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -1.55996 -0.36399 -0.03341  0.34400  1.65823 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 0.816722 0.90373 
##  Residual                0.003796 0.06161 
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  0.19052    0.20255   0.941
## condition2   0.19935    0.01948  10.231
## 
## Correlation of Fixed Effects:
##            (Intr)
## condition2 -0.048
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
## refitting model(s) with ML (instead of REML)
```

```
## Data: df.original
## Models:
## fit.compact: value ~ 1 + (1 | participant)
## fit.augmented: value ~ condition + (1 | participant)
##               Df    AIC    BIC   logLik deviance  Chisq Chi Df Pr(>Chisq)
## fit.compact    3 53.315 58.382 -23.6575   47.315                         
## fit.augmented  4 17.849 24.605  -4.9247    9.849 37.466      1  9.304e-10
##                  
## fit.compact      
## fit.augmented ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

This result is identical to running a paired samples t-test: 


```r
t.test(df.original$value[df.original$condition == "1"],
       df.original$value[df.original$condition == "2"],
       alternative = "two.sided",
       paired = T)
```

```
## 
## 	Paired t-test
## 
## data:  df.original$value[df.original$condition == "1"] and df.original$value[df.original$condition == "2"]
## t = -10.231, df = 19, p-value = 3.636e-09
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.2401340 -0.1585717
## sample estimates:
## mean of the differences 
##              -0.1993528
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

![](17-linear_mixed_effects_models1_files/figure-latex/lmer1-17-1.pdf)<!-- --> 

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

![](17-linear_mixed_effects_models1_files/figure-latex/lmer1-18-1.pdf)<!-- --> 

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

![](17-linear_mixed_effects_models1_files/figure-latex/lmer1-19-1.pdf)<!-- --> 

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

![](17-linear_mixed_effects_models1_files/figure-latex/lmer1-20-1.pdf)<!-- --> 

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
## refitting model(s) with ML (instead of REML)
```

```
## Data: df.original
## Models:
## fit.compact: value ~ 1 + condition
## fit.augmented: value ~ 1 + condition + (1 | participant)
##               Df     AIC     BIC  logLik deviance  Chisq Chi Df Pr(>Chisq)
## fit.compact    3 109.551 114.617 -51.775  103.551                         
## fit.augmented  4  17.849  24.605  -4.925    9.849 93.701      1  < 2.2e-16
##                  
## fit.compact      
## fit.augmented ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Yes, the likelihood of the data given the linear mixed effects model is significantly higher compared to its likelihood given the linear model. 

## Additional resources 

### Readings 

- [Linear mixed effects models tutorial by Bodo Winter](https://arxiv.org/pdf/1308.5499.pdf)

<!--chapter:end:17-linear_mixed_effects_models1.Rmd-->

# Linear mixed effects models 2

## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")    # for tidying up linear models 
library("patchwork")    # for making figure panels
library("lme4")    # for linear mixed effects models
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Things that came up in class 

### Difference between `replicate()` and `map()`

`replicate()` comes with base R whereas `map()` is part of the tidyverse. `map()` can do everything that `replicate()` can do and more. However, if you just want to run the same function (without changing the parameters) multiple times, you might as well use `replicate()`. 

Here are some examples for what you can do with `replicate()` and `map()`.


```r
# draw from a normal distribution and take mean
fun.normal_means = function(n, mean, sd){
  mean(rnorm(n = n, mean = mean, sd = sd))
}

# execute the function 4 times
replicate(n = 4, fun.normal_means(n = 20, mean = 1, sd = 0.5))
```

```
## [1] 0.9890719 0.9185493 1.0414970 1.1843926
```

```r
# same same but different 
map_dbl(.x = c(20, 20, 20, 20), ~ fun.normal_means(n = .x, mean = 1, sd = 0.5))
```

```
## [1] 0.9051688 1.0460964 1.0287334 0.8769381
```

```r
# and more flexible
map_dbl(.x = c(1, 1, 10, 10), ~ fun.normal_means(n = 20, mean = .x, sd = 0.5))
```

```
## [1]  0.9455255  0.9521051  9.9983295 10.0362489
```

## Simulating a linear mixed effects model 

To generate some data for a linear mixed effects model with random intercepts, we do pretty much what we are used to doing when we generated data for a linear model. However, this time, we have an additional parameter that captures the variance in the intercepts between participants. So, we draw a separate (offset from the global) intercept for each participant from this distribution.  


```r
# make example reproducible 
set.seed(1)

# parameters
sample_size = 100
b0 = 1
b1 = 2
sd_residual = 1
sd_participant = 0.5 

# randomly draw intercepts for each participant
intercepts = rnorm(sample_size, sd = sd_participant)

# generate the data 
df.mixed = tibble(
  condition = rep(0:1, each = sample_size), 
  participant = rep(1:sample_size, 2)) %>% 
  group_by(condition) %>% 
  mutate(value = b0 + b1 * condition + intercepts + rnorm(n(), sd = sd_residual)) %>% 
  ungroup %>% 
  mutate(condition = as.factor(condition),
         participant = as.factor(participant))
```

Let's fit a model to this data now and take a look at the summary output: 


```r
# fit model
fit.mixed = lmer(formula = value ~ 1 + condition + (1 | participant),
                data = df.mixed)

fit.mixed %>% 
  summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + condition + (1 | participant)
##    Data: df.mixed
## 
## REML criterion at convergence: 606
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -2.53710 -0.62295 -0.04364  0.67035  2.19899 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 0.1607   0.4009  
##  Residual                1.0427   1.0211  
## Number of obs: 200, groups:  participant, 100
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   1.0166     0.1097   9.267
## condition1    2.0675     0.1444  14.317
## 
## Correlation of Fixed Effects:
##            (Intr)
## condition1 -0.658
```

Let's visualize the model's predictions: 


```r
fit.mixed %>%
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

![](18-linear_mixed_effects_models2_files/figure-latex/lmer2-06-1.pdf)<!-- --> 

Let's simulate some data from this fitted model: 


```r
# simulated data 
fit.mixed %>% 
  simulate() %>% 
  bind_cols(df.mixed) %>% 
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

![](18-linear_mixed_effects_models2_files/figure-latex/lmer2-07-1.pdf)<!-- --> 

Even though we only fitted random intercepts in this model, when we simulate from the model, we get different slopes since, when simulating new data, the model takes our uncertainty in the residuals into account as well. 

Let's see whether fitting random intercepts was worth it in this case: 


```r
# using chisq test
fit.compact = lm(formula = value ~ 1 +  condition,
                data = df.mixed)

fit.augmented = lmer(formula = value ~ 1 + condition +  (1 | participant),
                data = df.mixed)

anova(fit.augmented, fit.compact)
```

```
## refitting model(s) with ML (instead of REML)
```

```
## Data: df.mixed
## Models:
## fit.compact: value ~ 1 + condition
## fit.augmented: value ~ 1 + condition + (1 | participant)
##               Df   AIC    BIC logLik deviance  Chisq Chi Df Pr(>Chisq)
## fit.compact    3 608.6 618.49 -301.3    602.6                         
## fit.augmented  4 608.8 621.99 -300.4    600.8 1.7999      1     0.1797
```

Nope, it's not worth it in this case. That said, even though having random intercepts does not increase the likelihood of the data given the model significantly, we should still include random intercepts to capture the dependence in the data. 

## The effect of outliers 

Let's take 20 participants from our `df.mixed` data set, and make one of the participants be an outlier: 


```r
# let's make one outlier
df.outlier = df.mixed %>%
  mutate(participant = participant %>% as.character() %>% as.numeric()) %>% 
  filter(participant <= 20) %>% 
  mutate(value = ifelse(participant == 20, value + 30, value),
         participant = as.factor(participant))
```

Let's fit the model and look at the summary: 


```r
# fit model
fit.outlier = lmer(formula = value ~ 1 + condition + (1 | participant),
                   data = df.outlier)

fit.outlier %>% 
  summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + condition + (1 | participant)
##    Data: df.outlier
## 
## REML criterion at convergence: 192
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -1.44598 -0.48367  0.03043  0.44689  1.41232 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 45.1359  6.7183  
##  Residual                 0.6738  0.8209  
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   2.7091     1.5134   1.790
## condition1    2.1512     0.2596   8.287
## 
## Correlation of Fixed Effects:
##            (Intr)
## condition1 -0.086
```

The variance for the participants' intercepts has increased dramatically! 

Let's visualize the data together with the model's predictions: 


```r
fit.outlier %>%
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

![](18-linear_mixed_effects_models2_files/figure-latex/lmer2-11-1.pdf)<!-- --> 

The model is still able to capture the participants quite well. But note what its simulated data looks like now: 


```r
# simulated data from lmer with outlier
fit.outlier %>% 
  simulate() %>% 
  bind_cols(df.outlier) %>% 
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

![](18-linear_mixed_effects_models2_files/figure-latex/lmer2-12-1.pdf)<!-- --> 

The simulated data doesn't look like our original data. This is because one normal distribution is used to model the variance in the intercepts between participants. 

## Different slopes 

Let's generate data where the effect of condition is different for participants: 


```r
# make example reproducible 
set.seed(1)

tmp = rnorm(n = 20)

df.slopes = tibble(
  condition = rep(1:2, each = 20), 
  participant = rep(1:20, 2),
  value = ifelse(condition == 1, tmp,
                 mean(tmp) + rnorm(n = 20, sd = 0.3)) # regression to the mean
) %>% 
  mutate(condition = as.factor(condition),
         participant = as.factor(participant))
```

Let's fit a model with random intercepts. 


```r
fit.slopes = lmer(formula = value ~ 1 + condition + (1 | participant),
                data = df.slopes)
```

```
## boundary (singular) fit: see ?isSingular
```

```r
fit.slopes %>% summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + condition + (1 | participant)
##    Data: df.slopes
## 
## REML criterion at convergence: 83.6
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -3.5808 -0.3184  0.0130  0.4551  2.0913 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 0.0000   0.0000  
##  Residual                0.4512   0.6717  
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##              Estimate Std. Error t value
## (Intercept)  0.190524   0.150197   1.268
## condition2  -0.001941   0.212411  -0.009
## 
## Correlation of Fixed Effects:
##            (Intr)
## condition2 -0.707
## convergence code: 0
## boundary (singular) fit: see ?isSingular
```

Note how the summary says "singular fit", and how the variance for random intercepts is 0. Here, fitting random intercepts did not help the model fit at all, so the lmer gave up ... 

How about fitting random slopes? 


```r
# fit model
lmer(formula = value ~ 1 + condition + (1 + condition | participant),
     data = df.slopes)
```

This won't work because the model has more parameters than there are data points. To fit random slopes, we need more than 2 observations per participants. 

## Simpson's paradox 

Taking dependence in the data into account is extremely important. The Simpson's paradox is an instructive example for what can go wrong when we ignore the dependence in the data. 

Let's start by simulating some data to demonstrate the paradox. 


```r
# make example reproducible 
set.seed(2)

n_participants = 20
n_observations = 10
slope = -10 
sd_error = 0.4
sd_participant = 5
intercept = rnorm(n_participants, sd = sd_participant) %>% sort()

df.simpson = tibble(x = runif(n_participants * n_observations, min = 0, max = 1)) %>%
  arrange(x) %>% 
  mutate(intercept = rep(intercept, each = n_observations),
         y = intercept + x * slope + rnorm(n(), sd = sd_error),
         participant = factor(intercept, labels = 1:n_participants))
```

Let's visualize the overall relationship between `x` and `y` with a simple linear model. 


```r
# overall effect 
ggplot(data = df.simpson,
       mapping = aes(x = x,
                     y = y)) +
  geom_point() +
  geom_smooth(method = "lm",
              color = "black")
```

![](18-linear_mixed_effects_models2_files/figure-latex/lmer2-17-1.pdf)<!-- --> 

As we see, overall, there is a positive relationship between `x` and `y`.


```r
lm(formula = y ~ x,
   data = df.simpson) %>% 
  summary()
```

```
## 
## Call:
## lm(formula = y ~ x, data = df.simpson)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -5.8731 -0.6362  0.2272  1.0051  2.6410 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  -7.1151     0.2107  -33.76   <2e-16 ***
## x             6.3671     0.3631   17.54   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.55 on 198 degrees of freedom
## Multiple R-squared:  0.6083,	Adjusted R-squared:  0.6064 
## F-statistic: 307.5 on 1 and 198 DF,  p-value: < 2.2e-16
```

And this relationship is significant. 

Let's take another look at the data use different colors for the different participants.


```r
# effect by participant 
ggplot(data = df.simpson,
       mapping = aes(x = x,
                     y = y,
                     color = participant)) +
  geom_point() +
  geom_smooth(method = "lm",
              color = "black") +
  theme(legend.position = "none")
```

![](18-linear_mixed_effects_models2_files/figure-latex/lmer2-19-1.pdf)<!-- --> 

And let's fit a different regression for each participant:


```r
# effect by participant 
ggplot(data = df.simpson,
       mapping = aes(x = x,
                     y = y,
                     color = participant,
                     group = participant)) +
  geom_point() +
  geom_smooth(method = "lm",
              color = "black") +
  theme(legend.position = "none")
```

![](18-linear_mixed_effects_models2_files/figure-latex/lmer2-20-1.pdf)<!-- --> 

What this plot shows, is that for almost all individual participants, the relationship between `x` and `y` is negative. The different participants where along the `x` spectrum they are. 

Let's fit a linear mixed effects model with random intercepts: 


```r
fit.lmer = lmer(formula = y ~ 1 + x + (1 | participant),
     data = df.simpson)

fit.lmer %>% 
  summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: y ~ 1 + x + (1 | participant)
##    Data: df.simpson
## 
## REML criterion at convergence: 345.1
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -2.43394 -0.59687  0.04493  0.62694  2.68828 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 21.4898  4.6357  
##  Residual                 0.1661  0.4075  
## Number of obs: 200, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  -0.1577     1.3230  -0.119
## x            -7.6678     1.6572  -4.627
## 
## Correlation of Fixed Effects:
##   (Intr)
## x -0.621
```

As we can see, the fixed effect for `x` is now negative! 


```r
fit.lmer %>% 
  augment() %>% 
  clean_names() %>% 
  ggplot(data = .,
         aes(x = x,
             y = y,
             group = participant,
             color = participant)) +
  geom_point() +
  geom_line(aes(y = fitted),
            size = 1,
            color = "black") +
  theme(legend.position = "none")
```

![](18-linear_mixed_effects_models2_files/figure-latex/lmer2-22-1.pdf)<!-- --> 

Lesson learned: taking dependence into account is critical for drawing correct inferences! 

## Additional resources 

### Readings 

- [Linear mixed effects models tutorial by Bodo Winter](https://arxiv.org/pdf/1308.5499.pdf)
- [Simpson's paradox](https://paulvanderlaken.com/2017/09/27/simpsons-paradox-two-hr-examples-with-r-code/)
- [Tutorial on pooling](https://www.tjmahr.com/plotting-partial-pooling-in-mixed-effects-models/)

<!--chapter:end:18-linear_mixed_effects_models2.Rmd-->

# Linear mixed effects models 3



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")    # for tidying up linear models 
library("patchwork")    # for making figure panels
library("lme4")    # for linear mixed effects models
library("modelr")    # for bootstrapping
library("boot")    # also for bootstrapping
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Load data set 


```r
# load sleepstudy data set 
df.sleep = sleepstudy %>% 
  as_tibble() %>% 
  clean_names() %>% 
  mutate(subject = as.character(subject)) %>% 
  select(subject, days, reaction)
```


```r
# add two fake participants (with missing data)
df.sleep = df.sleep %>% 
  bind_rows(
    tibble(subject = "374",
           days = 0:1,
           reaction = c(286, 288)),
    tibble(subject = "373",
           days = 0,
           reaction = 245)
  )
```

## Things that came up in class 

### One-tailed vs. two-tailed tests

#### t distribution

Some code to draw a t-distribution: 


```r
tibble(x = c(-4, 4)) %>% 
  ggplot(data = ., 
         mapping = aes(x = x)) + 
  stat_function(fun = "dt",
                args = list(df = 20),
                size = 1,
                geom = "area",
                fill = "red",
                # xlim = c(qt(0.95, df = 20), qt(0.999, df = 20))) +
                # xlim = c(qt(0.001, df = 20), qt(0.05, df = 20))) +
                xlim = c(qt(0.001, df = 20), qt(0.025, df = 20))) +
  stat_function(fun = "dt",
                args = list(df = 20),
                size = 1,
                geom = "area",
                fill = "red",
                xlim = c(qt(0.975, df = 20), qt(0.999, df = 20))) +
  stat_function(fun = "dt",
                args = list(df = 20),
                size = 1) +
  coord_cartesian(expand = F)
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-06-1.pdf)<!-- --> 

#### F distribution

Some code to draw an F-distribution


```r
tibble(x = c(0, 5)) %>% 
  ggplot(data = ., 
         mapping = aes(x = x)) +
  stat_function(fun = "df",
                args = list(df1 = 100, df2 = 10),
                size = 1,
                geom = "area",
                fill = "red",
                xlim = c(qf(0.95, df1 = 100, df2 = 10), qf(0.999, df1 = 100, df2 = 10))) +
  stat_function(fun = "df",
                args = list(df1 = 100, df2 = 10),
                size = 1) +
  coord_cartesian(expand = F)
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-07-1.pdf)<!-- --> 

### Mixtures of participants 

What if we have groups of participants who differ from each other? Let's generate data for which this is the case.


```r
# make example reproducible 
set.seed(1)

sample_size = 20
b0 = 1
b1 = 2
sd_residual = 0.5
sd_participant = 0.5
mean_group1 = 1
mean_group2 = 10

df.mixed = tibble(
  condition = rep(0:1, each = sample_size), 
  participant = rep(1:sample_size, 2)) %>% 
  group_by(participant) %>% 
  mutate(group = sample(1:2, size = 1),
         intercept = ifelse(group == 1,
                            rnorm(n(), mean = mean_group1, sd = sd_participant),
                            rnorm(n(), mean = mean_group2, sd = sd_participant))) %>% 
  group_by(condition) %>% 
  mutate(value = b0 + b1 * condition + intercept + rnorm(n(), sd = sd_residual)) %>% 
  ungroup %>% 
  mutate(condition = as.factor(condition),
         participant = as.factor(participant))
```

#### Ignoring mixture

Let' first fit a model that ignores the fact that there are two different groups of participatns. 


```r
# fit model
fit.mixed = lmer(formula = value ~ 1 + condition + (1 | participant),
                data = df.mixed)

fit.mixed %>% summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + condition + (1 | participant)
##    Data: df.mixed
## 
## REML criterion at convergence: 165.6
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -1.6437 -0.4510 -0.0246  0.4987  1.5265 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 21.5142  4.6383  
##  Residual                 0.3521  0.5934  
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)   7.2229     1.0456   6.908
## condition1    1.6652     0.1876   8.875
## 
## Correlation of Fixed Effects:
##            (Intr)
## condition1 -0.090
```

Let's look at the model's predictions: 


```r
fit.mixed %>%
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

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-10-1.pdf)<!-- --> 


And let's simulate some data from the fitted model: 


```r
# simulated data 
fit.mixed %>%
  simulate() %>%
  bind_cols(df.mixed) %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-11-1.pdf)<!-- --> 

As we can see, the simulated data doesn't look like the data that was used to fit the model.  

#### Modeling mixture

Now, let's fit a model that takes the differences between groups into account by adding a fixed effect for `group`.


```r
# fit model
fit.grouped = lmer(formula = value ~ 1 + group + condition + (1 | participant),
                data = df.mixed)

fit.grouped %>% summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + group + condition + (1 | participant)
##    Data: df.mixed
## 
## REML criterion at convergence: 83.7
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -1.56168 -0.69876  0.05887  0.50419  2.30259 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 0.1147   0.3387  
##  Residual                0.3521   0.5934  
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept)  -6.8299     0.4055 -16.842
## group         9.0663     0.2424  37.409
## condition1    1.6652     0.1876   8.875
## 
## Correlation of Fixed Effects:
##            (Intr) group 
## group      -0.926       
## condition1 -0.231  0.000
```

Note how the variance of the random intercepts is much smaller now that we've taken the group structure in the data into account. 

Let's visualize the model's predictions:


```r
fit.grouped %>%
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

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-13-1.pdf)<!-- --> 

And simulate some data from the model: 


```r
# simulated data 
fit.grouped %>%
  simulate() %>%
  bind_cols(df.mixed) %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-14-1.pdf)<!-- --> 

This time, the simulated data looks much more like the data that was used to fit the model. Yay! 

#### Heterogeneity in variance

The example above has shown that we can take overall differences between groups into account by adding a fixed effect. Can we also deal with heterogeneity in variance between groups? For example, what if the responses of one group exhibit much more variance than the responses of another group? 

Let's first generate some data with heterogeneous variance: 


```r
# make example reproducible 
set.seed(1)

sample_size = 20
b0 = 1
b1 = 2
sd_residual = 0.5
mean_group1 = 1
sd_group1 = 1
mean_group2 = 30
sd_group2 = 10

df.variance = tibble(
  condition = rep(0:1, each = sample_size), 
  participant = rep(1:sample_size, 2)) %>% 
  group_by(participant) %>% 
  mutate(group = sample(1:2, size = 1),
         intercept = ifelse(group == 1,
                            rnorm(n(), mean = mean_group1, sd = sd_group1),
                            rnorm(n(), mean = mean_group2, sd = sd_group2))) %>% 
  group_by(condition) %>% 
  mutate(value = b0 + b1 * condition + intercept + rnorm(n(), sd = sd_residual)) %>% 
  ungroup %>% 
  mutate(condition = as.factor(condition),
         participant = as.factor(participant))
```

Let's fit the model: 


```r
# fit model
fit.variance = lmer(formula = value ~ 1 + group + condition + (1 | participant),
                data = df.variance)

fit.variance %>% summary()
```

```
## Linear mixed model fit by REML ['lmerMod']
## Formula: value ~ 1 + group + condition + (1 | participant)
##    Data: df.variance
## 
## REML criterion at convergence: 250
## 
## Scaled residuals: 
##      Min       1Q   Median       3Q      Max 
## -2.70344 -0.21278  0.07355  0.43873  1.39493 
## 
## Random effects:
##  Groups      Name        Variance Std.Dev.
##  participant (Intercept) 17.60    4.196   
##  Residual                26.72    5.169   
## Number of obs: 40, groups:  participant, 20
## 
## Fixed effects:
##             Estimate Std. Error t value
## (Intercept) -26.5805     4.1525  -6.401
## group        29.6200     2.5010  11.843
## condition1    0.1853     1.6346   0.113
## 
## Correlation of Fixed Effects:
##            (Intr) group 
## group      -0.934       
## condition1 -0.197  0.000
```

Look at the data and model predictions: 


```r
fit.variance %>%
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

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-17-1.pdf)<!-- --> 

And the simulated data: 


```r
# simulated data 
fit.mixed %>%
  simulate() %>%
  bind_cols(df.mixed) %>%
  ggplot(data = .,
         mapping = aes(x = condition,
                       y = sim_1,
                       group = participant)) +
  geom_line(alpha = 0.5) +
  geom_point(alpha = 0.5)
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-18-1.pdf)<!-- --> 

The lmer() fails here. It uses one normal distribution to model the variance between participants. It cannot account for the fact that the answers of one groups of participants vary more than the answers from another groups of participants. Again, the simulated data doesn't look the original data, even though we did take the grouping into account. 

## Pooling and shrinkage 

Let's illustrate the concept of pooling and shrinkage via the sleep data set that comes with the lmer package. We've already loaded the data set into our environment as `df.sleep`. 

Let's start by visualizing the data 


```r
# visualize the data
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-19-1.pdf)<!-- --> 

The plot shows the effect of the number of days of sleep deprivation on the average reaction time (presumably in an experiment). Note that for participant 373 and 374 we only have one and two data points respectively. 

### Complete pooling 

Let's first fit a model the simply combines all the data points. This model ignores the dependence structure in the data (i.e. the fact that we have repeated observations from the same participants). 


```r
fit.complete = lm(formula = reaction ~ days,
                  data = df.sleep)

fit.params = tidy(fit.complete)

fit.complete %>% 
  summary()
```

```
## 
## Call:
## lm(formula = reaction ~ days, data = df.sleep)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -110.646  -27.951    1.829   26.388  139.875 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  252.321      6.406  39.389  < 2e-16 ***
## days          10.328      1.210   8.537 5.48e-15 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 47.43 on 181 degrees of freedom
## Multiple R-squared:  0.2871,	Adjusted R-squared:  0.2831 
## F-statistic: 72.88 on 1 and 181 DF,  p-value: 5.484e-15
```

And let's visualize the predictions of this model.


```r
# visualization (aggregate) 
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_abline(intercept = fit.params$estimate[1],
              slope = fit.params$estimate[2],
              color = "blue") +
  geom_point() +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-21-1.pdf)<!-- --> 

And here is what the model's predictions look like separated by participant.


```r
# visualization (separate participants) 
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_abline(intercept = fit.params$estimate[1],
              slope = fit.params$estimate[2],
              color = "blue") +
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-22-1.pdf)<!-- --> 

The model predicts the same relationship between sleep deprivation and reaction time for each participant (not surprising since we didn't even tell the model that this data is based on different participants). 

### No pooling 

We could also fit separate regressions for each participant. Let's do that.


```r
# fit regressions and extract parameter estimates 
df.no_pooling = df.sleep %>% 
  group_by(subject) %>% 
  nest(days, reaction) %>% 
  mutate(fit = map(data, ~ lm(reaction ~ days, data = .)),
         params = map(fit, tidy)) %>% 
  unnest(params) %>% 
  select(subject, term, estimate) %>% 
  complete(subject, term, fill = list(estimate = 0)) %>% 
  spread(term, estimate) %>% 
  clean_names()
```

And let's visualize what the predictions of these separate regressions would look like: 


```r
ggplot(data = df.sleep,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_abline(data = df.no_pooling %>% 
                filter(subject != 373),
              aes(intercept = intercept,
                  slope = days),
              color = "blue") +
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-24-1.pdf)<!-- --> 

When we fit separate regression, no information is shared between participants. 

### Partial pooling 

By usign linear mixed effects models, we are partially pooling information. That is, the estimates for one participant are influenced by the rest of the participants.

We'll fit a number of mixed effects models that differ in their random effects structure. 

#### Random intercept and random slope

This model allows for random differences in the intercepts and slopes between subjects (and also models the correlation between intercepts and slopes). 

Let's fit the model


```r
fit.random_intercept_slope = lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                                  data = df.sleep)
```

and take a look at the model's predictions: 


```r
fit.random_intercept_slope %>% 
  augment() %>% 
  clean_names() %>% 
ggplot(data = .,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_line(aes(y = fitted),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-26-1.pdf)<!-- --> 

As we can see, the lines for each participant are different. We've allowed for the intercept as well as the relationship between sleep deprivation and reaction time to be different between participants. 

#### Only random intercepts 

Let's fit a model that only allows for the intercepts to vary between participants. 


```r
fit.random_intercept = lmer(formula = reaction ~ 1 + days + (1 | subject),
                            data = df.sleep)
```

And let's visualize what these predictions look like: 


```r
fit.random_intercept %>% 
  augment() %>% 
  clean_names() %>% 
ggplot(data = .,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_line(aes(y = fitted),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-28-1.pdf)<!-- --> 

Now, all the lines are parallel but the intercept differs between participants. 

#### Only random slopes 

Finally, let's compare a model that only allows for the slopes to differ but not the intercepts. 


```r
fit.random_slope = lmer(formula = reaction ~ 1 + days + (0 + days | subject),
                        data = df.sleep)
```

And let's visualize the model fit: 


```r
fit.random_slope %>% 
  augment() %>% 
  clean_names() %>% 
ggplot(data = .,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_line(aes(y = fitted),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## geom_path: Each group consists of only one observation. Do you need to
## adjust the group aesthetic?
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-30-1.pdf)<!-- --> 

Here, all the lines have the same starting point (i.e. the same intercept) but the slopes are different. 

### Compare results 

Let's compare the results of the different methods -- complete pooling, no pooling, and partial pooling (with random intercepts and slopes). 


```r
# complete pooling
fit.complete_pooling = lm(formula = reaction ~ days,
                          data = df.sleep)  

df.complete_pooling =  fit.complete_pooling %>% 
  augment() %>% 
  bind_rows(
    fit.complete_pooling %>% 
      augment(newdata = tibble(subject = c("373", "374"),
                               days = rep(10, 2)))
  ) %>% 
  clean_names() %>% 
  select(reaction, days, complete_pooling = fitted)

# no pooling
df.no_pooling = df.sleep %>% 
  group_by(subject) %>% 
  nest(days, reaction) %>% 
  mutate(fit = map(data, ~ lm(reaction ~ days, data = .)),
         augment = map(fit, augment)) %>% 
  unnest(augment) %>% 
  clean_names() %>% 
  select(subject, reaction, days, no_pooling = fitted)

# partial pooling
fit.lmer = lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                data = df.sleep) 

df.partial_pooling = fit.lmer %>% 
  augment() %>% 
  bind_rows(
    fit.lmer %>% 
      augment(newdata = tibble(subject = c("373", "374"),
                               days = rep(10, 2)))
  ) %>% 
  clean_names() %>% 
  select(subject, reaction, days, partial_pooling = fitted)

# combine results
df.pooling = df.partial_pooling %>% 
  left_join(df.complete_pooling) %>% 
  left_join(df.no_pooling)
```

Let's compare the predictions of the different models visually: 


```r
ggplot(data = df.pooling,
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_smooth(method = "lm",
              se = F,
              color = "orange",
              fullrange = T) + 
  geom_line(aes(y = complete_pooling),
            color = "green") + 
  geom_line(aes(y = partial_pooling),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject, ncol = 5) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## Warning: Removed 4 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 4 rows containing missing values (geom_point).
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-32-1.pdf)<!-- --> 

To better see the differences between the approaches, let's focus on the predictions for the participants with incomplete data: 


```r
# subselection
ggplot(data = df.pooling %>% 
         filter(subject %in% c("373", "374")),
       mapping = aes(x = days,
                     y = reaction)) + 
  geom_smooth(method = "lm",
              se = F,
              color = "orange",
              fullrange = T) + 
  geom_line(aes(y = complete_pooling),
            color = "green") + 
  geom_line(aes(y = partial_pooling),
            color = "blue") + 
  geom_point() +
  facet_wrap(~subject) +
  labs(x = "Days of sleep deprivation", 
       y = "Average reaction time (ms)") + 
  scale_x_continuous(breaks = 0:4 * 2) +
  theme(strip.text = element_text(size = 12),
        axis.text.y = element_text(size = 12))
```

```
## Warning: Removed 4 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 4 rows containing missing values (geom_point).
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-33-1.pdf)<!-- --> 

### Coefficients 

One good way to get a sense for what the different models are doing is by taking a look at the coefficients: 


```r
fit.complete_pooling %>% 
  coef()
```

```
## (Intercept)        days 
##   252.32070    10.32766
```


```r
fit.random_intercept %>% 
  coef()
```

```
## $subject
##     (Intercept)     days
## 308    292.2749 10.43191
## 309    174.0559 10.43191
## 310    188.7454 10.43191
## 330    256.0247 10.43191
## 331    261.8141 10.43191
## 332    259.8262 10.43191
## 333    268.0765 10.43191
## 334    248.6471 10.43191
## 335    206.5096 10.43191
## 337    323.5643 10.43191
## 349    230.5114 10.43191
## 350    265.6957 10.43191
## 351    243.7988 10.43191
## 352    287.8850 10.43191
## 369    258.6454 10.43191
## 370    245.2931 10.43191
## 371    248.3508 10.43191
## 372    269.6861 10.43191
## 373    248.2086 10.43191
## 374    273.9400 10.43191
## 
## attr(,"class")
## [1] "coef.mer"
```


```r
fit.random_slope %>% 
  coef()
```

```
## $subject
##     (Intercept)       days
## 308    252.2965 19.9526801
## 309    252.2965 -4.3719650
## 310    252.2965 -0.9574726
## 330    252.2965  8.9909957
## 331    252.2965 10.5394285
## 332    252.2965 11.3994289
## 333    252.2965 12.6074020
## 334    252.2965 10.3413879
## 335    252.2965 -0.5722073
## 337    252.2965 24.2246485
## 349    252.2965  7.7702676
## 350    252.2965 15.0661415
## 351    252.2965  7.9675415
## 352    252.2965 17.0002999
## 369    252.2965 11.6982767
## 370    252.2965 11.3939807
## 371    252.2965  9.4535879
## 372    252.2965 13.4569059
## 373    252.2965 10.4142695
## 374    252.2965 11.9097917
## 
## attr(,"class")
## [1] "coef.mer"
```


```r
fit.random_intercept_slope %>% 
  coef()
```

```
## $subject
##     (Intercept)       days
## 308    253.9479 19.6264139
## 309    211.7328  1.7319567
## 310    213.1579  4.9061843
## 330    275.1425  5.6435987
## 331    273.7286  7.3862680
## 332    260.6504 10.1632535
## 333    268.3684 10.2245979
## 334    244.5523 11.4837825
## 335    251.3700 -0.3355554
## 337    286.2321 19.1090061
## 349    226.7662 11.5531963
## 350    238.7807 17.0156766
## 351    256.2344  7.4119501
## 352    272.3512 13.9920698
## 369    254.9484 11.2985741
## 370    226.3701 15.2027922
## 371    252.5051  9.4335432
## 372    263.8916 11.7253342
## 373    248.9752 10.3915245
## 374    271.1451 11.0782697
## 
## attr(,"class")
## [1] "coef.mer"
```

### Shrinkage 

In mixed effects models, the variance of parameter estimates across participants shrinks compared to a no pooling model (where we fit a different regression to each participant). Expressed differently, individual parameter estimates are borrowing strength from the overall data set in mixed effects models. 


```r
# get estimates from partial pooling model
df.partial_pooling = fit.random_intercept_slope %>% 
  coef() %>% 
  .[[1]] %>% 
  rownames_to_column("subject") %>% 
  clean_names()

# combine estimates from no pooling with partial pooling model 
df.plot = df.sleep %>% 
  group_by(subject) %>% 
  nest(days, reaction) %>% 
  mutate(fit = map(data, ~ lm(reaction ~ days, data = .)),
         tidy = map(fit, tidy)) %>% 
  unnest(tidy) %>% 
  select(subject, term, estimate) %>% 
  spread(term, estimate) %>% 
  clean_names() %>% 
  mutate(method = "no pooling") %>% 
  bind_rows(df.partial_pooling %>% 
              mutate(method = "partial pooling")) %>% 
  gather("index", "value", -c(subject, method)) %>% 
  mutate(index = factor(index, levels = c("intercept", "days")))

  
# visualize the results  
ggplot(data = df.plot,
       mapping = aes(x = value,
                     group = method,
                     fill = method)) + 
  stat_density(position = "identity",
               geom = "area",
               color = "black",
               alpha = 0.3) +
  facet_grid(cols = vars(index),
             scales = "free")
```

```
## Warning: Removed 1 rows containing non-finite values (stat_density).
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-38-1.pdf)<!-- --> 

## Bootstrapping 

Bootstrapping is a good way to estimate our uncertainty on the parameter estimates in the model. 

### Linear model 

Let's briefly review how to do bootstrapping in a simple linear model. 


```r
# fit model 
fit.lm = lm(formula = reaction ~ 1 + days,
            data = df.sleep)

# coefficients
fit.lm %>% coef()
```

```
## (Intercept)        days 
##   252.32070    10.32766
```

```r
# bootstrapping 
df.boot = df.sleep %>% 
  bootstrap(n = 100,
            id = "id") %>% 
  mutate(fit = map(strap, ~ lm(formula = reaction ~ 1 + days, data = .)),
         tidy = map(fit, tidy)) %>% 
  unnest(tidy) %>% 
  select(id, term, estimate) %>% 
  spread(term, estimate) %>% 
  clean_names() 
```

Let's illustrate the linear model with a confidence interval (making parametric assumptions using the t-distribution). 


```r
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_smooth(method = "lm") + 
  geom_point(alpha = 0.3)
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-40-1.pdf)<!-- --> 

And let's compare this with the different regression lines that we get out of our bootstrapped samples:


```r
ggplot(data = df.sleep,
       mapping = aes(x = days, y = reaction)) + 
  geom_abline(data = df.boot,
              aes(intercept = intercept,
                  slope = days,
                  group = id),
              alpha = 0.1) +
  geom_point(alpha = 0.3)
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-41-1.pdf)<!-- --> 

#### bootmer() function

For the linear mixed effects model, we can use the `bootmer()` function to do bootstrapping. 


```r
# fit the model 
fit.lmer = lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                data = df.sleep)

# bootstrap parameter estimates 
boot.lmer = bootMer(fit.lmer,
                    FUN = fixef,
                    nsim = 100)

# compute confidence interval 
boot.ci(boot.lmer, index = 2, type = "perc")
```

```
## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
## Based on 100 bootstrap replicates
## 
## CALL : 
## boot.ci(boot.out = boot.lmer, type = "perc", index = 2)
## 
## Intervals : 
## Level     Percentile     
## 95%   ( 7.36, 13.52 )  
## Calculations and Intervals on Original Scale
## Some percentile intervals may be unstable
```

```r
# plot estimates 
boot.lmer$t %>% 
  as_tibble() %>% 
  clean_names() %>% 
  mutate(id = 1:n()) %>% 
  gather("index", "value", - id) %>% 
  ggplot(data = .,
       mapping = aes(x = value)) + 
  geom_density() + 
  facet_grid(cols = vars(index),
             scales = "free") +
  coord_cartesian(expand = F)
```

![](19-linear_mixed_effects_models3_files/figure-latex/lmer3-42-1.pdf)<!-- --> 

## Getting p-values 

We can use the "lmerTest" package to get p-values for the different fixed effects. 


```r
lmerTest::lmer(formula = reaction ~ 1 + days + (1 + days | subject),
                data = df.sleep) %>% 
  summary()
```

```
## Linear mixed model fit by REML. t-tests use Satterthwaite's method [
## lmerModLmerTest]
## Formula: reaction ~ 1 + days + (1 + days | subject)
##    Data: df.sleep
## 
## REML criterion at convergence: 1771.4
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -3.9707 -0.4703  0.0276  0.4594  5.2009 
## 
## Random effects:
##  Groups   Name        Variance Std.Dev. Corr
##  subject  (Intercept) 582.73   24.140       
##           days         35.03    5.919   0.07
##  Residual             649.36   25.483       
## Number of obs: 183, groups:  subject, 20
## 
## Fixed effects:
##             Estimate Std. Error      df t value Pr(>|t|)    
## (Intercept)  252.543      6.433  19.294  39.256  < 2e-16 ***
## days          10.452      1.542  17.163   6.778 3.06e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##      (Intr)
## days -0.137
```

## Understanding the lmer() syntax 

Here is an overview of how to specify different kinds of linear mixed effects models.


\begin{tabular}{l|l}
\hline
formula & description\\
\hline
`dv \textasciitilde{} x1 + (1 | g)` & Random intercept for each level of `g`\\
\hline
`dv \textasciitilde{} x1 + (0 + x1 | g)` & Random slope for each level of `g`\\
\hline
`dv \textasciitilde{} x1 + (x1 | g)` & Correlated random slope and intercept for each level of `g`\\
\hline
`dv \textasciitilde{} x1 + (x1 || g)` & Uncorrelated random slope and intercept for each level of `g`\\
\hline
`dv \textasciitilde{} x1 + (1 | school) + (1 | teacher)` & Random intercept for each level of `school` and for each level of `teacher` (crossed)\\
\hline
`dv \textasciitilde{} x1 + (1 | school/teacher)` & Random intercept for each level of `school` and for each level of `teacher` in `school` (nested)\\
\hline
\end{tabular}

<!--chapter:end:19-linear_mixed_effects_models3.Rmd-->

# Generalized linear model 



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("titanic")    # titanic dataset
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("broom")      # for tidying up linear models 
library("lme4")       # for linear mixed effects models
library("boot")       # for bootstrapping (also has an inverse logit function)
library("effects")    # for showing effects in linear, generalized linear, and other models
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Load data set 


```r
df.titanic = titanic_train %>% 
  clean_names() %>% 
  mutate(sex = as.factor(sex))
```

Let's take a quick look at the data: 


```r
df.titanic %>% glimpse()
```

```
## Observations: 891
## Variables: 12
## $ passenger_id <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15...
## $ survived     <int> 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0...
## $ pclass       <int> 3, 1, 3, 1, 3, 3, 1, 3, 3, 2, 3, 1, 3, 3, 3, 2, 3...
## $ name         <chr> "Braund, Mr. Owen Harris", "Cumings, Mrs. John Br...
## $ sex          <fct> male, female, female, female, male, male, male, m...
## $ age          <dbl> 22, 38, 26, 35, 35, NA, 54, 2, 27, 14, 4, 58, 20,...
## $ sib_sp       <int> 1, 1, 0, 1, 0, 0, 0, 3, 0, 1, 1, 0, 0, 1, 0, 0, 4...
## $ parch        <int> 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 1, 0, 0, 5, 0, 0, 1...
## $ ticket       <chr> "A/5 21171", "PC 17599", "STON/O2. 3101282", "113...
## $ fare         <dbl> 7.2500, 71.2833, 7.9250, 53.1000, 8.0500, 8.4583,...
## $ cabin        <chr> "", "C85", "", "C123", "", "", "E46", "", "", "",...
## $ embarked     <chr> "S", "C", "S", "S", "S", "Q", "S", "S", "S", "C",...
```


```r
# Table of the first 10 entries
df.titanic %>% 
  head(10) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|l|l|r|r|r|l|r|l|l}
\hline
passenger\_id & survived & pclass & name & sex & age & sib\_sp & parch & ticket & fare & cabin & embarked\\
\hline
1 & 0 & 3 & Braund, Mr. Owen Harris & male & 22 & 1 & 0 & A/5 21171 & 7.25 &  & S\\
\hline
2 & 1 & 1 & Cumings, Mrs. John Bradley (Florence Briggs Thayer) & female & 38 & 1 & 0 & PC 17599 & 71.28 & C85 & C\\
\hline
3 & 1 & 3 & Heikkinen, Miss. Laina & female & 26 & 0 & 0 & STON/O2. 3101282 & 7.92 &  & S\\
\hline
4 & 1 & 1 & Futrelle, Mrs. Jacques Heath (Lily May Peel) & female & 35 & 1 & 0 & 113803 & 53.10 & C123 & S\\
\hline
5 & 0 & 3 & Allen, Mr. William Henry & male & 35 & 0 & 0 & 373450 & 8.05 &  & S\\
\hline
6 & 0 & 3 & Moran, Mr. James & male & NA & 0 & 0 & 330877 & 8.46 &  & Q\\
\hline
7 & 0 & 1 & McCarthy, Mr. Timothy J & male & 54 & 0 & 0 & 17463 & 51.86 & E46 & S\\
\hline
8 & 0 & 3 & Palsson, Master. Gosta Leonard & male & 2 & 3 & 1 & 349909 & 21.07 &  & S\\
\hline
9 & 1 & 3 & Johnson, Mrs. Oscar W (Elisabeth Vilhelmina Berg) & female & 27 & 0 & 2 & 347742 & 11.13 &  & S\\
\hline
10 & 1 & 2 & Nasser, Mrs. Nicholas (Adele Achem) & female & 14 & 1 & 0 & 237736 & 30.07 &  & C\\
\hline
\end{tabular}
\end{table}

## Logistic regression 

Let's see if we can predict whether or not a passenger survived based on the price of their ticket. 

Let's run a simple regression first: 


```r
# fit a linear model 
fit.lm = lm(formula = survived ~ 1 + fare,
            data = df.titanic)

# summarize the results
fit.lm %>% summary()
```

```
## 
## Call:
## lm(formula = survived ~ 1 + fare, data = df.titanic)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -0.9653 -0.3391 -0.3222  0.6044  0.6973 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 0.3026994  0.0187849  16.114  < 2e-16 ***
## fare        0.0025195  0.0003174   7.939 6.12e-15 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.4705 on 889 degrees of freedom
## Multiple R-squared:  0.06621,	Adjusted R-squared:  0.06516 
## F-statistic: 63.03 on 1 and 889 DF,  p-value: 6.12e-15
```

Look's like `fare` is a significant predictor of whether or not a person survived. Let's visualize the model's predictions:


```r
ggplot(data = df.titanic,
       mapping = aes(x = fare,
                     y = survived)) + 
  geom_smooth(method = "lm") + 
  geom_point() +
  labs(y = "survived")
```

![](20-generalized_linear_model_files/figure-latex/glm-08-1.pdf)<!-- --> 

This doesn't look good! The model predicts intermediate values of `survived` (which doesn't make sense given that a person either survived or didn't survive). Furthermore, the model predicts values greater than 1 for fares greather than ~ 300.  

Let's run a logistic regression instead. 


```r
# fit a logistic regression 
fit.glm = glm(formula = survived ~ 1 + fare,
              family = "binomial",
              data = df.titanic)

fit.glm %>% summary()
```

```
## 
## Call:
## glm(formula = survived ~ 1 + fare, family = "binomial", data = df.titanic)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.4906  -0.8878  -0.8531   1.3429   1.5942  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -0.941330   0.095129  -9.895  < 2e-16 ***
## fare         0.015197   0.002232   6.810 9.79e-12 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1186.7  on 890  degrees of freedom
## Residual deviance: 1117.6  on 889  degrees of freedom
## AIC: 1121.6
## 
## Number of Fisher Scoring iterations: 4
```

And let's visualize the predictions of the logistic regression: 


```r
ggplot(data = df.titanic,
       mapping = aes(x = fare,
                     y = survived)) + 
  geom_smooth(method = "glm",
              method.args = list(family = "binomial")) + 
  geom_point() +
  labs(y = "p(survived)")
```

![](20-generalized_linear_model_files/figure-latex/glm-10-1.pdf)<!-- --> 

Much better! Note that we've changed the interpretation of our dependent variable. We are now predicting the _probability that a person survived_ based on their fare. The model now only predicts values between 0 and 1. To achieve this, we apply a logit transform to the outcome variable like so: 

$$
\ln(\frac{\pi_i}{1-\pi_i}) = b_0 + b_1 \cdot X_i + e_i
$$
where $\pi_i$ is the probability of passenger $i$ having survived. Importantly, this affects our interpretation of the model parameters. They are now defined in log-odds, and can apply an inverse logit transformation to turn this back into a probability: 

With

$$
\pi = P(Y = 1)
$$
and the logit transformation 

$$
\ln(\frac{\pi}{1-\pi}) = V,
$$
where $V$ is just a placeholder for our linear model formula, we can go back to $\pi$ through the inverse logit transformation like so: 

$$
\pi = \frac{e^V}{1 + e^V}
$$
In R, we can use `log(x)` to calculate the natural logarithm $\ln(x)$, and `exp(x)` to calculate `e^x`. 

### Interpreting the parameters 


```r
fit.glm %>% summary()
```

```
## 
## Call:
## glm(formula = survived ~ 1 + fare, family = "binomial", data = df.titanic)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.4906  -0.8878  -0.8531   1.3429   1.5942  
## 
## Coefficients:
##              Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -0.941330   0.095129  -9.895  < 2e-16 ***
## fare         0.015197   0.002232   6.810 9.79e-12 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1186.7  on 890  degrees of freedom
## Residual deviance: 1117.6  on 889  degrees of freedom
## AIC: 1121.6
## 
## Number of Fisher Scoring iterations: 4
```

The estimate for the intercept and fare are in log-odds. We apply the inverse logit transformation to turn these into probabilities: 


```r
fit.glm$coefficients[1] %>% inv.logit()
```

```
## (Intercept) 
##   0.2806318
```

Here, we see that the intercept is $p = 0.28$. That is, the predicted chance of survival for someone who didn't pay any fare at all is 28% according to the model. Interpreting the slope is a little more tricky. Let's look at a situation first where we have a binary predictor. 

#### Binary predictor

Let's see whether the probability of survival differed between male and female passengers. 


```r
fit.glm2 = glm(formula = survived ~ sex,
               family = "binomial",
               data = df.titanic)

fit.glm2 %>% summary()
```

```
## 
## Call:
## glm(formula = survived ~ sex, family = "binomial", data = df.titanic)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.6462  -0.6471  -0.6471   0.7725   1.8256  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)   1.0566     0.1290   8.191 2.58e-16 ***
## sexmale      -2.5137     0.1672 -15.036  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1186.7  on 890  degrees of freedom
## Residual deviance:  917.8  on 889  degrees of freedom
## AIC: 921.8
## 
## Number of Fisher Scoring iterations: 4
```

It looks like it did! Let's visualize: 


```r
df.titanic %>% 
  mutate(survived = factor(survived, labels = c("died", "survived"))) %>% 
  ggplot(data = .,
         mapping = aes(x = sex,
                       fill = survived)) +
  geom_bar(position = "fill",
           color = "black") +
  scale_fill_brewer(palette = "Set1")  +
  labs(x = "", fill = "", y = "probability")
```

![](20-generalized_linear_model_files/figure-latex/glm-14-1.pdf)<!-- --> 

And let's interpret the parameters by applying the inverse logit transform. To get the prediction for female passengers we get 

$$
\widehat{\ln(\frac{\pi_i}{1-\pi_i})} = b_0 + b_1 \cdot \text{sex}_i = b_0 + b_1 \cdot 0 = b_0
$$

since we dummy coded the predictor and female is our reference category. To get the predicted probability of surival for women we do the logit transform: 

$$
\pi = \frac{e^{b_0}}{1 + e^{b_0}}
$$
The predicted probability is: 


```r
fit.glm2$coefficients[1] %>% inv.logit()
```

```
## (Intercept) 
##   0.7420382
```

To get the prediction for male passengers we have: 

$$
\widehat{\ln(\frac{\pi_i}{1-\pi_i})} = b_0 + b_1 \cdot \text{sex}_i = b_0 + b_1 \cdot 1 = b_0 + b_1
$$
Applying the logit transform like so

$$
\pi = \frac{e^{b_0 + b_1}}{1 + e^{b_0 + b_1}}
$$

The predicted probability of male passengers surviving is: 


```r
sum(fit.glm2$coefficients) %>% inv.logit()
```

```
## [1] 0.1889081
```

Here is the same information in a table: 


```r
df.titanic %>% 
  count(sex, survived) %>% 
  mutate(p = n/sum(n)) %>% 
  group_by(sex) %>% 
  mutate(`p(survived|sex)` = p/sum(p)) %>% 
  head(10) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{l|r|r|r|r}
\hline
sex & survived & n & p & p(survived|sex)\\
\hline
female & 0 & 81 & 0.09 & 0.26\\
\hline
female & 1 & 233 & 0.26 & 0.74\\
\hline
male & 0 & 468 & 0.53 & 0.81\\
\hline
male & 1 & 109 & 0.12 & 0.19\\
\hline
\end{tabular}
\end{table}

#### Continuous predictor

To interpret the predictions when a continuous predictor is invovled, it's easiest to consider a few concrete cases. Here, I use the `augment()` function from the "broom" package to get the model's predictions for some values of interest: 


```r
fit.glm %>% 
  augment(newdata = tibble(fare = c(0, 10, 50, 100, 500))) %>% 
  clean_names() %>% 
  select(fare, prediction = fitted) %>% 
  mutate(`p(survival)` = prediction %>% inv.logit()) %>% 
  head(10) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r}
\hline
fare & prediction & p(survival)\\
\hline
0 & -0.94 & 0.28\\
\hline
10 & -0.79 & 0.31\\
\hline
50 & -0.18 & 0.45\\
\hline
100 & 0.58 & 0.64\\
\hline
500 & 6.66 & 1.00\\
\hline
\end{tabular}
\end{table}

#### Several predictors 

Let's fit a logistic regression that predicts the probability of survival based both on the passenger's sex and what fare they paid (allowing for an interaction of the two predictors): 


```r
fit.glm = glm(formula = survived ~ 1 + sex * fare,
              family = "binomial",
              data = df.titanic)

fit.glm %>% summary()
```

```
## 
## Call:
## glm(formula = survived ~ 1 + sex * fare, family = "binomial", 
##     data = df.titanic)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.6280  -0.6279  -0.5991   0.8172   1.9288  
## 
## Coefficients:
##               Estimate Std. Error z value Pr(>|z|)    
## (Intercept)   0.408428   0.189999   2.150 0.031584 *  
## sexmale      -2.099345   0.230291  -9.116  < 2e-16 ***
## fare          0.019878   0.005372   3.701 0.000215 ***
## sexmale:fare -0.011617   0.005934  -1.958 0.050252 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1186.66  on 890  degrees of freedom
## Residual deviance:  879.85  on 887  degrees of freedom
## AIC: 887.85
## 
## Number of Fisher Scoring iterations: 5
```

And let's visualize the result: 


```r
df.titanic %>% 
  mutate(sex = as.factor(sex)) %>% 
  ggplot(data = .,
         mapping = aes(x = fare,
                       y = survived,
                       color = sex,
                       group = sex)) +
  geom_point(alpha = 0.1, size = 2) + 
  geom_smooth(method = "glm",
              method.args = list(family = "binomial"),
              alpha = 0.2,
              aes(fill = sex)) +
  scale_color_brewer(palette = "Set1")
```

![](20-generalized_linear_model_files/figure-latex/glm-20-1.pdf)<!-- --> 

We notice that there is one outlier who was male and paid a $500 fare (or maybe this is a mistake in the data entry?!). Let's remove this outlier and see what happens: 


```r
df.titanic %>% 
  filter(fare < 500) %>% 
  mutate(sex = as.factor(sex)) %>% 
  ggplot(data = .,
         mapping = aes(x = fare,
                       y = survived,
                       color = sex,
                       group = sex)) +
  geom_point(alpha = 0.1, size = 2) + 
  geom_smooth(method = "glm",
              method.args = list(family = "binomial"),
              alpha = 0.2,
              aes(fill = sex)) +
  scale_color_brewer(palette = "Set1")
```

![](20-generalized_linear_model_files/figure-latex/glm-21-1.pdf)<!-- --> 

There is still a clear difference between female and male passengers, but the prediction for male passengers has changed a bit. Let's look at a concrete example: 


```r
# with the outlier: 

# predicted probability of survival for a male passenger who paid $200 for their fare 
inv.logit(fit.glm$coefficients[1] + fit.glm$coefficients[2] + fit.glm$coefficients[3] * 200 + fit.glm$coefficients[4] * 200)
```

```
## (Intercept) 
##   0.4903402
```

```r
# without the outlier: 

# predicted probability of survival for a male passenger who paid $200 for their fare 
fit.glm_no_outlier = glm(formula = survived ~ 1 + sex * fare,
                         family = "binomial",
                         data = df.titanic %>% 
                           filter(fare < 500))

inv.logit(fit.glm_no_outlier$coefficients[1] + fit.glm_no_outlier$coefficients[2] + fit.glm_no_outlier$coefficients[3] * 200 + fit.glm_no_outlier$coefficients[4] * 200) 
```

```
## (Intercept) 
##   0.4658284
```

With the oulier removed, the predicted probability of survival for a male passenger who paid $200 decreases from 49% to 47%. 

#### Using the "effects" package 

The "effects" package helps with the interpretation of the results. It applies the inverse logit transform for us, and shows the predictions for a range of cases. 


```r
# show effects 
allEffects(mod = fit.glm, xlevels = list(fare = c(0, 100, 200, 300, 400, 500)))
```

```
##  model: survived ~ 1 + sex * fare
## 
##  sex*fare effect
##         fare
## sex              0       100       200       300       400       500
##   female 0.6007108 0.9165428 0.9876799 0.9982941 0.9997660 0.9999679
##   male   0.1556552 0.2963415 0.4903402 0.6872927 0.8339147 0.9198098
```

I've used the xlevels argument to specify for what values of the predictor `fare`, I'd like get the predicted values. 

## Simulate a logistic regression

As always, to better understand a statistical modeling procedure, it's helpful to simulate data from the assumed data-generating process, fit the model, and see whether we can reconstruct the parameters.  


```r
# make example reproducible 
set.seed(1)

# set parameters 
sample_size = 1000 
b0 = 0
b1 = 1
# b1 = 8

# generate data 
df.data = tibble(
  x = rnorm(n = sample_size),
  y = b0 + b1 * x,
  p = inv.logit(y)) %>% 
  mutate(response = rbinom(n(), size = 1, p = p))

# fit model 
fit = glm(formula = response ~ 1 + x,
          family = "binomial",
          data = df.data)

# model summary 
fit %>% summary()
```

```
## 
## Call:
## glm(formula = response ~ 1 + x, family = "binomial", data = df.data)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.1137  -1.0118  -0.4591   1.0287   2.2591  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -0.06214    0.06918  -0.898    0.369    
## x            0.92905    0.07937  11.705   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 1385.4  on 999  degrees of freedom
## Residual deviance: 1209.6  on 998  degrees of freedom
## AIC: 1213.6
## 
## Number of Fisher Scoring iterations: 3
```

Nice! The inferred estimates are very close to the parameter values we used to simulate the data. 

Let's visualize the result: 


```r
ggplot(data = df.data,
       mapping = aes(x = x,
                     y = response)) + 
  geom_smooth(method = "glm",
              method.args = list(family = "binomial")) + 
  geom_point(alpha = 0.1) +
  labs(y = "p(response)")
```

![](20-generalized_linear_model_files/figure-latex/glm-25-1.pdf)<!-- --> 

#### Calculate the model's likelihood 


To calculate the likelihood of the data for a given logistic model, we look at the actual response, and the probability of the predicted response, and then determine the likelihood of the observation assuming a bernoulli process. To get the overall likelihood of the data, we then multiply the likelihood of each data point (or take the logs first and then the sum to get the log-likelihood). 

This table illustrate the steps involved: 


```r
fit %>% 
  augment() %>% 
  clean_names() %>% 
  mutate(p = inv.logit(fitted)) %>% 
  select(response, p) %>% 
  mutate(p_response = ifelse(response == 1, p, 1-p),
         log_p = log(p_response)) %>% 
  rename(`p(Y = 1)` = p, `p(Y = response)` = p_response,
         `log(p(Y = response))` = log_p) %>% 
  head(10) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r|r}
\hline
response & p(Y = 1) & p(Y = response) & log(p(Y = response))\\
\hline
1 & 0.34 & 0.34 & -1.07\\
\hline
0 & 0.53 & 0.47 & -0.75\\
\hline
1 & 0.30 & 0.30 & -1.20\\
\hline
1 & 0.81 & 0.81 & -0.22\\
\hline
1 & 0.56 & 0.56 & -0.58\\
\hline
0 & 0.30 & 0.70 & -0.36\\
\hline
1 & 0.60 & 0.60 & -0.52\\
\hline
1 & 0.65 & 0.65 & -0.43\\
\hline
1 & 0.62 & 0.62 & -0.48\\
\hline
0 & 0.41 & 0.59 & -0.54\\
\hline
\end{tabular}
\end{table}

Let's calculate the log-likelihood by hand:


```r
fit %>% 
  augment() %>% 
  clean_names() %>% 
  mutate(p = inv.logit(fitted),
         log_likelihood = response * log(p) + (1 - response) * log(1 - p)) %>% 
  summarize(log_likelihood = sum(log_likelihood))
```

```
## # A tibble: 1 x 1
##   log_likelihood
##            <dbl>
## 1          -605.
```

And compare it with the model summary


```r
fit %>% 
  glance() %>% 
  select(logLik, AIC, BIC) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|r}
\hline
logLik & AIC & BIC\\
\hline
-604.82 & 1213.64 & 1223.45\\
\hline
\end{tabular}
\end{table}

We're getting the same result -- neat! Now we know how the likelihood of the data is calculated for a logistic regression model. 

## Testing hypotheses

To test hypotheses, we use our gold old model comparison approach: 


```r
# fit compact model
fit.compact = glm(formula = survived ~ 1 + fare,
                  family = "binomial",
                  data = df.titanic)

# fit augmented model
fit.augmented = glm(formula = survived ~ 1 + sex + fare,
                    family = "binomial",
                    data = df.titanic)

# likelihood ratio test
anova(fit.compact, fit.augmented, test = "LRT")
```

```
## Analysis of Deviance Table
## 
## Model 1: survived ~ 1 + fare
## Model 2: survived ~ 1 + sex + fare
##   Resid. Df Resid. Dev Df Deviance  Pr(>Chi)    
## 1       889    1117.57                          
## 2       888     884.31  1   233.26 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Note that in order to get a p-value out of this, we need to specify what statistical test we'd like to run. In this case, we use the likelihood ratio test ("LRT"). 

## Logistic mixed effects model 

Just like we can build linear mixed effects models using `lmer()` instead of `lm()`, we can also build a logistic mixed effects regression using `glmer()` instead of `glm()`. 

Let's read in some data: 


```r
# load bdf data set from nlme package
data(bdf, package = "nlme")

df.language = bdf %>% 
  clean_names() %>% 
  filter(repeatgr != 2) %>% 
  mutate(repeatgr = repeatgr %>% as.character() %>% as.numeric())

rm(bdf)
```

Fit the model, and print out the results: 


```r
fit =  glmer(repeatgr ~ 1 + ses * minority + (1 | school_nr),
             data = df.language,
             family = "binomial")
```

```
## Warning in checkConv(attr(opt, "derivs"), opt$par, ctrl =
## control$checkConv, : Model failed to converge with max|grad| = 0.00172186
## (tol = 0.001, component 1)
```

```r
fit %>% summary()
```

```
## Generalized linear mixed model fit by maximum likelihood (Laplace
##   Approximation) [glmerMod]
##  Family: binomial  ( logit )
## Formula: repeatgr ~ 1 + ses * minority + (1 | school_nr)
##    Data: df.language
## 
##      AIC      BIC   logLik deviance df.resid 
##   1660.9   1689.6   -825.5   1650.9     2278 
## 
## Scaled residuals: 
##     Min      1Q  Median      3Q     Max 
## -0.8943 -0.4062 -0.3151 -0.2233  5.9156 
## 
## Random effects:
##  Groups    Name        Variance Std.Dev.
##  school_nr (Intercept) 0.2464   0.4964  
## Number of obs: 2283, groups:  school_nr, 131
## 
## Fixed effects:
##                Estimate Std. Error z value Pr(>|z|)    
## (Intercept)   -0.478689   0.206057  -2.323   0.0202 *  
## ses           -0.061214   0.007915  -7.733 1.05e-14 ***
## minorityY      0.482829   0.472314   1.022   0.3067    
## ses:minorityY  0.010820   0.022867   0.473   0.6361    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Correlation of Fixed Effects:
##             (Intr) ses    mnrtyY
## ses         -0.907              
## minorityY   -0.400  0.368       
## ses:minrtyY  0.298 -0.318 -0.865
## convergence code: 0
## Model failed to converge with max|grad| = 0.00172186 (tol = 0.001, component 1)
```

## Additional information 

### Datacamp 

- [Multiple and logistic regression](https://www.datacamp.com/courses/multiple-and-logistic-regression)
- [Generalized linear models in R](https://www.datacamp.com/courses/generalized-linear-models-in-r)
- [Categorical data in the tidyverse](https://www.datacamp.com/courses/categorical-data-in-the-tidyverse)


<!--chapter:end:20-generalized_linear_model.Rmd-->

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

![](21-bayesian_data_analysis1_files/figure-latex/bda1-04-1.pdf)<!-- --> 

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

![](21-bayesian_data_analysis1_files/figure-latex/bda1-08-1.pdf)<!-- --> 

<!--chapter:end:21-bayesian_data_analysis1.Rmd-->

# Bayesian data analysis 2



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("greta")      # for writing Bayesian models
library("tidybayes")  # tidying up results from Bayesian models
library("cowplot")    # for making figure panels
library("ggrepel")    # for labels in ggplots 
library("gganimate")  # for animations
library("extraDistr") # additional probability distributions
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Doing Bayesian inference "by hand"

### Sequential updating based on the Beta distribution 


```r
# data 
data = c(0, 1, 1, 0, 1, 1, 1, 1)

# whether observation is a success or failure 
success = c(0, cumsum(data)) 
failure = c(0, cumsum(1 - data))
# I've added 0 at the beginning to show the prior

# plotting function
fun.plot_beta = function(success, failure){
  ggplot(data = tibble(x = c(0, 1)),
         mapping = aes(x = x)) +
    stat_function(fun = "dbeta",
                  args = list(shape1 = success + 1, shape2 = failure + 1),
                  geom = "area",
                  color = "black",
                  fill = "lightblue") +
    coord_cartesian(expand = F) +
    scale_x_continuous(breaks = seq(0.25, 0.75, 0.25)) + 
    theme(axis.title = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.margin = margin(r = 1, t = 0.5, unit = "cm"))
}

# generate the plots 
plots = map2(success, failure, ~ fun.plot_beta(.x, .y))

# make a grid of plots
plot_grid(plotlist = plots)
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-04-1.pdf)<!-- --> 

### Coin flip example 

Is the coin biased? 


```r
# data 
data = rep(0:1, c(8, 2))

# parameters 
theta = c(0.1, 0.5, 0.9)

# prior 
prior = c(0.25, 0.5, 0.25)
# prior = c(0.1, 0.1, 0.8) # alternative setting of the prior
# prior = c(0.000001, 0.000001, 0.999998) # another prior setting 

# likelihood 
likelihood = dbinom(sum(data == 1), size = length(data), prob = theta)

# posterior 
posterior = likelihood * prior / sum(likelihood * prior)

# store in data frame 
df.coins = tibble(
  theta = theta,
  prior = prior,
  likelihood = likelihood,
  posterior = posterior
) 
```

Visualize the results: 


```r
df.coins %>% 
  gather("index", "value", -theta) %>% 
  mutate(index = factor(index, levels = c("prior", "likelihood", "posterior")),
         theta = factor(theta, labels = c("p = 0.1", "p = 0.5", "p = 0.9"))) %>% 
  ggplot(data = .,
         mapping = aes(x = theta,
                       y = value,
                       fill = index)) + 
  geom_bar(stat = "identity",
           color = "black") +
  facet_grid(rows = vars(index),
             switch = "y",
             scales = "free") + 
  annotate("segment", x = -Inf, xend = Inf, y = -Inf, yend = -Inf) + 
  annotate("segment", x = -Inf, xend = -Inf, y = -Inf, yend = Inf) + 
  theme(legend.position = "none",
        strip.background = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.x = element_blank(),
        axis.line = element_blank())
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-06-1.pdf)<!-- --> 

### Bayesian inference by discretization

### Effect of the prior 


```r
# grid
theta = seq(0, 1, 0.01)

# data
data = rep(0:1, c(8, 2))

# calculate posterior
df.prior_effect = tibble(theta = theta, 
                  prior_uniform = dbeta(theta, shape1 = 1, shape2 = 1),
                  prior_normal = dbeta(theta, shape1 = 5, shape2 = 5),
                  prior_biased = dbeta(theta, shape1 = 8, shape2 = 2)) %>% 
  gather("prior_index", "prior", -theta) %>% 
  mutate(likelihood = dbinom(sum(data == 1),
                             size = length(data),
                             prob = theta)) %>% 
  group_by(prior_index) %>% 
  mutate(posterior = likelihood * prior / sum(likelihood * prior)) %>% 
  ungroup() %>% 
  gather("index", "value", -c(theta, prior_index))

# make the plot
df.prior_effect %>% 
  mutate(index = factor(index, levels = c("prior", "likelihood", "posterior")),
         prior_index = factor(prior_index,
                              levels = c("prior_uniform", "prior_normal", "prior_biased"),
                              labels = c("uniform", "symmetric", "asymmetric"))) %>% 
  ggplot(data = .,
         mapping = aes(x = theta,
                       y = value,
                       color = index)) +
  geom_line(size = 1) + 
  facet_grid(cols = vars(prior_index),
             rows = vars(index),
             scales = "free",
             switch = "y") +
  scale_x_continuous(breaks = seq(0, 1, 0.2)) +
  annotate("segment", x = -Inf, xend = Inf, y = -Inf, yend = -Inf) + 
  annotate("segment", x = -Inf, xend = -Inf, y = -Inf, yend = Inf) + 
  theme(legend.position = "none",
        strip.background = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.line = element_blank())
```

![(\#fig:bda2-07)Illustration of how the prior affects the posterior.](22-bayesian_data_analysis2_files/figure-latex/bda2-07-1.pdf) 

### Effect of the likelihood 


```r
# grid
theta = seq(0, 1, 0.01)

df.likelihood_effect = tibble(theta = theta, 
                              prior = dbeta(theta, shape1 = 2, shape2 = 8),
                              likelihood_left = dbeta(theta, shape1 = 1, shape2 = 9),
                              likelihood_center = dbeta(theta, shape1 = 5, shape2 = 5),
                              likelihood_right = dbeta(theta, shape1 = 9, shape2 = 1)) %>% 
  gather("likelihood_index", "likelihood", -c("theta", "prior")) %>% 
  group_by(likelihood_index) %>% 
  mutate(posterior = likelihood * prior / sum(likelihood * prior)) %>% 
  ungroup() %>% 
  gather("index", "value", -c(theta, likelihood_index))

df.likelihood_effect %>% 
  mutate(index = factor(index, levels = c("prior", "likelihood", "posterior")),
         likelihood_index = factor(likelihood_index,
                                   levels = c("likelihood_left", "likelihood_center", "likelihood_right"),
                                   labels = c("left", "center", "right"))) %>% 
  ggplot(data = .,
         mapping = aes(x = theta,
                       y = value,
                       color = index)) +
  geom_line(size = 1) + 
  facet_grid(cols = vars(likelihood_index),
             rows = vars(index),
             scales = "free",
             switch = "y") +
  scale_x_continuous(breaks = seq(0, 1, 0.2)) +
  annotate("segment", x = -Inf, xend = Inf, y = -Inf, yend = -Inf) + 
  annotate("segment", x = -Inf, xend = -Inf, y = -Inf, yend = Inf) + 
  theme(legend.position = "none",
        strip.background = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.line = element_blank(),
        strip.text.x = element_blank())
```

![(\#fig:bda2-08)Illustration of how the likelihood of the data affects the posterior.](22-bayesian_data_analysis2_files/figure-latex/bda2-08-1.pdf) 

### Effect of the sample size  


```r
# grid
theta = seq(0, 1, 0.01)

df.sample_size_effect = tibble(theta = theta, 
                               prior = dbeta(theta, shape1 = 5, shape2 = 5),
                               likelihood_low = dbeta(theta, shape1 = 2, shape2 = 8),
                               likelihood_medium = dbeta(theta, shape1 = 10, shape2 = 40),
                               likelihood_high = dbeta(theta, shape1 = 20, shape2 = 80)) %>% 
  gather("likelihood_index", "likelihood", -c("theta", "prior")) %>% 
  group_by(likelihood_index) %>% 
  mutate(posterior = likelihood * prior / sum(likelihood * prior)) %>% 
  ungroup() %>% 
  gather("index", "value", -c(theta, likelihood_index))

df.sample_size_effect %>% 
  mutate(index = factor(index, levels = c("prior", "likelihood", "posterior")),
         likelihood_index = factor(likelihood_index,
                                   levels = c("likelihood_low", "likelihood_medium", "likelihood_high"),
                                   labels = c("n = low", "n = medium", "n = high"))) %>% 
  ggplot(data = .,
         mapping = aes(x = theta,
                       y = value,
                       color = index)) +
  geom_line(size = 1) + 
  facet_grid(cols = vars(likelihood_index),
             rows = vars(index),
             scales = "free",
             switch = "y") +
  scale_x_continuous(breaks = seq(0, 1, 0.2)) +
  annotate("segment", x = -Inf, xend = Inf, y = -Inf, yend = -Inf) + 
  annotate("segment", x = -Inf, xend = -Inf, y = -Inf, yend = Inf) + 
  theme(legend.position = "none",
        strip.background = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.line = element_blank())
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-09-1.pdf)<!-- --> 

## Distributions 

### Normal vs Student-t distribution


```r
tibble(x = c(-5, 5)) %>% 
  ggplot(aes(x = x)) + 
  stat_function(fun = "dnorm",
                size = 1,
                color = "blue") +
  stat_function(fun = "dt",
                size = 1,
                color = "red",
                args = list(df = 1))
```

![(\#fig:bda2-10)Comparison between the normal distribution and the student-t distribution.](22-bayesian_data_analysis2_files/figure-latex/bda2-10-1.pdf) 

### Beta distributions


```r
fun.draw_beta = function(shape1, shape2){
  ggplot(data = tibble(x = c(0, 1)),
         aes(x = x)) + 
  stat_function(fun = "dbeta",
                size = 1,
                color = "black",
                args = list(shape1 = shape1, shape2 = shape2)) +
    annotate(geom = "text", 
             label = str_c("Beta(", shape1,",",shape2,")"),
             x = 0.5,
             y = Inf,
             hjust = 0.5,
             vjust = 1.1,
             size = 4) +
    scale_x_continuous(breaks = seq(0, 1, 0.2)) +
    theme(axis.title.x = element_blank())
}


shape1 = c(1, 0.5, 5, 1, 8, 20)
shape2 = c(1, 0.5, 5, 9, 2, 20)

p.list = map2(.x = shape1, .y = shape2, ~ fun.draw_beta(.x, .y))

plot_grid(plotlist = p.list)
```

![(\#fig:bda2-11)Beta distributions with different parameter settings.](22-bayesian_data_analysis2_files/figure-latex/bda2-11-1.pdf) 

### Normal distributions 


```r
tibble(x = c(-10, 10)) %>% 
  ggplot(aes(x = x)) + 
  stat_function(fun = "dnorm",
                size = 1,
                color = "blue",
                args = list(sd = 1)) +
  stat_function(fun = "dnorm",
                size = 1,
                color = "red",
                args = list(sd = 5))
```

![(\#fig:bda2-12)Normal distributions with different standard deviation.](22-bayesian_data_analysis2_files/figure-latex/bda2-12-1.pdf) 

### Distributions for non-negative parameters 


```r
tibble(x = c(0, 10)) %>% 
  ggplot(aes(x = x)) + 
  stat_function(fun = "dcauchy",
                size = 1,
                color = "blue",
                args = list(location = 0, scale = 1),
                xlim = c(0, 10)) +
  stat_function(fun = "dgamma",
                size = 1,
                color = "red",
                args = list(shape = 4, rate = 2))
```

![(\#fig:bda2-13)Cauchy and Gamma distribution.](22-bayesian_data_analysis2_files/figure-latex/bda2-13-1.pdf) 


## Inference via sampling 

Example for how we can compute probabilities based on random samples generated from a distribution. 


```r
# generate samples 
df.samples = tibble(x = rnorm(n = 10000, mean = 1, sd = 2)) 

# visualize distribution 
ggplot(data = df.samples,
       mapping = aes(x = x)) + 
  stat_density(geom = "line",
               color = "red",
               size = 2) + 
  stat_function(fun = "dnorm",
                args = list(mean = 1, sd = 2),
                color = "black",
                linetype = 2)
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-14-1.pdf)<!-- --> 

```r
# calculate probability based on samples 
df.samples %>% 
  summarize(prob = sum(x >= 0 & x < 4)/n())
```

```
## # A tibble: 1 x 1
##    prob
##   <dbl>
## 1 0.616
```

```r
# calculate probability based on theoretical distribution
pnorm(4, mean = 1, sd = 2) - pnorm(0, mean = 1, sd = 2)
```

```
## [1] 0.6246553
```

## Greta 

You can find out more about how get started with "greta" here: [https://greta-stats.org/articles/get_started.html](https://greta-stats.org/articles/get_started.html). Make sure to install the development version of "greta" (as shown in the "install-packages" code chunk above: `devtools::install_github("greta-dev/greta")`).

### Attitude data set 


```r
# load the attitude data set 
df.attitude = attitude
```

Visualize relationship between how well complaints are handled and the overall rating of an employee


```r
ggplot(data = df.attitude,
       mapping = aes(x = complaints,
                     y = rating)) +
  geom_point()
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-16-1.pdf)<!-- --> 

### Frequentist analysis 


```r
# fit model 
fit = lm(formula = rating ~ 1 + complaints, 
         data = df.attitude)

# print summary
fit %>% summary()
```

```
## 
## Call:
## lm(formula = rating ~ 1 + complaints, data = df.attitude)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -12.8799  -5.9905   0.1783   6.2978   9.6294 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 14.37632    6.61999   2.172   0.0385 *  
## complaints   0.75461    0.09753   7.737 1.99e-08 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 6.993 on 28 degrees of freedom
## Multiple R-squared:  0.6813,	Adjusted R-squared:  0.6699 
## F-statistic: 59.86 on 1 and 28 DF,  p-value: 1.988e-08
```

Visualize the model's predictions


```r
ggplot(data = df.attitude,
       mapping = aes(x = complaints,
                     y = rating)) +
  geom_smooth(method = "lm",
              color = "black") + 
  geom_point()
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-18-1.pdf)<!-- --> 

### Bayesian regression

#### Fit the model


```r
# variables & priors
b0 = normal(0, 10)
b1 = normal(0, 10)
sd = cauchy(0, 3, truncation = c(0, Inf))

# linear predictor
mu = b0 + b1 * df.attitude$complaints

# observation model (likelihood)
distribution(df.attitude$rating) = normal(mu, sd)

# define the model
m = model(b0, b1, sd)
```

Visualize the model as graph: 


```r
# plotting
plot(m)
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-20-1.pdf)<!-- --> 

Draw samples from the posterior distribution: 


```r
# sampling
draws = mcmc(m, n_samples = 1000)

# tidy up the draws
df.draws = tidy_draws(draws) %>% 
  clean_names()
```

#### Visualize the priors

These are the priors I used for the intercept, regression weights, and the standard deviation of the Gaussian likelihood function:  


```r
# Gaussian
ggplot(tibble(x = c(-30, 30)),
       aes(x = x)) +
  stat_function(fun = "dnorm", 
                size = 2,
                args = list(sd = 10))
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-22-1.pdf)<!-- --> 

```r
# Cauchy
ggplot(tibble(x = c(0, 30)),
       aes(x = x)) +
  stat_function(fun = "dcauchy", 
                size = 2,
                args = list(location = 0,
                            scale = 3))
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-22-2.pdf)<!-- --> 

#### Visualize the posteriors

This is what the posterior looks like for the three parameters in the model: 


```r
df.draws %>% 
  select(draw:sd) %>% 
  gather("index", "value", -draw) %>% 
  ggplot(data = .,
         mapping = aes(x = value)) + 
  stat_density(geom = "line") + 
  facet_grid(rows = vars(index),
             scales = "free_y",
             switch = "y") + 
  annotate("segment", x = -Inf, xend = Inf, y = -Inf, yend = -Inf) + 
  annotate("segment", x = -Inf, xend = -Inf, y = -Inf, yend = Inf) + 
  theme(legend.position = "none",
        strip.background = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.line = element_blank(),
        strip.text.x = element_blank())
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-23-1.pdf)<!-- --> 

#### Visualize model predictions 

Let's take some samples from the posterior to visualize the model predictions: 


```r
ggplot(data = df.attitude,
       mapping = aes(x = complaints, 
                     y = rating)) + 
  geom_abline(data = df.draws %>% 
                sample_n(size = 50),
              aes(intercept = b0, 
                  slope = b1),
              alpha = 0.3,
              color = "lightblue") + 
  geom_point() 
```

![](22-bayesian_data_analysis2_files/figure-latex/bda2-24-1.pdf)<!-- --> 

#### Posterior predictive check 

Let's make an animation that illustrates what predicted data sets (based on samples from the posterior) would look like: 


```r
df.draws %>% 
  sample_n(size = 10) %>%  
  mutate(complaints = list(seq(min(df.attitude$complaints),
                 max(df.attitude$complaints),
                 length.out = nrow(df.attitude)))) %>% 
  unnest(complaints) %>% 
  mutate(prediction = b0 + b1 * complaints + rnorm(n(), sd = sd)) %>% 
  ggplot(aes(x = complaints, y = prediction)) + 
  geom_point(alpha = 0.8,
             color = "lightblue") +
  geom_point(data = df.attitude,
             aes(y = rating,
                 x = complaints)) +
  coord_cartesian(xlim = c(20, 100),
                  ylim = c(20, 100)) +
  transition_manual(draw)
```


\animategraphics[,controls,loop]{60}{22-bayesian_data_analysis2_files/figure-latex/bda2-25-}{1}{10}

```r
# animate(p, nframes = 60, width = 800, height = 600, res = 96, type = "cairo")

# anim_save("posterior_predictive.gif")
```

#### Prior predictive check 

And let's illustrate what data we would have expected to see just based on the information that we encoded in our priors. 


```r
sample_size = 10

tibble(
  b0 = rnorm(sample_size, mean = 0, sd = 10),
  b1 = rnorm(sample_size, mean = 0, sd = 10),
  sd = rhcauchy(sample_size, sigma = 3),
  draw = 1:sample_size
) %>% 
  mutate(complaints = list(runif(nrow(df.attitude),
                                 min = min(df.attitude$complaints),
                                 max = max(df.attitude$complaints)))) %>% 
  unnest(complaints) %>% 
  mutate(prediction = b0 + b1 * complaints + rnorm(n(), sd = sd)) %>% 
  ggplot(aes(x = complaints, y = prediction)) + 
  geom_point(alpha = 0.8,
             color = "lightblue") +
  geom_point(data = df.attitude,
             aes(y = rating,
                 x = complaints)) +
  transition_manual(draw)
```


\animategraphics[,controls,loop]{60}{22-bayesian_data_analysis2_files/figure-latex/bda2-26-}{1}{10}

```r
# animate(p, nframes = 60, width = 800, height = 600, res = 96, type = "cairo")

# anim_save("prior_predictive.gif")
```

<!--chapter:end:22-bayesian_data_analysis2.Rmd-->

# Bayesian data analysis 3



## Load packages and set plotting theme  


```r
library("knitr")      # for knitting RMarkdown 
library("kableExtra") # for making nice tables
library("janitor")    # for cleaning column names
library("modelr")     # for doing modeling stuff
library("tidybayes")  # tidying up results from Bayesian models
library("brms")       # Bayesian regression models with Stan
library("rstanarm")   # for Bayesian models
library("cowplot")    # for making figure panels
library("ggrepel")    # for labels in ggplots
library("gganimate")  # for animations
library("GGally")     # for pairs plot
library("bayesplot")  # for visualization of Bayesian model fits 
library("tidyverse")  # for wrangling, plotting, etc. 
```


```r
theme_set(
  theme_classic() + #set the theme 
    theme(text = element_text(size = 20)) #set the default text size
)
```

## Load data set 

Load the poker data set. 


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

## Poker 

### Visualization

Let's visualize the data first: 


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

![](23-bayesian_data_analysis3_files/figure-latex/bda3-05-1.pdf)<!-- --> 

### Linear model 

And let's now fit a simple (frequentist) regression model: 


```r
fit.lm = lm(formula = balance ~ 1 + hand,
            data = df.poker)

fit.lm %>% summary()
```

```
## 
## Call:
## lm(formula = balance ~ 1 + hand, data = df.poker)
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

### Bayesian model 

Now, let's fit a Bayesian regression model using the `brm()` function:


```r
fit.brm1 = brm(formula = balance ~ 1 + hand,
               data = df.poker,
               file = "cache/brm1")

fit.brm1 %>% summary()
```

```
##  Family: gaussian 
##   Links: mu = identity; sigma = identity 
## Formula: balance ~ 1 + hand 
##    Data: df.poker (Number of observations: 300) 
## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
##          total post-warmup samples = 4000
## 
## Population-Level Effects: 
##             Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## Intercept       5.95      0.42     5.12     6.79       3609 1.00
## handneutral     4.38      0.59     3.24     5.56       3489 1.00
## handgood        7.07      0.59     5.94     8.22       3553 1.00
## 
## Family Specific Parameters: 
##       Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## sigma     4.13      0.17     3.81     4.47       3578 1.00
## 
## Samples were drawn using sampling(NUTS). For each parameter, Eff.Sample 
## is a crude measure of effective sample size, and Rhat is the potential 
## scale reduction factor on split chains (at convergence, Rhat = 1).
```

I use the `file = ` argument to save the model's results so that when I run this code chunk again, the model doesn't need to be fit again (fitting Bayesian models takes a while ...). 

#### Visualize the posteriors 

Let's visualize what the posterior for the different parameters looks like. We use the `geom_halfeyeh()` function from the "tidybayes" package to do so: 


```r
fit.brm1 %>% 
  posterior_samples() %>% 
  select(-lp__) %>% 
  gather("variable", "value") %>% 
  ggplot(data = .,
         mapping = aes(y = variable, x = value)) +
  geom_halfeyeh()
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-08-1.pdf)<!-- --> 

And let's look at how the samples from the posterior are correlated with each other: 


```r
fit.brm1 %>% 
  posterior_samples() %>% 
  select(b_Intercept:sigma) %>% 
  ggpairs(lower = list(continuous = wrap("points", alpha = 0.03)),
          upper = list(continuous = wrap("cor", size = 6))) + 
  theme(panel.grid.major = element_blank(),
        text = element_text(size = 12))
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-09-1.pdf)<!-- --> 

#### Compute highest density intervals 

To compute the MAP (maximum a posteriori probability) estimate and highest density interval, we use the `mode_hdi()` function that comes with the "tidybayes" package.


```r
fit.brm1 %>% 
  posterior_samples() %>% 
  clean_names() %>% 
  select(starts_with("b_"), sigma) %>% 
  mode_hdi() %>% 
  gather("index", "value", -c(.width:.interval)) %>% 
  select(index, value) %>% 
  mutate(index = ifelse(str_detect(index, fixed(".")), index, str_c(index, ".mode"))) %>% 
  separate(index, into = c("parameter", "type"), sep = "\\.") %>% 
  spread(type, value) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
                full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{l|r|r|r}
\hline
parameter & lower & mode & upper\\
\hline
b\_handgood & 5.93 & 7.10 & 8.20\\
\hline
b\_handneutral & 3.19 & 4.42 & 5.47\\
\hline
b\_intercept & 5.11 & 6.02 & 6.78\\
\hline
sigma & 3.81 & 4.10 & 4.46\\
\hline
\end{tabular}
\end{table}

#### Posterior predictive check 

To check whether the model did a good job capturing the data, we can simulate what future data the Baysian model predicts, now that it has learned from the data we feed into it.  


```r
pp_check(fit.brm1, nsamples = 100)
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-11-1.pdf)<!-- --> 

This looks good! The predicted shaped of the data based on samples from the posterior distribution looks very similar to the shape of the actual data.  

Let's make a hypothetical outcome plot that shows what concrete data sets the model would predict: 


```r
# generate predictive samples 
df.predictive_samples = fit.brm1 %>% 
  posterior_samples() %>% 
  clean_names() %>% 
  select(contains("b_"), sigma) %>% 
  sample_n(size = 20) %>% 
  mutate(sample = 1:n()) %>% 
  group_by(sample) %>% 
  nest() %>% 
  mutate(bad = map(data, ~ .$b_intercept + rnorm(100, sd = .$sigma)),
         neutral = map(data, ~ .$b_intercept + .$b_handneutral + rnorm(100, sd = .$sigma)),
         good = map(data, ~ .$b_intercept + .$b_handgood + rnorm(100, sd = .$sigma))) %>% 
  unnest(bad, neutral, good)

# plot the results as an animation
df.predictive_samples %>% 
  gather("hand", "balance", -sample) %>% 
  mutate(hand = factor(hand, levels = c("bad", "neutral", "good"))) %>% 
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
  theme(legend.position = "none") + 
  transition_manual(sample)
```


\animategraphics[,controls,loop]{120}{23-bayesian_data_analysis3_files/figure-latex/bda3-12-}{1}{20}

```r
# animate(p, nframes = 120, width = 800, height = 600, res = 96, type = "cairo")

# anim_save("poker_posterior_predictive.gif")
```

#### Test hypothesis

One key advantage of Bayesian over frequentist analysis is that we can test hypothesis in a very flexible manner by directly probing our posterior samples in different ways. 

We may ask, for example, what the probability is that the parameter for the difference between a bad hand and a neutral hand (`b_handneutral`) is greater than 0. Let's plot the posterior distribution together with the criterion: 


```r
fit.brm1 %>% 
  posterior_samples() %>% 
  select(b_handneutral) %>% 
  gather("variable", "value") %>% 
  ggplot(data = .,
         mapping = aes(y = variable, x = value)) +
  geom_halfeyeh() + 
  geom_vline(xintercept = 0,
             color = "red")
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-13-1.pdf)<!-- --> 

We see that the posterior is definitely greater than 0. 

We can ask many different kinds of questions about the data by doing basic arithmetic on our posterior samples. The `hypothesis()` function makes this even easier. Here are some examples: 


```r
# the probability that the posterior for handneutral is less than 0
hypothesis(fit.brm1,
           hypothesis = "handneutral < 0")
```

```
## Hypothesis Tests for class b:
##          Hypothesis Estimate Est.Error CI.Lower CI.Upper Evid.Ratio
## 1 (handneutral) < 0     4.38      0.59     -Inf     5.36          0
##   Post.Prob Star
## 1         0     
## ---
## '*': The expected value under the hypothesis lies outside the 95%-CI.
## Posterior probabilities of point hypotheses assume equal prior probabilities.
```


```r
# the probability that the posterior for handneutral is greater than 4
hypothesis(fit.brm1,
           hypothesis = "handneutral > 4")
```

```
## Hypothesis Tests for class b:
##              Hypothesis Estimate Est.Error CI.Lower CI.Upper Evid.Ratio
## 1 (handneutral)-(4) > 0     0.38      0.59    -0.56      Inf       2.89
##   Post.Prob Star
## 1      0.74     
## ---
## '*': The expected value under the hypothesis lies outside the 95%-CI.
## Posterior probabilities of point hypotheses assume equal prior probabilities.
```


```r
# the probability that good hands make twice as much as bad hands
hypothesis(fit.brm1,
           hypothesis = "Intercept + handgood > 2 * Intercept")
```

```
## Hypothesis Tests for class b:
##                 Hypothesis Estimate Est.Error CI.Lower CI.Upper Evid.Ratio
## 1 (Intercept+handgo... > 0     1.12      0.94    -0.42      Inf        7.6
##   Post.Prob Star
## 1      0.88     
## ---
## '*': The expected value under the hypothesis lies outside the 95%-CI.
## Posterior probabilities of point hypotheses assume equal prior probabilities.
```


```r
# the probability that neutral hands make less than the average of bad and good hands
hypothesis(fit.brm1,
           hypothesis = "Intercept + handneutral < (Intercept + Intercept + handgood) / 2")
```

```
## Hypothesis Tests for class b:
##                 Hypothesis Estimate Est.Error CI.Lower CI.Upper Evid.Ratio
## 1 (Intercept+handne... < 0     0.85      0.49     -Inf     1.66       0.04
##   Post.Prob Star
## 1      0.04     
## ---
## '*': The expected value under the hypothesis lies outside the 95%-CI.
## Posterior probabilities of point hypotheses assume equal prior probabilities.
```

Let's double check one example, and calculate the result directly based on the posterior samples: 


```r
df.hypothesis = fit.brm1 %>% 
  posterior_samples() %>% 
  clean_names() %>% 
  select(starts_with("b_")) %>% 
  mutate(neutral = b_intercept + b_handneutral,
         bad_good_average = (b_intercept + b_intercept + b_handgood)/2,
         hypothesis = neutral < bad_good_average)

df.hypothesis %>% 
  summarize(p = sum(hypothesis)/n())
```

```
##         p
## 1 0.04175
```

#### Bayes factor 

Another way of testing hypothesis is via the Bayes factor. Let's fit the two models we are interested in comparing with each other: 


```r
fit.brm2 = brm(formula = balance ~ 1 + hand,
               data = df.poker,
               save_all_pars = T,
               file = "cache/brm2")

fit.brm3 = brm(formula = balance ~ 1 + hand + skill,
               data = df.poker,
               save_all_pars = T,
               file = "cache/brm3")
```

And then compare the models useing the `bayes_factor()` function: 


```r
bayes_factor(fit.brm3, fit.brm2)
```

```
## Iteration: 1
## Iteration: 2
## Iteration: 3
## Iteration: 4
## Iteration: 5
## Iteration: 1
## Iteration: 2
## Iteration: 3
## Iteration: 4
```

```
## Estimated Bayes factor in favor of bridge1 over bridge2: 3.82212
```

#### Full specification

So far, we have used the defaults that `brm()` comes with and not bothered about specifiying the priors, etc. 

##### Getting the priors

Notice that we didn't specify any priors in the model. By default, "brms" assigns weakly informative priors to the parameters in the model. We can see what these are by running the following command: 


```r
fit.brm1 %>% 
  prior_summary()
```

```
##                  prior     class        coef group resp dpar nlpar bound
## 1                              b                                        
## 2                              b    handgood                            
## 3                              b handneutral                            
## 4 student_t(3, 10, 10) Intercept                                        
## 5  student_t(3, 0, 10)     sigma
```

We can also get information about which priors need to be specified before fitting a model:


```r
get_prior(formula = balance ~ 1 + hand,
          family = "gaussian",
          data = df.poker)
```

```
##                  prior     class        coef group resp dpar nlpar bound
## 1                              b                                        
## 2                              b    handgood                            
## 3                              b handneutral                            
## 4 student_t(3, 10, 10) Intercept                                        
## 5  student_t(3, 0, 10)     sigma
```

Here is an example for what a more complete model specification could look like: 


```r
fit.brm4 = brm(
  formula = balance ~ 1 + hand,
  family = "gaussian",
  data = df.poker,
  prior = c(
    prior(normal(0, 10), class = "b", coef = "handgood"),
    prior(normal(0, 10), class = "b", coef = "handneutral"),
    prior(student_t(3, 3, 10), class = "Intercept"),
    prior(student_t(3, 0, 10), class = "sigma")
  ),
  inits = list(
    list(Intercept = 0, sigma = 1, handgood = 5, handneutral = 5),
    list(Intercept = -5, sigma = 3, handgood = 2, handneutral = 2),
    list(Intercept = 2, sigma = 1, handgood = -1, handneutral = 1),
    list(Intercept = 1, sigma = 2, handgood = 2, handneutral = -2)
  ),
  iter = 4000,
  warmup = 1000,
  chains = 4,
  file = "cache/brm4",
  seed = 1
)

fit.brm4 %>% summary()
```

```
##  Family: gaussian 
##   Links: mu = identity; sigma = identity 
## Formula: balance ~ 1 + hand 
##    Data: df.poker (Number of observations: 300) 
## Samples: 4 chains, each with iter = 4000; warmup = 1000; thin = 1;
##          total post-warmup samples = 12000
## 
## Population-Level Effects: 
##             Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## Intercept       5.96      0.41     5.15     6.76       9191 1.00
## handneutral     4.37      0.58     3.23     5.53       9629 1.00
## handgood        7.05      0.58     5.93     8.19       9778 1.00
## 
## Family Specific Parameters: 
##       Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## sigma     4.13      0.17     3.81     4.49      12855 1.00
## 
## Samples were drawn using sampling(NUTS). For each parameter, Eff.Sample 
## is a crude measure of effective sample size, and Rhat is the potential 
## scale reduction factor on split chains (at convergence, Rhat = 1).
```

We can also take a look at the Stan code that the `brm()` function creates: 


```r
fit.brm4 %>% stancode()
```

```
## // generated with brms 2.7.0
## functions { 
## } 
## data { 
##   int<lower=1> N;  // total number of observations 
##   vector[N] Y;  // response variable 
##   int<lower=1> K;  // number of population-level effects 
##   matrix[N, K] X;  // population-level design matrix 
##   int prior_only;  // should the likelihood be ignored? 
## } 
## transformed data { 
##   int Kc = K - 1; 
##   matrix[N, K - 1] Xc;  // centered version of X 
##   vector[K - 1] means_X;  // column means of X before centering 
##   for (i in 2:K) { 
##     means_X[i - 1] = mean(X[, i]); 
##     Xc[, i - 1] = X[, i] - means_X[i - 1]; 
##   } 
## } 
## parameters { 
##   vector[Kc] b;  // population-level effects 
##   real temp_Intercept;  // temporary intercept 
##   real<lower=0> sigma;  // residual SD 
## } 
## transformed parameters { 
## } 
## model { 
##   vector[N] mu = temp_Intercept + Xc * b;
##   // priors including all constants 
##   target += normal_lpdf(b[1] | 0, 10); 
##   target += normal_lpdf(b[2] | 0, 10); 
##   target += student_t_lpdf(temp_Intercept | 3, 3, 10); 
##   target += student_t_lpdf(sigma | 3, 0, 10)
##     - 1 * student_t_lccdf(0 | 3, 0, 10); 
##   // likelihood including all constants 
##   if (!prior_only) { 
##     target += normal_lpdf(Y | mu, sigma);
##   } 
## } 
## generated quantities { 
##   // actual population-level intercept 
##   real b_Intercept = temp_Intercept - dot_product(means_X, b); 
## }
```

One thing worth noticing: by default, "brms" centers the predictors which makes it easier to assign a default prior over the intercept. 


#### Inference diagnostics

So far, we've assumed that the inference has worked out. We can check this by running plot() on our brm object:  


```r
plot(fit.brm1)
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-25-1.pdf)<!-- --> 

Let's make our own version of a trace plot for one parameter in the model:


```r
fit.brm1 %>% 
  spread_draws(b_Intercept) %>% 
  clean_names() %>% 
  mutate(chain = as.factor(chain)) %>% 
  ggplot(aes(x = iteration, y = b_intercept, group = chain, color = chain)) + 
  geom_line()
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-26-1.pdf)<!-- --> 

We can also take a look at the auto-correlation plot. Ideally, we want to generate independent samples from the posterior. So we don't want subsequent samples to be strongly correlated with each other. Let's take a look: 


```r
variables = fit.brm1 %>% get_variables() %>% .[1:4]

fit.brm1 %>% 
  posterior_samples() %>% 
  mcmc_acf(pars = variables,
           lags = 4)
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-27-1.pdf)<!-- --> 

Looking good! The autocorrelation should become very small as the lag increases (indicating that we are getting independent samples from the posterior). 

##### When things go wrong 

Let's try to fit a model to very little data (just two observations) with extremely uninformative priors: 


```r
df.data = tibble(y = c(-1, 1))

fit.brm5 = brm(
  data = df.data,
  family = gaussian,
  formula = y ~ 1,
  prior = c(
    prior(uniform(-1e10, 1e10), class = Intercept),
    prior(uniform(0, 1e10), class = sigma)
  ),
  inits = list(
    list(Intercept = 0, sigma = 1),
    list(Intercept = 0, sigma = 1)
  ),
  iter = 4000,
  warmup = 1000,
  chains = 2,
  file = "cache/brm5"
)
```

Let's take a look at the posterior distributions of the model parameters: 


```r
summary(fit.brm5)
```

```
## Warning: There were 225 divergent transitions after warmup. Increasing adapt_delta above 0.8 may help.
## See http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
```

```
##  Family: gaussian 
##   Links: mu = identity; sigma = identity 
## Formula: y ~ 1 
##    Data: df.data (Number of observations: 2) 
## Samples: 2 chains, each with iter = 4000; warmup = 1000; thin = 1;
##          total post-warmup samples = 6000
## 
## Population-Level Effects: 
##               Estimate    Est.Error       l-95% CI     u-95% CI Eff.Sample
## Intercept -51502175.28 484211604.68 -1258318917.93 524975203.26        103
##           Rhat
## Intercept 1.04
## 
## Family Specific Parameters: 
##           Estimate     Est.Error l-95% CI      u-95% CI Eff.Sample Rhat
## sigma 398611802.92 1217973385.49   852.93 4284866883.47         13 1.07
## 
## Samples were drawn using sampling(NUTS). For each parameter, Eff.Sample 
## is a crude measure of effective sample size, and Rhat is the potential 
## scale reduction factor on split chains (at convergence, Rhat = 1).
```

Not looking good -- The estimates and credible intervals are off the charts. And the effective samples sizes in the chains are very small. 

Let's visualize the trace plots:


```r
plot(fit.brm5)
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-30-1.pdf)<!-- --> 


```r
fit.brm5 %>% 
  spread_draws(b_Intercept) %>% 
  clean_names() %>% 
  mutate(chain = as.factor(chain)) %>% 
  ggplot(aes(x = iteration,
             y = b_intercept,
             group = chain,
             color = chain)) + 
  geom_line()
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-31-1.pdf)<!-- --> 

Given that we have so little data in this case, we need to help the model a little bit by providing some slighlty more specific priors. 


```r
fit.brm6 = brm(
  data = df.data,
  family = gaussian,
  formula = y ~ 1,
  prior = c(
    prior(normal(0, 10), class = Intercept), # more reasonable priors
    prior(cauchy(0, 1), class = sigma)
  ),
  iter = 4000,
  warmup = 1000,
  chains = 2,
  seed = 1,
  file = "cache/brm6"
)
```

Let's take a look at the posterior distributions of the model parameters: 


```r
summary(fit.brm6)
```

```
## Warning: There were 3 divergent transitions after warmup. Increasing adapt_delta above 0.8 may help.
## See http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup
```

```
##  Family: gaussian 
##   Links: mu = identity; sigma = identity 
## Formula: y ~ 1 
##    Data: df.data (Number of observations: 2) 
## Samples: 2 chains, each with iter = 4000; warmup = 1000; thin = 1;
##          total post-warmup samples = 6000
## 
## Population-Level Effects: 
##           Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## Intercept    -0.13      1.69    -4.10     3.06        881 1.00
## 
## Family Specific Parameters: 
##       Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## sigma     2.04      1.88     0.61     6.95       1152 1.00
## 
## Samples were drawn using sampling(NUTS). For each parameter, Eff.Sample 
## is a crude measure of effective sample size, and Rhat is the potential 
## scale reduction factor on split chains (at convergence, Rhat = 1).
```

This looks much better. There is still quite a bit of uncertainty in our paremeter estimates, but it has reduced dramatically. 

Let's visualize the trace plots:


```r
plot(fit.brm6)
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-34-1.pdf)<!-- --> 


```r
fit.brm6 %>% 
  spread_draws(b_Intercept) %>% 
  clean_names() %>% 
  mutate(chain = as.factor(chain)) %>% 
  ggplot(aes(x = iteration, y = b_intercept, group = chain, color = chain)) + 
  geom_line()
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-35-1.pdf)<!-- --> 

Looking mostly good -- except for one hiccup on sigma ... 

## Dealing with heteroscedasticity 

Let's generate some fake developmental data where the variance in the data is greatest for young children, smaller for older children, and even smaller for adults:  


```r
# make example reproducible 
set.seed(0)

df.variance = tibble(
  group = rep(c("3yo", "5yo", "adults"), each = 20),
  response = rnorm(60, mean = rep(c(0, 5, 8), each = 20), sd = rep(c(3, 1.5, 0.3), each = 20))
)

df.variance %>%
  ggplot(aes(x = group, y = response)) +
  geom_jitter(height = 0,
              width = 0.1,
              alpha = 0.7)
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-36-1.pdf)<!-- --> 

While frequentist models (such as a linear regression) assume equality of variance, Baysian models afford us with the flexibility of inferring both the parameter estimates of the groups (i.e. the means and differences between the means), as well as the variances. 

We simply define a multivariate model which tries to fit both the `response` as well as the variance `sigma`: 


```r
fit.brm7 = brm(
  formula = bf(response ~ group,
               sigma ~ group),
  data = df.variance,
  file = "cache/brm7"
)
```

Let's take a look at the model output: 


```r
summary(fit.brm7)
```

```
##  Family: gaussian 
##   Links: mu = identity; sigma = log 
## Formula: response ~ group 
##          sigma ~ group
##    Data: df.variance (Number of observations: 60) 
## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
##          total post-warmup samples = 4000
## 
## Population-Level Effects: 
##                   Estimate Est.Error l-95% CI u-95% CI Eff.Sample Rhat
## Intercept             0.00      0.72    -1.38     1.45       1273 1.00
## sigma_Intercept       1.15      0.17     0.85     1.51       2033 1.00
## group5yo              5.16      0.77     3.60     6.62       1424 1.00
## groupadults           7.96      0.72     6.49     9.37       1276 1.00
## sigma_group5yo       -1.05      0.23    -1.51    -0.59       2355 1.00
## sigma_groupadults    -2.19      0.23    -2.65    -1.74       2231 1.00
## 
## Samples were drawn using sampling(NUTS). For each parameter, Eff.Sample 
## is a crude measure of effective sample size, and Rhat is the potential 
## scale reduction factor on split chains (at convergence, Rhat = 1).
```

And let's visualize the results:


```r
df.variance %>%
  expand(group) %>% 
  add_fitted_draws(fit.brm7, dpar = TRUE) %>%
  select(group, .row, .draw, posterior = .value, mu, sigma) %>% 
  gather("index", "value", c(mu, sigma)) %>% 
  ggplot(aes(x = value, y = group)) +
  geom_halfeyeh() +
  geom_vline(xintercept = 0, linetype = "dashed") +
  facet_grid(cols = vars(index))
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-39-1.pdf)<!-- --> 

This plot shows what the posterior looks like for both mu (the inferred means), and for sigma (the inferred variances) for the different groups. 

## Ordinal regression 

For more information, see this [tutorial](https://mjskay.github.io/tidybayes/articles/tidy-
brms.html#ordinal-models).

While running an ordinal regression is far from trivial in frequentist world, it's easy to do using "brms". 

Let's load the cars data and turn the number of cylinders into an ordered factor: 


```r
df.cars = mtcars %>% 
  mutate(cyl = ordered(cyl)) # creates an ordered factor
```

Let's check that the cylinders are indeed ordered now: 


```r
df.cars %>% str()
```

```
## 'data.frame':	32 obs. of  11 variables:
##  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
##  $ cyl : Ord.factor w/ 3 levels "4"<"6"<"8": 2 2 1 2 3 2 3 1 1 2 ...
##  $ disp: num  160 160 108 258 360 ...
##  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
##  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
##  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
##  $ qsec: num  16.5 17 18.6 19.4 17 ...
##  $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
##  $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
##  $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
##  $ carb: num  4 4 1 1 2 1 4 2 2 4 ...
```


```r
fit.brm8 = brm(formula = cyl ~ mpg,
               data = df.cars,
               family = "cumulative",
               file = "cache/brm8",
               seed = 1)
```

Visualize the results:


```r
data_plot = df.cars %>%
  ggplot(aes(x = mpg, y = cyl, color = cyl)) +
  geom_point() +
  scale_color_brewer(palette = "Dark2", name = "cyl")

fit_plot = df.cars %>%
  data_grid(mpg = seq_range(mpg, n = 101)) %>%
  add_fitted_draws(fit.brm8, value = "P(cyl | mpg)", category = "cyl") %>%
  ggplot(aes(x = mpg, y = `P(cyl | mpg)`, color = cyl)) +
  stat_lineribbon(aes(fill = cyl),
                  alpha = 1/5,
                  .width = c(0.95)) +
  scale_color_brewer(palette = "Dark2") +
  scale_fill_brewer(palette = "Dark2")

plot_grid(ncol = 1, align = "v",
          data_plot,
          fit_plot
)
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-43-1.pdf)<!-- --> 

Posterior predictive check: 


```r
df.cars %>%
  select(mpg) %>%
  add_predicted_draws(fit.brm8, prediction = "cyl", seed = 1234) %>%
  ggplot(aes(x = mpg, y = cyl)) +
  geom_count(color = "gray75") +
  geom_point(aes(fill = cyl),
             data = df.cars,
             shape = 21,
             size = 2) +
  scale_fill_brewer(palette = "Dark2") +
  geom_label_repel(
    data = . %>% ungroup() %>% filter(cyl == "8") %>% filter(mpg == max(mpg)) %>% dplyr::slice(1),
    label = "posterior predictions",
    xlim = c(26, NA),
    ylim = c(NA, 2.8),
    point.padding = 0.3,
    label.size = NA,
    color = "gray50",
    segment.color = "gray75") +
  geom_label_repel(
    data = df.cars %>% filter(cyl == "6") %>% filter(mpg == max(mpg)) %>% dplyr::slice(1),
    label = "observed data",
    xlim = c(26, NA),
    ylim = c(2.2, NA),
    point.padding = 0.2,
    label.size = NA,
    segment.color = "gray35")
```

![](23-bayesian_data_analysis3_files/figure-latex/bda3-44-1.pdf)<!-- --> 


## Additional resources 

- [Tutorial on visualizing brms posteriors with tidybayes](https://mjskay.github.io/tidybayes/articles/tidy-brms.html)
- [Hypothetical outcome plots](https://mucollective.northwestern.edu/files/2018-HOPsTrends-InfoVis.pdf)
- [Visual MCMC diagnostics](https://cran.r-project.org/web/packages/bayesplot/vignettes/visual-mcmc-diagnostics.html#general-mcmc-diagnostics)
- [How to model slider data the Baysian way](https://vuorre.netlify.com/post/2019/02/18/analyze-analog-scale-
ratings-with-zero-one-inflated-beta-models/#zoib-regression)

<!--chapter:end:23-bayesian_data_analysis3.Rmd-->


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

\begin{figure}
\includegraphics[width=0.75\linewidth]{figures/mediation} \caption{__Basic mediation model__. c = the total effect of X on Y; c = c’ + ab; c’ = the direct effect of X on Y after controlling for M; c’ = c - ab; ab = indirect effect of X on Y.}(\#fig:mediation-04)
\end{figure}

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

![](24-mediation_moderation_files/figure-latex/mediation-12-1.pdf)<!-- --> 

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

![](24-mediation_moderation_files/figure-latex/mediation-14-1.pdf)<!-- --> ![](24-mediation_moderation_files/figure-latex/mediation-14-2.pdf)<!-- --> 

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

![](24-mediation_moderation_files/figure-latex/mediation-16-1.pdf)<!-- --> 

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

\begin{figure}
\includegraphics[width=0.75\linewidth]{figures/moderation} \caption{__Basic moderation model__.}(\#fig:mediation-18)
\end{figure}

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

![](24-mediation_moderation_files/figure-latex/mediation-21-1.pdf)<!-- --> 


```r
df.prediction %>% 
  head(9) %>% 
  kable(digits = 2) %>% 
  kable_styling(bootstrap_options = "striped",
              full_width = F)
```

\begin{table}[H]
\centering
\begin{tabular}{r|r|l|r|r}
\hline
x & z & moderator & .fitted & .se.fit\\
\hline
-1.83 & -1 & low & 18.58 & 3.75\\
\hline
-1.83 & 0 & average & 15.80 & 2.51\\
\hline
-1.83 & 1 & high & 13.02 & 2.99\\
\hline
2.41 & -1 & low & 68.52 & 4.32\\
\hline
2.41 & 0 & average & 91.60 & 3.09\\
\hline
2.41 & 1 & high & 114.68 & 4.12\\
\hline
\end{tabular}
\end{table}

## Additional resources 

### Books 

- [Introduction to Mediation, Moderation, and Conditional Process Analysis (Second Edition): A Regression-Based Approach](https://www.guilford.com/books/Introduction-to-Mediation-Moderation-and-Conditional-Process-Analysis/Andrew-Hayes/9781462534654)
  - [Recoded with BRMS and Tidyverse](https://bookdown.org/connect/#/apps/1523/access)

### Tutorials

- [R tutorial on mediation and moderation](https://ademos.people.uic.edu/Chapter14.html)
- [R tutorial on moderated mediation](https://ademos.people.uic.edu/Chapter15.html)
- [Path analysis with brms](http://www.imachordata.com/bayesian-sem-with-brms/)

<!--chapter:end:24-mediation_moderation.Rmd-->

# Cheatsheets

This chapter contains a selection of useful cheatsheets. 

- For updates check here: [https://www.rstudio.com/resources/cheatsheets/](https://www.rstudio.com/resources/cheatsheets/)
- Most of the cheatsheets have more than one page. To see the full cheatsheet, rightclick on it and select `Open image in New Window`

## Statistics 

\begin{figure}

{\centering \includegraphics[width=20.11in]{figures/cheatsheets/stats-help} 

}

\caption{Stats cheatsheet}(\#fig:cheatsheets-01)
\end{figure}

## R 

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/data-wrangling} 

}

\caption{Data wrangling in the tidyverse}(\#fig:cheatsheets-02)
\end{figure}


\begin{figure}

{\centering \includegraphics{figures/cheatsheets/advancedr} 

}

\caption{advancedr}(\#fig:cheatsheets-03)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/base-r} 

}

\caption{base-r}(\#fig:cheatsheets-04)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/data-import} 

}

\caption{data-import}(\#fig:cheatsheets-05)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/data-transformation} 

}

\caption{data-transformation}(\#fig:cheatsheets-06)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/data-visualization} 

}

\caption{data-visualization}(\#fig:cheatsheets-07)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/how-big-is-your-graph} 

}

\caption{how-big-is-your-graph}(\#fig:cheatsheets-08)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/latexsheet} 

}

\caption{latexsheet}(\#fig:cheatsheets-09)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/leaflet} 

}

\caption{leaflet}(\#fig:cheatsheets-10)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/lubridate} 

}

\caption{lubridate}(\#fig:cheatsheets-11)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/mosaic} 

}

\caption{mosaic}(\#fig:cheatsheets-12)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/purrr} 

}

\caption{purrr}(\#fig:cheatsheets-13)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/regexcheatsheet} 

}

\caption{regexcheatsheet}(\#fig:cheatsheets-14)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/rmarkdown-reference} 

}

\caption{rmarkdown-reference}(\#fig:cheatsheets-15)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/rmarkdown} 

}

\caption{rmarkdown}(\#fig:cheatsheets-16)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/rstudio-ide} 

}

\caption{rstudio-ide}(\#fig:cheatsheets-17)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/shiny} 

}

\caption{shiny}(\#fig:cheatsheets-18)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/strings} 

}

\caption{strings}(\#fig:cheatsheets-19)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/syntax} 

}

\caption{syntax}(\#fig:cheatsheets-20)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/tidyeval} 

}

\caption{tidyeval}(\#fig:cheatsheets-21)
\end{figure}

\begin{figure}

{\centering \includegraphics{figures/cheatsheets/visualization-principles} 

}

\caption{visualization principles}(\#fig:cheatsheets-22)
\end{figure}



<!--chapter:end:25-cheatsheets.Rmd-->



<!--chapter:end:26-references.Rmd-->

