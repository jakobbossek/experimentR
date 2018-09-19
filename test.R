library(methods)
library(devtools)
library(testthat)
library(ggplot2)
library(tidyverse)
library(viridis)

load_all(".")

stop("paretFormat")

# import single file
format.sting = "results/prob{c}/letter{c}_bool{l}_double{n}/repl{i}/filename.csv"
imported = import(file = "results/prob1/alpha_FALSE_0.1/1/ps.csv", param.format.string = format.sting)
print(imported)

files = list.files("results/prob1", recursive = TRUE, pattern = "ps.csv$", full.names = TRUE)

imported = import(
  files = files,
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
