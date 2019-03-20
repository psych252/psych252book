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

opts_chunk$set(
  comment = "",
  results = "hold",
  fig.show = "hold"
)
```

## Some R basics 

To test your knowledge of the R basics, I recommend taking the free interactive tutorial on datacamp: [Introduction to R](https://www.datacamp.com/courses/free-introduction-to-r). Here, I will just give a very quick overview of some of the basics. 

### Modes 

Variables in R can have different modes. Table \@ref(tab:data-wrangling1-03) shows the most common ones. 


Table: (\#tab:data-wrangling1-03)Most commonly used variable modes in R.

          name  example                  
--------------  -------------------------
       numeric  `1`, `3`, `48`           
     character  `'Steve'`, `'a'`, `'78'` 
       logical  `TRUE`, `FALSE`          
 not available  `NA`                     

For characters you can either use `"` or `'`. R has a number of functions to convert a variable from one mode to another. `NA` is used for missing values.


```r
tmp1 = "1" # we start with a character
str(tmp1) 

tmp2 = as.numeric(tmp1) # turn it into a numeric
str(tmp2) 

tmp3 = as.factor(tmp2) # turn that into a factor
str(tmp3)

tmp4 = as.character(tmp3) # and go full cycle by turning it back into a character
str(tmp4)

identical(tmp1, tmp4) # checks whether tmp1 and tmp4 are the same
```

```
 chr "1"
 num 1
 Factor w/ 1 level "1": 1
 chr "1"
[1] TRUE
```

The `str()` function displays the structure of an R object. Here, it shows us what mode the variable is. 

### Data types

R has a number of different data types. Table \@ref(tab:data-wrangling1-05) shows the ones you're most likely to come across (taken from [this source](https://www.statmethods.net/input/datatypes.html)): 


