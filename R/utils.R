# use y if x is.null
`%||%` <- function(x, y) if (is.null(x)) y else x

read_pkg_file <- function(..., collapse = "\n", sep = "") {
  paste(
    readLines(system.file(..., package = "tweetrmd", mustWork = TRUE)),
    sep = "",
    collapse = collapse
  )
}

assert_string <- function(x) {
  var <- substitute(x)
  if (!is.character(x) || length(x) != 1) {
    stop(paste0(
      "`", var, "` must be a single string."
    ))
  }
}
