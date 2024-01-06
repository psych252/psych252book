# Linear mixed effects models 3

## Learning goals

- Pitfalls in fitting `lmers()`s (and what to do about it). 
- Understanding `lmer()` syntax even better.
- ANOVA vs. Lmer 

## Load packages and set plotting theme


```r
library("knitr")       # for knitting RMarkdown 
library("kableExtra")  # for making nice tables
library("janitor")     # for cleaning column names
library("broom.mixed") # for tidying up linear mixed effects models 
library("patchwork")   # for making figure panels
library("lme4")        # for linear mixed effects models
library("afex")        # for ANOVAs
library("car")         # for ANOVAs
library("datarium")    # for ANOVA dataset
library("modelr")      # for bootstrapping
library("boot")        # also for bootstrapping
library("ggeffects")   # for plotting marginal effects
library("emmeans")     # for marginal effects
library("tidyverse")   # for wrangling, plotting, etc. 
```


```r
theme_set(theme_classic() + #set the theme 
            theme(text = element_text(size = 20))) #set the default text size

# knitr display options 
opts_chunk$set(comment = "",
               fig.show = "hold")

# # set contrasts to using sum contrasts
# options(contrasts = c("contr.sum", "contr.poly"))

# suppress grouping warning messages
options(dplyr.summarise.inform = F)
```

## Load data sets

### Sleep data


```r
# load sleepstudy data set 
df.sleep = sleepstudy %>% 
  as_tibble() %>% 
  clean_names() %>% 
  mutate(subject = as.character(subject)) %>% 
  select(subject, days, reaction)

# add two fake participants (with missing data)
df.sleep = df.sleep %>% 
  bind_rows(tibble(subject = "374",
                   days = 0:1,
                   reaction = c(286, 288)),
            tibble(subject = "373",
                   days = 0,
                   reaction = 245))
```

### Reasoning data


```r
df.reasoning = sk2011.1
```

### Weight loss data


```r
data("weightloss", package = "datarium")

# Modify it to have three-way mixed design
df.weightloss = weightloss %>%
  mutate(id = rep(1:24, 2)) %>% 
  pivot_longer(cols = t1:t3,
               names_to = "timepoint",
               values_to = "score") %>% 
  arrange(id)
```

### Politness data


```r
df.politeness = read_csv("data/politeness_data.csv") %>% 
  mutate(scenario = as.factor(scenario))
```

```
Rows: 84 Columns: 5
── Column specification ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Delimiter: ","
chr (3): subject, gender, attitude
dbl (2): scenario, frequency

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## Understanding the lmer() syntax

Here is an overview of how to specify different kinds of linear mixed effects models.

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> formula </th>
   <th style="text-align:left;"> description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (1 | g)` </td>
   <td style="text-align:left;"> Random intercept for each level of `g` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (0 + x1 | g)` </td>
   <td style="text-align:left;"> Random slope for each level of `g` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (x1 | g)` </td>
   <td style="text-align:left;"> Correlated random slope and intercept for each level of `g` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (x1 || g)` </td>
   <td style="text-align:left;"> Uncorrelated random slope and intercept for each level of `g` </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (1 | school) + (1 | teacher)` </td>
   <td style="text-align:left;"> Random intercept for each level of `school` and for each level of `teacher` (crossed) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `dv ~ x1 + (1 | school/teacher)` </td>
   <td style="text-align:left;"> Random intercept for each level of `school` and for each level of `teacher` in `school` (nested) </td>
  </tr>
</tbody>
</table>