Table: (\#tab:data-wrangling1-05)Most commonly used data types in R.

       name  description                                                   
-----------  --------------------------------------------------------------
     vector  list of values with of the same variable mode                 
     factor  for ordinal variables                                         
     matrix  2D data structure                                             
      array  same as matrix for higher dimensional data                    
 data frame  similar to matrix but with column names                       
       list  flexible type that can contain different other variable types 

#### Vectors 

We build vectors using the concatenate function `c()`, and we use `[]` to access one or more elements of a vector.  


```r
numbers = c(1, 4, 5) # make a vector
numbers[2] # access the second element 
numbers[1:2] # access the first two elements
numbers[c(1, 3)] # access the first and last element
```

```
[1] 4
[1] 1 4
[1] 1 5
```

In R (unlike in Python for example), 1 refers to the first element of a vector (or list). 

#### Matrix 

We build a matrix using the `matrix()` function, and we use `[]` to access its elements. 


```r
matrix = matrix(data = c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2)
matrix # the full matrix
matrix[1, 2] # element in row 1, column 2
matrix[1, ] # all elements in the first row 
matrix[ , 1] # all elements in the first column 
matrix[-1, ] # a matrix which excludes the first row
```

```
     [,1] [,2]
[1,]    1    4
[2,]    2    5
[3,]    3    6
[1] 4
[1] 1 4
[1] 1 2 3
     [,1] [,2]
[1,]    2    5
[2,]    3    6
```

Note how we use an empty placeholder to indicate that we want to select all the values in a row or column, and `-` to indicate that we want to remove something.

#### Array 

Arrays work the same was as matrices with data of more than two dimensions. 

#### Data frame 


```r
df = tibble(participant_id = c(1, 2, 3),
            participant_name = c("Leia", "Luke", "Darth")) # make the data frame 

df # the complete data frame
df[1, 2] # a single element using numbers 

df$participant_id # all participants 
df[["participant_id"]] # same as before but using [[]] instead of $

df$participant_name[2] # name of the second participant
df[["participant_name"]][2] # same as above
```

```
# A tibble: 3 x 2
  participant_id participant_name
           <dbl> <chr>           
1              1 Leia            
2              2 Luke            
3              3 Darth           
# A tibble: 1 x 1
  participant_name
  <chr>           
1 Leia            
[1] 1 2 3
[1] 1 2 3
[1] "Luke"
[1] "Luke"
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

# three different ways of accessing a list
l.mixed$character
l.mixed[['character']]
l.mixed[[2]] 
```

```
$number
[1] 1

$character
[1] "2"

$factor
[1] 3
Levels: 3

$matrix
     [,1] [,2]
[1,]    1    3
[2,]    2    4

$df
# A tibble: 2 x 2
      x     y
  <dbl> <dbl>
1     1     3
2     2     4

[1] "2"
[1] "2"
[1] "2"
```

Lists are a very flexible data format. You can put almost anything in a list.

### Operators

Table \@ref(tab:data-wrangling1-10) shows the comparison operators that result in logical outputs. 


Table: (\#tab:data-wrangling1-10)Table of comparison operators that result in boolean (TRUE/FALSE) outputs.

symbol          name                                      
--------------  ------------------------------------------
`==`            equal to                                  
`!=`            not equal to                              
`>`, `<`        greater/less than                         
`>=`, `<=`      greater/less than or equal                
`&`, `|`, `!`   logical operators: and, or, not           
`%in%`          checks whether an element is in an object 


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
[1] "The number is neither 1 nor 2."
```

As a shorthand version, we can also use the `ifelse()` function like so: 


```r
number = 3
ifelse(test = number == 1, yes = "correct", no = "false")
```

```
[1] "false"
```


#### for loop


```r
sequence = 1:10

for(i in 1:length(sequence)){
  print(i)
}
```

```
[1] 1
[1] 2
[1] 3
[1] 4
[1] 5
[1] 6
[1] 7
[1] 8
[1] 9
[1] 10
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
[1] 1
[1] 2
[1] 3
[1] 4
[1] 5
[1] 6
[1] 7
[1] 8
[1] 9
[1] 10
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
[1] "The result is 3"
```

I've used the `str_c()` function here to concatenate the string with the number. (R converts the number `x` into a string for us.) Note, R functions can only return a single object. However, this object can be a list (which can contain anything). 

#### Some often used functions 


Table: (\#tab:data-wrangling1-16)Some frequently used functions.

          name  description                                               
--------------  ----------------------------------------------------------
    `length()`  length of an object                                       
       `dim()`  dimensions of an object (e.g. number of rows and columns) 
      `rm()  `  remove an object                                          
       `seq()`  generate a sequence of numbers                            
       `rep()`  repeat something n times                                  
       `max()`  maximum                                                   
       `min()`  minimum                                                   
 `which.max()`  index of the maximum                                      
 `which.min()`  index of the maximum                                      
      `mean()`  mean                                                      
    `median()`  median                                                    
       `sum()`  sum                                                       
       `var()`  variance                                                  
        `sd()`  standard deviation                                        

### The pipe operator `%>%` 

<div class="figure">
<img src="figures/pipe.jpg" alt="Inspiration for the `magrittr` package name." width="80%" />
<p class="caption">(\#fig:data-wrangling1-17)Inspiration for the `magrittr` package name.</p>
</div>

<div class="figure">
<img src="figures/magrittr.png" alt="The `magrittr` package logo." width="40%" />
<p class="caption">(\#fig:data-wrangling1-18)The `magrittr` package logo.</p>
</div>

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
[1] 6
```

With the pipe, we can rewrite this as: 


```r
x = 1:3

# with the pipe  
x %>% sum()
```

```
[1] 6
```

This doesn't seem super useful yet, but just hold on a little longer. 

> `f(x, y)` can be rewritten as `x %>% f(y)`

So, we could rewrite the following standard R code ... 


```r
# rounding pi to 6 digits, standard R 
round(pi, digits = 6)
```

```
[1] 3.141593
```

... by using the pipe: 


```r
# rounding pi to 6 digits, standard R 
pi %>% round(digits = 6)
```

```
[1] 3.141593
```

Here is another example: 


```r
a = 3
b = 4
sum(a, b) # standard way 
a %>% sum(b) # the pipe way 
```

```
[1] 7
[1] 7
```

The pipe operator inserts the result of the previous computation as a first element into the next computation. So, `a %>% sum(b)` is equivalent to `sum(a, b)`. We can also specify to insert the result at a different position via the `.` operator. For example:  


```r
a = 1
b = 10 
b %>% seq(from = a, to = .)
```

```
 [1]  1  2  3  4  5  6  7  8  9 10
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
[1] 1.183216
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
[1] 1.183216
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

# the pipe way (write your code underneath)
```

```
[1] 0.0000000 0.6931472 1.0986123 1.3862944 1.6094379
```


```r
# standard way
mean(round(sqrt(x), digits = 2))

# the pipe way (write your code underneath)
```

```
[1] 1.676
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
# A tibble: 6 x 13
  name  height  mass hair_color skin_color eye_color birth_year gender
  <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
1 Luke…    172    77 blond      fair       blue            19   male  
2 C-3PO    167    75 <NA>       gold       yellow         112   <NA>  
3 R2-D2     96    32 <NA>       white, bl… red             33   <NA>  
4 Dart…    202   136 none       white      yellow          41.9 male  
5 Leia…    150    49 brown      light      brown           19   female
6 Owen…    178   120 brown, gr… light      blue            52   male  
# … with 5 more variables: homeworld <chr>, species <chr>, films <list>,
#   vehicles <list>, starships <list>
```

### `glimpse()`

`glimpse()` is helpful when the data frame has many columns. The data is shown in a transposed way with columns as rows. 


```r
glimpse(df.starwars)
```

```
Observations: 87
Variables: 13
$ name       <chr> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "L…
$ height     <int> 172, 167, 96, 202, 150, 178, 165, 97, 183, 182, 188, …
$ mass       <dbl> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 84.…
$ hair_color <chr> "blond", NA, NA, "none", "brown", "brown, grey", "bro…
$ skin_color <chr> "fair", "gold", "white, blue", "white", "light", "lig…
$ eye_color  <chr> "blue", "yellow", "red", "yellow", "brown", "blue", "…
$ birth_year <dbl> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0, …
$ gender     <chr> "male", NA, NA, "male", "female", "male", "female", N…
$ homeworld  <chr> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alderaa…
$ species    <chr> "Human", "Droid", "Droid", "Human", "Human", "Human",…
$ films      <list> [<"Revenge of the Sith", "Return of the Jedi", "The …
$ vehicles   <list> [<"Snowspeeder", "Imperial Speeder Bike">, <>, <>, <…
$ starships  <list> [<"X-wing", "Imperial shuttle">, <>, <>, "TIE Advanc…
```

### `distinct()`

`distinct()` shows all the distinct values for a character or factor column. 


```r
df.starwars %>% 
  distinct(name)
```

```
# A tibble: 87 x 1
   name              
   <chr>             
 1 Luke Skywalker    
 2 C-3PO             
 3 R2-D2             
 4 Darth Vader       
 5 Leia Organa       
 6 Owen Lars         
 7 Beru Whitesun lars
 8 R5-D4             
 9 Biggs Darklighter 
10 Obi-Wan Kenobi    
# … with 77 more rows
```

### `count()`

`count()` shows a count of all the different distinct values in a column. 


```r
df.starwars %>% 
  count(gender)
```

```
# A tibble: 5 x 2
  gender            n
  <chr>         <int>
1 <NA>              3
2 female           19
3 hermaphrodite     1
4 male             62
5 none              2
```

It's possible to do grouped counts by combining several variables.


```r
df.starwars %>% 
  count(species, gender) %>% 
  head(n = 10)
```

```
# A tibble: 10 x 3
   species  gender     n
   <chr>    <chr>  <int>
 1 <NA>     female     3
 2 <NA>     male       2
 3 Aleena   male       1
 4 Besalisk male       1
 5 Cerean   male       1
 6 Chagrian male       1
 7 Clawdite female     1
 8 Droid    <NA>       3
 9 Droid    none       2
10 Dug      male       1
```

### `datatable()`

For RMardkown files specifically, we can use the `datatable()` function from the `DT` package to get an interactive table widget.


```r
df.starwars %>% 
  DT::datatable()
```

<!--html_preserve--><div id="htmlwidget-da689d38844b23c90e0d" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-da689d38844b23c90e0d">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87"],["Luke Skywalker","C-3PO","R2-D2","Darth Vader","Leia Organa","Owen Lars","Beru Whitesun lars","R5-D4","Biggs Darklighter","Obi-Wan Kenobi","Anakin Skywalker","Wilhuff Tarkin","Chewbacca","Han Solo","Greedo","Jabba Desilijic Tiure","Wedge Antilles","Jek Tono Porkins","Yoda","Palpatine","Boba Fett","IG-88","Bossk","Lando Calrissian","Lobot","Ackbar","Mon Mothma","Arvel Crynyd","Wicket Systri Warrick","Nien Nunb","Qui-Gon Jinn","Nute Gunray","Finis Valorum","Jar Jar Binks","Roos Tarpals","Rugor Nass","Ric Olié","Watto","Sebulba","Quarsh Panaka","Shmi Skywalker","Darth Maul","Bib Fortuna","Ayla Secura","Dud Bolt","Gasgano","Ben Quadinaros","Mace Windu","Ki-Adi-Mundi","Kit Fisto","Eeth Koth","Adi Gallia","Saesee Tiin","Yarael Poof","Plo Koon","Mas Amedda","Gregar Typho","Cordé","Cliegg Lars","Poggle the Lesser","Luminara Unduli","Barriss Offee","Dormé","Dooku","Bail Prestor Organa","Jango Fett","Zam Wesell","Dexter Jettster","Lama Su","Taun We","Jocasta Nu","Ratts Tyerell","R4-P17","Wat Tambor","San Hill","Shaak Ti","Grievous","Tarfful","Raymus Antilles","Sly Moore","Tion Medon","Finn","Rey","Poe Dameron","BB8","Captain Phasma","Padmé Amidala"],[172,167,96,202,150,178,165,97,183,182,188,180,228,180,173,175,170,180,66,170,183,200,190,177,175,180,150,null,88,160,193,191,170,196,224,206,183,137,112,183,163,175,180,178,94,122,163,188,198,196,171,184,188,264,188,196,185,157,183,183,170,166,165,193,191,183,168,198,229,213,167,79,96,193,191,178,216,234,188,178,206,null,null,null,null,null,165],[77,75,32,136,49,120,75,32,84,77,84,null,112,80,74,1358,77,110,17,75,78.2,140,113,79,79,83,null,null,20,68,89,90,null,66,82,null,null,null,40,null,null,80,null,55,45,null,65,84,82,87,null,50,null,null,80,null,85,null,null,80,56.2,50,null,80,null,79,55,102,88,null,null,15,null,48,null,57,159,136,79,48,80,null,null,null,null,null,45],["blond",null,null,"none","brown","brown, grey","brown",null,"black","auburn, white","blond","auburn, grey","brown","brown",null,null,"brown","brown","white","grey","black","none","none","black","none","none","auburn","brown","brown","none","brown","none","blond","none","none","none","brown","black","none","black","black","none","none","none","none","none","none","none","white","none","black","none","none","none","none","none","black","brown","brown","none","black","black","brown","white","black","black","blonde","none","none","none","white","none","none","none","none","none","none","brown","brown","none","none","black","brown","brown","none","unknown","brown"],["fair","gold","white, blue","white","light","light","light","white, red","light","fair","fair","fair","unknown","fair","green","green-tan, brown","fair","fair","green","pale","fair","metal","green","dark","light","brown mottle","fair","fair","brown","grey","fair","mottled green","fair","orange","grey","green","fair","blue, grey","grey, red","dark","fair","red","pale","blue","blue, grey","white, blue","grey, green, yellow","dark","pale","green","brown","dark","pale","white","orange","blue","dark","light","fair","green","yellow","yellow","light","fair","tan","tan","fair, green, yellow","brown","grey","grey","fair","grey, blue","silver, red","green, grey","grey","red, blue, white","brown, white","brown","light","pale","grey","dark","light","light","none","unknown","light"],["blue","yellow","red","yellow","brown","blue","blue","red","brown","blue-gray","blue","blue","blue","brown","black","orange","hazel","blue","brown","yellow","brown","red","red","brown","blue","orange","blue","brown","brown","black","blue","red","blue","orange","orange","orange","blue","yellow","orange","brown","brown","yellow","pink","hazel","yellow","black","orange","brown","yellow","black","brown","blue","orange","yellow","black","blue","brown","brown","blue","yellow","blue","blue","brown","brown","brown","brown","yellow","yellow","black","black","blue","unknown","red, blue","unknown","gold","black","green, yellow","blue","brown","white","black","dark","hazel","brown","black","unknown","brown"],[19,112,33,41.9,19,52,47,null,24,57,41.9,64,200,29,44,600,21,null,896,82,31.5,15,53,31,37,41,48,null,8,null,92,null,91,52,null,null,null,null,null,62,72,54,null,48,null,null,null,72,92,null,null,null,null,null,22,null,null,null,82,null,58,40,null,102,67,66,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,46],["male",null,null,"male","female","male","female",null,"male","male","male","male","male","male","male","hermaphrodite","male","male","male","male","male","none","male","male","male","male","female","male","male","male","male","male","male","male","male","male","male","male","male","male","female","male","male","female","male","male","male","male","male","male","male","female","male","male","male","male","male","female","male","male","female","female","female","male","male","male","female","male","male","female","female","male","female","male","male","female","male","male","male","female","male","male","female","male","none","female","female"],["Tatooine","Tatooine","Naboo","Tatooine","Alderaan","Tatooine","Tatooine","Tatooine","Tatooine","Stewjon","Tatooine","Eriadu","Kashyyyk","Corellia","Rodia","Nal Hutta","Corellia","Bestine IV",null,"Naboo","Kamino",null,"Trandosha","Socorro","Bespin","Mon Cala","Chandrila",null,"Endor","Sullust",null,"Cato Neimoidia","Coruscant","Naboo","Naboo","Naboo","Naboo","Toydaria","Malastare","Naboo","Tatooine","Dathomir","Ryloth","Ryloth","Vulpter","Troiken","Tund","Haruun Kal","Cerea","Glee Anselm","Iridonia","Coruscant","Iktotch","Quermia","Dorin","Champala","Naboo","Naboo","Tatooine","Geonosis","Mirial","Mirial","Naboo","Serenno","Alderaan","Concord Dawn","Zolan","Ojom","Kamino","Kamino","Coruscant","Aleen Minor",null,"Skako","Muunilinst","Shili","Kalee","Kashyyyk","Alderaan","Umbara","Utapau",null,null,null,null,null,"Naboo"],["Human","Droid","Droid","Human","Human","Human","Human","Droid","Human","Human","Human","Human","Wookiee","Human","Rodian","Hutt","Human","Human","Yoda's species","Human","Human","Droid","Trandoshan","Human","Human","Mon Calamari","Human","Human","Ewok","Sullustan","Human","Neimodian","Human","Gungan","Gungan","Gungan",null,"Toydarian","Dug",null,"Human","Zabrak","Twi'lek","Twi'lek","Vulptereen","Xexto","Toong","Human","Cerean","Nautolan","Zabrak","Tholothian","Iktotchi","Quermian","Kel Dor","Chagrian","Human","Human","Human","Geonosian","Mirialan","Mirialan","Human","Human","Human","Human","Clawdite","Besalisk","Kaminoan","Kaminoan","Human","Aleena",null,"Skakoan","Muun","Togruta","Kaleesh","Wookiee","Human",null,"Pau'an","Human","Human","Human","Droid",null,"Human"],[["Revenge of the Sith","Return of the Jedi","The Empire Strikes Back","A New Hope","The Force Awakens"],["Attack of the Clones","The Phantom Menace","Revenge of the Sith","Return of the Jedi","The Empire Strikes Back","A New Hope"],["Attack of the Clones","The Phantom Menace","Revenge of the Sith","Return of the Jedi","The Empire Strikes Back","A New Hope","The Force Awakens"],["Revenge of the Sith","Return of the Jedi","The Empire Strikes Back","A New Hope"],["Revenge of the Sith","Return of the Jedi","The Empire Strikes Back","A New Hope","The Force Awakens"],["Attack of the Clones","Revenge of the Sith","A New Hope"],["Attack of the Clones","Revenge of the Sith","A New Hope"],"A New Hope","A New Hope",["Attack of the Clones","The Phantom Menace","Revenge of the Sith","Return of the Jedi","The Empire Strikes Back","A New Hope"],["Attack of the Clones","The Phantom Menace","Revenge of the Sith"],["Revenge of the Sith","A New Hope"],["Revenge of the Sith","Return of the Jedi","The Empire Strikes Back","A New Hope","The Force Awakens"],["Return of the Jedi","The Empire Strikes Back","A New Hope","The Force Awakens"],"A New Hope",["The Phantom Menace","Return of the Jedi","A New Hope"],["Return of the Jedi","The Empire Strikes Back","A New Hope"],"A New Hope",["Attack of the Clones","The Phantom Menace","Revenge of the Sith","Return of the Jedi","The Empire Strikes Back"],["Attack of the Clones","The Phantom Menace","Revenge of the Sith","Return of the Jedi","The Empire Strikes Back"],["Attack of the Clones","Return of the Jedi","The Empire Strikes Back"],"The Empire Strikes Back","The Empire Strikes Back",["Return of the Jedi","The Empire Strikes Back"],"The Empire Strikes Back",["Return of the Jedi","The Force Awakens"],"Return of the Jedi","Return of the Jedi","Return of the Jedi","Return of the Jedi","The Phantom Menace",["Attack of the Clones","The Phantom Menace","Revenge of the Sith"],"The Phantom Menace",["Attack of the Clones","The Phantom Menace"],"The Phantom Menace","The Phantom Menace","The Phantom Menace",["Attack of the Clones","The Phantom Menace"],"The Phantom Menace","The Phantom Menace",["Attack of the Clones","The Phantom Menace"],"The Phantom Menace","Return of the Jedi",["Attack of the Clones","The Phantom Menace","Revenge of the Sith"],"The Phantom Menace","The Phantom Menace","The Phantom Menace",["Attack of the Clones","The Phantom Menace","Revenge of the Sith"],["Attack of the Clones","The Phantom Menace","Revenge of the Sith"],["Attack of the Clones","The Phantom Menace","Revenge of the Sith"],["The Phantom Menace","Revenge of the Sith"],["The Phantom Menace","Revenge of the Sith"],["The Phantom Menace","Revenge of the Sith"],"The Phantom Menace",["Attack of the Clones","The Phantom Menace","Revenge of the Sith"],["Attack of the Clones","The Phantom Menace"],"Attack of the Clones","Attack of the Clones","Attack of the Clones",["Attack of the Clones","Revenge of the Sith"],["Attack of the Clones","Revenge of the Sith"],"Attack of the Clones","Attack of the Clones",["Attack of the Clones","Revenge of the Sith"],["Attack of the Clones","Revenge of the Sith"],"Attack of the Clones","Attack of the Clones","Attack of the Clones","Attack of the Clones","Attack of the Clones","Attack of the Clones","The Phantom Menace",["Attack of the Clones","Revenge of the Sith"],"Attack of the Clones","Attack of the Clones",["Attack of the Clones","Revenge of the Sith"],"Revenge of the Sith","Revenge of the Sith",["Revenge of the Sith","A New Hope"],["Attack of the Clones","Revenge of the Sith"],"Revenge of the Sith","The Force Awakens","The Force Awakens","The Force Awakens","The Force Awakens","The Force Awakens",["Attack of the Clones","The Phantom Menace","Revenge of the Sith"]],[["Snowspeeder","Imperial Speeder Bike"],[],[],[],"Imperial Speeder Bike",[],[],[],[],"Tribubble bongo",["Zephyr-G swoop bike","XJ-6 airspeeder"],[],"AT-ST",[],[],[],"Snowspeeder",[],[],[],[],[],[],[],[],[],[],[],[],[],"Tribubble bongo",[],[],[],[],[],[],[],[],[],[],"Sith speeder",[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],"Flitknot speeder",[],[],"Koro-2 Exodrive airspeeder",[],[],[],[],[],[],[],[],[],"Tsmeu-6 personal wheel bike",[],[],[],[],[],[],[],[],[],[]],[["X-wing","Imperial shuttle"],[],[],"TIE Advanced x1",[],[],[],[],"X-wing",["Jedi starfighter","Trade Federation cruiser","Naboo star skiff","Jedi Interceptor","Belbullab-22 starfighter"],["Trade Federation cruiser","Jedi Interceptor","Naboo fighter"],[],["Millennium Falcon","Imperial shuttle"],["Millennium Falcon","Imperial shuttle"],[],[],"X-wing","X-wing",[],[],"Slave 1",[],[],"Millennium Falcon",[],[],[],"A-wing",[],"Millennium Falcon",[],[],[],[],[],[],"Naboo Royal Starship",[],[],[],[],"Scimitar",[],[],[],[],[],[],[],[],[],[],[],[],"Jedi starfighter",[],"Naboo fighter",[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],"Belbullab-22 starfighter",[],[],[],[],[],[],"T-70 X-wing fighter",[],[],["H-type Nubian yacht","Naboo star skiff","Naboo fighter"]]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>name<\/th>\n      <th>height<\/th>\n      <th>mass<\/th>\n      <th>hair_color<\/th>\n      <th>skin_color<\/th>\n      <th>eye_color<\/th>\n      <th>birth_year<\/th>\n      <th>gender<\/th>\n      <th>homeworld<\/th>\n      <th>species<\/th>\n      <th>films<\/th>\n      <th>vehicles<\/th>\n      <th>starships<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,3,7]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

