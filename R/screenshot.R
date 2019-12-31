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
#' @param file A character string of output files. Can end with `.png` or `.pdf`.
#' @inheritDotParams tweet_embed
#' @seealso [tweet_embed()]
#' @export
tweet_screenshot <- function(
  tweet_url,
  maxwidth = 550,
  file = NULL,
  ...
) {
  requires_webshot2()

  html <- htmltools::tagList(
    tweet_embed(tweet_url, maxwidth = maxwidth, ...),
    htmltools::tags$script(
      htmltools::HTML(paste(
        readLines(system.file("styleTweet.js", package = "tweetrmd")),
        collapse = "\n"
      ))
    )
  )

  tmpfile <- tempfile(fileext = ".html")
  htmltools::save_html(html, tmpfile, "transparent")

  webshot2::webshot(
    url = tmpfile,
    file = file %||% tempfile(fileext = ".png"),
    vwidth = maxwidth + 10,
    selector = ".twitter-tweet",
    expand = c(0, 0, 2, 0),
    delay = 0.25
  )
}

requires_webshot2 <- function() {
  if (!requireNamespace("webshot2", quietly = TRUE)) {
    stop("`webshot2` is required: devtools::install_github('rstudio/webshot2')")
  }
}
