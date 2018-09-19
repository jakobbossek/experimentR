context("PARSE FORMAT")

test_that("parsing formats works well", {
  format.string = "results/a/b/cd/prob{c}/x{c}_y{l}_z{n}/repl{i}/ps.csv"
  format = parseFormat(format.string)
  expect_length(format, 3L)
  expect_true(all(format$param.names == c("prob", "x", "y", "z", "repl")))
  expect_true(all(format$param.types == c("c", "c", "l", "n", "i")))
  expect_true(all(format$param.positions == 5:9))

  format.string = "results/algo{c}/p1{l}/p2{c}/p3/p4{i}/repl{i}.csv"
  format = parseFormat(format.string)
  expect_length(format, 3L)
  expect_true(all(format$param.types == c("c", "l", "c", "i", "i")))
  expect_true(all(format$param.names == c("algo", "p1", "p2", "p4", "repl")))
  expect_true(all(format$param.positions == c(2, 3, 4, 6, 7)))
})
