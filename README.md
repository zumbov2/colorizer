[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/colorizer)](https://cran.r-project.org/package=colorizer)
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-orange.svg)
[![Build Status](https://travis-ci.org/zumbov2/colorizer.svg?branch=master)](https://travis-ci.org/zumbov2/colorizer)
[![cranlogs](https://cranlogs.r-pkg.org/badges/grand-total/colorizer)](http://cran.rstudio.com/web/packages/colorizer/index.html)

# colorizer
This R package is an interface to the awesome [DeOldify image colorization API](https://github.com/jantic/DeOldify) on [DeepAI](https://deepai.org/machine-learning-model/colorizer), providing the possibility to **colorize and restore old images**. More about the NoGAN learning method used to train DeOldify can be found [here](https://www.fast.ai/2019/05/03/decrappify/).
 
The default api-key can be used to make a **few requests**. After [registration on DeepAI](https://deepai.org/), around **5000 requests** are currently (Oct 2020) possible within the **free service**.

## Installation
Version 0.1.0 is on CRAN and can be installed as follows:
```r
install.packages("colorizer")
```
Install from GitHub for a regularly updated version (latest: 0.1.0):
```r
install.packages("devtools")
devtools::install_github("zumbov2/colorizer")
```
# Functions
The package provides **three functions/verbs**: `colorize()` to perform API requests, `juxtapose()` to create different comparisons of original and colorized images, and `clsave()` to save colorized images and comparisons.

## Examples
### Breadfruit, approx. 1870
```r
# API call
colorizer::colorize(
  img = "https://upload.wikimedia.org/wikipedia/commons/9/9e/Breadfruit.jpg", 
  key = my_key
  ) %>%
  
  # Saving colorized image
  colorizer::clsave(destfile = "colorized.png") %>% 
  
  # Comparing colorized image to original
  colorizer::juxtapose(type = "side-by-side") %>% 
  
  # Saving comparsion
  colorizer::clsave(destfile = "comparison.png") 
 ```
<img src="https://github.com/zumbov2/colorizer/blob/master/img/colorized.png" width="300">  

<img src="https://github.com/zumbov2/colorizer/blob/master/img/comaprison.png" width="600">  

### Children, 1920s
```r
colorizer::colorize(
  img = "https://cdn.pixabay.com/photo/2013/02/13/22/38/children-81487_1280.jpg", 
  key = my_key,
  ) %>% 
  juxtapose("side-by-side") %>% 
  clsave("children1920.jpg")
 ```
<img src="https://github.com/zumbov2/colorizer/blob/master/img/children1920.jpg" width="600">  

### My Grandpa, 1936
```r
colorizer::colorize(
  img = "diskus1936.jpg", 
  key = my_key
  ) %>%
  colorizer::juxtapose("side-by-side") %>% 
  colorizer::clsave("HansZumbach.jpg") 
 ```

<img src="https://github.com/zumbov2/colorizer/blob/master/img/HansZumbach.jpg" width="600">  

### John Wayne and Gail Russell, 1940s
```r
colorizer::colorize(
  img = "https://cdn.pixabay.com/photo/2014/07/16/03/49/john-wayne-394468_1280.jpg", 
  key = my_key
  ) %>%
  colorizer::juxtapose("side-by-side") %>% 
  colorizer::clsave("Wayne-Russel.jpg") 
 ```

<img src="https://github.com/zumbov2/colorizer/blob/master/img/Wayne-Russel.jpg" width="600">  
  
## Types of juxtaposition
The comparisons are made using the [magick package](https://github.com/ropensci/magick) – for platform-specific dependencies please see the section [Installation](https://github.com/ropensci/magick#Installation). The following **juxtaposition types** are currently available:

### `type = "side-by-side"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison1.png" width="150">  

### `type = "stacked"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison2.png" width="150">  

### `type = "c-focus"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison3.png" width="150">  

### `type = "h-focus"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison4.png" width="150"> 

### `type = "v-focus"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison5.png" width="150"> 

### `type = "h-split"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison6.png" width="150"> 

### `type = "v-split"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison7.png" width="150"> 

### `type = "d-split"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison8.png" width="150"> 

### `type = "u-animate"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison9.gif" width="150"> 

### `type = "s-animate"`
<img src="https://github.com/zumbov2/colorizer/blob/master/img/comparison10.gif" width="150"> 
