#' Take or embed a screenshot of a tweet
#'
#' Takes a screenshot of the tweet that is automatically embedded in R Markdown
#' documents or that can be saved for use later.
#'
#' @examples
#' \dontrun{
#' tmpimg <- tempfile(fileext = "png")
#' tweet_screenshot(
#'   tweet_url = "https://twitter.com/alexpghayes/status/1211748406730706944",
#'   file = tmpimg
#' )
#' }
#'
#' @inheritParams tweet_embed
#' @param scale Scale the tweet for a better quality screenshot. Default is 2.
#' @param file A character string of output files. Can end with `.png` or `.pdf`.
#' @inheritDotParams tweet_embed
#' @family Tweet-embedding functions
#' @export
tweet_screenshot <- function(
  tweet_url,
  maxwidth = 550,
  scale = 2,
  file = NULL,
  link_color = NULL,
  ...
) {
  assert_string(tweet_url)
  requires_webshot2()

  html <- single_tweet_page(tweet_url, maxwidth, link_color, ...)

  tmpfile <- tempfile(fileext = ".html")
  htmltools::save_html(html, tmpfile, "transparent")

  webshot2::webshot(
    url = tmpfile,
    file = file %||% tempfile(fileext = ".png"),
    vwidth = maxwidth + 10,
    vheight = 2500,
    selector = "#screenshot-tweet",
    zoom = scale,
    expand = 0,
    delay = 0.5
  )
}

requires_webshot2 <- function(stop = TRUE) {
  has_webshot2 <- requireNamespace("webshot2", quietly = TRUE)
  if (!isTRUE(stop)) {
    has_webshot2
  } else if (!has_webshot2) {
    stop("`webshot2` is required: devtools::install_github('rstudio/webshot2')")
  } else {
    invisible(TRUE)
  }
}

single_tweet_page <- function(
  tweet_url,
  maxwidth = 550,
  link_color = NULL,
  ...
) {
  htmltools::tagList(
    htmltools::div(
      id = "screenshot-tweet",
      tweet_embed(tweet_url, maxwidth = maxwidth, ...)
    ),
    htmltools::tags$head(
      htmltools::tags$style(
        sprintf(
          read_pkg_file("tweet-screenshot-default.css"),
          link_color %||% "#3b94d9"
        )
      )
    )
  )
}
