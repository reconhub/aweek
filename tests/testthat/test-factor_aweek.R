context("factorisation tests")
dat <- structure(c(17965, 17960, 17954, 17956, 17955, 17952, 17958, 
                   17952, 17958, 17957), class = "Date")

test_that("factor_aweek will reject non-aweek objects", {

  expect_error(factor_aweek("2018-W10-1"), "x must be an 'aweek' object")

})

test_that("factor_aweek accounts for edge weeks", {

  expect_identical(levels(factor_aweek(as.aweek(dat))), c("2019-W09", "2019-W10", "2019-W11"))

})
