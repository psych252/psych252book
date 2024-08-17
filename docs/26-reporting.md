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


``` r
df.credit = read_csv("data/credit.csv") %>% 
  rename(index = `...1`) %>% 
  clean_names()
```

__Research question__: Do people with more income have a higher credit card balance? 


``` r
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


``` r
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


``` r
# summarize the model results 
results_regression = fit %>% 
  apa_print()

results_prediction = fit %>% 
  ggpredict(terms = "income [20, 100]") %>% 
  mutate(across(where(is.numeric), ~ round(., 2)))
```

**Possible text**:

People with a higher income have a greater credit card balance $R^2 = .21$, $F(1, 398) = 108.99$, $p < .001$ (see Table \@ref(tab:apa-table)). For each increase in income of \$1K per year, the credit card balance is predicted to increase by $b = 6.05$, 95\% CI $[4.91, 7.19]$. For example, the predicted credit card balance of a person with an income of \$20K per year is \$367.48, 95% CI [318.16, 416.8], whereas for a person with an income of \$100K per year, it is \$851.35, 95% CI [777.19, 925.52] (see Figure \@ref(fig:income-figure)).


``` r
apa_table(results_regression$table,
          caption = "A full regression table.",
          escape = FALSE)
```

Table: (\#tab:apa-table) A full regression table.


Predictor   $b$      95\% CI            $t$     $\mathit{df}$   $p$    
----------  -------  -----------------  ------  --------------  -------
Intercept   246.51   [181.25, 311.78]   7.43    398             < .001 
Income      6.05     [4.91, 7.19]       10.44   398             < .001 

## Additional resources

### Misc

- [Guide to reporting effect sizes and confidence intervals](https://matthewbjane.quarto.pub/)

## Session info


```
## R version 4.4.1 (2024-06-14)
## Platform: aarch64-apple-darwin20
## Running under: macOS Sonoma 14.6
## 
## Matrix products: default
## BLAS:   /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRblas.0.dylib 
## LAPACK: /Library/Frameworks/R.framework/Versions/4.4-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.0
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
##  [4] dplyr_1.1.4            purrr_1.0.2            readr_2.1.5           
##  [7] tidyr_1.3.1            tibble_3.2.1           ggplot2_3.5.1         
## [10] tidyverse_2.0.0        statsExpressions_1.5.5 ggeffects_1.7.0       
## [13] tidybayes_3.0.6        modelr_0.1.11          brms_2.21.0           
## [16] Rcpp_1.0.13            lme4_1.1-35.5          Matrix_1.7-0          
## [19] broom_1.0.6            papaja_0.1.2           tinylabels_0.2.4      
## [22] janitor_2.2.0          kableExtra_1.4.0       knitr_1.48            
## 
## loaded via a namespace (and not attached):
##  [1] gridExtra_2.3        inline_0.3.19        rlang_1.1.4         
##  [4] magrittr_2.0.3       snakecase_0.11.1     matrixStats_1.3.0   
##  [7] compiler_4.4.1       mgcv_1.9-1           loo_2.8.0           
## [10] systemfonts_1.1.0    vctrs_0.6.5          crayon_1.5.3        
## [13] pkgconfig_2.0.3      arrayhelpers_1.1-0   fastmap_1.2.0       
## [16] backports_1.5.0      labeling_0.4.3       effectsize_0.8.9    
## [19] utf8_1.2.4           rmarkdown_2.27       tzdb_0.4.0          
## [22] haven_2.5.4          nloptr_2.1.1         bit_4.0.5           
## [25] xfun_0.45            cachem_1.1.0         jsonlite_1.8.8      
## [28] highr_0.11           parallel_4.4.1       R6_2.5.1            
## [31] bslib_0.7.0          stringi_1.8.4        StanHeaders_2.32.9  
## [34] boot_1.3-30          jquerylib_0.1.4      estimability_1.5.1  
## [37] bookdown_0.40        rstan_2.32.6         parameters_0.22.1   
## [40] bayesplot_1.11.1     splines_4.4.1        timechange_0.3.0    
## [43] tidyselect_1.2.1     rstudioapi_0.16.0    abind_1.4-5         
## [46] yaml_2.3.9           sjlabelled_1.2.0     codetools_0.2-20    
## [49] curl_5.2.1           pkgbuild_1.4.4       lattice_0.22-6      
## [52] withr_3.0.0          bridgesampling_1.1-2 bayestestR_0.14.0   
## [55] posterior_1.6.0      coda_0.19-4.1        evaluate_0.24.0     
## [58] RcppParallel_5.1.8   ggdist_3.3.2         xml2_1.3.6          
## [61] pillar_1.9.0         tensorA_0.36.2.1     checkmate_2.3.1     
## [64] stats4_4.4.1         insight_0.20.3       distributional_0.4.0
## [67] generics_0.1.3       vroom_1.6.5          hms_1.1.3           
## [70] rstantools_2.4.0     munsell_0.5.1        scales_1.3.0        
## [73] minqa_1.2.7          xtable_1.8-4         glue_1.7.0          
## [76] emmeans_1.10.3       tools_4.4.1          mvtnorm_1.2-5       
## [79] grid_4.4.1           QuickJSR_1.3.0       datawizard_0.12.2   
## [82] colorspace_2.1-0     nlme_3.1-164         cli_3.6.3           
## [85] fansi_1.0.6          svUnit_1.0.6         viridisLite_0.4.2   
## [88] svglite_2.1.3        Brobdingnag_1.2-9    V8_5.0.0            
## [91] gtable_0.3.5         zeallot_0.1.0        sass_0.4.9          
## [94] digest_0.6.36        farver_2.1.2         htmltools_0.5.8.1   
## [97] lifecycle_1.0.4      bit64_4.0.5          MASS_7.3-61
```


