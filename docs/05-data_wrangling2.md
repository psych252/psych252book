# Data wrangling 2

In this session, we will continue to learn about wrangling data. Some of the functions that I'll introduce in this session are a little tricky to master. Like learning a new language, it takes some time to get fluent. However, it's worth investing the time. 

## Learning goals

- Learn how to group and summarize data using `group_by()` and `summarize()`. 
- Get familiar with how to reshape data using `pivot_longer()`, `pivot_wider()`, `separate()` and `unite()`.
- Learn the basics of how to join multiple data frames with a focus on `left_join()`. 
- Learn how to deal with missing data entries `NA`. 
- Master how to _read_ and _save_ data. 

## Load packages

Let's first load the packages that we need for this chapter. 


``` r
library("knitr") # for rendering the RMarkdown file
library("tidyverse") # for data wrangling 
```

## Settings


``` r
# sets how code looks in knitted document
opts_chunk$set(comment = "")

# suppresses warning about grouping 
options(dplyr.summarise.inform = F)
```


## Wrangling data (continued)

### Summarizing data

Let's first load the `starwars` data set again: 


``` r
df.starwars = starwars
```

A particularly powerful way of interacting with data is by grouping and summarizing it. `summarize()` returns a single value for each summary that we ask for: 


``` r
df.starwars %>% 
  summarize(height_mean = mean(height, na.rm = T),
            height_max = max(height, na.rm = T),
            n = n())
```

```
# A tibble: 1 × 3
  height_mean height_max     n
        <dbl>      <int> <int>
1        175.        264    87
```

Here, I computed the mean height, the maximum height, and the total number of observations (using the function `n()`). 
Let's say we wanted to get a quick sense for how tall starwars characters from different species are. To do that, we combine grouping with summarizing: 


``` r
df.starwars %>% 
  group_by(species) %>% 
  summarize(height_mean = mean(height, na.rm = T))
```

```
# A tibble: 38 × 2
   species   height_mean
   <chr>           <dbl>
 1 Aleena            79 
 2 Besalisk         198 
 3 Cerean           198 
 4 Chagrian         196 
 5 Clawdite         168 
 6 Droid            131.
 7 Dug              112 
 8 Ewok              88 
 9 Geonosian        183 
10 Gungan           209.
# ℹ 28 more rows
```

I've first used `group_by()` to group our data frame by the different species, and then used `summarize()` to calculate the mean height of each species.

It would also be useful to know how many observations there are in each group. 


``` r
df.starwars %>% 
  group_by(species) %>% 
  summarize(height_mean = mean(height, na.rm = T), 
            group_size = n()) %>% 
  arrange(desc(group_size)) 
```

```
# A tibble: 38 × 3
   species  height_mean group_size
   <chr>          <dbl>      <int>
 1 Human           178          35
 2 Droid           131.          6
 3 <NA>            175           4
 4 Gungan          209.          3
 5 Kaminoan        221           2
 6 Mirialan        168           2
 7 Twi'lek         179           2
 8 Wookiee         231           2
 9 Zabrak          173           2
10 Aleena           79           1
# ℹ 28 more rows
```

Here, I've used the `n()` function to get the number of observations in each group, and then I've arranged the data frame according to group size in descending order. 

Note that `n()` always yields the number of observations in each group. If we don't group the data, then we get the overall number of observations in our data frame (i.e. the number of rows). 

So, Humans are the largest group in our data frame, followed by Droids (who are considerably smaller) and Gungans (who would make for good Basketball players). 

Sometimes `group_by()` is also useful without summarizing the data. For example, we often want to z-score (i.e. normalize) data on the level of individual participants. To do so, we first group the data on the level of participants, and then use `mutate()` to scale the data. Here is an example: 


``` r
# first let's generate some random data 
set.seed(1) # to make this reproducible 

df.summarize = tibble(participant = rep(1:3, each = 5),
                      judgment = sample(x = 0:100,
                                        size = 15,
                                        replace = TRUE)) %>% 
  print()
```

```
# A tibble: 15 × 2
   participant judgment
         <int>    <int>
 1           1       67
 2           1       38
 3           1        0
 4           1       33
 5           1       86
 6           2       42
 7           2       13
 8           2       81
 9           2       58
10           2       50
11           3       96
12           3       84
13           3       20
14           3       53
15           3       73
```


``` r
df.summarize %>%   
  group_by(participant) %>% # group by participants
  mutate(judgment_zscored = scale(judgment)) %>% # z-score data of individual participants
  ungroup() %>% # ungroup the data frame
  head(n = 10) # print the top 10 rows 
```

