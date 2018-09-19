library(methods)
library(devtools)
library(testthat)

if (interactive()) {
  load_all(".")
} else {
  library(experimentR)
}

test_dir("tests/testthat")