### Other tools for taking a quick look at data 

#### `vis_dat()`

The `vis_dat()` function from the `visdat` package, gives a visual summary that makes it easy to see the variable types and whether there are missing values in the data. 


```r
visdat::vis_dat(df.starwars)
```

<img src="04-data_wrangling1_files/figure-html/data-wrangling1-37-1.png" width="672" />

<div class="info">
<p>When R loads packages, functions loaded in earlier packages are overwritten by functions of the same name from later packages. This means that the order in which packages are loaded matters. To make sure that a function from the correct package is used, you can use the <code>package_name::function_name()</code> construction. This way, the <code>function_name()</code> from the <code>package_name</code> is used, rather than the same function from a different package.</p>
<p>This is why, in general, I recommend to load the tidyverse package last (since it contains a large number of functions that we use a lot).</p>
</div>

#### `skim()`

The `skim()` function from the `skimr` package provides a nice overview of the data, separated by variable types. 


```r
# install.packages("skimr")
skimr::skim(df.starwars)
```

```
Skim summary statistics
 n obs: 87 
 n variables: 13 

── Variable type:character ────────────────────────────────────────────────
   variable missing complete  n min max empty n_unique
  eye_color       0       87 87   3  13     0       15
     gender       3       84 87   4  13     0        4
 hair_color       5       82 87   4  13     0       12
  homeworld      10       77 87   4  14     0       48
       name       0       87 87   3  21     0       87
 skin_color       0       87 87   3  19     0       31
    species       5       82 87   3  14     0       37

── Variable type:integer ──────────────────────────────────────────────────
 variable missing complete  n   mean    sd p0 p25 p50 p75 p100     hist
   height       6       81 87 174.36 34.77 66 167 180 191  264 ▁▁▁▂▇▃▁▁

── Variable type:list ─────────────────────────────────────────────────────
  variable missing complete  n n_unique min_length median_length
     films       0       87 87       24          1             1
 starships       0       87 87       17          0             0
  vehicles       0       87 87       11          0             0
 max_length
          7
          5
          2

── Variable type:numeric ──────────────────────────────────────────────────
   variable missing complete  n  mean     sd p0  p25 p50  p75 p100
 birth_year      44       43 87 87.57 154.69  8 35    52 72    896
       mass      28       59 87 97.31 169.46 15 55.6  79 84.5 1358
     hist
 ▇▁▁▁▁▁▁▁
 ▇▁▁▁▁▁▁▁
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


Table: (\#tab:data-wrangling1-40)Some naming conventions I adopt to make my life easier.

      name  use                     
----------  ------------------------
  df.thing  for data frames         
   l.thing  for lists               
 fun.thing  for functions           
 tmp.thing  for temporary variables 

## Wrangling data 

We use the functions in the package `dplyr` to manipulate our data. 

### filter() 

`filter()` lets us apply logical (and other) operators (see Table \@ref(tab:data-wrangling1-10)) to subset the data. Here, I've filtered out the male characters. 


```r
df.starwars %>% 
  filter(gender == 'male')
