context("as.aweek tests")


test_that("as.aweek rejects invalid weeks", {

  expect_error(as.aweek("2018-01-01"), 
               "aweek strings must match the pattern 'YYYY-Www-d'. The first incorrect string was: '2018-01-01'")

  expect_error(as.aweek("2018-W61-1"), 
               "aweek strings must match the pattern 'YYYY-Www-d'. The first incorrect string was: '2018-W61-1'")


})

test_that("as.aweek takes into account the length of week_start", {

  x <- as.aweek("2018-W10-1", week_start = 1:2)
  y <- as.aweek("2018-W10-1", week_start = c("Mon", "Tue"))

  expect_identical(x, y)
  expect_identical(as.character(x), c("2018-W10-1", "2018-W10-2"))


})


test_that("as.aweek correctly converts characters", {

  expect_is(as.aweek(c(NA, "2018-W10-1")), "aweek")
  expect_identical(as.aweek(c(NA, "2018-W10-1")), as.aweek(c(NA, "2018-W10-1"), week_start = "Monday"))
  expect_is(as.aweek(c(NA, "2018-W10-1"), factor = TRUE, floor_day = TRUE), "aweek")
  expect_is(as.aweek(c(NA, "2018-W10-1"), factor = TRUE, floor_day = TRUE), "factor")

})


test_that("as.aweek correctly converts dates", {

  expect_identical(as.aweek(Sys.Date()), date2week(Sys.Date()))
  expect_is(as.aweek(Sys.Date()), "aweek")

})
