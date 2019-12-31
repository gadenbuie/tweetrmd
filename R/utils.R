# use y if x is.null
`%||%` <- function(x, y) if (is.null(x)) y else x

read_pkg_file <- function(..., collapse = "\n", sep = "") {
  paste(
    readLines(system.file(..., package = "tweetrmd", mustWork = TRUE)),
    sep = "",
    collapse = collapse
  )
}