```

```
# A tibble: 62 x 13
   name  height  mass hair_color skin_color eye_color birth_year gender
   <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
 1 Luke…    172    77 blond      fair       blue            19   male  
 2 Dart…    202   136 none       white      yellow          41.9 male  
 3 Owen…    178   120 brown, gr… light      blue            52   male  
 4 Bigg…    183    84 black      light      brown           24   male  
 5 Obi-…    182    77 auburn, w… fair       blue-gray       57   male  
 6 Anak…    188    84 blond      fair       blue            41.9 male  
 7 Wilh…    180    NA auburn, g… fair       blue            64   male  
 8 Chew…    228   112 brown      unknown    blue           200   male  
 9 Han …    180    80 brown      fair       brown           29   male  
10 Gree…    173    74 <NA>       green      black           44   male  
# … with 52 more rows, and 5 more variables: homeworld <chr>,
#   species <chr>, films <list>, vehicles <list>, starships <list>
```

We can combine multiple conditions in the same call. Here, I've filtered out male characters, whose height is greater than the median height (i.e. they are in the top 50 percentile), and whose mass was not `NA`. 


```r
df.starwars %>% 
  filter(gender == 'male',
         height > median(height, na.rm = T),
         !is.na(mass))
```

```
# A tibble: 26 x 13
   name  height  mass hair_color skin_color eye_color birth_year gender
   <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
 1 Dart…    202 136   none       white      yellow          41.9 male  
 2 Bigg…    183  84   black      light      brown           24   male  
 3 Obi-…    182  77   auburn, w… fair       blue-gray       57   male  
 4 Anak…    188  84   blond      fair       blue            41.9 male  
 5 Chew…    228 112   brown      unknown    blue           200   male  
 6 Boba…    183  78.2 black      fair       brown           31.5 male  
 7 Bossk    190 113   none       green      red             53   male  
 8 Qui-…    193  89   brown      fair       blue            92   male  
 9 Nute…    191  90   none       mottled g… red             NA   male  