Note that this `(1 | school/teacher)` is equivalent to `(1 | school) + (1 | teacher:school)` (see [here](https://stats.stackexchange.com/questions/228800/crossed-vs-nested-random-effects-how-do-they-differ-and-how-are-they-specified)). 

## ANOVA vs. Lmer

### Between subjects ANOVA

Let's start with a between subjects ANOVA (which means we are in `lm()` world). We'll take a look whether what type of `instruction` participants received made a difference to their `response`. 

First, we use the `aov_ez()` function from the "afex" package to do so. 


```r
aov_ez(id = "id",
       dv = "response",
       between = "instruction",
       data = df.reasoning)
```

```
Warning: More than one observation per design cell, aggregating data using `fun_aggregate = mean`.
To turn off this warning, pass `fun_aggregate = mean` explicitly.
```

```
Contrasts set to contr.sum for the following variables: instruction
```

```
Anova Table (Type 3 tests)

Response: response
       Effect    df    MSE    F  ges p.value
1 instruction 1, 38 253.43 0.31 .008    .583
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '+' 0.1 ' ' 1
```

Looks like there was no main effect of `instruction` on participants' responses. 

An alternative route for getting at the same test, would be via combining `lm()` with `Anova()` (as we've done before in class). 


```r
lm(formula = response ~ instruction,
   data = df.reasoning %>% 
     group_by(id, instruction) %>% 
     summarize(response = mean(response)) %>% 
     ungroup()) %>% 
  joint_tests()
```

```
 model term  df1 df2 F.ratio p.value
 instruction   1  38   0.307  0.5830
```

The two routes yield the same result. Notice that for the `lm()` approach, I calculated the means for each participant in each condition first (using `group_by()` and `summarize()`). 

### Repeated-measures ANOVA

Now let's take a look whether `validity` and `plausibility` affected participants' responses in the reasoning task. These two factors were varied within participants. Again, we'll use the `aov_ez()` function like so: 


```r
aov_ez(id = "id",
       dv = "response",
       within = c("validity", "plausibility"),
       data = df.reasoning %>% 
         filter(instruction == "probabilistic"))
```

```
Warning: More than one observation per design cell, aggregating data using `fun_aggregate = mean`.
To turn off this warning, pass `fun_aggregate = mean` explicitly.
```

```
Anova Table (Type 3 tests)

Response: response
                 Effect    df    MSE         F   ges p.value
1              validity 1, 19 183.01      0.01 <.001    .904
2          plausibility 1, 19 321.44 30.30 ***  .366   <.001
3 validity:plausibility 1, 19  65.83   9.21 **  .035    .007
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '+' 0.1 ' ' 1
```

For the linear model route, given that we have repeated observations from the same participants, we need to use `lmer()`. The repeated measures anova has the random effect structure as shown below: 


```r
lmer(formula = response ~ validity * plausibility + (1 | id) + (1 | validity:id) + (1 | plausibility:id),
     data = df.reasoning %>% 
        filter(instruction == "probabilistic") %>%
        group_by(id, validity, plausibility) %>%
        summarize(response = mean(response))) %>% 
  joint_tests()
```

```
boundary (singular) fit: see help('isSingular')
```

```
 model term            df1 df2 F.ratio p.value
 validity                1  19   0.016  0.9007
 plausibility            1  19  34.210  <.0001
 validity:plausibility   1  19   8.927  0.0076
```

Again, we get a similar result using the `joint_tests()` function. 

Note though that the results of the ANOVA route and the `lmer()` route weren't identical here (although they were very close). For more information as to why this happens, see [this post](https://stats.stackexchange.com/questions/117660/what-is-the-lme4lmer-equivalent-of-a-three-way-repeated-measures-anova).

### Mixed ANOVA

Now let's take a look at both between- as well as within-subjects factors. Let's compare the `aov_ez()` route


```r
aov_ez(id = "id",
       dv = "response",
       between = "instruction",
       within = c("validity", "plausibility"),
       data = df.reasoning)
```

```
Warning: More than one observation per design cell, aggregating data using `fun_aggregate = mean`.
To turn off this warning, pass `fun_aggregate = mean` explicitly.
```

```
Contrasts set to contr.sum for the following variables: instruction
```

```
Anova Table (Type 3 tests)

Response: response
                             Effect    df     MSE         F   ges p.value
1                       instruction 1, 38 1013.71      0.31  .005    .583
2                          validity 1, 38  339.32    4.12 *  .020    .049
3              instruction:validity 1, 38  339.32    4.65 *  .023    .037
4                      plausibility 1, 38  234.41 34.23 ***  .106   <.001
5          instruction:plausibility 1, 38  234.41  10.67 **  .036    .002
6             validity:plausibility 1, 38  185.94      0.14 <.001    .715
7 instruction:validity:plausibility 1, 38  185.94    4.78 *  .013    .035
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '+' 0.1 ' ' 1
```

with the `lmer()` route: 


```r
lmer(formula = response ~ instruction * validity * plausibility + (1 | id) + (1 | validity:id) + (1 | plausibility:id),
      data = df.reasoning %>%
        group_by(id, validity, plausibility, instruction) %>%
        summarize(response = mean(response))) %>% 
  joint_tests()
```

```
 model term                        df1 df2 F.ratio p.value
 instruction                         1  38   0.307  0.5830
 validity                            1  38   4.121  0.0494
 plausibility                        1  38  34.227  <.0001
 instruction:validity                1  38   4.651  0.0374
 instruction:plausibility            1  38  10.667  0.0023
 validity:plausibility               1  38   0.136  0.7148
 instruction:validity:plausibility   1  38   4.777  0.0351
```

Here, both routes yield the same results. 

## Session info

Information about this R session including which version of R was used, and what packages were loaded. 


```r
sessionInfo()
```

```
R version 4.3.2 (2023-10-31)
Platform: aarch64-apple-darwin20 (64-bit)
Running under: macOS Sonoma 14.1.2

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRblas.0.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.11.0

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: America/Los_Angeles
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] lubridate_1.9.3     forcats_1.0.0       stringr_1.5.1      
 [4] dplyr_1.1.4         purrr_1.0.2         readr_2.1.4        
 [7] tidyr_1.3.0         tibble_3.2.1        ggplot2_3.4.4      
[10] tidyverse_2.0.0     emmeans_1.9.0       ggeffects_1.3.4    
[13] boot_1.3-28.1       modelr_0.1.11       datarium_0.1.0     
[16] car_3.1-2           carData_3.0-5       afex_1.3-0         
[19] lme4_1.1-35.1       Matrix_1.6-4        patchwork_1.1.3    
[22] broom.mixed_0.2.9.4 janitor_2.2.0       kableExtra_1.3.4   
[25] knitr_1.45         

loaded via a namespace (and not attached):
 [1] tidyselect_1.2.0    viridisLite_0.4.2   fastmap_1.1.1      
 [4] digest_0.6.33       timechange_0.2.0    estimability_1.4.1 
 [7] lifecycle_1.0.4     magrittr_2.0.3      compiler_4.3.2     
[10] rlang_1.1.2         sass_0.4.8          tools_4.3.2        
[13] utf8_1.2.4          yaml_2.3.8          bit_4.0.5          
[16] plyr_1.8.9          xml2_1.3.6          abind_1.4-5        
[19] withr_2.5.2         numDeriv_2016.8-1.1 grid_4.3.2         
[22] fansi_1.0.6         xtable_1.8-4        colorspace_2.1-0   
[25] future_1.33.1       globals_0.16.2      scales_1.3.0       
[28] MASS_7.3-60         cli_3.6.2           mvtnorm_1.2-4      
[31] crayon_1.5.2        rmarkdown_2.25      generics_0.1.3     
[34] rstudioapi_0.15.0   tzdb_0.4.0          httr_1.4.7         
[37] reshape2_1.4.4      minqa_1.2.6         cachem_1.0.8       
[40] splines_4.3.2       rvest_1.0.3         parallel_4.3.2     
[43] vctrs_0.6.5         webshot_0.5.5       jsonlite_1.8.8     
[46] bookdown_0.37       hms_1.1.3           pbkrtest_0.5.2     
[49] bit64_4.0.5         listenv_0.9.0       systemfonts_1.0.5  
[52] jquerylib_0.1.4     glue_1.6.2          parallelly_1.36.0  
[55] nloptr_2.0.3        codetools_0.2-19    stringi_1.8.3      
[58] gtable_0.3.4        lmerTest_3.1-3      munsell_0.5.0      
[61] furrr_0.3.1         pillar_1.9.0        htmltools_0.5.7    
[64] R6_2.5.1            vroom_1.6.5         evaluate_0.23      
[67] lattice_0.22-5      highr_0.10          backports_1.4.1    
[70] broom_1.0.5         snakecase_0.11.1    bslib_0.6.1        
[73] Rcpp_1.0.11         svglite_2.1.3       coda_0.19-4        
[76] nlme_3.1-164        xfun_0.41           pkgconfig_2.0.3    
```
