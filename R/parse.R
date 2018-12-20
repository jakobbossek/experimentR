#' File parsers
#'
#' @param file [\code{character(1)}]\cr
#'   Path to file.
#' @param ... [any]
#'   Further arguments passed down to actual parse/import/read function.
#' @return [any]
#' @rdname parserDf
#' @family file parsers
#' @export
parserDf = function(file, ...) {
  defaults = list(stringsAsFactors = FALSE, sep = " ", header = TRUE)
  args = BBmisc::insert(defaults, list(...))
  args$file = file
  do.call(read.table, args)
}

#' @rdname parserDf
#' @family file parsers
#' @export
parserDatatable = function(file, ...) {
  defaults = list(sep = " ")
  args = BBmisc::insert(defaults, list(...))
  args$input = file
  do.call(data.table::fread, args)
}

#' @rdname parserDf
#' @family file parsers
#' @export
parserList = function(file, ...) {
  res = parserDf(file, ...)
  list(res)
}
