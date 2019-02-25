context("conversion tests")


dat <- Sys.Date()
datw <- rw_date2week(dat, 5)


test_that("rainboweek prints as expected", {

  expect_output(wtad <- print(datw), "rainboweek start: 5")
  expect_identical(wtad, datw)

})


test_that("rainboweek can be converted to character", {

  expect_failure(expect_output(print(as.character(datw)), "rainboweek start: 5"))

})

test_that("rainboweek can be converted to POSIXlt", {

  p <- as.POSIXlt(datw)
  expect_identical(as.POSIXlt(dat), p)

})


test_that("rainboweek can be converted to POSIXlt", {

  p <- as.POSIXlt(datw)
  expect_identical(as.POSIXlt(dat), p)

  p2 <- as.POSIXlt(datw, floor_day = TRUE)
  expect_failure(expect_identical(p, p2))

  expect_true(p2 <= p)
  expect_false(p2 > p)

})
