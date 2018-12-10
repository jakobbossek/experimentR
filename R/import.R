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
#' @param continue.on.error [\logical(1)]\cr
#'   Should the import process be continued if an error occurs due to failed file or file name parsing?
#'   Default is \code{TRUE}. In this case errors are logged and a log-file is written to the current
#'   working directory.
#' @param ... [any]\cr
#'   Further optional arguments passed down to \code{parser}.
#' @return \code{any} Reduced results (\code{data.frame} by default).
#' @export
import = function(files, param.sep = NULL, param.format.string, append.params = TRUE, parser = parserDf, combiner = rbind, continue.on.error = TRUE, ...) {
  #checkmate::assertFileExists(file, access = "r")

  checkmate::assertString(param.sep, null.ok = TRUE)
  checkmate::assertString(param.format.string, null.ok = FALSE)
  checkmate::assertFlag(append.params)
  checkmate::assertFunction(parser)
  checkmate::assertFunction(combiner)
  checkmate::assertFlag(continue.on.error)

  #FIXME: make parameter out of it or better just automatically identify
  file.ext = ".csv"

  n.files = length(files)
  "!DEBUG [import] Processing `n.files` files."

  format = parseFormat(param.format.string, param.sep = param.sep, file.ext = file.ext)
  #print(format)

  pbar = progress::progress_bar$new(
    format = "Processing [:bar] :percent eta: :eta",
    total = n.files,
    width = 60
  )

  issues = data.frame()

  imported = lapply(files, function(current.file) {
    data = try({parser(current.file, ...)}, silent = TRUE)
    # log if failed
    if (inherits(data, "try-error")) {
      issues = rbind(issues, data.frame(file = current.file, error = data[1L], type = "data"))
      if (!continue.on.error)
        BBmisc::stopf("[import] Error in parsing result file '%s'. Aborting import!", current.file)
      return(NULL)
    }
    pbar$tick()

    if (!append.params)
      return(data)
    meta = try({parseFilePath(current.file, format = format, param.sep = param.sep, file.ext = file.ext)}, silent = TRUE)
#    print(meta)
    # log if failed
    if (inherits(meta, "try-error")) {
      issues = rbind(issues, data.frame(file = current.file, error = meta[1L], type = "meta"))
      if (!continue.on.error)
        BBmisc::stopf("[import] Error in parsing file path '%s'. Aborting import!", current.file)
      return(NULL)
    }

    #FIXME: this will fail miserably, if data is no data frame!
    "!DEBUG [import] Appending meta data."
    data = cbind(data, as.data.frame(meta, stringsAsFactors = FALSE))
    #print(data)
    #Sys.sleep(0.1)
    return(data)
  })

  if (nrow(issues) > 0L) {
    log.file = sprintf("import-%s.log", format(Sys.time(), "%d%m%Y_%H%M"))
    write.table(issues, file = log.file, row.names = FALSE, quote = FALSE, col.names = TRUE)
    BBmisc::messagef("[import] In total %i result files caused an data import or meta import error.
      See log file '%s' in your working directory for details.", nrow(issues), log.file)
  }

  imported = imported[!sapply(imported, is.null)]

  #print(imported)

  "!DEBUG [import] Combining result files"
  return(do.call(combiner, imported))
}
