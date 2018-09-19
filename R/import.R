#' @title Import result file from EMOA experiments.
#'
#' @description When large-scale experiments are performed, e.g., in machine learning studies
#' or benchmarking of multi-objective optimization algorithms, usually the results of experimental
#' runs are somehow stored in files in the file system. These files are not stored arbitrarily, but
#' rather the way they are stored follows some folder structure. Imagine we run a stochastic algorithm
#' \dQuote{myalgo} in total for \eqn{10} replications on problem instances \dQuote{instance-1} and \dQuote{instance-2}.
#' The algorithm has parameters. Here, we assume the logical parameter \eqn{a} and the numeric parameter
#' \eqn{b} to be varied. Moreover, assume that the root folder of results files is \dQuote{/results/}.
#' Then, a possible folder structure below \dQuote{/results/} is
#' \dQuote{/results/instance-1/myalgo_TRUE_0.5/1/res.csv}. In order to evaluate the data one usually needs
#' to gather all or partial results in a single, e.g., \code{data.frame} and append the instance, algorithm
#' parameter and replication. The following \code{\link{import}} function does exactly this in a convenient
#' manner. Here, we pass a character vector of full files paths and an essential format string. The latter
#' is the very nice part of the function and lets the user specify the names and atomic data types of the
#' algorithm parameters with a nice notation. For the upper example we would set \code{param.format.string}
#' to \dQuote{/results/instance{c}/algorithm{c}_a{l}_b{n}/replication{i}/filename.csv}. All fragments in the
#' format string with an \dQuote{\{.\}} appended are interpreted as parameter which should be imported from
#' the file(s) paths. The values inside the curly braces specify the data type, e.g., \dQuote{i} for \dQuote{integer}.
#'
#' @param files [\code{character}]\cr
#'   List of full paths to results files obtained, e.g., via \code{\link[base]{list.files}}.
#' @param param.sep [\code{character(1)}]\cr
#'   Character used as \dQuote{split}-value to extract parameter settings from result paths.
#FIXME: param.format.string needs much more detailed docs.
#' @param param.format.string [\code{character(1)}]\cr
#'   Formal format specification for paths to result files. E.g.,
#'   \dQuote{prob{c}/x{i}_y{n}_z{l}/repl{i}/filename.csv}.
#' @param append.params [\code{logical(1)}]\cr
#'   Should parameter extracted from result paths be appended to results?
#'   Default is \code{TRUE}.
#' @param parser [\code{function(file, ...)}]\cr
#'   Function used to read the file.
#'   Default is \code{\link{parserDf}}, which is basically \code{\link[utils]{read.table}},
#'   with some adapted parameters.
#' @param combiner [\code{function}]\cr
#'   Function used to combine imported results from multiple results files.
#'   Default is \code{\link[base]{rbind}}, since the default parser returns data frames.
#' @param ... [any]\cr
#'   Further optional arguments passed down to \code{parser}.
#' @return \code{any} Reduced results (\code{data.frame} by default).
#' @export
import = function(files, param.sep, param.format.string, append.params = TRUE, parser = parserDf, combiner = rbind, ...) {
  #checkmate::assertFileExists(file, access = "r")

  checkmate::assertString(param.sep, null.ok = FALSE)
  checkmate::assertString(param.format.string, null.ok = FALSE)
  checkmate::assertFlag(append.params)
  checkmate::assertFunction(parser)

  #FIXME: make parameter out of it
  file.ext = ".csv"

  n.files = length(files)
  BBmisc::catf("Processing %i file(s) ...", n.files)

  format = parseFormat(param.format.string, file.ext = file.ext)

  imported = lapply(files, function(current.file) {
    data = parser(current.file, ...)

    if (!append.params) {
      return(data)
    }
    meta = parseFilePath(current.file, format = format, file.ext = file.ext)
    #FIXME: this will fail miserably, if data is no data frame!
    data = cbind(data, as.data.frame(meta, stringsAsFactors = FALSE))
    return(data)

  })
  return(do.call(combiner, imported))
}