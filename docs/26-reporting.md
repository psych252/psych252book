# Reporting statistics 



In this chapter, I'll give a few examples for how to report statistical analysis. 

## General advice

Here is some general advice first: 

1. Make good figures! 
2. Use statistical models to answer concrete research questions.
3. Illustrate the uncertainty in your statistical inferences. 
4. Report effect sizes. 

### Make good figures!

Chapters \@ref(visualization-1) and \@ref(visualization-2) go into how to make figures and also talk a little bit about what makes for a good figure. Personally, I like it when the figures give me a good sense for the actual data. For example, for an experimental study, I would like to get a good sense for the responses that participants gave in the different experimental conditions. 

Sometimes, papers just report the results of statistical tests, or only visually display estimates of the parameters in the model. I'm not a fan of that since, as we've learned, the parameters of the model are only useful in so far the model captures the data-generating process reasonably well. 

### Use statistical models to answer concrete research questions.

Ideally, we formulate our research questions as statistical models upfront and pre-register our planned analyses (e.g. as an RMarkdown script with a complete analysis based on simulated data). We can then organize the results section by going through the sequence of research questions. Each statistical analysis then provides an answer to a specific research question. 

### Illustrate the uncertainty in your statistical inferences. 

For frequentist statistics, we can calculate confidence intervals (e.g. using bootstrapping) and we should provide these intervals together with the point estimates of the model's predictors. 

For Bayesian statistics, we can calculate credible intervals based on the posterior over the model parameters. 

Our figures should also indicate the uncertainty that we have in our statistical inferences (e.g. by adding confidence bands, or by showing some samples from the posterior). 

### Report effect sizes.

Rather than just saying whether the results of a statistical test was significant or not, you should, where possible, provide a measure of the effect size. Chapter \@ref(power-analysis) gives an overview of commonly used measures of effect size. 

### Reporting statistical results using RMarkdown 