10 Jar …    196  66   none       orange     orange          52   male  
# … with 16 more rows, and 5 more variables: homeworld <chr>,
#   species <chr>, films <list>, vehicles <list>, starships <list>
```

Many functions like `mean()`, `median()`, `var()`, `sd()`, `sum()` have the argument `na.rm` which is set to `FALSE` by default. I set the argument to `TRUE` here (or `T` for short), which means that the `NA` values are ignored, and the `median()` is calculated based on the remaning values.

You can use `,` and `&` interchangeably in `filter()`. Make sure to use parentheses when combining several logical operators to indicate which logical operation should be performed first: 


```r
df.starwars %>% 
  filter((skin_color %in% c("dark", "pale") | gender == "hermaphrodite") & height > 170)
```

```
# A tibble: 10 x 13
   name  height  mass hair_color skin_color eye_color birth_year gender
   <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
 1 Jabb…    175  1358 <NA>       green-tan… orange           600 herma…
 2 Land…    177    79 black      dark       brown             31 male  
 3 Quar…    183    NA black      dark       brown             62 male  
 4 Bib …    180    NA none       pale       pink              NA male  
 5 Mace…    188    84 none       dark       brown             72 male  
 6 Ki-A…    198    82 white      pale       yellow            92 male  
 7 Adi …    184    50 none       dark       blue              NA female
 8 Saes…    188    NA none       pale       orange            NA male  
 9 Greg…    185    85 black      dark       brown             NA male  
10 Sly …    178    48 none       pale       white             NA female
# … with 5 more variables: homeworld <chr>, species <chr>, films <list>,
#   vehicles <list>, starships <list>
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
# A tibble: 87 x 13
   person height mass_kg hair_color skin_color eye_color birth_year gender
   <chr>   <int>   <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
 1 Luke …    172      77 blond      fair       blue            19   male  
 2 C-3PO     167      75 <NA>       gold       yellow         112   <NA>  
 3 R2-D2      96      32 <NA>       white, bl… red             33   <NA>  
 4 Darth…    202     136 none       white      yellow          41.9 male  
 5 Leia …    150      49 brown      light      brown           19   female
 6 Owen …    178     120 brown, gr… light      blue            52   male  
 7 Beru …    165      75 brown      light      blue            47   female
 8 R5-D4      97      32 <NA>       white, red red             NA   <NA>  
 9 Biggs…    183      84 black      light      brown           24   male  
10 Obi-W…    182      77 auburn, w… fair       blue-gray       57   male  
# … with 77 more rows, and 5 more variables: homeworld <chr>,
#   species <chr>, films <list>, vehicles <list>, starships <list>
```

The new variable names goes on the LHS of the`=` sign, and the old name on the RHS.  

To rename all variables at the same time use `set_names()`: 


```r
df.starwars %>%
  set_names(letters[1:ncol(.)])  # renamed all variables to letters: a, b, ...
```

```
# A tibble: 87 x 13
   a          b     c d     e     f         g h     i     j     k     l    
   <chr>  <int> <dbl> <chr> <chr> <chr> <dbl> <chr> <chr> <chr> <lis> <lis>
 1 Luke …   172    77 blond fair  blue   19   male  Tato… Human <chr… <chr…
 2 C-3PO    167    75 <NA>  gold  yell… 112   <NA>  Tato… Droid <chr… <chr…
 3 R2-D2     96    32 <NA>  whit… red    33   <NA>  Naboo Droid <chr… <chr…
 4 Darth…   202   136 none  white yell…  41.9 male  Tato… Human <chr… <chr…
 5 Leia …   150    49 brown light brown  19   fema… Alde… Human <chr… <chr…
 6 Owen …   178   120 brow… light blue   52   male  Tato… Human <chr… <chr…
 7 Beru …   165    75 brown light blue   47   fema… Tato… Human <chr… <chr…
 8 R5-D4     97    32 <NA>  whit… red    NA   <NA>  Tato… Droid <chr… <chr…
 9 Biggs…   183    84 black light brown  24   male  Tato… Human <chr… <chr…
