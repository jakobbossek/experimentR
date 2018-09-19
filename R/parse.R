#' @param file [\code{character(1)}]\cr
#'   Path to file.
#' @param ... [any]
#'   Further arguments passed down to \code{\link[utils]{read.table}}.
#' @return [\code{data.frame}]
#' @export
parserDf = function(file, ...) {
  defaults = list(stringsAsFactors = FALSE, sep = " ", header = TRUE)
  args = BBmisc::insert(defaults, list(...))
  args$file = file
  do.call(read.table, args)
}

parserList = function(file, ...) {
  res = parserDf(file, ...)
  list(res)
}
