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
  rename(index = X1) %>% 
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
<img src="25-reporting_files/figure-html/income-figure-1.png" alt="Relationship between income level and credit card balance. The error band indicates a 95% confidence interval." width="768" />
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


Predictor   $b$      95\% CI            $t(398)$   $p$    
----------  -------  -----------------  ---------  -------
Intercept   246.51   [181.25, 311.78]   7.43       < .001 
Income      6.05     [4.91, 7.19]       10.44      < .001 


<!-- ### Bayesian statistics -->

## Session info


```
## R version 4.0.3 (2020-10-10)
## Platform: x86_64-apple-darwin17.0 (64-bit)
## Running under: macOS Catalina 10.15.7
## 
## Matrix products: default
## BLAS:   /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRblas.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] forcats_0.5.1          stringr_1.4.0          dplyr_1.0.4           
##  [4] purrr_0.3.4            readr_1.4.0            tidyr_1.1.2           
##  [7] tibble_3.0.6           ggplot2_3.3.3          tidyverse_1.3.0       
## [10] statsExpressions_0.7.0 ggeffects_1.0.1        tidybayes_2.3.1       
## [13] modelr_0.1.8           brms_2.14.4            Rcpp_1.0.6            
## [16] lme4_1.1-26            Matrix_1.3-2           broom_0.7.3           
## [19] papaja_0.1.0.9997      tinylabels_0.2.0       janitor_2.1.0         
## [22] kableExtra_1.3.1       knitr_1.31            
## 
## loaded via a namespace (and not attached):
##   [1] tidyselect_1.1.0       htmlwidgets_1.5.3      grid_4.0.3            
##   [4] munsell_0.5.0          codetools_0.2-18       effectsize_0.4.3-1    
##   [7] statmod_1.4.35         DT_0.17                miniUI_0.1.1.1        
##  [10] withr_2.4.1            Brobdingnag_1.2-6      metaBMA_0.6.6         
##  [13] colorspace_2.0-0       highr_0.8              rstudioapi_0.13       
##  [16] stats4_4.0.3           ipmisc_5.0.2           bayesplot_1.8.0       
##  [19] labeling_0.4.2         emmeans_1.5.3          rstan_2.21.1          
##  [22] bbmle_1.0.23.1         farver_2.1.0           bridgesampling_1.0-0  
##  [25] coda_0.19-4            vctrs_0.3.6            generics_0.1.0        
##  [28] TH.data_1.0-10         metafor_2.4-0          afex_0.28-1           
##  [31] xfun_0.21              R6_2.5.0               markdown_1.1          
##  [34] BayesFactor_0.9.12-4.2 gamm4_0.2-6            projpred_2.0.2        
##  [37] reshape_0.8.8          logspline_2.1.16       assertthat_0.2.1      
##  [40] promises_1.1.1         scales_1.1.1           multcomp_1.4-15       
##  [43] gtable_0.3.0           processx_3.4.5         sandwich_3.0-0        
##  [46] rlang_0.4.10           MatrixModels_0.4-1     zeallot_0.1.0         
##  [49] splines_4.0.3          inline_0.3.17          yaml_2.2.1            
##  [52] reshape2_1.4.4         abind_1.4-5            threejs_0.3.3         
##  [55] crosstalk_1.1.1        backports_1.2.1        httpuv_1.5.5          
##  [58] rsconnect_0.8.16       tools_4.0.3            bookdown_0.21         
##  [61] ellipsis_0.3.1         WRS2_1.1-0             ggridges_0.5.3        
##  [64] plyr_1.8.6             base64enc_0.1-3        ps_1.6.0              
##  [67] prettyunits_1.1.1      pbapply_1.4-3          correlation_0.5.0     
##  [70] zoo_1.8-8              LaplacesDemon_16.1.4   haven_2.3.1           
##  [73] fs_1.5.0               magrittr_2.0.1         data.table_1.13.6     
##  [76] ggdist_2.4.0           openxlsx_4.2.3         lmerTest_3.1-3        
##  [79] reprex_1.0.0           colourpicker_1.1.0     mvtnorm_1.1-1         
##  [82] matrixStats_0.57.0     hms_1.0.0              shinyjs_2.0.0         
##  [85] mime_0.10              evaluate_0.14          arrayhelpers_1.1-0    
##  [88] xtable_1.8-4           shinystan_2.5.0        rio_0.5.16            
##  [91] readxl_1.3.1           gridExtra_2.3          rstantools_2.1.1      
##  [94] bdsmatrix_1.3-4        compiler_4.0.3         V8_3.4.0              
##  [97] crayon_1.4.1           minqa_1.2.4            StanHeaders_2.21.0-7  
## [100] htmltools_0.5.1.1      mgcv_1.8-33            mc2d_0.1-18           
## [103] later_1.1.0.1          RcppParallel_5.0.2     lubridate_1.7.9.2     
## [106] DBI_1.1.1              sjlabelled_1.1.7       dbplyr_2.0.0          
## [109] MASS_7.3-53            boot_1.3-26            car_3.0-10            
## [112] cli_2.3.0              parallel_4.0.3         insight_0.13.1.1      
## [115] igraph_1.2.6           metaplus_0.7-11        pkgconfig_2.0.3       
## [118] numDeriv_2016.8-1.1    foreign_0.8-81         xml2_1.3.2            
## [121] svUnit_1.0.3           dygraphs_1.1.1.6       webshot_0.5.2         
## [124] estimability_1.3       rvest_0.3.6            snakecase_0.11.0      
## [127] distributional_0.2.1   callr_3.5.1            digest_0.6.27         
## [130] parameters_0.12.0.1    fastGHQuad_1.0         rmarkdown_2.6         
## [133] cellranger_1.1.0       curl_4.3               shiny_1.6.0           
## [136] gtools_3.8.2           nloptr_1.2.2.2         lifecycle_1.0.0       
## [139] nlme_3.1-151           jsonlite_1.7.2         carData_3.0-4         
## [142] viridisLite_0.3.0      pillar_1.4.7           lattice_0.20-41       
## [145] loo_2.4.1.9000         fastmap_1.1.0          httr_1.4.2            
## [148] pkgbuild_1.2.0         survival_3.2-7         glue_1.4.2            
## [151] xts_0.12.1             bayestestR_0.8.3.1     zip_2.1.1             
## [154] shinythemes_1.2.0      performance_0.7.0.1    stringi_1.5.3
```


