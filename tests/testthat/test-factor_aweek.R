context("factorisation tests")

test_that("factor_aweek will reject non-aweek objects", {

  expect_error(factor_aweek("2018-W10-1"), "x must be an 'aweek' object")

})

test_that("factor_aweek accounts for edge weeks", {

  w1 <- get_aweek(c(8, 11), year = 2019, day = c(7, 1))
  w2 <- get_aweek(c(8, 11), year = 2019, day = c(1, 7))

  f1 <- factor_aweek(w1)
  f2 <- factor_aweek(w2)
  expect_identical(levels(f1), c("2019-W08", "2019-W09", "2019-W10", "2019-W11"))
  expect_identical(levels(f2), c("2019-W08", "2019-W09", "2019-W10", "2019-W11"))

})

test_that("factor_aweek accounts for edge days across years", {

  w3 <- get_aweek(c(53, 02), year = 2015:2016, day = c(7, 1))
  w4 <- get_aweek(c(53, 02), year = 2015:2016, day = c(1, 7))
  
  f3 <- factor_aweek(w3)
  f4 <- factor_aweek(w4)
  expect_identical(levels(f3), c("2015-W53", "2016-W01", "2016-W02"))
  expect_identical(levels(f4), c("2015-W53", "2016-W01", "2016-W02"))

})
