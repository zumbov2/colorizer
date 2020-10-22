#' Compare Images
#'
#' \code{juxtapose} compares the original image with the colorized version obtained with
#'     \code{colorize}.
#'
#' @param response a response object of a \code{colorize} function call.
#' @param pane defines in which pane the image is displayed: \code{Plots} or \code{Viewer}.
#' @param type defines the type of juxtaposition: \itemize{
#' \item \code{side-by-side} original image left, colorized right.
#' \item \code{stacked} original above colorized.
#' \item \code{c-focus} colorized center with original image border.
#' \item \code{h-focus} above and below strips of original image.
#' \item \code{v-focus} left and right strips of original image.
#' \item \code{h-split} horizontally halved.
#' \item \code{v-split} vertically halved.
#' \item \code{d-split} diagonally halved.
#' \item \code{u-animate} animated, colorized to the top (upwards).
#' \item \code{s-animate} animated, colorized from left to right (sideways).
#'  }
#'
#' @return The function adds the comparison to the response object and returns it invisibly.
#'
#' @examples
#' \dontrun{
#' # Compare images
#' res <- colorize(img = "https://upload.wikimedia.org/wikipedia/commons/9/9e/Breadfruit.jpg")
#' juxtapose(res)
#' }
#' @export
#' @importFrom dplyr filter bind_cols
#' @importFrom stringr str_detect
#' @importFrom purrr map2_dfr
juxtapose <- function(response, type = c("side-by-side", "stacked", "c-focus", "h-focus", "v-focus", "h-split", "v-split", "d-split", "u-animate", "s-animate"),
                      pane = c("plot", "view", "none")) {

  # Remove Non-Responses
  response <- response %>% dplyr::filter(stringr::str_detect(response, "https://api.deepai.org/job-view-file/"))
  if (nrow(response) == 0) stop ("No URLs of colorized images found in response.")

  # Juxtapose
  jp <- purrr::map2_dfr(
    response$request,
    response$response,
    juxtapose_wh,
    pane = pane[1],
    type = type
    )

  # Return respons
  response <- dplyr::bind_cols(response, jp)
  return(invisible(response))

}
