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
#' @family Tweet-embedding functions
#' @export
include_tweet <- function(tweet_url, plain = FALSE, ...) {
  if (!in_knitr() || knitr::is_html_output()) {
    return(tweet_embed(tweet_url, plain = plain, ...))
  }

  if (isTRUE(plain) || !requires_webshot2(stop = FALSE)) {
    knitr::asis_output(tweet_markdown(tweet_url, ...))
  } else {
    tweet_screenshot(tweet_url, ...)
  }
}

#' @describeIn include_tweet Return a tweet as plain markdown.
#' @export
tweet_markdown <- function(tweet_url, ...) {
  assert_string(tweet_url)
  bq <- tweet_blockquote(tweet_url, ...)
  html_to_markdown(bq)
}

html_to_markdown <- function(html, ...) {
  rmarkdown::pandoc_available(error = TRUE)
  tmpfile <- tempfile(fileext = ".html")
  tmpout <- tempfile(fileext = ".md")
  on.exit(unlink(c(tmpfile, tmpout)))
  writeLines(format(html), tmpfile)
  rmarkdown::pandoc_convert(tmpfile, from = "html", output = tmpout)
  x <- paste(readLines(tmpout), collapse = "\n")
  # strip twitter ?ref_src from urls
  gsub("(twitter[.]com.+?)([?][^)]+)", "\\1", x)
}


in_knitr <- function() {
  !is.null(knitr::current_input())
}
