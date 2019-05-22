context("subsetting tests")

d <- as.Date("2018-12-31") + 0:14
x <- date2week(d, week_start = "Monday")
f <- date2week(d, week_start = "Monday", factor = TRUE, floor_day = TRUE)
y <- date2week(d, week_start = "Saturday")
dd <- date2week(c(d, as.Date("2019-01-15")), week_start = "Monday")


test_that("subsetting returns an aweek object", {

  expect_identical(x[], x)
  expect_is(x[1], "aweek")
  expect_is(y[1], "aweek")
  expect_is(f[1], "aweek")
  expect_identical(as.Date(x[1]), d[1])
  expect_identical(as.Date(y[1]), d[1])
  expect_identical(as.Date(f[1]), d[1])

  expect_is(as.list(x)[[1]], "aweek")
  expect_is(as.list(y)[[1]], "aweek")
  expect_is(as.list(f)[[1]], "aweek")
  expect_is(as.list(f)[[1]], "factor")
  expect_identical(as.Date(as.list(x)[[1]]), d[1])
  expect_identical(as.Date(as.list(y)[[1]]), d[1])
  expect_identical(as.Date(as.list(f)[[1]]), d[1])

  expect_is(x[[1]], "aweek")
  expect_is(y[[1]], "aweek")
  expect_is(f[[1]], "aweek")
  expect_identical(as.Date(x[[1]]), d[1])
  expect_identical(as.Date(y[[1]]), d[1])
  expect_identical(as.Date(f[[1]]), d[1])

})

test_that("aweek objects can be ammended", {

  xx <- rev(x)
  xx[1] <- NA
  expect_identical(xx[1], as.aweek(NA_character_, week_start = get_week_start(xx)))
  xx[1] <- x[1]
  expect_identical(xx[1], x[1])
  xx[2] <- as.Date(x[2])
  expect_identical(xx[2], x[2])
  xx[3] <- as.character(x[3])
  expect_identical(xx[3], x[3])

  expect_error(y[1] <- x[1], "aweek objects must have the same week_start attribute")

})

test_that("change_week_start() only works on aweek objects", {

  expect_error(change_week_start("2018-W01-1"), "x must be an aweek object")
  expect_identical(change_week_start(x, get_week_start(x)), x)
  expect_identical(change_week_start(x, "Saturday"), y)

})


test_that("concatenation returns aweek object with the correct week_start attribute", {

  expect_error(xy <- c(x, y), "All aweek objects must have the same week_start attribute.")
  expect_error(yx <- c(y, x), "All aweek objects must have the same week_start attribute.")
  xy <- c(x, change_week_start(y, get_week_start(x)))
  yx <- c(y, change_week_start(x, get_week_start(y)))

  
  expect_identical(attr(xy, "week_start"), 1L)
  expect_identical(attr(yx, "week_start"), 6L)

})

test_that("truncation works", {

  expect_identical(trunc(x), date2week(d, week_start = 1, floor_day = TRUE))
  expect_identical(trunc(y), date2week(d, week_start = 6, floor_day = TRUE))
  expect_identical(trunc(f), date2week(d, week_start = 1, floor_day = TRUE, factor = TRUE))

})

test_that("rep works", {

  expect_identical(as.Date(rep(y, each = 2)), rep(d, each = 2))
  expect_identical(as.Date(rep(x, each = 2)), rep(d, each = 2))
  expect_true(all(as.Date(rep(f, each = 2)) <= rep(d, each = 2)))

})

test_that("characters can be added", {

  xw <- c(x, "2019-W03-2")
  xd <- c(x, "2019-01-15")

  expect_identical(xw, dd)
  expect_identical(xw, xd)

})


test_that("factors don't force factors", {

  xf <- c(date2week(d[1], week_start = "Monday", factor = TRUE), x[-1])
  expect_is(xf, "aweek")
  expect_failure(expect_is(xf, "factor"))
  expect_true(all(as.Date(xf) <= as.Date(x)))

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

