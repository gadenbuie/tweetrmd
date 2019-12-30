#' Embed a Tweet in R Markdown HTML outputs
#'
#' Uses Twitter's [oembed](https://publish.twitter.com/oembed) API to embed a
#' tweet in R Markdown HTML outputs.
#'
#' @examples
#' \dontrun{
#' # these are equivalent
#' tweet_embed("https://twitter.com/alexpghayes/status/1211748406730706944")
#'
#' tweet_embed(tweet_url("alexpghayes", "1211748406730706944"))
#' }
#'
#' @return The placeholder HTML for the tweet
#' @param tweet_url The URL for the tweet, or use [tweet_url()] to build the URL
#'   from a `screen_name` and `status_id`.
#' @param maxwidth The maximum width of a rendered Tweet in whole pixels. A
#'   supplied value under or over the allowed range will be returned as the
#'   minimum or maximum supported width respectively; the reset width value will
#'   be reflected in the returned `width` property. Note that Twitter does not
#'   support the oEmbed `maxheight` parameter. Tweets are fundamentally text,
#'   and are therefore of unpredictable height that cannot be scaled like an
#'   image or video. Relatedly, the oEmbed response will not provide a value for
#'   `height.` Implementations that need consistent heights for Tweets should
#'   refer to the `hide_thread` and `hide_media`` parameters below.
#' @param hide_media When set to `true`, `"t"`, or `1` links in a Tweet are not
#'   expanded to photo, video, or link previews.
#' @param hide_thread When set to `true`, `"t"`, or `1` a collapsed version of
#'   the previous Tweet in a conversation thread will not be displayed when the
#'   requested Tweet is in reply to another Tweet.
#' @param omit_script When set to `FALSE`, Twitter's remote script responsible
#'   for loading the Tweet widget will be used. Otherwise, the script included
#'   by this package will be used. If you are including multiple tweets on a
#'   page, it is recommended to use the default `FALSE`.
#' @param align Specifies whether the embedded Tweet should be floated left,
#'   right, or center in the page relative to the parent element.
#' @param related  A comma-separated list of Twitter usernames related to your
#'   content. This value will be forwarded to
#'   [Tweet action intents](https://developer.twitter.com/web/intents)
#'   if a viewer chooses to reply, like, or retweet the embedded Tweet.
#' @param lang Request returned HTML and a rendered Tweet in the specified
#'   [Twitter language supported by embedded Tweets](https://developer.twitter.com/web/overview/languages).
#' @param theme When set to `dark`, the Tweet is displayed with light text over
#'   a dark background.
#' @param link_color Adjust the color of Tweet text links with a
#'   [hexadecimal color value](https://en.wikipedia.org/wiki/Web_colors#Hex_triplet).
#' @param widget_type Set to `video` to return a Twitter Video embed for the
#'   given Tweet.
#' @param dnt When set to `true`, the Tweet and its embedded page on your site
#'   are not used for purposes that include
#'   [personalized suggestions](https://support.twitter.com/articles/20169421)
#'   and [personalized ads](https://support.twitter.com/articles/20170405).
#' @export
tweet_embed <- function(
  tweet_url,
  maxwidth = 325,
  hide_media = FALSE,
  hide_thread = FALSE,
  omit_script = TRUE,
  align = c("none", "left", "right", "center"),
  related = NULL,
  lang = "en",
  theme = c("light", "dark"),
  link_color = NULL,
  widget_type = NULL,
  dnt = TRUE
) {
  align <- match.arg(align)
  theme <- match.arg(theme)
  if (!is.null(widget_type) && !identical(widget_type, "video")) {
    stop("`widget_type` must be NULL or 'video'")
  }

  url <- httr::parse_url("https://publish.twitter.com/oembed")
  url$query <- list(
    url = tweet_url,
    maxwidth = maxwidth,
    hide_media = validate_true(hide_media),
    hide_thread = validate_true(hide_thread),
    omit_script = omit_script,
    align = align,
    related = related %||% paste(related, collapse = ","),
    lang = lang,
    theme = theme,
    link_color = link_color,
    widget_type = widget_type,
    dnt = validate_true(dnt)
  )

  url <- httr::build_url(url)
  res <- httr::GET(url)
  httr::stop_for_status(res)
  if (!grepl("application/json", res$headers$`content-type`)) {
    stop("Expected json response, got ", res$headers$`content-type`)
  }
  res_txt <- httr::content(res, "text")
  res_json <- jsonlite::fromJSON(res_txt)
  bq <- htmltools::HTML(res_json$html)
  if (omit_script) {
    bq <- htmltools::tagList(
      html_dependency_twitter(),
      bq
    )
  }
  htmltools::browsable(bq)
}

#' @describeIn tweet_embed Create a URL for a tweet from a screen name and status id.
#' @param screen_name The user's screen name
#' @param status_id The tweet's status id
#' @export
tweet_url <- function(screen_name, status_id) {
  stopifnot(grepl("[^\\d]", status_id))
  sprintf("https://twitter.com/%s/status/%s", screen_name, status_id)
}

html_dependency_twitter <- function() {
  htmltools::htmlDependency(
    name = "twitter-widget",
    version = "0.0.1",
    package = "tweetrmd",
    src = "tw",
    script = c("twitter-widgets-loader.js"),
    all_files = TRUE
  )
}

validate_true <- function(x) {
  if (isTRUE(x) || identical(tolower(x), "t") || x == 1) {
    TRUE
  } else FALSE
}

#' @describeIn tweet_embed A shortcut for the impatient.
#' @export
`%tweet%` <- function(screen_name, status_id) {
  tweet_url(screen_name, status_id)
}