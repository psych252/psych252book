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
## `geom_smooth()` using formula = 'y ~ x'
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

People with a higher income have a greater credit card balance $R^2 = .21$, $F(1, 398) = 108.99$, $p < .001$ (see Table \@ref(tab:apa-table)). For each increase in income of \$1K per year, the credit card balance is predicted to increase by $b = 6.05$, 95\% CI $[4.91, 7.19]$. For example, the predicted credit card balance of a person with an income of \$20K per year is \$367.48, 95% CI [318.16, 416.8], whereas for a person with an income of \$100K per year, it is \$851.35, 95% CI [777.19, 925.52] (see Figure \@ref(fig:income-figure)).


```r
apa_table(results_regression$table,
          caption = "A full regression table.",
          escape = FALSE)
```

Table: (\#tab:apa-table) A full regression table.


Predictor   $b$      95\% CI            $t$     $\mathit{df}$   $p$    
----------  -------  -----------------  ------  --------------  -------
Intercept   246.51   [181.25, 311.78]   7.43    398             < .001 
Income      6.05     [4.91, 7.19]       10.44   398             < .001 


<!-- ### Bayesian statistics -->

## Session info


```
## R version 4.3.2 (2023-10-31)
## Platform: aarch64-apple-darwin20 (64-bit)
## Running under: macOS Sonoma 14.1.2
## 
## Matrix products: default
## BLAS:   /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRblas.0.dylib 
## LAPACK: /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.11.0
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## time zone: America/Los_Angeles
## tzcode source: internal
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] lubridate_1.9.3        forcats_1.0.0          stringr_1.5.1         
##  [4] dplyr_1.1.4            purrr_1.0.2            readr_2.1.4           
##  [7] tidyr_1.3.0            tibble_3.2.1           ggplot2_3.4.4         
## [10] tidyverse_2.0.0        statsExpressions_1.5.2 ggeffects_1.3.4       
## [13] tidybayes_3.0.6        modelr_0.1.11          brms_2.20.4           
## [16] Rcpp_1.0.11            lme4_1.1-35.1          Matrix_1.6-4          
## [19] broom_1.0.5            papaja_0.1.2           tinylabels_0.2.4      
## [22] janitor_2.2.0          kableExtra_1.3.4       knitr_1.45            
## 
## loaded via a namespace (and not attached):
##   [1] tensorA_0.36.2.1     rstudioapi_0.15.0    jsonlite_1.8.8      
##   [4] datawizard_0.9.1     magrittr_2.0.3       estimability_1.4.1  
##   [7] farver_2.1.1         nloptr_2.0.3         rmarkdown_2.25      
##  [10] vctrs_0.6.5          minqa_1.2.6          base64enc_0.1-3     
##  [13] effectsize_0.8.6     webshot_0.5.5        htmltools_0.5.7     
##  [16] haven_2.5.4          distributional_0.3.2 curl_5.2.0          
##  [19] sass_0.4.8           StanHeaders_2.26.28  bslib_0.6.1         
##  [22] htmlwidgets_1.6.4    plyr_1.8.9           emmeans_1.9.0       
##  [25] zoo_1.8-12           cachem_1.0.8         igraph_1.6.0        
##  [28] mime_0.12            lifecycle_1.0.4      pkgconfig_2.0.3     
##  [31] sjlabelled_1.2.0     colourpicker_1.3.0   R6_2.5.1            
##  [34] fastmap_1.1.1        shiny_1.8.0          snakecase_0.11.1    
##  [37] digest_0.6.33        colorspace_2.1-0     crosstalk_1.2.1     
##  [40] labeling_0.4.3       fansi_1.0.6          timechange_0.2.0    
##  [43] mgcv_1.9-1           httr_1.4.7           abind_1.4-5         
##  [46] compiler_4.3.2       bit64_4.0.5          withr_2.5.2         
##  [49] backports_1.4.1      inline_0.3.19        shinystan_2.6.0     
##  [52] highr_0.10           QuickJSR_1.0.9       pkgbuild_1.4.3      
##  [55] MASS_7.3-60          gtools_3.9.5         loo_2.6.0           
##  [58] tools_4.3.2          httpuv_1.6.13        threejs_0.3.3       
##  [61] glue_1.6.2           nlme_3.1-164         promises_1.2.1      
##  [64] grid_4.3.2           checkmate_2.3.1      reshape2_1.4.4      
##  [67] generics_0.1.3       gtable_0.3.4         tzdb_0.4.0          
##  [70] hms_1.1.3            xml2_1.3.6           utf8_1.2.4          
##  [73] ggdist_3.3.1         pillar_1.9.0         markdown_1.12       
##  [76] vroom_1.6.5          posterior_1.5.0      later_1.3.2         
##  [79] splines_4.3.2        lattice_0.22-5       bit_4.0.5           
##  [82] tidyselect_1.2.0     miniUI_0.1.1.1       arrayhelpers_1.1-0  
##  [85] gridExtra_2.3        V8_4.4.1             bookdown_0.37       
##  [88] svglite_2.1.3        stats4_4.3.2         xfun_0.41           
##  [91] bridgesampling_1.1-2 matrixStats_1.2.0    DT_0.31             
##  [94] rstan_2.32.3         stringi_1.8.3        yaml_2.3.8          
##  [97] boot_1.3-28.1        evaluate_0.23        codetools_0.2-19    
## [100] cli_3.6.2            RcppParallel_5.1.7   shinythemes_1.2.0   
## [103] xtable_1.8-4         parameters_0.21.3    systemfonts_1.0.5   
## [106] munsell_0.5.0        jquerylib_0.1.4      zeallot_0.1.0       
## [109] coda_0.19-4          svUnit_1.0.6         parallel_4.3.2      
## [112] rstantools_2.3.1.1   ellipsis_0.3.2       bayestestR_0.13.1   
## [115] dygraphs_1.1.1.6     bayesplot_1.10.0     Brobdingnag_1.2-9   
## [118] viridisLite_0.4.2    mvtnorm_1.2-4        scales_1.3.0        
## [121] xts_0.13.1           crayon_1.5.2         insight_0.19.7      
## [124] rlang_1.1.2          rvest_1.0.3          shinyjs_2.1.0
```


