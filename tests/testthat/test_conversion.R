context("conversion tests")


dat <- Sys.Date()
datw <- date2week(dat, 5)


test_that("aweek prints as expected", {

  expect_output(wtad <- print(datw), "aweek start: 5")
  expect_identical(wtad, datw)

})


test_that("a character can be converted to a date", {

  w <- week2date("2018-W13", 1)
  expect_is(w, "Date")
  expect_identical(format(w, "%Y-%m-%d"), "2018-03-26")

})

test_that("aweek can be converted to character", {

  expect_failure(expect_output(print(as.character(datw)), "aweek start: 5"))

})

test_that("aweek can be converted to POSIXlt", {

  p <- as.POSIXlt(datw)
  expect_identical(as.POSIXlt(dat), p)

})


test_that("aweek can be converted to POSIXlt", {

  p <- as.POSIXlt(datw)
  expect_identical(as.POSIXlt(dat), p)

  p2 <- as.POSIXlt(datw, floor_day = TRUE)
  expect_failure(expect_identical(p, p2))

  expect_true(p2 <= p)
  expect_false(p2 > p)

})
