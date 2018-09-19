context("PARSE FILE PATH")

test_that("parsing file path works", {
  #FIXME: this needs to be stored in helper function
  #FIXME: find out where I can write data
  for (i in c("alpha", "beta")) {
    for (j in c(TRUE, FALSE)) {
      for (k in c(0.1, 0.25)) {
        for (repl in 1:2) {
          setup = sprintf("%s_%s_%s", i, j, k)
          dir = file.path("results/prob1", setup, repl)
          dir.create(dir, recursive = TRUE, showWarnings = FALSE)
          file = file.path(dir, "ps.csv")
          data = matrix(runif(20), ncol = 2L)
          data = as.data.frame(data)
          colnames(data) = c("f1", "f2")
          write.table(data, file = file, row.names = FALSE, quote = FALSE)
        }
      }
    }
  }

  format.string = "results/prob{c}/char{c}_bool{l}_num{n}/repl{i}/ps.csv"
  files = list.files("results/", pattern = ".csv$", full.names = TRUE, recursive = TRUE)

  imported = import(files, param.sep = "_", param.format.string = format.string)
  print(imported)
  print(sapply(imported, typeof))
  exp.types = c(
    "numeric", "numeric", # f1 and f2
    "character", # prob
    "character", # char
    "logical", # bool
    "numeric", # num
    "integer" # repl
  )
  expect_data_frame(imported, types = exp.types)
  expect_true(all(imported$prob == "prob1"))
  expect_true(all(imported$char %in% c("alpha", "beta")))
  expect_true(all(imported$bool %in% c(TRUE, FALSE)))
  expect_true(all(imported$repl %in% 1:2))

  unlink("results/", recursive = TRUE)
})

