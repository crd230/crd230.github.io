---
title: "Lab 6: Spatial Regression I"
subtitle: <h4 style="font-style:normal">CRD 298 - Spatial Methods in Community Research</h4>
author: <h4 style="font-style:normal">Professor Noli Brazil</h4>
date: <h4 style="font-style:normal">February 13, 2019</h4>
output: 
  html_document:
    toc: true
    toc_depth: 3
    toc_float: true
    theme: cosmo
    code_folding: show
---


<style>
p.comment {
background-color: #DBDBDB;
padding: 10px;
border: 1px solid black;
margin-left: 25px;
border-radius: 5px;
font-style: italic;
}

h1.title {
  font-weight: bold;
}

</style>
\



The methods we have been covering up to this point have been descriptive in nature.  In this lab, you will be moving from the descriptive to the inferential side of spatial data analysis by learning how to run spatial regression models in R.  We focus on how to model spatial dependence both as a nuisance to control for and as a process of theoretical interest.  The objectives of the guide are as follows

1. Learn how to run a linear regression model
2. Learn the process for detecting spatial autocorrelation
3. Learn how to run a spatial lag model
4. Learn how to run a spatial error model

To help us accomplish these learning objectives, we will examine the association between neighborhood characteristics and violent crime rates (per Federal Bureau of Investigation guidelines, violent crimes are murder and nonnegligent manslaughter, rape, robbery, and aggravated assault) in the City of Seattle, WA. 

This lab guide assumes working knowledge of basic concepts in linear regression modelling. If you need a brushing up on linear regression modelling concepts and terms, please see this week's handout and Chapters 3 and 4 in Gelman and Hill.

<div style="margin-bottom:25px;">
</div>
## **Load necessary packages**
\

We'll be introducing the following packages in this lab 


```r
install.packages("broom")
install.packages("corrplot")
install.packages("car")
install.packages("olsrr")
install.packages("stargazer")
install.packages("knitr")
```

You may have already installed **knitr** in the past if you've been using the function `kable()` to create presentation ready tables in your html documents.

Load in the following packages, all of which we've covered in previous labs


```r
library(sf)
library(tidyverse)
library(sp)
library(tmap)
library(spdep)
```

<div style="margin-bottom:25px;">
</div>
## **Bring in the data**
\

We will be using the shape file seattle_census_tracts_2010.shp. This file contains violent crime rates between 2014 and 2017 by census tract.  It also contains demographic and socioeconomic data from the 2012-16 American Community Survey. The record layout for the shapefile's attribute table is located [here](https://raw.githubusercontent.com/crd230/data/master/seattle_record_layout.txt).

I zipped up the files associated with the shapefile onto Github.  Download the file, unzip it, and bring it into R using the following code.


```r
setwd("insert your pathway here")
download.file(url = "https://raw.githubusercontent.com/crd230/data/master/seattle_census_tracts_2010.zip", destfile = "seattle_census_tracts_2010.zip")
unzip(zipfile = "seattle_census_tracts_2010.zip")

sea.tracts <- st_read("seattle_census_tracts_2010.shp")
```



<div style="margin-bottom:25px;">
</div>
## **Standard linear regression**
\

We're interested in examining the neighborhood characteristics associated with violent crime rates in Seattle. What explanatory variables should we include?  An important determining factor is to make sure we do not pick variables that are highly correlated.  In regression, this is known as multicollinearity, and is a problem because the partial regression coefficient for any collinear variable is highly unstable. 

One way to detect multicollinearity is to view a correlation matrix. Let's produce a correlation matrix of the candidate variables using the function `cor()`. The function does not directly take in spatial objects. We use the function `st_geometry()` in the following way to make the spatial data set not spatial.


```r
sea.tracts.df <- sea.tracts
st_geometry(sea.tracts.df) <- NULL
```

The way to read the above is code is that `st_geometry()` calls up the geometry of *sea.tracts.df*, which we then set to NULL. This removes the geometry and makes *sea.tracts.df* a non-spatial data frame.


```r
class(sea.tracts.df)
```

We then select the variables we want to calculate correlations for and feed the resulting pared down data frame into the `cor()` function.


```r
corrMat <- sea.tracts.df %>% 
            select(ppov:pfhh, vcmrt1417,popd) %>%
            cor()
corrMat
```

