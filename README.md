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
## An example
sadsadf

```r
library(colorizer)

colorize(
  img = "https://upload.wikimedia.org/wikipedia/commons/9/9e/Breadfruit.jpg", 
  key = my_key
  ) %>%
  clsave(destfile = "colorized.png") %>% 
  juxtapose(type = "side-by-side") %>% 
  clsave(destfile = "comaprison.png") 
 ```
