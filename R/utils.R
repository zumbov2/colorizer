#' @importFrom httr POST upload_file add_headers status_code content
#' @importFrom tibble tibble
#' @noRd
colorize_wh <- function(img, key, pane) {

  # Prepare body for request
  if (file.exists(img)) {

    body <- list("image" = httr::upload_file(img))

  } else {

    body <- list("image" = img)

  }

  # API call
  response <- httr::POST(
    url = "https://api.deepai.org/api/colorizer",
    httr::add_headers("api-key" = key),
    body = body
  )

  # Display image and return response
  if (httr::status_code(response) == 200) {

    show_colorized(response = httr::content(response)[["output_url"]], pane = pane)

    response <- tibble::tibble(
      request = img,
      response = httr::content(response)[["output_url"]]
    )

  } else {

    if (is.null(httr::content(response)[["status"]])) warning("No valid image found.")
    if (!is.null(httr::content(response)[["status"]])) warning(httr::content(response)[["status"]])

    response <- tibble::tibble(
      request = img,
      response = NA
    )

  }

  return(response)

}

#' @importFrom magick image_read
#' @noRd
plot_img <- function(img) {

  cl <- magick::image_read(img)
  plot(cl)

}

#' @importFrom magick image_read
#' @noRd
print_img <- function(img) {

  cl <- magick::image_read(img)
  print(cl)

}

#' @importFrom dplyr filter
#' @importFrom magrittr "%>%"
#' @noRd
show_colorized <- function(response, pane) {

  # Read and display
  if (pane == "plot") plot_img(response)
  if (pane == "view") print_img(response)

  }

#' @importFrom magick image_read image_info image_scale image_append
#' @noRd
juxtapose_sbs <- function(img_bw, img_cl) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  bw <- magick::image_scale(bw, magick::image_info(cl)[["width"]])
  jp <- magick::image_append(c(bw, cl), stack = F)
  return(jp)

}

#' @importFrom magick image_read image_info image_scale image_append
#' @noRd
juxtapose_stacked <- function(img_bw, img_cl) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  bw <- magick::image_scale(bw, magick::image_info(cl)[["width"]])
  jp <- magick::image_append(c(bw, cl), stack = T)
  return(jp)
}

#' @importFrom magick image_read image_info image_scale image_append image_crop geometry_area
#' @noRd
juxtapose_focus_c <- function(img_bw, img_cl) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  cli <-  magick::image_info(cl)
  bw <- magick::image_scale(bw, cli[["width"]])

  upper_bw <- round(cli$height / 6)
  lower_bw <- round(cli$height / 6)
  middle_cl1 <- cli$height - upper_bw - lower_bw

  left_bw <- round(cli$width / 6)
  right_bw <- round(cli$width / 6)
  middle_cl2 <- cli$width - left_bw - right_bw

  p1 <- magick::image_crop(bw, magick::geometry_area(width = cli$width, height = upper_bw))

  p2a <- magick::image_crop(bw, magick::geometry_area(width = left_bw, height = middle_cl1, y_off = upper_bw))
  p2b <- magick::image_crop(cl, magick::geometry_area(width = middle_cl2, height = middle_cl1, x_off = left_bw, y_off = upper_bw))
  p2c <- magick::image_crop(bw, magick::geometry_area(width = right_bw, height = middle_cl1, x_off = left_bw + middle_cl2, y_off = upper_bw))
  p2 <- magick::image_append(c(p2a, p2b, p2c), stack = F)

  p3 <- magick::image_crop(bw, magick::geometry_area(width = cli$width, height = lower_bw, y_off = (upper_bw + middle_cl1)))

  jp <- magick::image_append(c(p1, p2, p3), stack = T)

  return(jp)

}

