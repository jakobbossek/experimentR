#' Glimpse into results folder.
#'
#' @param path [\code{character(1)}]\cr
#'   Path to result folder.
#' @param pattern [\code{character(1)}]\cr
#'   Pattern used to filter files recursively. See argument \code{pattern} of
#'   \code{\link[base]{list.files}}.
#' @return Nothing
#' @export
inspectResultFolder = function(path, pattern = NULL, ...) {
  n.files = length(list.files(path, pattern = pattern, recursive = TRUE, ...))
  n.dirs = length(list.dirs(path))
  cat(crayon::red$bold(n.files) %+% " files in " %+% crayon::red$bold(n.dirs) %+% " directories (on top level).\n")
}