```
##                  ppov         tpop      mhhinc     pnhwhite    pnhblack
## ppov       1.00000000  0.041576357 -0.72997644 -0.576247612  0.42449864
## tpop       0.04157636  1.000000000 -0.02367974 -0.031709181  0.02823612
## mhhinc    -0.72997644 -0.023679744  1.00000000  0.645176496 -0.48295953
## pnhwhite  -0.57624761 -0.031709181  0.64517650  1.000000000 -0.81281986
## pnhblack   0.42449864  0.028236119 -0.48295953 -0.812819855  1.00000000
## pnhasian   0.56619989  0.037426912 -0.52348530 -0.831337854  0.50564332
## phisp      0.25789639  0.032021981 -0.43908005 -0.514871654  0.30639225
## unemp      0.68030188  0.004486756 -0.50780424 -0.534437251  0.36104147
## pm1834     0.46818852  0.118217856 -0.44579424 -0.063187369 -0.12245627
## div        0.56374118  0.039985830 -0.69553859 -0.921135459  0.74842294
## pfb        0.56982293  0.064708411 -0.58719797 -0.895337638  0.66716581
## mob        0.50115587  0.202842669 -0.41735437  0.008336732 -0.13048745
## pocc      -0.22457586  0.110261400  0.21139029  0.178339014 -0.13365671
## pfhh       0.21496873  0.008354680 -0.30230602 -0.688882452  0.69439479
## vcmrt1417  0.23841814 -0.102752503 -0.26027001 -0.183984231  0.14911326
## popd       0.03195487  0.006678511 -0.02550528 -0.018556868 -0.02428409
##              pnhasian       phisp        unemp      pm1834         div
## ppov       0.56619989  0.25789639  0.680301876  0.46818852  0.56374118
## tpop       0.03742691  0.03202198  0.004486756  0.11821786  0.03998583
## mhhinc    -0.52348530 -0.43908005 -0.507804239 -0.44579424 -0.69553859
## pnhwhite  -0.83133785 -0.51487165 -0.534437251 -0.06318737 -0.92113546
## pnhblack   0.50564332  0.30639225  0.361041466 -0.12245627  0.74842294
## pnhasian   1.00000000  0.15111631  0.533306092  0.19957684  0.67152942
## phisp      0.15111631  1.00000000  0.212272193  0.02473400  0.59918752
## unemp      0.53330609  0.21227219  1.000000000  0.25846620  0.50761717
## pm1834     0.19957684  0.02473400  0.258466199  1.00000000  0.17860792
## div        0.67152942  0.59918752  0.507617168  0.17860792  1.00000000
## pfb        0.88104358  0.38060593  0.514856320  0.14405408  0.79014331
## mob        0.11743552 -0.02980207  0.250659072  0.83821530  0.14002677
## pocc      -0.13373592 -0.14789776 -0.206689302 -0.13451408 -0.22661912
## pfhh       0.39333848  0.47039787  0.250799137 -0.36406424  0.59924748
## vcmrt1417  0.13309873  0.10089597  0.140269432  0.16687085  0.25166012
## popd      -0.04031585  0.08747867  0.017220958 -0.05674208  0.06397972
##                   pfb          mob         pocc         pfhh   vcmrt1417
## ppov       0.56982293  0.501155867 -0.224575856  0.214968733  0.23841814
## tpop       0.06470841  0.202842669  0.110261400  0.008354680 -0.10275250
## mhhinc    -0.58719797 -0.417354367  0.211390292 -0.302306017 -0.26027001
## pnhwhite  -0.89533764  0.008336732  0.178339014 -0.688882452 -0.18398423
## pnhblack   0.66716581 -0.130487446 -0.133656714  0.694394789  0.14911326
## pnhasian   0.88104358  0.117435520 -0.133735918  0.393338485  0.13309873
## phisp      0.38060593 -0.029802065 -0.147897759  0.470397872  0.10089597
## unemp      0.51485632  0.250659072 -0.206689302  0.250799137  0.14026943
## pm1834     0.14405408  0.838215302 -0.134514083 -0.364064241  0.16687085
## div        0.79014331  0.140026775 -0.226619124  0.599247483  0.25166012
## pfb        1.00000000  0.101751651 -0.208109912  0.498920065  0.21374976
## mob        0.10175165  1.000000000 -0.231309533 -0.411501184  0.17814429
## pocc      -0.20810991 -0.231309533  1.000000000  0.003197837 -0.41233114
## pfhh       0.49892006 -0.411501184  0.003197837  1.000000000 -0.07413971
## vcmrt1417  0.21374976  0.178144294 -0.412331143 -0.074139713  1.00000000
## popd      -0.04079050 -0.083710869 -0.123616410 -0.011969695 -0.05113622
##                   popd
## ppov       0.031954873
## tpop       0.006678511
## mhhinc    -0.025505275
## pnhwhite  -0.018556868
## pnhblack  -0.024284086
## pnhasian  -0.040315852
## phisp      0.087478665
## unemp      0.017220958
## pm1834    -0.056742082
## div        0.063979722
## pfb       -0.040790497
## mob       -0.083710869
## pocc      -0.123616410
## pfhh      -0.011969695
## vcmrt1417 -0.051136222
## popd       1.000000000
```

