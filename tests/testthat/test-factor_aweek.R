context("factorisation tests")

test_that("factor_aweek will reject non-aweek objects", {

  expect_error(factor_aweek("2018-W10-1"), "x must be an 'aweek' object")

})