```
# A tibble: 10 × 3
   participant judgment judgment_zscored[,1]
         <int>    <int>                <dbl>
 1           1       67               0.671 
 2           1       38              -0.205 
 3           1        0              -1.35  
 4           1       33              -0.356 
 5           1       86               1.24  
 6           2       42              -0.275 
 7           2       13              -1.45  
 8           2       81               1.30  
 9           2       58               0.372 
10           2       50               0.0485
```

First, I've generated some random data using the repeat function `rep()` for making a `participant` column, and the `sample()` function to randomly choose values from a range between 0 and 100 with replacement. (We will learn more about these functions later when we look into how to simulate data.) I've then grouped the data by participant, and used the scale function to z-score the data. 

> __TIP__: Don't forget to `ungroup()` your data frame. Otherwise, any subsequent operations are applied per group. 

Sometimes, I want to run operations on each row, rather than per column. For example, let's say that I wanted each character's average combined height and mass. 

Let's see first what doesn't work: 


``` r
df.starwars %>% 
  mutate(mean_height_mass = mean(c(height, mass), na.rm = T)) %>% 
  select(name, height, mass, mean_height_mass)
```

```
# A tibble: 87 × 4
   name               height  mass mean_height_mass
   <chr>               <int> <dbl>            <dbl>
 1 Luke Skywalker        172    77             142.
 2 C-3PO                 167    75             142.
 3 R2-D2                  96    32             142.
 4 Darth Vader           202   136             142.
 5 Leia Organa           150    49             142.
 6 Owen Lars             178   120             142.
 7 Beru Whitesun Lars    165    75             142.
 8 R5-D4                  97    32             142.
 9 Biggs Darklighter     183    84             142.
10 Obi-Wan Kenobi        182    77             142.
# ℹ 77 more rows
```

Note that all the values are the same. The value shown here is just the mean of all the values in `height` and `mass`.


``` r
df.starwars %>% 
  select(height, mass) %>% 
  unlist() %>% # turns the data frame into a vector
  mean(na.rm = T) 
```

```
[1] 142.0314
```

To get the mean by row, we can either spell out the arithmetic


``` r
df.starwars %>% 
  mutate(mean_height_mass = (height + mass) / 2) %>% # here, I've replaced the mean() function  
  select(name, height, mass, mean_height_mass)
```

```
# A tibble: 87 × 4
   name               height  mass mean_height_mass
   <chr>               <int> <dbl>            <dbl>
 1 Luke Skywalker        172    77            124. 
 2 C-3PO                 167    75            121  
 3 R2-D2                  96    32             64  
 4 Darth Vader           202   136            169  
 5 Leia Organa           150    49             99.5
 6 Owen Lars             178   120            149  
 7 Beru Whitesun Lars    165    75            120  
 8 R5-D4                  97    32             64.5
 9 Biggs Darklighter     183    84            134. 
10 Obi-Wan Kenobi        182    77            130. 
# ℹ 77 more rows
```

or use the `rowwise()` helper function which is like `group_by()` but treats each row like a group: 


``` r
df.starwars %>% 
  rowwise() %>% # now, each row is treated like a separate group 
  mutate(mean_height_mass = mean(c(height, mass), na.rm = T)) %>%
  ungroup() %>% 
  select(name, height, mass, mean_height_mass)
```

```
# A tibble: 87 × 4
   name               height  mass mean_height_mass
   <chr>               <int> <dbl>            <dbl>
 1 Luke Skywalker        172    77            124. 
 2 C-3PO                 167    75            121  
 3 R2-D2                  96    32             64  
 4 Darth Vader           202   136            169  
 5 Leia Organa           150    49             99.5
 6 Owen Lars             178   120            149  
 7 Beru Whitesun Lars    165    75            120  
 8 R5-D4                  97    32             64.5
 9 Biggs Darklighter     183    84            134. 
10 Obi-Wan Kenobi        182    77            130. 
# ℹ 77 more rows
```

#### Practice 1

Find out what the average `height` and `mass` (as well as the standard deviation) is from different `species` in different `homeworld`s. Why is the standard deviation `NA` for many groups?  


``` r
# write your code here 
```

Who is the tallest member of each species? What eye color do they have? The `top_n()` function or the `row_number()` function (in combination with `filter()`) will be useful here. 


``` r
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

#### `pivot_longer()` and `pivot_wider()`

Let's first generate a data set that is _not_ tidy. 


``` r
# construct data frame 
df.reshape = tibble(participant = c(1, 2),
                    observation_1 = c(10, 25),
                    observation_2 = c(100, 63),
                    observation_3 = c(24, 45)) %>% 
  print()
