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
#' @seealso [tweet_embed()]
#' @export
tweet_screenshot <- function(
  tweet_url,
  maxwidth = 550,
  scale = 2,
  file = NULL,
  link_color = NULL,
  ...
) {
  requires_webshot2()

  html <- single_tweet_page(tweet_url, maxwidth, scale, link_color, ...)

  tmpfile <- tempfile(fileext = ".html")
  htmltools::save_html(html, tmpfile, "transparent")

  webshot2::webshot(
    url = tmpfile,
    file = file %||% tempfile(fileext = ".png"),
    vwidth = maxwidth * scale + 10,
    vheight = 2500 * scale,
    selector = "#screenshot-tweet",
    expand = c(0, 0, 2, 0),
    delay = 0.5
  )
}

requires_webshot2 <- function() {
  if (!requireNamespace("webshot2", quietly = TRUE)) {
    stop("`webshot2` is required: devtools::install_github('rstudio/webshot2')")
  }
}

single_tweet_page <- function(
  tweet_url,
  maxwidth = 550,
  scale = 2,
  link_color = NULL,
  ...
) {
  htmltools::tagList(
    htmltools::div(
      id = "screenshot-tweet",
      style = "width: 100%",
      tweet_embed(tweet_url, maxwidth = maxwidth, ...)
    ),
    htmltools::tags$head(
      htmltools::tags$style(
        sprintf(
          read_pkg_file("tweet-screenshot-default.css"),
          scale,
          link_color %||% "#3b94d9"
        )
      )
    ),
    htmltools::tags$script(
      htmltools::HTML(read_pkg_file("styleTweet.js"))
    )
  )
}
