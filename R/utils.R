paramTypesToTypeConvertFunctions = function(param.types) {
  checkmate::assertCharacter(param.types, min.len = 1L)

  map = list(
    i = "as.integer",
    l = "as.logical",
    c = "as.character",
    n = "as.numeric"
  )

  return(map[param.types])
}

#' Drop files extension(s).
#'
#' @param fn [\code{character}]
#'   Path.
#' @param levels [\code{integer(1)}]\cr
#'   How many extensions should be removed?
#'   Defaults to 1.
#' @export
dropExtension = function(fn, levels = 1L) {
  for (i in 1:levels)
    fn = gsub("\\.[[:alpha:]]*$", "", fn)
  return(fn)
}