```

```
# A tibble: 2 × 4
  participant observation_1 observation_2 observation_3
        <dbl>         <dbl>         <dbl>         <dbl>
1           1            10           100            24
2           2            25            63            45
```

Here, I've generated data from two participants with three observations. This data frame is not tidy since each row contains more than a single observation. Data frames that have one row per participant but many observations are called _wide_ data frames. 

We can make it tidy using the `pivot_longer()` function. 


``` r
df.reshape.long = df.reshape %>% 
  pivot_longer(cols = -participant,
               names_to = "index",
               values_to = "rating") %>%
  arrange(participant) %>% 
  print()
```

```
# A tibble: 6 × 3
  participant index         rating
        <dbl> <chr>          <dbl>
1           1 observation_1     10
2           1 observation_2    100
3           1 observation_3     24
4           2 observation_1     25
5           2 observation_2     63
6           2 observation_3     45
```

`df.reshape.long` now contains one observation in each row. Data frames with one row per observation are called _long_ data frames. 

The `pivot_longer()` function takes at least four arguments: 

1. the data which I've passed to it via the pipe `%>%` 
2. a specification for which columns we want to gather -- here I've specified that we want to gather the values from all columns except the `participant` column
3. a `names_to` argument which specifies the name of the column which will contain the column names of the original data frame
4. a `values_to` argument which specifies the name of the column which will contain the values that were spread across different columns in the original data frame

`pivot_wider()` is the counterpart of `pivot_longer()`. We can use it to go from a data frame that is in _long_ format, to a data frame in _wide_ format, like so: 


``` r
df.reshape.wide = df.reshape.long %>% 
  pivot_wider(names_from = index,
              values_from = rating) %>% 
  print()
```

```
# A tibble: 2 × 4
  participant observation_1 observation_2 observation_3
        <dbl>         <dbl>         <dbl>         <dbl>
1           1            10           100            24
2           2            25            63            45
```

For my data, I often have a wide data frame that contains demographic information about participants, and a long data frame that contains participants' responses in the experiment. In Section \@ref(joining-multiple-data-frames), we will learn how to combine information from multiple data frames (with potentially different formats).

Here is a more advanced example that involves reshaping a data frame. Let's consider the following data frame to start with: 


``` r
# construct data frame 
df.reshape2 = tibble(participant = c(1, 2),
                     stimulus_1 = c("flower", "car"),
                     observation_1 = c(10, 25),
                     stimulus_2 = c("house", "flower"),
                     observation_2 = c(100, 63),
                     stimulus_3 = c("car", "house"),
                     observation_3 = c(24, 45)) %>% 
  print()
```

```
# A tibble: 2 × 7
  participant stimulus_1 observation_1 stimulus_2 observation_2 stimulus_3
        <dbl> <chr>              <dbl> <chr>              <dbl> <chr>     
1           1 flower                10 house                100 car       
2           2 car                   25 flower                63 house     
# ℹ 1 more variable: observation_3 <dbl>
```

The data frame contains in each row: which stimuli a participant saw, and what rating she gave. The participants saw a picture of a flower, car, and house, and rated how much they liked the picture on a scale from 0 to 100. The order at which the pictures were presented was randomized between participants. I will use a combination of `pivot_longer()`, and `pivot_wider()` to turn this into a data frame in long format. 


``` r
df.reshape2 %>% 
  pivot_longer(cols = -participant,
               names_to = c("index", "order"),
               names_sep = "_",
               values_to = "rating",
               values_transform = as.character) %>% 
  pivot_wider(names_from = "index",
              values_from = "rating") %>% 
  mutate(across(.cols = c(order, observation),
                .fns = ~ as.numeric(.))) %>% 
  select(participant, order, stimulus, rating = observation)
```

```
# A tibble: 6 × 4
  participant order stimulus rating
        <dbl> <dbl> <chr>     <dbl>
1           1     1 flower       10
2           1     2 house       100
3           1     3 car          24
4           2     1 car          25
5           2     2 flower       63
6           2     3 house        45
```

Voilà! Getting the desired data frame involved a few new tricks. Let's take it step by step. 

First, I use `pivot_longer()` to make a long table. 


``` r
df.reshape2 %>% 
  pivot_longer(cols = -participant,
               names_to = c("index", "order"),
               names_sep = "_",
               values_to = "rating",
               values_transform = as.character)
```

```
# A tibble: 12 × 4
   participant index       order rating
         <dbl> <chr>       <chr> <chr> 
 1           1 stimulus    1     flower
 2           1 observation 1     10    
 3           1 stimulus    2     house 
 4           1 observation 2     100   
 5           1 stimulus    3     car   
 6           1 observation 3     24    
 7           2 stimulus    1     car   
 8           2 observation 1     25    
 9           2 stimulus    2     flower
