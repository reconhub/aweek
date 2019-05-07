context("global week_start tests")


oa <- getOption("aweek.week_start", 1L)

test_that("global week_start variable can be set and reset", {

  expect_identical(oa, get_week_start())
  # converting to Sunday
  expect_identical(oa, set_week_start("Sunday"))
  expect_identical(7L, get_week_start())
  # Converting to Tuesday
  expect_identical(7L, set_week_start("Tuesday"))
  expect_identical(2L, get_week_start())
  # Converting back to Monday (or whatever day it was originally set to)
  expect_identical(2L, set_week_start(oa))
  expect_identical(oa, get_week_start())

})


test_that("get_week_start will return the attibute from an aweek object", {

  # Converting to Wednesday
  ws <- set_week_start("Wednesday")
  w  <- date2week(Sys.Date())
  # Resetting global to Monday
  we <- set_week_start(oa)
  # week_start for wednesday is retained in the object
  expect_identical(we, 3L)
  expect_identical(we, get_week_start(w))
  # global week start is different
  expect_identical(oa, get_week_start())

})


test_that("get_week_start will return an error if not null or aweek", {

  expect_error(get_week_start(Sys.Date()), "w must be an 'aweek' object or NULL")

})

test_that("set_week_start will throw an error for invalid weekdays", {

  msg <- "week_start must be a whole number from 1 to 7, representing the days of the week."
  expect_error(set_week_start(8),  msg)
  expect_error(set_week_start(pi), msg)
  expect_error(set_week_start(0),  msg)

})
