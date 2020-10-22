#' Call Image Colorization API
#'
#' \code{colorize} calls the DeOldify image colorization API on DeepAI.
#'
#' @param img path or url to the images to be colorized.
#' @param key DeepAI api-key.
#' @param pane defines in which pane the image is displayed: \code{plot}, \code{view} or \code{none}.
#'
#' @details With the standard api-key a few queries are possible. After registration on DeepAI
#'    \url{https://deepai.org/}, around 5000 free requests are currently possible.
#'
#' @return A tibble with the file locations of the original images and the response urls to
#'    the colorized images or status messages.
#'
#' @examples
#' \dontrun{
#' # Call image colorization API
#' colorize(img = "https://upload.wikimedia.org/wikipedia/commons/9/9e/Breadfruit.jpg")
#' }
#' @export
#' @importFrom purrr map_dfr
colorize <- function(img, key = "quickstart-QUdJIGlzIGNvbWluZy4uLi4K", pane = c("plot", "view", "none")) {

  # Colorize
  response <- purrr::map_dfr(
    img,
    colorize_wh,
    key = key,
    pane = pane[1]
    )

  # Return response
  return(response)

}