10           2 observation 2     63    
11           2 stimulus    3     house 
12           2 observation 3     45    
```

Notice how I've used a combination of the `names_to = ` and `names_sep = ` arguments to create two columns. Because I'm combining data of two different types ("character" and "numeric"), I needed to specify what I want the resulting data type to be via the `values_transform = ` argument. 

I would like to have the information about the stimulus and the observation in the same row. That is, I want to see what rating a participant gave to the flower stimulus, for example. To get there, I can use the `pivot_wider()` function to make a separate column for each entry in `index` that contains the values in `rating`. 


``` r
df.reshape2 %>% 
  pivot_longer(cols = -participant,
               names_to = c("index", "order"),
               names_sep = "_",
               values_to = "rating",
               values_transform = as.character) %>% 
  pivot_wider(names_from = "index",
              values_from = "rating")
```

```
# A tibble: 6 × 4
  participant order stimulus observation
        <dbl> <chr> <chr>    <chr>      
1           1 1     flower   10         
2           1 2     house    100        
3           1 3     car      24         
4           2 1     car      25         
5           2 2     flower   63         
6           2 3     house    45         
```

That's pretty much it. Now, each row contains information about the order in which a stimulus was presented, what the stimulus was, and the judgment that a participant made in this trial. 


``` r
df.reshape2 %>% 
  pivot_longer(cols = -participant,
               names_to = c("index", "order"),
               names_sep = "_",
               values_to = "rating",
               values_transform = as.character) %>% 
  pivot_wider(names_from = "index",
              values_from = "rating") %>% 
  mutate(across(.cols = c(order, observation),
                .fns = as.numeric)) %>% 
  select(participant, order, stimulus, rating = observation)
```

```
# A tibble: 6 × 4
  participant order stimulus rating
        <dbl> <dbl> <chr>     <dbl>
1           1     1 flower       10
2           1     2 house       100
3           1     3 car          24
4           2     1 car          25
5           2     2 flower       63
6           2     3 house        45
```

The rest is familiar. I've used `mutate()` with `across()` to turn `order` and `observation` into numeric columns, `select()` to change the order of the columns (and renamed the `observation` column to `rating` along the way). 

Getting familiar with `pivot_longer()` and `pivot_wider()` takes some time plus trial and error. So don't be discouraged if you don't get what you want straight away. Once you've mastered these functions, they will make it much easier to beat your data frames into shape. 

After having done some transformations like this, it's worth checking that nothing went wrong. I often compare a few values in the transformed and original data frame to make sure everything is legit. 

When reading older code, you will often see `gather()` (instead of `pivot_longer()`), and `spread()` (instead of `pivot_wider()`). `gather` and `spread` are not developed anymore now, and their newer counterparts have additional functionality that comes in handy.  

#### `separate()` and `unite()`

Sometimes, we want to separate one column into multiple columns. For example, we could have achieved the same result we did above slightly differently, like so: 


``` r
df.reshape2 %>% 
  pivot_longer(cols = -participant,
               names_to = "index",
               values_to = "rating",
               values_transform = as.character) %>% 
  separate(col = index,
           into = c("index", "order"),
           sep = "_")
```

```
# A tibble: 12 × 4
   participant index       order rating
         <dbl> <chr>       <chr> <chr> 
 1           1 stimulus    1     flower
 2           1 observation 1     10    
 3           1 stimulus    2     house 
 4           1 observation 2     100   
 5           1 stimulus    3     car   
 6           1 observation 3     24    
 7           2 stimulus    1     car   
 8           2 observation 1     25    
 9           2 stimulus    2     flower
10           2 observation 2     63    
11           2 stimulus    3     house 
12           2 observation 3     45    
```

Here, I've used the `separate()` function to separate the original `index` column into two columns. The `separate()` function takes four arguments: 

1. the data which I've passed to it via the pipe `%>%` 
2. the name of the column `col` which we want to separate
3. the names of the columns `into` into which we want to separate the original column 
4. the separator `sep` that we want to use to split the columns. 

Note, like `pivot_longer()` and `pivot_wider()`, there is a partner for `separate()`, too. It's called `unite()` and it allows you to combine several columns into one, like so:


``` r
tibble(index = c("flower", "observation"),
       order = c(1, 2)) %>% 
  unite("combined", index, order)
```

```
# A tibble: 2 × 1
  combined     
  <chr>        
