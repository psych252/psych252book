# Linear mixed effects models 3

## Learning goals

- Pitfalls in fitting `lmers()`s (and what to do about it). 
- Understanding `lmer()` syntax even better.
- ANOVA vs. lmer 

## Load packages and set plotting theme


``` r
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


``` r
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

### Reasoning data


``` r
df.reasoning = sk2011.1
```

## Understanding the lmer() syntax

Here is an overview of how to specify different kinds of linear mixed effects models.


|formula                                                   |description                                                                                      |
|:---------------------------------------------------------|:------------------------------------------------------------------------------------------------|
|`dv ~ x1 + (1 &#124; g)`                                  |Random intercept for each level of `g`                                                           |
|`dv ~ x1 + (0 + x1 &#124; g)`                             |Random slope for each level of `g`                                                               |
|`dv ~ x1 + (x1 &#124; g)`                                 |Correlated random slope and intercept for each level of `g`                                      |
|`dv ~ x1 + (x1 &#124;&#124; g)`                           |Uncorrelated random slope and intercept for each level of `g`                                    |
|`dv ~ x1 + (1 &#124; school) + (1 &#124; teacher)`        |Random intercept for each level of `school` and for each level of `teacher` (crossed)            |
|`dv ~ x1 + (1 &#124; school) + (1 &#124; school:teacher)` |Random intercept for each level of `school` and for each level of `teacher` in `school` (nested) |

Note that this `(1 | school/teacher)` is equivalent to `(1 | school) + (1 | teacher:school)` (see [here](https://stats.stackexchange.com/questions/228800/crossed-vs-nested-random-effects-how-do-they-differ-and-how-are-they-specified)). 

## ANOVA vs. lmer

### Between subjects ANOVA

Let's start with a between subjects ANOVA (which means we are in `lm()` world). We'll take a look whether what type of `instruction` participants received made a difference to their `response`. 

First, we use the `aov_ez()` function from the "afex" package to do so. 


``` r
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

An alternative route for getting at the same test, would be via combining `lm()` with `joint_tests()` (as we've done before in class). 


``` r
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


``` r
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

For the linear model route, given that we have repeated observations from the same participants, we need to use `lmer()`. The repeated measures ANOVA has the random effect structure as shown below: 


``` r
lmer(formula = response ~ 1 + validity * plausibility + (1 | id) + 
       (1 | id:validity) + (1 | id:plausibility),
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


``` r
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


``` r
lmer(formula = response ~ instruction * validity * plausibility + (1 | id) + 
       (1 | id:validity) + (1 | id:plausibility),
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

## Additional resources

### Readings

- [Nested and crossed random effects in lme4](https://www.muscardinus.be/statistics/nested.html)

## Session info

Information about this R session including which version of R was used, and what packages were loaded. 


``` r
sessionInfo()
```

```
R version 4.4.2 (2024-10-31)
Platform: aarch64-apple-darwin20
Running under: macOS Sequoia 15.2

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
 [1] lubridate_1.9.3     forcats_1.0.0       stringr_1.5.1      
 [4] dplyr_1.1.4         purrr_1.0.2         readr_2.1.5        
 [7] tidyr_1.3.1         tibble_3.2.1        ggplot2_3.5.1      
[10] tidyverse_2.0.0     emmeans_1.10.6      ggeffects_2.0.0    
[13] boot_1.3-31         modelr_0.1.11       datarium_0.1.0     
[16] car_3.1-3           carData_3.0-5       afex_1.4-1         
[19] lme4_1.1-35.5       Matrix_1.7-1        patchwork_1.3.0    
[22] broom.mixed_0.2.9.6 janitor_2.2.1       kableExtra_1.4.0   
[25] knitr_1.49         

loaded via a namespace (and not attached):
 [1] tidyselect_1.2.1    viridisLite_0.4.2   farver_2.1.2       
 [4] fastmap_1.2.0       digest_0.6.36       timechange_0.3.0   
 [7] estimability_1.5.1  lifecycle_1.0.4     magrittr_2.0.3     
[10] compiler_4.4.2      rlang_1.1.4         sass_0.4.9         
[13] tools_4.4.2         utf8_1.2.4          yaml_2.3.10        
[16] plyr_1.8.9          xml2_1.3.6          abind_1.4-5        
[19] withr_3.0.2         numDeriv_2016.8-1.1 grid_4.4.2         
[22] fansi_1.0.6         xtable_1.8-4        colorspace_2.1-0   
[25] future_1.33.2       globals_0.16.3      scales_1.3.0       
[28] MASS_7.3-64         insight_1.0.0       cli_3.6.3          
[31] mvtnorm_1.2-5       rmarkdown_2.29      generics_0.1.3     
[34] rstudioapi_0.16.0   tzdb_0.4.0          reshape2_1.4.4     
[37] minqa_1.2.7         cachem_1.1.0        splines_4.4.2      
[40] parallel_4.4.2      vctrs_0.6.5         jsonlite_1.8.8     
[43] bookdown_0.42       hms_1.1.3           pbkrtest_0.5.3     
[46] Formula_1.2-5       listenv_0.9.1       systemfonts_1.1.0  
[49] jquerylib_0.1.4     glue_1.8.0          parallelly_1.37.1  
[52] nloptr_2.1.1        codetools_0.2-20    stringi_1.8.4      
[55] gtable_0.3.5        lmerTest_3.1-3      munsell_0.5.1      
[58] furrr_0.3.1         pillar_1.9.0        htmltools_0.5.8.1  
[61] R6_2.5.1            evaluate_0.24.0     lattice_0.22-6     
[64] backports_1.5.0     broom_1.0.7         snakecase_0.11.1   
[67] bslib_0.7.0         Rcpp_1.0.13         svglite_2.1.3      
[70] coda_0.19-4.1       nlme_3.1-166        xfun_0.49          
[73] pkgconfig_2.0.3    
```
