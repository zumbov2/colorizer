#' Save Colorized and Juxtaposed Images
#'
#' \code{clsave} saves images that have been colorized using \code{colorize} or
#'     juxtaposed with \code{juxtapose}.
#'
#' @param response a response object of a \code{colorize} function call.
#' @param destfile a character string or vector with the name where the images are saved.
#'
#' @return Besides saving, the function returns the response object invisibly.
#'
#' @examples
#' \dontrun{
#' # Save colorized images
#' res <- colorize(img = "https://upload.wikimedia.org/wikipedia/commons/9/9e/Breadfruit.jpg")
#' clsave(res, destfile = "colorized_version.jpg")
#' }
#' @export
#' @importFrom dplyr filter
#' @importFrom stringr str_detect str_remove_all str_replace_all
#' @importFrom purrr walk2
clsave <- function(response, destfile = "") {

  # Remove Non-Responses
  response <- response %>% dplyr::filter(stringr::str_detect(response, "https://api.deepai.org/job-view-file/"))
  if (nrow(response) == 0) stop ("No URLs of colorized images found in response.")

  # Save Colorized Images from URL
  if (ncol(response) == 2) {

    i <- c(1:nrow(response))
    if (destfile == "") destfile <- rep("", nrow(response))
    purrr::pwalk(list(response$response, destfile, i), save_col_wh)

    }

  # Save Juxtaposed Images
  if (ncol(response) == 4) {

    i <- c(1:nrow(response))
    if (destfile == "") destfile <- rep("", nrow(response))
    purrr::pwalk(list(response$jp_type, response$jp, destfile, i), save_jp_wh)

  }

  # Return response
  return(invisible(response))

}