1 flower_1     
2 observation_2
```

Sometimes, we may have a data frame where data is recorded in a long string. 


``` r
df.reshape3 = tibble(participant = 1:2,
                     judgments = c("10, 4, 12, 15", "3, 4")) %>% 
  print()
```

```
# A tibble: 2 × 2
  participant judgments    
        <int> <chr>        
1           1 10, 4, 12, 15
2           2 3, 4         
```

Here, I've created a data frame with data from two participants. For whatever reason, we have four judgments from participant 1 and only two judgments from participant 2 (data is often messy in real life, too!). 

We can use the `separate_rows()` function to turn this into a tidy data frame in long format. 


``` r
df.reshape3 %>% 
  separate_rows(judgments)
```

```
# A tibble: 6 × 2
  participant judgments
        <int> <chr>    
1           1 10       
2           1 4        
3           1 12       
4           1 15       
5           2 3        
6           2 4        
```

#### Practice 2

Load this data frame first.


``` r
df.practice2 = tibble(participant = 1:10,
                      initial = c("AR", "FA", "IR", "NC", "ER", "PI", "DH", "CN", "WT", "JD"), 
                      judgment_1 = c(12, 13, 1, 14, 5, 6, 12, 41, 100, 33),
                      judgment_2 = c(2, 20, 10, 89, 94, 27, 29, 19, 57, 74),
                      judgment_3 = c(2, 20, 10, 89, 94, 27, 29, 19, 57, 74))
```

- Make the `df.practice2` data frame tidy (by turning into a long format).
- Compute the z-score of each participants' judgments (using the `scale()` function).
- Calculate the mean and standard deviation of each participants' z-scored judgments. 
- Notice anything interesting? Think about what [z-scoring](https://www.statisticshowto.com/probability-and-statistics/z-score/) does ... 


``` r
# write your code here 
```


### Joining multiple data frames

It's nice to have all the information we need in a single, tidy data frame. We have learned above how to go from a single untidy data frame to a tidy one. However, often our situation to start off with is even worse. The information we need sits in several, messy data frames. 

For example, we may have one data frame `df.stimuli` with information about each stimulus, and then have another data frame with participants' responses `df.responses` that only contains a stimulus index but no other infromation about the stimuli. 


``` r
set.seed(1) # setting random seed to make this example reproducible

# data frame with stimulus information
df.stimuli = tibble(index = 1:5,
  height = c(2, 3, 1, 4, 5),
  width = c(4, 5, 2, 3, 1),
  n_dots = c(12, 15, 5, 13, 7),
  color = c("green", "blue", "white", "red", "black")) %>% 
  print()
```

```
# A tibble: 5 × 5
  index height width n_dots color
  <int>  <dbl> <dbl>  <dbl> <chr>
1     1      2     4     12 green
2     2      3     5     15 blue 
3     3      1     2      5 white
4     4      4     3     13 red  
5     5      5     1      7 black
```

``` r
# data frame with participants' responses 
df.responses = tibble(participant = rep(1:3, each = 5),
  index = rep(1:5, 3), 
  response = sample(0:100, size = 15, replace = TRUE)) %>% # randomly sample 15 values from 0 to 100
  print()
```

```
# A tibble: 15 × 3
   participant index response
         <int> <int>    <int>
 1           1     1       67
 2           1     2       38
 3           1     3        0
 4           1     4       33
 5           1     5       86
 6           2     1       42
 7           2     2       13
 8           2     3       81
 9           2     4       58
10           2     5       50
11           3     1       96
12           3     2       84
13           3     3       20
14           3     4       53
15           3     5       73
```

The `df.stimuli` data frame contains an `index`, information about the `height`, and `width`, as well as the number of `dots`, and their `color`. Let's imagine that participants had to judge how much they liked each image from a scale of 0 ("not liking this dot pattern at all") to 100 ("super thrilled about this dot pattern"). 

Let's say that I now wanted to know what participants' average response for the differently colored dot patterns are. Here is how I would do this: 


``` r
df.responses %>% 
  left_join(df.stimuli %>%
              select(index, color),
            by = "index") %>% 
  group_by(color) %>% 
  summarize(response_mean = mean(response))
```

```
# A tibble: 5 × 2
  color response_mean
  <chr>         <dbl>
1 black          69.7
2 blue           45  
3 green          68.3
4 red            48  
5 white          33.7
```

Let's take it step by step. The key here is to add the information from the `df.stimuli` data frame to the `df.responses` data frame. 


``` r
df.responses %>% 
  left_join(df.stimuli %>% 
              select(index, color),
            by = "index")