That's a lot of numbers.  Let's visualize this matrix using a correlation plot.  We do this using the function `corrplot()` in the the *corrplot* package, which we need to load in.


```r
library(corrplot)
```


```r
corrplot(corrMat, method="color")
```

![](lab6_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

We find a lot of highly correlated variables.  But, which ones do we choose? Let theory and prior empirical research guide you.  Fortunately for us, there is substantive theoretical and empirical work discussing the structural neighborhood characteristics associated with the prevalence of crime.  Let's draw from this literature (for example, see [Hipp (2010)](https://academic.oup.com/socpro/article-abstract/57/2/205/1655557) and [Sampson et al. (1997)](http://science.sciencemag.org/content/277/5328/918?casa_token=FRkzNHg3zoMAAAAA:SGgF3R83W9KdKvwJV90lo54saJb56fIEvvlqq5Jt2oBNT5cltBz0pnIenQbNM3zmYmPwo3019h5MmW0)) to select the variables to include in the explanatory model.

Criminological studies typically incorporate measures of concentrated disadvantage, residential mobility, immigrant concentration, levels of racial/ethnic heterogeneity, and aspects of the built environment. How do we measure these concepts? We covered concentrated disadvantage in Week 4 (% of households on public assistance, percent poverty, unemployment rate, percent of female-headed households, percent non-Hispanic black, and percent of residents under 18 years old). Immigrant concentration can be measured by percent Hispanic and percent foreign-born.  Following the methods used in [Morenoff et al. (2001)](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1745-9125.2001.tb00932.x), we will standardize each of the variables, sum the resulting z-scores, and then divide by the number of variables in order to construct a scale of concentrated disadvantage and immigrant concentration. This produces a composite measure that evenly weights each of the original variables. We can do this using the following code, which follows closely the code we used when creating opportunity indices in [Lab 4](https://crd230.github.io/lab4.html).


```r
sea.tracts.std <-sea.tracts.df %>%
  select(GEOID10, ppov, unemp, pnhblack, pund18, pwelfare, pfb, phisp) %>%
  gather(variable, value, -c(GEOID10)) %>%
  group_by(variable) %>%
  mutate(mean = mean(value), sd = sd(value), z = (value-mean)/sd) %>%
  select(-(c(value, mean, sd))) %>%
  spread(variable, z) %>%
  mutate(concd = (ppov+unemp+pnhblack+pund18+pwelfare)/3, immc = (pfb+phisp)/2) %>%
  select(GEOID10, concd, immc)

sea.tracts <- left_join(sea.tracts, sea.tracts.std, by = "GEOID10")
```

Racial/ethnic heterogeneity is measured by the Herfindahl index (see, for example, page 666 in this [article](https://journals.sagepub.com/doi/10.1177/000312240707200501)). We also include the variables *mob*  *pocc*, and *popd* in the model.  Regress *lvcmrt1417* (log average yearly violent crime rates 2014-2017) on these variables using the `lm()` function.


```r
fit.ols <- lm(lvcmrt1417 ~ concd + mob + pocc + immc  + popd + div, 
     data = sea.tracts)
```

The first argument in `lm()` takes on a formula object. A formula is indicated by a tilde. The dependent variable *lvcmrt1417* comes first, followed by the tilde `~`, and then the independent variables separated by `+`.  The function `lm()` fits linear models.  You can run generalized linear models, which allows you to run different types of regression models (e.g. logit) including the basic linear model you run using `lm()`, using the function `glm()`. 

We can look at a summary of results using the `summary()` function


```r
summary(fit.ols)
```

```
## 
## Call:
## lm(formula = lvcmrt1417 ~ concd + mob + pocc + immc + popd + 
##     div, data = sea.tracts)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -5.8710 -0.4994  0.3924  1.1388  3.4698 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)   
## (Intercept)  3.8351930  5.3963313   0.711  0.47851   
## concd       -0.0410061  0.2359586  -0.174  0.86230   
## mob          4.4693388  1.5950932   2.802  0.00584 **
## pocc        -0.2609372  5.5270811  -0.047  0.96242   
## immc         0.0507213  0.3649737   0.139  0.88968   
## popd        -0.0015659  0.0005553  -2.820  0.00554 **
## div          1.4279538  2.0600280   0.693  0.48941   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.927 on 133 degrees of freedom
## Multiple R-squared:  0.1436,	Adjusted R-squared:  0.105 
## F-statistic: 3.717 on 6 and 133 DF,  p-value: 0.001893
```

We can make the results look "tidy" by using the function `tidy()` in the *broom* package


```r
library(broom)
tidy(fit.ols)
```

```
## # A tibble: 7 x 5
##   term        estimate std.error statistic p.value
##   <chr>          <dbl>     <dbl>     <dbl>   <dbl>
## 1 (Intercept)  3.84     5.40        0.711  0.479  
## 2 concd       -0.0410   0.236      -0.174  0.862  
## 3 mob          4.47     1.60        2.80   0.00584
## 4 pocc        -0.261    5.53       -0.0472 0.962  
## 5 immc         0.0507   0.365       0.139  0.890  
## 6 popd        -0.00157  0.000555   -2.82   0.00554
## 7 div          1.43     2.06        0.693  0.489
```

It appears that population density decreases crime - Jane Jacobs' [more eyes on the street](https://www.citylab.com/equity/2013/07/new-way-understanding-eyes-street/6276/) - whereas residential mobility increases crime.  

<div style="margin-bottom:25px;">
</div>
### **Diagnostic tests**
\

R has some useful commands for running diagnostics to see if our regression model has some problems, specifically if it's breaking any of the OLS standard assumptions.  First, we can verify whether multicollinearity is still a problem by calculating [Variance Inflation Factors (VIF)](https://en.wikipedia.org/wiki/Variance_inflation_factor). The higher a variable's VIF, the more collinear it is with one or more variables in the model. Use the `vif()` function in the *car* package 


```r
library(car)
```


```r
vif(fit.ols)
```

```
##    concd      mob     pocc     immc     popd      div 
## 2.557800 1.177415 1.130534 3.441351 1.041359 4.777150
```

A variable with a VIF generally above 10 is considered to be too high.  Looks like were good! yay.

One assumption of linear regression is that errors are normally distributed. We can visually inspect for violations of this assumption through a quantile-quantile (Q-Q) plot, which plots the quantile of the residuals against the expected quantile of the standard normal distribution.


```r
#QQ plot
qqPlot(fit.ols)
```

![](lab6_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

```
## [1]  1 28
```

The above figure is a quantile-comparison plot, graphing for each observation its `fit.ols` model residual on the y axis and the corresponding quantile in the t-distribution on the x axis. The dashed lines indicate 95% confidence intervals calculated under the assumption that the errors are normally distributed. If any observations fall outside this range, this is an indication that the normality assumption has been violated.

The function `shapiro.test()` runs the [Shapiro-Wilk Test](https://en.wikipedia.org/wiki/Shapiro%E2%80%93Wilk_testhttps://en.wikipedia.org/wiki/Shapiro%E2%80%93Wilk_test), a formal test of normality


```r
shapiro.test(resid(fit.ols))
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  resid(fit.ols)
## W = 0.86162, p-value = 4.029e-10
```

The function `resid()` extracts the residuals (Predicted Y minus Actual Y) from the linear regression model saved in *fit.ols*.

Want more tests of normality?There is the [Kolmogorov-Smirnov test](https://en.wikipedia.org/wiki/Kolmogorov%E2%80%93Smirnov_test)


```r
ks.test(resid(fit.ols), y  = pnorm)
```

```
## 
## 	One-sample Kolmogorov-Smirnov test
## 
## data:  resid(fit.ols)
## D = 0.17707, p-value = 0.0003078
## alternative hypothesis: two-sided
```

where `y = pnorm` specifies the null distribution, in this case normal.  What does the Q-Q plot and the tests for normality suggest?

Another assumption is that errors are homeskedastic - that is the variance of residuals are constant.  You can plot the residuals to explore the presence of heteroskedasticity.  If we see the spread of the points narrow or widen from left to right, heteroskedasticity is present.


```r
#plot residuals
plot(resid(fit.ols))
```

![](lab6_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

There are formal statistical tests to check for heteroscedasticity. One such test is the [Breusch-Pagan](https://en.wikipedia.org/wiki/Breusch%E2%80%93Pagan_test) test, which is located in the **lmtest** package.


```r
library(lmtest)
bptest(fit.ols)
```

```
## 
## 	studentized Breusch-Pagan test
## 
## data:  fit.ols
## BP = 18.069, df = 6, p-value = 0.006062
```

What did you find?  

<div style="margin-bottom:25px;">
</div>
## **Exploratory spatial data analysis**
\

The above sections go through the steps conducted in non spatial regression analysis. The focus of this lab, however, is to account for spatial dependence in the error term and the dependent variable. Before doing any kind of spatial modelling, you should conduct an Exploratory Spatial Data Analysis (ESDA) to gain an understanding of how your data are spatially structured. 

<div style="margin-bottom:25px;">
</div>
### **Map your data**
\

The first step in ESDA is to map your dependent variable.  Map the log average violent crime rate per 100,000 residents.  



```r
tm_shape(sea.tracts, unit = "mi") +
  tm_polygons(col = "lvcmrt1417", style = "quantile",palette = "Reds", 
              border.alpha = 0, title = "") +
  tm_scale_bar(breaks = c(0, 1, 2), size = 1, position = c("left", "bottom")) +
  tm_compass(type = "4star", position = c("left", "top")) + 
  tm_layout(main.title = "Log violent crime rates in Seattle
            Tracts",  main.title.size = 0.95, frame = FALSE, legend.outside = TRUE)
```

![](lab6_files/figure-html/unnamed-chunk-21-1.png)<!-- -->


Next, you'll want to map the residuals from your regression model. To extract the residuals from *fit.ols*, use the `resid()` function.  Save it back into *sea.tracts*.


```r
sea.tracts <- mutate(sea.tracts, olsresid = resid(fit.ols))
```

Plot it


```r
tm_shape(sea.tracts, unit = "mi") +
  tm_polygons(col = "olsresid", style = "quantile",palette = "Reds", 
              border.alpha = 0, title = "") +
  tm_scale_bar(breaks = c(0, 1, 2), size = 1, position = c("left", "bottom")) +
  tm_compass(type = "4star", position = c("left", "top")) + 
  tm_layout(main.title = "Residuals from linear regression in Seattle
            Tracts",  main.title.size = 0.95, frame = FALSE, legend.outside = TRUE)
```

![](lab6_files/figure-html/unnamed-chunk-23-1.png)<!-- -->

<div style="margin-bottom:25px;">
</div>
### **Global Moran's I**
\

There appears to be evidence of clustering from the exploratory maps. What does our buddy the Moran's I tell us?  First, we need to convert *sea.tracts* to an **sp** object. 


```r
sea.tracts.sp <- as(sea.tracts, "Spatial")
```

Then create a neighbor object and its associated spatial weights matrix.  Let's use the standard Queen contiguity.


```r
seab<-poly2nb(sea.tracts.sp, queen=T)
seaw<-nb2listw(seab, style="W", zero.policy = TRUE)
```

Examine the Moran scatterplot.


```r
moran.plot(sea.tracts.sp$lvcmrt1417, listw=seaw, xlab="Standardized Log Violent Crime Rate", ylab="Standardized Lagged Log Viiolent Crime Rate",
main=c("Moran Scatterplot for Log Violent Crime Rate", "in Seatte") )
```

![](lab6_files/figure-html/unnamed-chunk-26-1.png)<!-- -->

Finally, the Global Moran's I


```r
moran.mc(sea.tracts.sp$lvcmrt1417, seaw, nsim=999)
```

```
## 
## 	Monte-Carlo simulation of Moran I
## 
## data:  sea.tracts.sp$lvcmrt1417 
## weights: seaw  
## number of simulations + 1: 1000 
## 
## statistic = 0.37384, observed rank = 1000, p-value = 0.001
## alternative hypothesis: greater
```

Repeat for the residuals using the `lm.morantest()` function


```r
lm.morantest(fit.ols, seaw)
```

```
## 
## 	Global Moran I for regression residuals
## 
## data:  
## model: lm(formula = lvcmrt1417 ~ concd + mob + pocc + immc + popd
## + div, data = sea.tracts)
## weights: seaw
## 
## Moran I statistic standard deviate = 5.5829, p-value = 1.183e-08
## alternative hypothesis: greater
## sample estimates:
## Observed Moran I      Expectation         Variance 
##      0.267708587     -0.019089365      0.002638935
```

You should use other spatial weight matrices to test the robustness of your ESDA results. For example, do you get similar results when using a 3-nearest neighbor definition? What about a 2000 meter distance based matrix? How about a 2000 meter distance based matrix with inverse distance weights?




<div style="margin-bottom:25px;">
</div>
## **Spatial lag model**
\

Based on the exploratory mapping, Moran scatterplot, and the Moran's I, there appears to be spatial autocorrelation in the dependent variable.  This means that if there is a spatial lag process going on and we fit an OLS model our coefficients will be biased and inefficient.  That is, the coefficient size and sign are not close to their true value and its standard errors are underestimated. This means trouble, big trouble, real big trouble.

A spatial lag model can be estimated in R using the command `lagsarlm()`, which is in the **spdep** package.  Let's go with a Queen contiguity spatial weights matrix.  One potential motivation for using Queen contiguity is that the city is physically separated by a body of water.  Plotting the Queen contiguity neighborhood connections, we find no connections across Lake Union going west to Puget Sound and east to Lake Washington because the neighborhoods are not physically connected (or they are but only via bridges).  


```r
sea.coords <- coordinates(sea.tracts.sp)
plot(sea.tracts.sp, border = "grey60")
plot(seaw, coords = sea.coords, add=T, col=2)
```

![](lab6_files/figure-html/unnamed-chunk-30-1.png)<!-- -->

If we use a 2000 m distance band, we get connections, as seen in the following map.

![](lab6_files/figure-html/unnamed-chunk-31-1.png)<!-- -->

Some have argued that physical barriers like highways and lakes create natural neighborhood boundaries [(Kramer 2018)](https://journals.sagepub.com/doi/abs/10.1177/2399808318766067).  This is an example of how one should think very carefully about how to define neighbors in a spatial analysis.  Are those neighborhoods across Lake Union "connected"?

Let's fit the spatial lag model


```r
fit.lag<-lagsarlm(lvcmrt1417 ~ concd + mob + pocc + immc  + popd + div +pnhblack, 
     data = sea.tracts, listw = seaw) 
summary(fit.lag)
```

```
## 
## Call:lagsarlm(formula = lvcmrt1417 ~ concd + mob + pocc + immc + popd + 
##     div + pnhblack, data = sea.tracts, listw = seaw)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -4.83726 -0.55279  0.30206  0.97785  3.73405 
## 
## Type: lag 
## Coefficients: (asymptotic standard errors) 
##                Estimate  Std. Error z value Pr(>|z|)
## (Intercept)  1.00383069  4.62917261  0.2168  0.82833
## concd       -0.04525556  0.24413212 -0.1854  0.85294
## mob          3.17302805  1.45574070  2.1797  0.02928
## pocc         0.42652904  4.72143843  0.0903  0.92802
## immc         0.16953408  0.32309874  0.5247  0.59978
## popd        -0.00066296  0.00048075 -1.3790  0.16789
## div          0.19109995  1.98958373  0.0961  0.92348
## pnhblack     0.84348604  3.19232136  0.2642  0.79161
## 
## Rho: 0.55191, LR test value: 27.277, p-value: 1.7628e-07
## Asymptotic standard error: 0.086442
##     z-value: 6.3848, p-value: 1.716e-10
## Wald statistic: 40.766, p-value: 1.716e-10
## 
## Log likelihood: -273.1829 for lag model
## ML residual variance (sigma squared): 2.6973, (sigma: 1.6424)
## Number of observations: 140 
## Number of parameters estimated: 10 
## AIC: 566.37, (AIC for lm: 591.64)
## LM test for residual autocorrelation
## test value: 2.1681, p-value: 0.1409
```

The only real difference between the code for `lm()` and `lagsarlm()` is the argument `listw`, which you use to specify the spatial weights matrix.

Let's calculate the Moran's I on the model's residuals


```r
moran.mc(resid(fit.lag), seaw, nsim=999)
```

```
## 
## 	Monte-Carlo simulation of Moran I
## 
## data:  resid(fit.lag) 
## weights: seaw  
## number of simulations + 1: 1000 
## 
## statistic = -0.027722, observed rank = 366, p-value = 0.634
## alternative hypothesis: greater
```


<div style="margin-bottom:25px;">
</div>
## **Spatial error model**
\

The spatial error model incorporates spatial dependence in the errors. If there is a spatial error process going on and we fit an OLS model our coefficients will be unbiased but inefficient.  That is, the coefficient size and sign are asymptotically correct but its standard errors are underestimated. 

We can estimate a  spatial error model in R using the command `errorsarlm()` also in the **spdep** package.


```r
fit.err<-errorsarlm(lvcmrt1417 ~ concd + mob + pocc + immc  + popd + div +pnhblack, 
     data = sea.tracts, listw = seaw) 
summary(fit.err)
```

```
## 
## Call:errorsarlm(formula = lvcmrt1417 ~ concd + mob + pocc + immc + 
##     popd + div + pnhblack, data = sea.tracts, listw = seaw)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -5.05103 -0.53563  0.23645  1.06351  3.52178 
## 
## Type: error 
## Coefficients: (asymptotic standard errors) 
##                Estimate  Std. Error z value Pr(>|z|)
## (Intercept)  4.01348888  4.37971210  0.9164   0.3595
## concd        0.05070904  0.27062600  0.1874   0.8514
## mob          2.48137983  1.83221253  1.3543   0.1756
## pocc         0.11809724  4.58373077  0.0258   0.9794
## immc         0.31587006  0.33957270  0.9302   0.3523
## popd        -0.00056011  0.00047213 -1.1863   0.2355
## div          0.80469056  2.16560090  0.3716   0.7102
## pnhblack    -0.77447717  3.45762069 -0.2240   0.8228
## 
## Lambda: 0.59098, LR test value: 25.823, p-value: 3.7412e-07
## Asymptotic standard error: 0.083722
##     z-value: 7.0588, p-value: 1.6791e-12
## Wald statistic: 49.827, p-value: 1.679e-12
## 
## Log likelihood: -273.9097 for error model
## ML residual variance (sigma squared): 2.6911, (sigma: 1.6405)
## Number of observations: 140 
## Number of parameters estimated: 10 
## AIC: 567.82, (AIC for lm: 591.64)
```

And the Moran's I of the residuals


```r
moran.mc(resid(fit.err), seaw, nsim=999)
```

```
## 
## 	Monte-Carlo simulation of Moran I
## 
## data:  resid(fit.err) 
## weights: seaw  
## number of simulations + 1: 1000 
## 
## statistic = -0.020788, observed rank = 380, p-value = 0.62
## alternative hypothesis: greater
```

<div style="margin-bottom:25px;">
</div>
## **Presenting your results**
\

An organized table of results is an essential component not just in academic papers, but in any professional report or presentation.  Up till this point, we've been reporting results by simply printing objects, like the following


```r
fit.ols
```

We used the function `tidy()` above to create a tibble of modelling results. We can make these results prettier by using a couple of functions for making nice tables in R. First, there is the `kable()` function from the **knitr** package.   


```r
library(knitr)
```


```r
kable(tidy(fit.ols))
```



term             estimate   std.error    statistic     p.value
------------  -----------  ----------  -----------  ----------
(Intercept)     3.8351930   5.3963313    0.7107038   0.4785123
concd          -0.0410061   0.2359586   -0.1737850   0.8622986
mob             4.4693388   1.5950932    2.8019296   0.0058389
pocc           -0.2609372   5.5270811   -0.0472107   0.9624161
immc            0.0507213   0.3649737    0.1389724   0.8896821
popd           -0.0015659   0.0005553   -2.8199563   0.0055385
div             1.4279538   2.0600280    0.6931720   0.4894103

There are options to control the number of digits, whether row names are included or not, column alignment, and other options that depend on the output type.

The table produced by `kable()`looks good. But what if we want to present results for more than one model, such as presenting *fit.ols*, *fit.lag*, and *fit.err* side by side? We can use the `stargazer()` function from the **stargazer** package to do this.


```r
library(stargazer, quietly = TRUE)
stargazer(fit.ols, fit.lag, fit.err, type = "html",
                    title="Title: Regression Results")
```


<table style="text-align:center"><caption><strong>Title: Regression Results</strong></caption>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td colspan="3"><em>Dependent variable:</em></td></tr>
<tr><td></td><td colspan="3" style="border-bottom: 1px solid black"></td></tr>
<tr><td style="text-align:left"></td><td colspan="3">lvcmrt1417</td></tr>
<tr><td style="text-align:left"></td><td><em>OLS</em></td><td><em>spatial</em></td><td><em>spatial</em></td></tr>
<tr><td style="text-align:left"></td><td><em></em></td><td><em>autoregressive</em></td><td><em>error</em></td></tr>
<tr><td style="text-align:left"></td><td>(1)</td><td>(2)</td><td>(3)</td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">concd</td><td>-0.041</td><td>-0.045</td><td>0.051</td></tr>
<tr><td style="text-align:left"></td><td>(0.236)</td><td>(0.244)</td><td>(0.271)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">mob</td><td>4.469<sup>***</sup></td><td>3.173<sup>**</sup></td><td>2.481</td></tr>
<tr><td style="text-align:left"></td><td>(1.595)</td><td>(1.456)</td><td>(1.832)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">pocc</td><td>-0.261</td><td>0.427</td><td>0.118</td></tr>
<tr><td style="text-align:left"></td><td>(5.527)</td><td>(4.721)</td><td>(4.584)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">immc</td><td>0.051</td><td>0.170</td><td>0.316</td></tr>
<tr><td style="text-align:left"></td><td>(0.365)</td><td>(0.323)</td><td>(0.340)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">popd</td><td>-0.002<sup>***</sup></td><td>-0.001</td><td>-0.001</td></tr>
<tr><td style="text-align:left"></td><td>(0.001)</td><td>(0.0005)</td><td>(0.0005)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">div</td><td>1.428</td><td>0.191</td><td>0.805</td></tr>
<tr><td style="text-align:left"></td><td>(2.060)</td><td>(1.990)</td><td>(2.166)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">pnhblack</td><td></td><td>0.843</td><td>-0.774</td></tr>
<tr><td style="text-align:left"></td><td></td><td>(3.192)</td><td>(3.458)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td style="text-align:left">Constant</td><td>3.835</td><td>1.004</td><td>4.013</td></tr>
<tr><td style="text-align:left"></td><td>(5.396)</td><td>(4.629)</td><td>(4.380)</td></tr>
<tr><td style="text-align:left"></td><td></td><td></td><td></td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">Observations</td><td>140</td><td>140</td><td>140</td></tr>
<tr><td style="text-align:left">R<sup>2</sup></td><td>0.144</td><td></td><td></td></tr>
<tr><td style="text-align:left">Adjusted R<sup>2</sup></td><td>0.105</td><td></td><td></td></tr>
<tr><td style="text-align:left">Log Likelihood</td><td></td><td>-273.183</td><td>-273.910</td></tr>
<tr><td style="text-align:left">sigma<sup>2</sup></td><td></td><td>2.697</td><td>2.691</td></tr>
<tr><td style="text-align:left">Akaike Inf. Crit.</td><td></td><td>566.366</td><td>567.819</td></tr>
<tr><td style="text-align:left">Residual Std. Error</td><td>1.927 (df = 133)</td><td></td><td></td></tr>
<tr><td style="text-align:left">F Statistic</td><td>3.717<sup>***</sup> (df = 6; 133)</td><td></td><td></td></tr>
<tr><td style="text-align:left">Wald Test (df = 1)</td><td></td><td>40.766<sup>***</sup></td><td>49.827<sup>***</sup></td></tr>
<tr><td style="text-align:left">LR Test (df = 1)</td><td></td><td>27.277<sup>***</sup></td><td>25.823<sup>***</sup></td></tr>
<tr><td colspan="4" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"><em>Note:</em></td><td colspan="3" style="text-align:right"><sup>*</sup>p<0.1; <sup>**</sup>p<0.05; <sup>***</sup>p<0.01</td></tr>
</table>


\

There are a number of options you can tweak to make the table more presentation ready, such as adding footnotes and changing column and row labels.

Note three things: First, if you ran the `stargazer()` function above directly in your R console, you'll get output that won't make sense.  Knit the document and you'll see your pretty table. Second, you'll need to add the argument `quietly = TRUE` when you load **stargazer** into your current R session. Third, you will need to add `results = 'asis'` as an RMarkdown chunk option.


<div style="margin-bottom:25px;">
</div>
## **Which model? OLS, Spatial lag, or Spatial error?**
\

As we discussed in this week's handout, there are many fit statistics and tests to determine which model is most appropriate.  A popular set of tests proposed by Anselin (1988) (also see Anselin et al. 1996) are the Lagrange Multiplier (LM) tests. The null in these tests is the OLS model.  A test showing statistical significance rejects this null. 

In general, you fit the OLS model to your dependent variable, then submit the OLS model fit to the LM testing procedure. Then go through the series of steps I outlined in this week's handout.

To run the LM tests in R, use the `lm.LMtests()` command in the **spdep** package. Run this command and interpret the results. Which model is "best"? Why?

The LM test is not the only way to select between models. We'll go through a couple of other methods in next week's lecture and lab.


***


Website created and maintained by [Noli Brazil](https://nbrazil.faculty.ucdavis.edu/)
