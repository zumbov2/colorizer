[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/colorizer)](https://cran.r-project.org/package=colorizer)
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-orange.svg)
[![Build Status](https://travis-ci.org/zumbov2/colorizer.svg?branch=master)](https://travis-ci.org/zumbov2/colorizer)

# colorizer
This R package is an interface to the awesome [DeOldify](https://github.com/jantic/DeOldify) image colorization API on [DeepAI](https://deepai.org/machine-learning-model/colorizer), providing the possibility to colorize and restore old images. More about the NoGAN learning method used to train DeOldify can be found [here](https://www.fast.ai/2019/05/03/decrappify/).
 
The default api-key can be used to make a few requests. After registration on [DeepAI](https://deepai.org/), around 5000 requests are currently possible within the free service.

## Installation
The latest version is available on GitHub (0.1.0):

```r
install.packages("devtools")
devtools::install_github("zumbov2/colorizer")
```
# Functions
The package provides three functions/verbs: `colorize()` to perform API requests, `juxtapose()` to create different comparisons of original and colorized images, and `clsave()` to save colorized images and comparisons.

## An example
```r
# API call
colorizer::colorize(
  img = "https://upload.wikimedia.org/wikipedia/commons/9/9e/Breadfruit.jpg", 
  key = my_key
  ) %>%
  
  # Saving colorized image
  clsave(destfile = "colorized.png") %>% 
  
  # Comparing colorized image to original
  juxtapose(type = "side-by-side") %>% 
  
  # Saving comaprsion
  clsave(destfile = "comaprison.png") 
 ```

<img src="https://github.com/zumbov2/colorizer/blob/master/img/colorized.png" width="300">  
estfile = "comaprison.png") 

<img src="https://github.com/zumbov2/colorizer/blob/master/img/comaprison.png" width="600">  

## Types of juxtapositions