#' @importFrom magick image_read image_info image_scale image_append image_crop geometry_area
#' @noRd
juxtapose_focus_h <- function(img_bw, img_cl) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  cli <-  magick::image_info(cl)
  bw <- magick::image_scale(bw, cli[["width"]])

  upper_bw <- round(cli$height / 6)
  lower_bw <- round(cli$height / 6)
  middle_cl <- cli$height - upper_bw - lower_bw

  p1 <- magick::image_crop(bw, magick::geometry_area(width = cli$width, height = upper_bw))
  p2 <- magick::image_crop(cl, magick::geometry_area(width = cli$width, height = middle_cl, y_off = upper_bw))
  p3 <- magick::image_crop(bw, magick::geometry_area(width = cli$width, height = lower_bw, y_off = (upper_bw + middle_cl)))
  jp <- magick::image_append(c(p1, p2, p3), stack = T)

  return(jp)

}

#' @importFrom magick image_read image_info image_scale image_append image_crop geometry_area
#' @noRd
juxtapose_focus_v <- function(img_bw, img_cl) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  cli <-  magick::image_info(cl)
  bw <- magick::image_scale(bw, cli[["width"]])

  left_bw <- round(cli$width / 6)
  right_bw <- round(cli$width / 6)
  middle_cl <- cli$width - left_bw - right_bw

  p1 <- magick::image_crop(bw, magick::geometry_area(width = left_bw, height = cli$height))
  p2 <- magick::image_crop(cl, magick::geometry_area(width = middle_cl, height = cli$height, x_off = left_bw))
  p3 <- magick::image_crop(bw, magick::geometry_area(width = right_bw, height = cli$height, x_off = (left_bw + middle_cl)))
  jp <- magick::image_append(c(p1, p2, p3), stack = F)

  return(jp)

}

#' @importFrom magick image_read image_info image_scale image_append image_crop geometry_area
#' @noRd
juxtapose_split_h <- function(img_bw, img_cl) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  cli <-  magick::image_info(cl)
  bw <- magick::image_scale(bw, cli[["width"]])

  upper_half <- round(cli$height / 2)
  lower_half <- cli$height - upper_half

  p1 <- magick::image_crop(bw, magick::geometry_area(width = cli$width, height = upper_half))
  p2 <- magick::image_crop(cl, magick::geometry_area(width = cli$width, height = lower_half, y_off = upper_half))
  jp <- magick::image_append(c(p1, p2), stack = T)

  return(jp)

}

#' @importFrom magick image_read image_info image_scale image_append image_crop geometry_area
#' @noRd
juxtapose_split_v <- function(img_bw, img_cl) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  cli <-  magick::image_info(cl)
  bw <- magick::image_scale(bw, cli[["width"]])

  left_half <- round(cli$width / 2)
  right_half <- cli$width - left_half

  p1 <- magick::image_crop(bw, magick::geometry_area(width = left_half, height = cli$height))
  p2 <- magick::image_crop(cl, magick::geometry_area(width = right_half, height = cli$height, x_off = left_half))
  jp <- magick::image_append(c(p1, p2), stack = F)

  return(jp)

}

#' @importFrom magick image_read image_info image_scale image_crop geometry_area
#'     image_rotate image_append image_animate
#' @importFrom magrittr "%>%"
#' @noRd
juxtapose_split_d <- function(img_bw, img_cl) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  cli <-  magick::image_info(cl)
  bw <- magick::image_scale(bw, cli[["width"]])

  cl <- magick::image_border(cl, "black")
  bw <- magick::image_border(bw, "black")

  a <- cli$width / 2
  b <- cli$height / 2

  cl_rotated <- magick::image_rotate(cl, 180 * (asin(a / sqrt(a^2 + b^2)) / pi)) %>%
    magick::image_append()

  clri <- magick::image_info(cl_rotated)
  width_left_half <- round(clri$width / 2)
  width_right_half <- clri$width - width_left_half

  p1 <- magick::image_crop(cl_rotated, magick::geometry_area(width = width_right_half, height = clri$height, x_off = width_left_half))
  bw_rotated <- magick::image_rotate(bw, 180 * (asin(a / sqrt(a^2 + b^2)) / pi)) %>%
    magick::image_append()

  p2 <- magick::image_crop(bw_rotated, magick::geometry_area(width = width_left_half, height = clri$height))
  jp_rotated <- magick::image_append(c(p2, p1), stack = F)

  jp <- magick::image_rotate(jp_rotated, -180 * (asin(a / sqrt(a^2 + b^2)) / pi)) %>%
    magick::image_trim()

  jp_i <- magick::image_info(jp)

  jp <- magick::image_crop(
    jp,
    magick::geometry_area(
      width = cli$width,
      height = cli$height,
      x_off = (jp_i$width - cli$width) / 2,
      y_off = (jp_i$height - cli$height) / 2
    )
  )

  return(jp)

}

