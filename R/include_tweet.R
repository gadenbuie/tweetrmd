#' Include A Tweet in All R Markdown Formats
#'
#' Similar to [knitr::include_graphics()], but for tweets. In HTML documents,
#' the tweet is embedded using [tweet_embed()] and for all other documents types
#' a screen shot of the tweet is rendered and used [tweet_screenshot()]. If you
#' would rather that just the text of the tweet be included in non-HTML outputs,
#' use [tweet_embed()].
#'
#' @return An `htmltools::tagList()` to include a tweet in an HTML document, or
#'   a screen shot of the tweet for use in non-HTML outputs.
#'
#' @examples
#'
#' include_tweet("https://twitter.com/dsquintana/status/1275705042385940480")
#'
#' @inheritParams tweet_embed
#' @inheritDotParams tweet_embed
#' @export
include_tweet <- function(tweet_url, ...) {
  if (!in_knitr() || knitr::is_html_output()) {
    return(tweet_embed(tweet_url, ...))
  }

  tweet_screenshot(tweet_url, ...)
}


in_knitr <- function() {
  !is.null(knitr::current_input())
}
