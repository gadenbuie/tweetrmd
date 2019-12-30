# use y if x is.null
`%||%` <- function(x, y) if (is.null(x)) y else x
