#' Wrapper around sprintf and dir.create.
#'
#' @param root [\code{character(1)}]\cr
#'   Root path.
#' @param format.string [\code{character(1)}]\cr
#'   Format string for \code{sprintf}.
#' @param ... [any]\cr
#'   Further atomic values passed down as arguments to \code{sprintf}.
#' @return [\code{invisible(character(1))}] Silently returns the build path.
#' As a side effect the path is generated.
buildOutputPath = function(root, format.string, ...) {
  checkmate::assertDirectoryExists(root)
  checkmate::assertString(format.string)
  path = sprintf(format.string, ...)
  path = file.path(root, path)
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
    BBmisc::catf("[buildResultFilePath] Created output path '%s'.", path)
  }
  invisible(path)
}