#' @importFrom magick image_read image_info image_scale image_append
#'     image_crop geometry_area image_rotate
#' @importFrom magrittr "%>%"
#' @noRd
juxtapose_animate_u <- function(img_bw, img_cl, frames = 60) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  cli <-  magick::image_info(cl)
  bw <- magick::image_scale(bw, cli[["width"]])

  transition_cl <- round(seq(0, cli$height, (cli$height/frames))) - 1
  transition_cl[transition_cl < 0] <- 0
  transition_bw <- cli$height - transition_cl

  p1 <- magick::image_crop(bw, magick::geometry_area(width = cli$width, height = transition_bw[1]))
  jps <- magick::image_append(p1)

  for (i in 2:(length(transition_cl))) {

    p1 <- magick::image_crop(bw, magick::geometry_area(width = cli$width, height = transition_bw[i]))
    p2 <- magick::image_crop(cl, magick::geometry_area(width = cli$width, height = transition_cl[i], y_off = transition_bw[i]))
    jp <- magick::image_append(c(p1, p2), stack = T)
    jps <- c(jps, jp)

    }
  jp <- magick::image_animate(jps, fps = 20)

  return(jp)

}

#' @importFrom magick image_read image_info image_scale image_append
#'     image_crop geometry_area image_rotate
#' @importFrom magrittr "%>%"
#' @noRd
juxtapose_animate_s <- function(img_bw, img_cl, frames = 60) {

  bw <- magick::image_read(img_bw)
  cl <- magick::image_read(img_cl)
  cli <-  magick::image_info(cl)
  bw <- magick::image_scale(bw, cli[["width"]])

  transition_cl <- round(seq(0, cli$width, (cli$width/frames))) - 1
  transition_cl[transition_cl < 0] <- 0
  transition_bw <- cli$width - transition_cl

  p1 <- magick::image_crop(bw, magick::geometry_area(width = transition_bw[1], height = cli$height))
  jps <- magick::image_append(p1)

  for (i in 2:(length(transition_cl))) {

    p1 <- magick::image_crop(bw, magick::geometry_area(width = transition_bw[i], height = cli$height, x_off = transition_cl[i]))
    p2 <- magick::image_crop(cl, magick::geometry_area(width = transition_cl[i], height = cli$height))
    jp <- magick::image_append(c(p2, p1), stack = F)
    jps <- c(jps, jp)

  }
  jp <- magick::image_animate(jps, fps = 20)

  return(jp)

}

