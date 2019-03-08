context("subsetting tests")

d <- as.Date("2018-12-31") + 0:14
x <- date2week(d, week_start = "Monday")
y <- date2week(d, week_start = "Saturday")
dd <- date2week(c(d, as.Date("2019-01-15")), week_start = "Monday")


test_that("subsetting returns an aweek object", {

  expect_identical(x[], x)
  expect_is(x[1], "aweek")
  expect_is(y[1], "aweek")
  expect_identical(as.Date(x[1]), d[1])
  expect_identical(as.Date(y[1]), d[1])

})


test_that("concatenation returns aweek object with the correct week_start attribute", {

  xy <- c(x, y)
  yx <- c(y, x)
  
  expect_identical(attr(xy, "week_start"), 1L)
  expect_identical(attr(yx, "week_start"), 6L)

})

test_that("characters can be added", {

  xw <- c(x, "2019-W03-2")
  xd <- c(x, "2019-01-15")

  expect_identical(xw, xd)
  expect_identical(xw, dd)

})


test_that("dates can be added", {

  xd <- c(x, as.Date("2019-01-15"))
  expect_identical(xd, dd)

})

test_that("POSIXt objects can be added", {


  xp <- c(x, as.POSIXlt("2019-01-15", tz = "UTC"))
  xc <- c(x, as.POSIXct("2019-01-15", tz = "UTC"))
  expect_identical(xp, xc)
  expect_identical(xp, dd)

})


test_that("all objects can be added", {


  xx <- c(x[1:5],
          y[6:10], 
          "2019-01-10", 
          as.Date(c("2019-01-11", "2019-01-12")),
          as.POSIXlt("2019-01-13"),
          date2week("2019-01-14", week_start = "Tuesday"),
          "2019-W03-2")

  expect_identical(xx, dd)

  yy <- c(y[1:5],
          x[6:10], 
          "2019-01-10", 
          as.Date(c("2019-01-11", "2019-01-12")),
          as.POSIXlt("2019-01-13"),
          date2week("2019-01-14", week_start = "Tuesday"),
          "2019-W03-4")

  expect_identical(yy, date2week(dd, week_start = "Saturday"))

})
