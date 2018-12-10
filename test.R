library(methods)
library(devtools)
library(testthat)
library(ggplot2)
library(tidyverse)
library(viridis)

load_all(".")

  format.string = "tests/testthat/results/prob{c}/char{c}_bool{l}_num{n}/repl{i}/ps.csv"
  files = list.files("tests/testthat/results/", pattern = ".csv$", full.names = TRUE, recursive = TRUE)

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

# for (i in c("alpha", "beta")) {
#     for (j in c(TRUE, FALSE)) {
#       for (k in c(0.1, 0.25)) {
#         for (repl in 1:2) {
#           setup = sprintf("%s_%s_%s", i, j, k)
#           dir = file.path("inst/testdata/prob1", setup, repl)
#           dir.create(dir, recursive = TRUE, showWarnings = FALSE)
#           file = file.path(dir, "ps.csv")
#           data = matrix(runif(20), ncol = 2L)
#           data = as.data.frame(data)
#           colnames(data) = c("f1", "f2")
#           # if (i == "alpha" & j == FALSE & repl == 2) {
#           #   cat("fail984721494", file = file)
#           # } else {
#             write.table(data, file = file, row.names = FALSE, quote = FALSE)
#           #}
#         }
#       }
#     }
#   }


# import single file
format.sting = "inst/testdata/TSPhybrid/prob{c}/algo{c}/repl{i}/result.csv"
# imported = import(file = "inst/testdata/prob1/alpha_FALSE_0.1/1/ps.csv", param.sep = "_", param.format.string = format.sting)
# print(imported)


files = list.files("inst/testdata/TSPhybrid", recursive = TRUE, pattern = "result.csv$", full.names = TRUE)

imported = import(
  files = files,
  #param.sep = "_",
  param.format.string = format.sting,
  parser = parserDf,
  combiner = rbind
)

print(imported)

stop("YAAY")


library(ggplot2)

pl = ggplot(imported, aes(x = f1, y = f2))
pl = pl + geom_point(aes(colour = letter, shape = as.factor(double)))
pl = pl + facet_grid(prob ~ letter)
print(pl)