```

```
# A tibble: 15 × 4
   participant index response color
         <int> <int>    <int> <chr>
 1           1     1       67 green
 2           1     2       38 blue 
 3           1     3        0 white
 4           1     4       33 red  
 5           1     5       86 black
 6           2     1       42 green
 7           2     2       13 blue 
 8           2     3       81 white
 9           2     4       58 red  
10           2     5       50 black
11           3     1       96 green
12           3     2       84 blue 
13           3     3       20 white
14           3     4       53 red  
15           3     5       73 black
```

I've joined the `df.stimuli` table in which I've only selected the `index` and `color` column, with the `df.responses` table, and specified the `index` column as the one by which the tables should be joined. This is the only column that both of the data frames have in common. 

To specify multiple columns by which we would like to join tables, we specify the `by` argument as follows: `by = c("one_column", "another_column")`. 

Sometimes, the tables I want to join don't have any column names in common. In that case, we can tell the `left_join()` function which column pair(s) should be used for joining. 


``` r
df.responses %>% 
  rename(stimuli = index) %>% # I've renamed the index column to stimuli
  left_join(df.stimuli %>% 
              select(index, color),
            by = c("stimuli" = "index")) 
```

```
# A tibble: 15 × 4
   participant stimuli response color
         <int>   <int>    <int> <chr>
 1           1       1       67 green
 2           1       2       38 blue 
 3           1       3        0 white
 4           1       4       33 red  
 5           1       5       86 black
 6           2       1       42 green
 7           2       2       13 blue 
 8           2       3       81 white
 9           2       4       58 red  
10           2       5       50 black
11           3       1       96 green
12           3       2       84 blue 
13           3       3       20 white
14           3       4       53 red  
15           3       5       73 black
```

Here, I've first renamed the index column (to create the problem) and then used the `by = c("stimuli" = "index")` construction (to solve the problem). 

In my experience, it often takes a little bit of playing around to make sure that the data frames were joined as intended. One very good indicator is the row number of the initial data frame, and the joined one. For a `left_join()`, most of the time, we want the row number of the original data frame ("the one on the left") and the joined data frame to be the same. If the row number changed, something probably went wrong. 

Take a look at the `join` help file to see other operations for combining two or more data frames into one (make sure to look at the one from the `dplyr` package). 

#### Practice 3

Load these three data frames first: 


``` r
set.seed(1)

df.judgments = tibble(participant = rep(1:3, each = 5),
                      stimulus = rep(c("red", "green", "blue"), 5),
                      judgment = sample(0:100, size = 15, replace = T))

df.information = tibble(number = seq(from = 0, to = 100, length.out = 5),
                        color = c("red", "green", "blue", "black", "white"))
```

Create a new data frame called `df.join` that combines the information from both `df.judgments` and `df.information`. Note that column with the colors is called `stimulus` in `df.judgments` and `color` in `df.information`. At the end, you want a data frame that contains the following columns: `participant`, `stimulus`, `number`, and `judgment`. 


``` r
# write your code here
```


### Dealing with missing data

There are two ways for data to be missing. 

- __implicit__: data is not present in the table 
- __explicit__: data is flagged with `NA`

We can check for explicit missing values using the `is.na()` function like so: 


``` r
tmp.na = c(1, 2, NA, 3)
is.na(tmp.na)
```

```
[1] FALSE FALSE  TRUE FALSE
```

I've first created a vector `tmp.na` with a missing value at index 3. Calling the `is.na()` function on this vector yields a logical vector with `FALSE` for each value that is not missing, and `TRUE` for each missing value.

Let's say that we have a data frame with missing values and that we want to replace those missing values with something else. Let's first create a data frame with missing values. 


``` r
df.missing = tibble(x = c(1, 2, NA),
                    y = c("a", NA, "b"))
print(df.missing)
```

```
# A tibble: 3 × 2
      x y    
  <dbl> <chr>
1     1 a    
2     2 <NA> 
3    NA b    
```

We can use the `replace_na()` function to replace the missing values with something else. 


``` r
df.missing %>% 
  mutate(x = replace_na(x, replace = 0),
         y = replace_na(y, replace = "unknown"))
```

```
# A tibble: 3 × 2
      x y      
  <dbl> <chr>  
1     1 a      
2     2 unknown
3     0 b      
```

We can also remove rows with missing values using the `drop_na()` function. 


``` r
df.missing %>% 
  drop_na()
```

```
# A tibble: 1 × 2
      x y    
  <dbl> <chr>
1     1 a    
```

If we only want to drop values from specific columns, we can specify these columns within the `drop_na()` function call. So, if we only want to drop rows that have missing values in the `x` column, we can write: 


``` r
df.missing %>% 
  drop_na(x)
```

```
# A tibble: 2 × 2
      x y    
  <dbl> <chr>
