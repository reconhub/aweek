context("conversion tests")


dat  <- c(as.Date("2019-03-07"), NA)
names(dat) <- c("one", "two")
datw <- date2week(dat, 5)


test_that("aweek prints as expected", {

  expect_output(wtad <- print(datw), "aweek start: Friday")
  expect_output(print(date2week(dat, 5, factor = TRUE)), "Levels:")
  expect_identical(wtad, datw)

})


test_that("a character can be converted to a date", {

  w <- week2date("2018-W13", 1)
  expect_is(w, "Date")
  expect_identical(format(w, "%Y-%m-%d"), "2018-03-26")

})

test_that("character can be converted to aweek if in YYYYMMDD format", {

  expect_identical(date2week(c("2019/03/07", NA), 5), unname(datw))
  expect_identical(date2week(c("2019:03:07", NA), 5, format = "%Y:%m:%d"), unname(datw))
  expect_identical(date2week(c("3/7/2019", NA), 5, format = "%m/%d/%Y"), unname(datw))
  expect_identical(date2week(c("7/3/2019", NA), 5, format = "%d/%m/%Y"), unname(datw))
  expect_error(date2week(c("2019-07-03", "7/3/2019"), 5), "The first incorrect date is 7/3/2019")

})

test_that("aweek can be converted to character", {

  expect_failure(expect_output(print(as.character(datw)), "aweek start: Friday"))
  expect_is(as.character(datw), "character")
  expect_named(as.character(datw), names(datw))

})

test_that("aweek can be converted to POSIXlt", {

  p <- as.POSIXlt(datw, tz = "UTC")
  expect_identical(as.POSIXlt(dat, tz = "UTC"), p)

})


test_that("aweek can be converted to POSIXlt", {

  p <- as.POSIXlt(datw, tz = "UTC")
  expect_identical(as.POSIXlt(dat), p)

  p2 <- as.POSIXlt(datw, tz = "UTC", floor_day = TRUE)
  expect_failure(expect_identical(p, p2))

  expect_lt(p2[1], p[1])

})