10 Obi-W…   182    77 aubu… fair  blue…  57   male  Stew… Human <chr… <chr…
# … with 77 more rows, and 1 more variable: m <list>
```

### select() 

`select()` allows us to select a subset of the columns in the data frame. 


```r
df.starwars %>% 
  select(name, height, mass)
```

```
# A tibble: 87 x 3
   name               height  mass
   <chr>               <int> <dbl>
 1 Luke Skywalker        172    77
 2 C-3PO                 167    75
 3 R2-D2                  96    32
 4 Darth Vader           202   136
 5 Leia Organa           150    49
 6 Owen Lars             178   120
 7 Beru Whitesun lars    165    75
 8 R5-D4                  97    32
 9 Biggs Darklighter     183    84
10 Obi-Wan Kenobi        182    77
# … with 77 more rows
```

We can select multiple columns using the `(from:to)` syntax: 


```r
df.starwars %>%  
  select(name:birth_year) # from name to birth_year
```

```
# A tibble: 87 x 7
   name           height  mass hair_color   skin_color eye_color birth_year
   <chr>           <int> <dbl> <chr>        <chr>      <chr>          <dbl>
 1 Luke Skywalker    172    77 blond        fair       blue            19  
 2 C-3PO             167    75 <NA>         gold       yellow         112  
 3 R2-D2              96    32 <NA>         white, bl… red             33  
 4 Darth Vader       202   136 none         white      yellow          41.9
 5 Leia Organa       150    49 brown        light      brown           19  
 6 Owen Lars         178   120 brown, grey  light      blue            52  
 7 Beru Whitesun…    165    75 brown        light      blue            47  
 8 R5-D4              97    32 <NA>         white, red red             NA  
 9 Biggs Darklig…    183    84 black        light      brown           24  
10 Obi-Wan Kenobi    182    77 auburn, whi… fair       blue-gray       57  
# … with 77 more rows
```

Or use a variable for column selection: 


```r
columns = c("name", "height", "species")

df.starwars %>% 
  select(one_of(columns)) # useful when using a variable for column selection
```

```
# A tibble: 87 x 3
   name               height species
   <chr>               <int> <chr>  
 1 Luke Skywalker        172 Human  
 2 C-3PO                 167 Droid  
 3 R2-D2                  96 Droid  
 4 Darth Vader           202 Human  
 5 Leia Organa           150 Human  
 6 Owen Lars             178 Human  
 7 Beru Whitesun lars    165 Human  
 8 R5-D4                  97 Droid  
 9 Biggs Darklighter     183 Human  
10 Obi-Wan Kenobi        182 Human  
# … with 77 more rows
```

We can also _deselect_ (multiple) columns:


```r
df.starwars %>% 
  select(-name, -(birth_year:vehicles))
```

```
# A tibble: 87 x 6
   height  mass hair_color    skin_color  eye_color starships
    <int> <dbl> <chr>         <chr>       <chr>     <list>   
 1    172    77 blond         fair        blue      <chr [2]>
 2    167    75 <NA>          gold        yellow    <chr [0]>
 3     96    32 <NA>          white, blue red       <chr [0]>
 4    202   136 none          white       yellow    <chr [1]>
 5    150    49 brown         light       brown     <chr [0]>
 6    178   120 brown, grey   light       blue      <chr [0]>
 7    165    75 brown         light       blue      <chr [0]>
 8     97    32 <NA>          white, red  red       <chr [0]>
 9    183    84 black         light       brown     <chr [1]>
10    182    77 auburn, white fair        blue-gray <chr [5]>
# … with 77 more rows
```

And select columns by partially matching the column name:


```r
df.starwars %>% 
  select(contains("_")) # every column that contains the character "_"
```

```
# A tibble: 87 x 4
   hair_color    skin_color  eye_color birth_year
   <chr>         <chr>       <chr>          <dbl>
 1 blond         fair        blue            19  
 2 <NA>          gold        yellow         112  
 3 <NA>          white, blue red             33  
 4 none          white       yellow          41.9
 5 brown         light       brown           19  
 6 brown, grey   light       blue            52  
 7 brown         light       blue            47  
 8 <NA>          white, red  red             NA  
 9 black         light       brown           24  
10 auburn, white fair        blue-gray       57  
# … with 77 more rows
```


```r
df.starwars %>% 
  select(starts_with("h")) # every column that starts with an "h"
```

```
# A tibble: 87 x 3
   height hair_color    homeworld
    <int> <chr>         <chr>    
 1    172 blond         Tatooine 
 2    167 <NA>          Tatooine 
 3     96 <NA>          Naboo    
 4    202 none          Tatooine 
 5    150 brown         Alderaan 
 6    178 brown, grey   Tatooine 
 7    165 brown         Tatooine 
 8     97 <NA>          Tatooine 
 9    183 black         Tatooine 
10    182 auburn, white Stewjon  
# … with 77 more rows
```

We can also use `select()` to reorder the columns: 


```r
# useful trick for changing the column order, now eye_color is at the beginning
df.starwars %>% 
  select(eye_color, everything())
```

```
# A tibble: 87 x 13
   eye_color name  height  mass hair_color skin_color birth_year gender
   <chr>     <chr>  <int> <dbl> <chr>      <chr>           <dbl> <chr> 
 1 blue      Luke…    172    77 blond      fair             19   male  
 2 yellow    C-3PO    167    75 <NA>       gold            112   <NA>  
 3 red       R2-D2     96    32 <NA>       white, bl…       33   <NA>  
 4 yellow    Dart…    202   136 none       white            41.9 male  
 5 brown     Leia…    150    49 brown      light            19   female
 6 blue      Owen…    178   120 brown, gr… light            52   male  
 7 blue      Beru…    165    75 brown      light            47   female
 8 red       R5-D4     97    32 <NA>       white, red       NA   <NA>  
 9 brown     Bigg…    183    84 black      light            24   male  
10 blue-gray Obi-…    182    77 auburn, w… fair             57   male  
# … with 77 more rows, and 5 more variables: homeworld <chr>,
#   species <chr>, films <list>, vehicles <list>, starships <list>
```

Here, I've moved the `eye_color` column to the beginning of the data frame. `everything()` is a helper function which selects all the columns. 


```r
df.starwars %>% 
  select(-eye_color, everything(), eye_color) # move eye_color to the end
```

```
# A tibble: 87 x 13
   name  height  mass hair_color skin_color birth_year gender homeworld
   <chr>  <int> <dbl> <chr>      <chr>           <dbl> <chr>  <chr>    
 1 Luke…    172    77 blond      fair             19   male   Tatooine 
 2 C-3PO    167    75 <NA>       gold            112   <NA>   Tatooine 
 3 R2-D2     96    32 <NA>       white, bl…       33   <NA>   Naboo    
 4 Dart…    202   136 none       white            41.9 male   Tatooine 
 5 Leia…    150    49 brown      light            19   female Alderaan 
 6 Owen…    178   120 brown, gr… light            52   male   Tatooine 
 7 Beru…    165    75 brown      light            47   female Tatooine 
 8 R5-D4     97    32 <NA>       white, red       NA   <NA>   Tatooine 
 9 Bigg…    183    84 black      light            24   male   Tatooine 