#' @importFrom tibble tibble
#' @noRd
juxtapose_wh <- function(img_bw, img_cl, pane, type) {

  # Select display type
  if (length(type) > 1) {

    cli <- magick::image_read(img_cl) %>%
      magick::image_info()

    if (cli$height >= cli$width) type <- "side-by-side"
    if (cli$height < cli$width) type <- "stacked"

  }

  # Check type
  if (!type %in% c(
    "side-by-side", "stacked", "c-focus", "h-focus", "v-focus",
    "h-split", "v-split", "d-split", "u-animate", "s-animate"
    )) stop("type ", type, " not found")

  # Compose
  if (type == "side-by-side") jp <- juxtapose_sbs(img_bw, img_cl)
  if (type == "stacked") jp <- juxtapose_stacked(img_bw, img_cl)
  if (type == "c-focus") jp <- juxtapose_focus_c(img_bw, img_cl)
  if (type == "h-focus") jp <- juxtapose_focus_h(img_bw, img_cl)
  if (type == "v-focus") jp <- juxtapose_focus_v(img_bw, img_cl)
  if (type == "h-split") jp <- juxtapose_split_h(img_bw, img_cl)
  if (type == "v-split") jp <- juxtapose_split_v(img_bw, img_cl)
  if (type == "d-split") jp <- juxtapose_split_d(img_bw, img_cl)
  if (type == "u-animate") jp <- juxtapose_animate_u(img_bw, img_cl)
  if (type == "s-animate") jp <- juxtapose_animate_s(img_bw, img_cl)

  # Display
  if (pane == "plot") plot(jp)
  if (pane == "view" | type %in% c("u-animate", "s-animate")) print(jp)

  # Return
  djp <- tibble::tibble(
    jp_type = type,
    jp = list(jp)
    )

  return(invisible(djp))

}

#' @importFrom stringr str_detect str_remove_all str_replace_all
#' @importFrom magick image_write
#' @noRd
save_jp_wh <- function(jp_type, jp, destfile, i) {

  if (stringr::str_detect(jp_type, "animate")) {

    if (destfile == "") {

      destfile <- paste0(
        Sys.time() %>%
          stringr::str_remove_all("[^ 0-9]") %>%
          stringr::str_replace_all(" ", "_"),
        "_Juxtaposed_",
        i,
        ".gif"
      )

    }
    cat("Saving gif... this may take a while. \n")
    magick::image_write_gif(jp, destfile)

    } else {

    if (destfile == "") {

      destfile <- paste0(
        Sys.time() %>%
          stringr::str_remove_all("[^ 0-9]") %>%
          stringr::str_replace_all(" ", "_"),
        "_Juxtaposed_",
        i,
        ".jpg"
        )

    }
    magick::image_write(jp, destfile)

  }

}

#' @importFrom magick image_read image_write
#' @importFrom magrittr "%>%"
#' @noRd
save_col <- function(url, destfile) {

  magick::image_read(url) %>%
    magick::image_write(path = destfile)

}

#' @importFrom magick image_read image_write
#' @importFrom magrittr "%>%"
#' @noRd
save_col_wh <- function(url, destfile, i) {

  if (destfile == "") {

    destfile <- paste0(
      Sys.time() %>%
        stringr::str_remove_all("[^ 0-9]") %>%
        stringr::str_replace_all(" ", "_"),
      "_Colorized_", i, ".jpg"
      )

  }

  save_col(url, destfile)

}

#' @noRd
check_pane <- function(pane) {

  if (is.null(pane)) stop("pane must not be NULL.")
  if (!pane[1] %in% c("plot", "view", "none")) stop("pane not specified correctly.")

}

#' @noRd
check_type <- function(type) {

  if (is.null(type)) stop("type must not be NULL.")
  if (!type[1] %in% c(
    "side-by-side", "stacked", "c-focus", "h-focus", "v-focus",
    "h-split", "v-split", "d-split", "u-animate", "s-animate")
    ) stop("type not specified correctly.")

}

#' @importFrom magrittr "%>%"
#' @importFrom dplyr filter
#' @importFrom stringr str_detect
#' @noRd
check_response <- function(response) {

  response2 <- response %>%
    dplyr::filter(stringr::str_detect(response, "https://api.deepai.org/job-view-file/"))

  if (nrow(response2) == 0) stop ("No URLs of colorized images found in response.")
  if (nrow(response2) < nrow(response)) warning ("Not all entries have valid URLs of colorized images.")
  return(response2)

}
