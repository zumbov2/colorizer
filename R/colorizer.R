#' \code{colorizer} package
#'
#' Colorize and Restore Old Images Using the 'DeOldify' Image Colorization API on 'DeepAI'
#'
#' See the README on
#' \href{https://github.com/zumbov2/colorizer#readme}{GitHub}
#'
#' @docType package
#' @name colorizer
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1") {

  utils::globalVariables(
    c("%>%")
  )
}
