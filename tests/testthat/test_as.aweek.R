context("as.aweek tests")


# Setup for a default
d <- strptime("2019-05-23 03:11", format = "%Y-%m-%d %H:%M", tz = "UTC")
e <- "2019-W21-4"
attr(e, "week_start") <- get_week_start()
class(e) <- "aweek"

test_that("aweek rejects invalid classes", {

  expect_error(as.aweek(iris), "There is no method to convert an object of class 'data.frame' to an aweek object")

})

test_that("aweek rejects NULL", {

  expect_error(as.aweek(NULL), "aweek objects can not be NULL")

})

test_that("as.aweek rejects invalid weeks", {

  base <- "aweek strings must match the pattern 'YYYY-Www-d'. The first incorrect string was: '%s'"

  expect_error(as.aweek("2018-01-01"), sprintf(base, "2018-01-01"))
  expect_error(as.aweek("2018-W61-1"), sprintf(base, "2018-W61-1"))


})

test_that("as.aweek takes into account the length of week_start", {

  x <- as.aweek("2018-W10-1", start = 1:2)
  y <- as.aweek("2018-W10-1", start = c("Mon", "Tue"))
  z <- as.aweek(c("2018-W09-7", "2018-W10-1"), week_start = get_week_start() + runif(1), start = "Tuesday")

  expect_identical(x, y)
  expect_identical(y, z)


})


test_that("as.aweek correctly converts characters", {

  expect_is(as.aweek(c(NA, "2018-W10-1")), "aweek")
  expect_identical(as.aweek(c(NA, "2018-W10-1")), as.aweek(c(NA, "2018-W10-1"), start = "Monday"))
  expect_is(as.aweek(c(NA, "2018-W10-1"), factor = TRUE, floor_day = TRUE), "aweek")
  expect_is(as.aweek(c(NA, "2018-W10-1"), factor = TRUE, floor_day = TRUE), "factor")

})


test_that("as.aweek correctly converts dates", {

  expect_is(as.Date(d), "Date")
  expect_is(as.aweek(as.Date(d)), "aweek")
  expect_identical(as.aweek(as.Date(d)), e)

})

test_that("as.aweek correctly converts POSIXt", {

  expect_is(d, "POSIXt")
  expect_is(as.aweek(d), "aweek")
  expect_identical(as.aweek(d), e)

})

test_that("as.aweek will act like change_week_start", {

  x <- as.aweek("2019-W10-1", week_start = 5)
  y <- as.aweek(as.Date(x), week_Start = 1)

  expect_is(x, "aweek")
  expect_is(y, "aweek")

  expect_identical(x, as.aweek(x))
  expect_identical(x, as.aweek(y, 5L))

})
