#' @import BBmisc
#' @import checkmate
#' @importFrom utils read.table
#' @importFrom purrr flatten
NULL

.onLoad = function(libname, pkgname) { # nocov start
  if (requireNamespace("debugme", quietly = TRUE) && "experimentR" %in% strsplit(Sys.getenv("DEBUGME"), ",", fixed = TRUE)[[1L]]) {
    debugme::debugme()
    #batchtools$debug = TRUE
  }
} # nocov end
