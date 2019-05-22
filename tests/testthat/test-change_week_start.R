context("week_start changing")

x <- get_aweek(week = 10, year = 2019, day = 1, week_start = get_week_start())

test_that("change_week_start changes to the default week_start variable", {

  expect_identical(x, change_week_start(x))

})

test_that("change_week_start will de-factorize", {

  xf <- change_week_start(factor_aweek(x))
  expect_is(xf, "aweek")
  expect_identical(xf, x)

})

test_that("change_week_start will change the week_start at will", {

  w <- change_week_start(x, "Wednesday")
  expect_identical(get_week_start(w), 3L)

})



