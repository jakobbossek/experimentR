#' Build up my project folder structure.
#'
#' @param dir [\code{character(1)}]\cr
#'   Root directory of the project.
#' @return Nothing
initProject = function(dir) {
  message.done = function(dir) {
    cat("Creating " %+% crayon::bold(dir) %+% " " %+% emo::ji("white_check_mark") %+% "\n")
  }

  dir.create2 = function(dir, ask = FALSE) {
    decision = 1L
    if (ask && !dir.exists(dir)) {
      decision = utils::menu(c("Yes", "No"), title = sprintf("Really create directory '%s'?", dir))
    }
    if (decision == 1) {
      dir.create(dir)
      message.done(dir)
    } else {
      BBmisc::stopf("You canceled project folder generation.")
    }
  }

  message("Creating project directory ...", domain = NA)
  dir.create2(dir, ask = TRUE)

  message("\nCreating sub-directories ...", domain = NA)
  dir.create2(file.path(dir, "experiments"))
  dir.create2(file.path(dir, "experiments", "src"))
  dir.create2(file.path(dir, "experiments", "results"))
  dir.create2(file.path(dir, "experiments", "images"))

  message("\nCreating files ...", domain = NA)
  defs.file = file.path(dir, "experiments/src", "defs.R")
  defs.file2 = file(defs.file, "wt")
  cat("# SETUP\n# ====\n", file = defs.file2, sep = "")
  close(defs.file2)
  message.done(defs.file)

  utils.file = file.path(dir, "experiments/src", "utils.R")
  utils.file2 = file(utils.file, "wt")
  close(utils.file2)
  message.done(utils.file)

  BBmisc::messagef("Project folder ready! " %+% emo::ji("rocket") %+% "\n")
}