10 Obi-…    182    77 auburn, w… fair             57   male   Stewjon  
# … with 77 more rows, and 5 more variables: species <chr>, films <list>,
#   vehicles <list>, starships <list>, eye_color <chr>
```

Here, I've moved `eye_color` to the end. Note that I had to deselect it first. 

We can select columns based on their data type using `select_if()`. 


```r
df.starwars %>% 
  select_if(is.numeric) # just select numeric columns
```

```
# A tibble: 87 x 3
   height  mass birth_year
    <int> <dbl>      <dbl>
 1    172    77       19  
 2    167    75      112  
 3     96    32       33  
 4    202   136       41.9
 5    150    49       19  
 6    178   120       52  
 7    165    75       47  
 8     97    32       NA  
 9    183    84       24  
10    182    77       57  
# … with 77 more rows
```

The following selects all columns that are not numeric: 


```r
df.starwars %>% 
  select_if(~ !is.numeric(.)) # selects all columns that are not numeric
```

```
# A tibble: 87 x 10
   name  hair_color skin_color eye_color gender homeworld species films
   <chr> <chr>      <chr>      <chr>     <chr>  <chr>     <chr>   <lis>
 1 Luke… blond      fair       blue      male   Tatooine  Human   <chr…
 2 C-3PO <NA>       gold       yellow    <NA>   Tatooine  Droid   <chr…
 3 R2-D2 <NA>       white, bl… red       <NA>   Naboo     Droid   <chr…
 4 Dart… none       white      yellow    male   Tatooine  Human   <chr…
 5 Leia… brown      light      brown     female Alderaan  Human   <chr…
 6 Owen… brown, gr… light      blue      male   Tatooine  Human   <chr…
 7 Beru… brown      light      blue      female Tatooine  Human   <chr…
 8 R5-D4 <NA>       white, red red       <NA>   Tatooine  Droid   <chr…
 9 Bigg… black      light      brown     male   Tatooine  Human   <chr…
10 Obi-… auburn, w… fair       blue-gray male   Stewjon   Human   <chr…
# … with 77 more rows, and 2 more variables: vehicles <list>,
#   starships <list>
```

Note that I used `~` here to indicate that I'm creating an anonymous function to check whether column type is numeric. A one-sided formula (expression beginning with `~`) is interpreted as `function(x)`, and wherever `x` would go in the function is represented by `.`.

So, I could write the same code like so: 


```r
df.starwars %>% 
  select_if(function(x) !is.numeric(x)) # selects all columns that are not numeric
```

```
# A tibble: 87 x 10
   name  hair_color skin_color eye_color gender homeworld species films
   <chr> <chr>      <chr>      <chr>     <chr>  <chr>     <chr>   <lis>
 1 Luke… blond      fair       blue      male   Tatooine  Human   <chr…
 2 C-3PO <NA>       gold       yellow    <NA>   Tatooine  Droid   <chr…
 3 R2-D2 <NA>       white, bl… red       <NA>   Naboo     Droid   <chr…
 4 Dart… none       white      yellow    male   Tatooine  Human   <chr…
 5 Leia… brown      light      brown     female Alderaan  Human   <chr…
 6 Owen… brown, gr… light      blue      male   Tatooine  Human   <chr…
 7 Beru… brown      light      blue      female Tatooine  Human   <chr…
 8 R5-D4 <NA>       white, red red       <NA>   Tatooine  Droid   <chr…
 9 Bigg… black      light      brown     male   Tatooine  Human   <chr…
10 Obi-… auburn, w… fair       blue-gray male   Stewjon   Human   <chr…
# … with 77 more rows, and 2 more variables: vehicles <list>,
#   starships <list>
```

We can rename some of the columns using `select()` like so: 


```r
df.starwars %>% 
  select(person = name, height, mass_kg = mass)
```

```
# A tibble: 87 x 3
   person             height mass_kg
   <chr>               <int>   <dbl>
 1 Luke Skywalker        172      77
 2 C-3PO                 167      75
 3 R2-D2                  96      32
 4 Darth Vader           202     136
 5 Leia Organa           150      49
 6 Owen Lars             178     120
 7 Beru Whitesun lars    165      75
 8 R5-D4                  97      32
 9 Biggs Darklighter     183      84
10 Obi-Wan Kenobi        182      77
# … with 77 more rows
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
# A tibble: 87 x 4
   name               height  mass   bmi
   <chr>               <dbl> <dbl> <dbl>
 1 Luke Skywalker       1.72    77  26.0
 2 C-3PO                1.67    75  26.9
 3 R2-D2                0.96    32  34.7
 4 Darth Vader          2.02   136  33.3
 5 Leia Organa          1.5     49  21.8
 6 Owen Lars            1.78   120  37.9
 7 Beru Whitesun lars   1.65    75  27.5
 8 R5-D4                0.97    32  34.0
 9 Biggs Darklighter    1.83    84  25.1
10 Obi-Wan Kenobi       1.82    77  23.2
# … with 77 more rows
```

Here, I've calculated the bmi for the different starwars characters. I first mutated the height variable by going from cm to m, and then created the new column "bmi".

A useful helper function for `mutate()` is `ifelse()` which is a shorthand for the if-else control flow (Section \@ref(if-else)). Here is an example: 


```r
df.starwars %>% 
  mutate(height_categorical = ifelse(height > median(height, na.rm = T), 'tall', 'short')) %>% 
  select(name, contains("height"))
```

```
# A tibble: 87 x 3
   name               height height_categorical
   <chr>               <int> <chr>             
 1 Luke Skywalker        172 short             
 2 C-3PO                 167 short             
 3 R2-D2                  96 short             
 4 Darth Vader           202 tall              
 5 Leia Organa           150 short             
 6 Owen Lars             178 short             
 7 Beru Whitesun lars    165 short             
 8 R5-D4                  97 short             
 9 Biggs Darklighter     183 tall              
10 Obi-Wan Kenobi        182 tall              
# … with 77 more rows
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
# A tibble: 87 x 13
   name  height[,1] mass[,1] hair_color skin_color eye_color birth_year[,1]
   <chr>      <dbl>    <dbl> <chr>      <chr>      <chr>              <dbl>
 1 Luke…    -0.0678  -0.120  blond      fair       blue              -0.443
 2 C-3PO    -0.212   -0.132  <NA>       gold       yellow             0.158
 3 R2-D2    -2.25    -0.385  <NA>       white, bl… red               -0.353
 4 Dart…     0.795    0.228  none       white      yellow            -0.295
 5 Leia…    -0.701   -0.285  brown      light      brown             -0.443
 6 Owen…     0.105    0.134  brown, gr… light      blue              -0.230
 7 Beru…    -0.269   -0.132  brown      light      blue              -0.262
 8 R5-D4    -2.22    -0.385  <NA>       white, red red               NA    
 9 Bigg…     0.249   -0.0786 black      light      brown             -0.411