For reporting statistical results in RMarkdown, I recommend the `papaja` package (see this chapter in the [online book](https://crsh.github.io/papaja_man/reporting.html#results-from-statistical-tests)). 

## Some concrete example

In this section, I'll give a few concrete examples for how to report the results of statistical tests. Each example tries to implement the general advice mentioned above. I will discuss frequentist and Bayesian statistics separately.

### Frequentist statistics

#### Simple regression


```r
df.credit = read_csv("data/credit.csv") %>% 
  rename(index = `...1`) %>% 
  clean_names()
```

__Research question__: Do people with more income have a higher credit card balance? 


```r
ggplot(data = df.credit,
       mapping = aes(x = income,
                     y = balance)) + 
  geom_smooth(method = "lm",
              color = "black") + 
  geom_point(alpha = 0.2) +
  coord_cartesian(xlim = c(0, max(df.credit$income))) + 
  labs(x = "Income in $1K per year",
       y = "Credit card balance in $")
```

```
## `geom_smooth()` using formula 'y ~ x'
```

<div class="figure">
<img src="26-reporting_files/figure-html/income-figure-1.png" alt="Relationship between income level and credit card balance. The error band indicates a 95% confidence interval." width="768" />
<p class="caption">(\#fig:income-figure)Relationship between income level and credit card balance. The error band indicates a 95% confidence interval.</p>
</div>


```r
# fit a model 
fit = lm(formula = balance ~ income,
         data = df.credit)

summary(fit)
```

```
## 
## Call:
## lm(formula = balance ~ income, data = df.credit)
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


```r
# summarize the model results 
results_regression = fit %>% 
  apa_print()

results_prediction = fit %>% 
  ggpredict(terms = "income [20, 100]") %>% 
  mutate(across(where(is.numeric), ~ round(., 2)))
```

**Possible text**:

People with a higher income have a greater credit card balance $R^2 = .21$, $F(1, 398) = 108.99$, $p < .001$ (see Table \@ref(tab:apa-table)). For each increase in income of \$1K per year, the credit card balance is predicted to increase by $b = 6.05$, 95\% CI $[4.91, 7.19]$. For example, the predicted credit card balance of a person with an income of \$20K per year is \$367.48, 95% CI [318.31, 416.65], whereas for a person with an income of \$100K per year, it is \$851.35, 95% CI [777.41, 925.29] (see Figure \@ref(fig:income-figure)).


```r
apa_table(results_regression$table,
          caption = "A full regression table.",
          escape = FALSE)
```

<caption>(\#tab:apa-table)</caption>

<div custom-style='Table Caption'>*A full regression table.*</div>


Predictor   $b$      95\% CI            $t$     $\mathit{df}$   $p$    
----------  -------  -----------------  ------  --------------  -------
Intercept   246.51   [181.25, 311.78]   7.43    398             < .001 
Income      6.05     [4.91, 7.19]       10.44   398             < .001 


<!-- ### Bayesian statistics -->

## Session info


```
## R version 4.1.2 (2021-11-01)
## Platform: x86_64-apple-darwin17.0 (64-bit)
## Running under: macOS Big Sur 10.16
## 
## Matrix products: default
## BLAS:   /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRblas.0.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] forcats_0.5.1          stringr_1.4.0          dplyr_1.0.9           
##  [4] purrr_0.3.4            readr_2.1.2            tidyr_1.2.0           
##  [7] tibble_3.1.7           ggplot2_3.3.6          tidyverse_1.3.1       
## [10] statsExpressions_1.3.1 ggeffects_1.1.2        tidybayes_3.0.2       
## [13] modelr_0.1.8           brms_2.17.0            Rcpp_1.0.8.3          
## [16] lme4_1.1-29            Matrix_1.4-1           broom_0.8.0           
## [19] papaja_0.1.0.9999      tinylabels_0.2.3       janitor_2.1.0         
## [22] kableExtra_1.3.4       knitr_1.39            
## 
## loaded via a namespace (and not attached):
##   [1] readxl_1.4.0         backports_1.4.1      systemfonts_1.0.4   
##   [4] plyr_1.8.7           igraph_1.3.1         splines_4.1.2       
##   [7] svUnit_1.0.6         crosstalk_1.2.0      TH.data_1.1-1       
##  [10] rstantools_2.2.0     inline_0.3.19        digest_0.6.29       
##  [13] htmltools_0.5.2      fansi_1.0.3          magrittr_2.0.3      
##  [16] checkmate_2.1.0      tzdb_0.3.0           RcppParallel_5.1.5  
##  [19] matrixStats_0.62.0   vroom_1.5.7          xts_0.12.1          
##  [22] sandwich_3.0-1       svglite_2.1.0        prettyunits_1.1.1   
##  [25] colorspace_2.0-3     rvest_1.0.2          ggdist_3.1.1        
##  [28] haven_2.5.0          xfun_0.30            callr_3.7.0         
##  [31] crayon_1.5.1         jsonlite_1.8.0       zeallot_0.1.0       
##  [34] survival_3.3-1       zoo_1.8-10           glue_1.6.2          
##  [37] gtable_0.3.0         emmeans_1.7.3        webshot_0.5.3       
##  [40] distributional_0.3.0 pkgbuild_1.3.1       rstan_2.21.5        
##  [43] abind_1.4-5          scales_1.2.0         mvtnorm_1.1-3       
##  [46] DBI_1.1.2            miniUI_0.1.1.1       viridisLite_0.4.0   
##  [49] xtable_1.8-4         performance_0.9.0    bit_4.0.4           
##  [52] stats4_4.1.2         StanHeaders_2.21.0-7 DT_0.22             
##  [55] datawizard_0.4.0     htmlwidgets_1.5.4    httr_1.4.3          
##  [58] threejs_0.3.3        arrayhelpers_1.1-0   posterior_1.2.1     
##  [61] ellipsis_0.3.2       pkgconfig_2.0.3      loo_2.5.1           
##  [64] farver_2.1.0         dbplyr_2.1.1         sass_0.4.1          
##  [67] utf8_1.2.2           labeling_0.4.2       tidyselect_1.1.2    
##  [70] rlang_1.0.2          reshape2_1.4.4       later_1.3.0         
##  [73] effectsize_0.6.0.1   cellranger_1.1.0     munsell_0.5.0       
##  [76] tools_4.1.2          cli_3.3.0            generics_0.1.2      
##  [79] sjlabelled_1.2.0     ggridges_0.5.3       evaluate_0.15       
##  [82] fastmap_1.1.0        yaml_2.3.5           bit64_4.0.5         
##  [85] fs_1.5.2             processx_3.5.3       nlme_3.1-157        
##  [88] mime_0.12            xml2_1.3.3           compiler_4.1.2      
##  [91] bayesplot_1.9.0      shinythemes_1.2.0    rstudioapi_0.13     
##  [94] reprex_2.0.1         bslib_0.3.1          stringi_1.7.6       
##  [97] highr_0.9            ps_1.7.0             parameters_0.17.0   
## [100] Brobdingnag_1.2-7    lattice_0.20-45      nloptr_2.0.0        
## [103] markdown_1.1         shinyjs_2.1.0        tensorA_0.36.2      
## [106] vctrs_0.4.1          pillar_1.7.0         lifecycle_1.0.1     
## [109] jquerylib_0.1.4      bridgesampling_1.1-2 estimability_1.3    
## [112] insight_0.17.0       httpuv_1.6.5         R6_2.5.1            
## [115] bookdown_0.26        promises_1.2.0.1     gridExtra_2.3       
## [118] codetools_0.2-18     boot_1.3-28          colourpicker_1.1.1  
## [121] MASS_7.3-57          gtools_3.9.2         assertthat_0.2.1    
## [124] withr_2.5.0          shinystan_2.6.0      multcomp_1.4-19     
## [127] mgcv_1.8-40          hms_1.1.1            bayestestR_0.12.1   
## [130] parallel_4.1.2       grid_4.1.2           coda_0.19-4         
## [133] minqa_1.2.4          rmarkdown_2.14       snakecase_0.11.0    
## [136] shiny_1.7.1          lubridate_1.8.0      base64enc_0.1-3     
## [139] dygraphs_1.1.1.6
```