1     1 a    
2     2 <NA> 
```

To make the distinction between implicit and explicit missing values more concrete, let's consider the following example (taken from [here](https://r4ds.had.co.nz/tidy-data.html#missing-values-3)): 


``` r
df.stocks = tibble(year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
                   qtr    = c(   1,    2,    3,    4,    2,    3,    4),
                   return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66))
```

There are two missing values in this dataset:

- The return for the fourth quarter of 2015 is explicitly missing, because the cell where its value should be instead contains `NA`.
- The return for the first quarter of 2016 is implicitly missing, because it simply does not appear in the dataset.

We can use the `complete()` function to make implicit missing values explicit: 


``` r
df.stocks %>% 
  complete(year, qtr)
```

```
# A tibble: 8 × 3
   year   qtr return
  <dbl> <dbl>  <dbl>
1  2015     1   1.88
2  2015     2   0.59
3  2015     3   0.35
4  2015     4  NA   
5  2016     1  NA   
6  2016     2   0.92
7  2016     3   0.17
8  2016     4   2.66
```

Note how now, the data frame contains an additional row in which `year = 2016`, `qtr = 1` and `return = NA` even though we didn't originally specify this. 

We can also directly tell the `complete()` function to replace the `NA` values via passing a list to its `fill` argument like so: 


``` r
df.stocks %>% 
  complete(year, qtr, fill = list(return = 0))
```

```
# A tibble: 8 × 3
   year   qtr return
  <dbl> <dbl>  <dbl>
1  2015     1   1.88
2  2015     2   0.59
3  2015     3   0.35
4  2015     4   0   
5  2016     1   0   
6  2016     2   0.92
7  2016     3   0.17
8  2016     4   2.66
```

This specifies that we would like to replace any `NA` in the `return` column with `0`. Again, if we had multiple columns with `NA`s, we could speficy for each column separately how to replace it. 

## Reading in data

So far, we've used data sets that already came with the packages we've loaded. In the visualization chapters, we used the `diamonds` data set from the `ggplot2` package, and in the data wrangling chapters, we used the `starwars` data set from the `dplyr` package. 


| file type|platform   |description                                  |
|---------:|:----------|:--------------------------------------------|
|     `csv`|general    |medium-size data frames                      |
|   `RData`|R          |saving the results of intensive computations |
|     `xls`|excel      |people who use excel                         |
|    `json`|general    |more complex data structures                 |
| `feather`|python & R |fast interaction between R and python        |


The `foreign` [package](https://cran.r-project.org/web/packages/foreign/index.html) helps with importing data that was saved in SPSS, Stata, or Minitab. 

For data in a json format, I highly recommend the `tidyjson` [package](https://github.com/sailthru/tidyjson).  

### csv

I've stored some data files in the `data/` subfolder. Let's first read a csv (= **c**omma-**s**eparated-**v**alue) file. 


``` r
df.csv = read_csv("data/movies.csv")
```

```
Rows: 2961 Columns: 11
── Column specification ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Delimiter: ","
chr (3): title, genre, director
dbl (8): year, duration, gross, budget, cast_facebook_likes, votes, reviews,...

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

The `read_csv()` function gives us information about how each column was parsed. Here, we have some columns that are characters (such as `title` and `genre`), and some columns that are numeric (such as `year` and `duration`). Note that it says `double()` in the specification but double and numeric are identical.  

And let's take a quick peek at the data: 


``` r
df.csv %>% glimpse()
```

```
Rows: 2,961
Columns: 11
$ title               <chr> "Over the Hill to the Poorhouse", "The Broadway Me…
$ genre               <chr> "Crime", "Musical", "Comedy", "Comedy", "Comedy", …
$ director            <chr> "Harry F. Millarde", "Harry Beaumont", "Lloyd Baco…
$ year                <dbl> 1920, 1929, 1933, 1935, 1936, 1937, 1939, 1939, 19…
$ duration            <dbl> 110, 100, 89, 81, 87, 83, 102, 226, 88, 144, 172, …
$ gross               <dbl> 3000000, 2808000, 2300000, 3000000, 163245, 184925…
$ budget              <dbl> 100000, 379000, 439000, 609000, 1500000, 2000000, …
$ cast_facebook_likes <dbl> 4, 109, 995, 824, 352, 229, 2509, 1862, 1178, 2037…
$ votes               <dbl> 5, 4546, 7921, 13269, 143086, 133348, 291875, 2153…
$ reviews             <dbl> 2, 107, 162, 164, 331, 349, 746, 863, 252, 119, 33…
$ rating              <dbl> 4.8, 6.3, 7.7, 7.8, 8.6, 7.7, 8.1, 8.2, 7.5, 6.9, …
```

