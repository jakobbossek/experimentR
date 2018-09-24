library(methods)
library(devtools)
library(testthat)
library(ggplot2)
library(tidyverse)
library(viridis)

load_all(".")

for (i in c("alpha", "beta")) {
    for (j in c(TRUE, FALSE)) {
      for (k in c(0.1, 0.25)) {
        for (repl in 1:2) {
          setup = sprintf("%s_%s_%s", i, j, k)
          dir = file.path("inst/testdata/prob1/", setup, repl)
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


# import single file
format.sting = "inst/testdata/prob{c}/letter{c}_bool{l}_double{n}/repl{i}/filename.csv"
imported = import(file = "inst/testdata/prob1/alpha_FALSE_0.1/1/ps.csv", param.sep = "_", param.format.string = format.sting)
print(imported)

files = list.files("inst/testdata/prob1", recursive = TRUE, pattern = "ps.csv$", full.names = TRUE)

imported = import(
  files = files,
  param.sep = "_",
  param.format.string = format.sting,
  parser = parserDf,
  combiner = rbind
)

print(imported)

library(ggplot2)

pl = ggplot(imported, aes(x = f1, y = f2))
pl = pl + geom_point(aes(colour = letter, shape = as.factor(double)))
pl = pl + facet_grid(prob ~ letter)
print(pl)