10 Obi-…     0.220   -0.120  auburn, w… fair       blue-gray         -0.198
# … with 77 more rows, and 6 more variables: gender <chr>,
#   homeworld <chr>, species <chr>, films <list>, vehicles <list>,
#   starships <list>
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
# A tibble: 87 x 7
   name    height height_z[,1]  mass mass_z[,1] birth_year birth_year_z[,1]
   <chr>    <int>        <dbl> <dbl>      <dbl>      <dbl>            <dbl>
 1 Luke S…    172      -0.0678    77    -0.120        19             -0.443
 2 C-3PO      167      -0.212     75    -0.132       112              0.158
 3 R2-D2       96      -2.25      32    -0.385        33             -0.353
 4 Darth …    202       0.795    136     0.228        41.9           -0.295
 5 Leia O…    150      -0.701     49    -0.285        19             -0.443
 6 Owen L…    178       0.105    120     0.134        52             -0.230
 7 Beru W…    165      -0.269     75    -0.132        47             -0.262
 8 R5-D4       97      -2.22      32    -0.385        NA             NA    
 9 Biggs …    183       0.249     84    -0.0786       24             -0.411
10 Obi-Wa…    182       0.220     77    -0.120        57             -0.198
# … with 77 more rows
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
# A tibble: 87 x 10
   name  height height_z[,1] height_centered…  mass mass_z[,1]
   <chr>  <int>        <dbl>            <dbl> <dbl>      <dbl>
 1 Luke…    172      -0.0678            -2.36    77    -0.120 
 2 C-3PO    167      -0.212             -7.36    75    -0.132 
 3 R2-D2     96      -2.25             -78.4     32    -0.385 
 4 Dart…    202       0.795             27.6    136     0.228 
 5 Leia…    150      -0.701            -24.4     49    -0.285 
 6 Owen…    178       0.105              3.64   120     0.134 
 7 Beru…    165      -0.269             -9.36    75    -0.132 
 8 R5-D4     97      -2.22             -77.4     32    -0.385 
 9 Bigg…    183       0.249              8.64    84    -0.0786
10 Obi-…    182       0.220              7.64    77    -0.120 
# … with 77 more rows, and 4 more variables: mass_centered[,1] <dbl>,
#   birth_year <dbl>, birth_year_z[,1] <dbl>,
#   birth_year_centered[,1] <dbl>
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
# A tibble: 87 x 2
   height mass 
   <chr>  <chr>
 1 172    77   
 2 167    75   
 3 96     32   
 4 202    136  
 5 150    49   
 6 178    120  
 7 165    75   
 8 97     32   
 9 183    84   
10 182    77   
# … with 77 more rows
```

Here, I've selected some columns first, and then changed the mode to character in each of them. 

Like we've seen with `mutate_at()`, you can add a name in the `mutate_all()` function call to make new columns instead of replacing the existing ones. 


```r
df.starwars %>% 
  select(height, mass) %>%
  mutate_all(.funs = list(char = "as.character")) # make new character columns
```

```
# A tibble: 87 x 4
   height  mass height_char mass_char
    <int> <dbl> <chr>       <chr>    
 1    172    77 172         77       
 2    167    75 167         75       
 3     96    32 96          32       
 4    202   136 202         136      
 5    150    49 150         49       
 6    178   120 178         120      
 7    165    75 165         75       
 8     97    32 97          32       
 9    183    84 183         84       
10    182    77 182         77       
# … with 77 more rows
```

#### mutate_if()

`mutate_if()` can sometimes come in handy. For example, the following code changes all the numeric columns to character columns:


```r
df.starwars %>% 
  mutate_if(.predicate = is.numeric, .funs = "as.character")
```

```
# A tibble: 87 x 13
   name  height mass  hair_color skin_color eye_color birth_year gender
   <chr> <chr>  <chr> <chr>      <chr>      <chr>     <chr>      <chr> 
 1 Luke… 172    77    blond      fair       blue      19         male  
 2 C-3PO 167    75    <NA>       gold       yellow    112        <NA>  
 3 R2-D2 96     32    <NA>       white, bl… red       33         <NA>  
 4 Dart… 202    136   none       white      yellow    41.9       male  
 5 Leia… 150    49    brown      light      brown     19         female
 6 Owen… 178    120   brown, gr… light      blue      52         male  
 7 Beru… 165    75    brown      light      blue      47         female
 8 R5-D4 97     32    <NA>       white, red red       <NA>       <NA>  
 9 Bigg… 183    84    black      light      brown     24         male  
10 Obi-… 182    77    auburn, w… fair       blue-gray 57         male  
# … with 77 more rows, and 5 more variables: homeworld <chr>,
#   species <chr>, films <list>, vehicles <list>, starships <list>
```

Or we can round all the numeric columns: 


```r
df.starwars %>% 
  mutate_if(.predicate = is.numeric, .funs = "round")
```

```
# A tibble: 87 x 13
   name  height  mass hair_color skin_color eye_color birth_year gender
   <chr>  <dbl> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
 1 Luke…    172    77 blond      fair       blue              19 male  
 2 C-3PO    167    75 <NA>       gold       yellow           112 <NA>  
 3 R2-D2     96    32 <NA>       white, bl… red               33 <NA>  
 4 Dart…    202   136 none       white      yellow            42 male  
 5 Leia…    150    49 brown      light      brown             19 female
 6 Owen…    178   120 brown, gr… light      blue              52 male  
 7 Beru…    165    75 brown      light      blue              47 female
 8 R5-D4     97    32 <NA>       white, red red               NA <NA>  
 9 Bigg…    183    84 black      light      brown             24 male  
10 Obi-…    182    77 auburn, w… fair       blue-gray         57 male  
# … with 77 more rows, and 5 more variables: homeworld <chr>,
#   species <chr>, films <list>, vehicles <list>, starships <list>
```

### arrange() 

`arrange()` allows us to sort the values in a data frame by one or more column entries. 


```r
df.starwars %>% 
  arrange(hair_color, desc(height))
```

```
# A tibble: 87 x 13
   name  height  mass hair_color skin_color eye_color birth_year gender
   <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
 1 Mon …    150  NA   auburn     fair       blue            48   female
 2 Wilh…    180  NA   auburn, g… fair       blue            64   male  
 3 Obi-…    182  77   auburn, w… fair       blue-gray       57   male  
 4 Bail…    191  NA   black      tan        brown           67   male  
 5 Greg…    185  85   black      dark       brown           NA   male  
 6 Bigg…    183  84   black      light      brown           24   male  
 7 Boba…    183  78.2 black      fair       brown           31.5 male  
 8 Quar…    183  NA   black      dark       brown           62   male  
 9 Jang…    183  79   black      tan        brown           66   male  
10 Land…    177  79   black      dark       brown           31   male  
# … with 77 more rows, and 5 more variables: homeworld <chr>,
#   species <chr>, films <list>, vehicles <list>, starships <list>
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