The data frame contains a bunch of movies with information about their genre, director, rating, etc. 

The `readr` package (which contains the `read_csv()` function) has a number of other functions for reading data. Just type `read_` in the console below and take a look at the suggestions that autocomplete offers. 

### RData

RData is a data format native to R. Since this format can only be read by R, it's not a good format for sharing data. However, it's a useful format that allows us to flexibly save and load R objects. For example, consider that we always start our script by reading in and structuring data, and that this takes quite a while. One thing we can do is to save the output of intermediate steps as an RData object, and then simply load this object (instead of re-running the whole routine every time). 

We read (or load) an RData file in the following way:


``` r
load("data/test.RData", verbose = TRUE)
```

```
Loading objects:
  df.test
```

I've set the `verbose = ` argument to `TRUE` here so that the `load()` function tells me what objects it added to the environment. This is useful for checking whether existing objects were overwritten. 

## Saving data

### csv

To save a data frame as a csv file, we simply write: 


``` r
df.test = tibble(x = 1:3,
                 y = c("test1", "test2", "test3"))

write_csv(df.test, file = "data/test.csv")
```

Just like for reading in data, the `readr` package has a number of other functions for saving data. Just type `write_` in the console below and take a look at the autocomplete suggestions.

### RData

To save objects as an RData file, we write: 


``` r
save(df.test, file = "data/test.RData")
```

We can add multiple objects simply by adding them at the beginning, like so: 


``` r
save(df.test, df.starwars, file = "data/test_starwars.RData")
```

## Additional resources

### Cheatsheets

-   [wrangling data](figures/data-wrangling.pdf) --> wrangling data using `dplyr` and `tidyr`
-   [importing & saving data](figures/data-import.pdf) --> importing and saving data with `readr`

### Data camp courses

-   [Joining tables](https://www.datacamp.com/courses/joining-data-in-r-with-dplyr)
-   [writing functions](https://www.datacamp.com/courses/writing-functions-in-r)
-   [importing data 1](https://www.datacamp.com/courses/importing-data-in-r-part-1)
-   [importing data 2](https://www.datacamp.com/courses/importing-data-in-r-part-2)
-   [categorical data](https://www.datacamp.com/courses/categorical-data-in-the-tidyverse)
-   [dealing with missing data](https://www.datacamp.com/courses/dealing-with-missing-data-in-r)

### Books and chapters

-   [Chapters 17-21 in R for Data Science](https://r4ds.had.co.nz/program-intro.html)
-   [Exploratory data analysis](https://bookdown.org/rdpeng/exdata/)
-   [R programming for data science](https://bookdown.org/rdpeng/rprogdatascience/)

### Tutorials

-   **Joining data**:
    -   [Two-table verbs](https://dplyr.tidyverse.org/articles/two-table.html)
    -   [Tutorial by Jenny Bryan](http://stat545.com/bit001_dplyr-cheatsheet.html)
-   [tidyexplain](https://github.com/gadenbuie/tidyexplain): Animations that illustrate how `pivot_longer()`, `pivot_wider()`, `left_join()`, etc. work

## Session info


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
 [1] lubridate_1.9.3 forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4    
 [5] purrr_1.0.2     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
 [9] ggplot2_3.5.1   tidyverse_2.0.0 knitr_1.48     

loaded via a namespace (and not attached):
 [1] bit_4.0.5         gtable_0.3.5      jsonlite_1.8.8    crayon_1.5.3     
 [5] compiler_4.4.1    tidyselect_1.2.1  parallel_4.4.1    jquerylib_0.1.4  
 [9] scales_1.3.0      yaml_2.3.9        fastmap_1.2.0     R6_2.5.1         
[13] generics_0.1.3    bookdown_0.40     munsell_0.5.1     bslib_0.7.0      
[17] pillar_1.9.0      tzdb_0.4.0        rlang_1.1.4       utf8_1.2.4       
[21] stringi_1.8.4     cachem_1.1.0      xfun_0.45         sass_0.4.9       
[25] bit64_4.0.5       timechange_0.3.0  cli_3.6.3         withr_3.0.0      
[29] magrittr_2.0.3    digest_0.6.36     grid_4.4.1        vroom_1.6.5      
[33] hms_1.1.3         lifecycle_1.0.4   vctrs_0.6.5       evaluate_0.24.0  
[37] glue_1.7.0        fansi_1.0.6       colorspace_2.1-0  rmarkdown_2.27   
[41] tools_4.4.1       pkgconfig_2.0.3   htmltools_0.5.8.1
```
