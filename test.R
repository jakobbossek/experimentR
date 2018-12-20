library(methods)
library(devtools)
library(testthat)
library(ggplot2)
library(tidyverse)
library(viridis)

load_all(".")

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

format.string = "inst/testdata/prob{c}/char{c}_i{l}_num{n}/repl{i}/ps.csv"
files = list.files("inst/testdata/", pattern = ".csv$", full.names = TRUE, recursive = TRUE)

imported = import(files, param.sep = "_", param.format.string = format.string)
print(imported)

stop("YAAY")


library(ggplot2)

pl = ggplot(imported, aes(x = f1, y = f2))
pl = pl + geom_point(aes(colour = letter, shape = as.factor(double)))
pl = pl + facet_grid(prob ~ letter)
print(pl)
