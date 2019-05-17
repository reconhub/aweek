context("make_aweek")

mat <- matrix(c(
  2019, 11, 1, 7, # 2019-03-10
  2019, 11, 2, 7,
  2019, 11, 3, 7,
  2019, 11, 4, 7,
  2019, 11, 5, 7,
  2019, 11, 6, 7,
  2019, 11, 7, 7
), ncol = 4, byrow = TRUE)
colnames(mat) <- c("year", "week", "day", "week_start")

m <- as.data.frame(mat)
ex_dat <- as.Date("2019-03-10") + 0:6


test_that("make_aweek() will always default to the first weekday of the year", {

  d1 <- as.Date(make_aweek())
  d2 <- as.Date(date2week(sprintf("%s-01-01", format(Sys.Date(), "%Y")), floor_day = TRUE))
  expect_identical(d1, d2)

})


test_that("make_aweek() can use vectors", {

  w <- make_aweek(week = m$week, year = m$year, day = m$day, week_start = m$week_start)
  expect_is(w, "aweek")
  expect_equal(get_week_start(w), 7L)
  expect_identical(sprintf("%04d-W%02d-%d", m$year, m$week, m$day), as.character(w))
  expect_identical(w, make_aweek(week = m$week, year = m$year, day = m$day, week_start = "Sunday"))
  expect_identical(w, make_aweek(week = m$week, year = m$year, day = m$day, week_start = rep("Sunday", 7)))
  expect_identical(as.Date(w), ex_dat)

})


test_that("make_aweek() can handle missing data", {
 
  for (i in c("year", "week", "week_start")) {
    mm <- m
    mm[1, i] <- NA
    lab <- sprintf("make_aweek() couldn't handle missing [%s].", i)
    expect_is({
      w <- try(with(mm, make_aweek(week = week, year = year, day = day, week_start = week_start)))
    }, "aweek", label = paste("(gen)", lab))
    expect_identical(as.Date(w), c(as.Date(NA_character_), ex_dat[-1]),
                     label = paste("(acc)", lab))
  }
  
})

test_that("make_aweek() can handle several missing random data", {

  skip_if_not_installed("stats")
  mm <- mat
  mm[sample.int(7, 1), "year"] <- NA
  mm[sample.int(7, 1), "week"] <- NA
  mm[sample.int(7, 1), "week_start"] <- NA
  mm <- as.data.frame(mm)
  cc <- stats::complete.cases(mm)

  expect_is({
    w <- try(with(mm, make_aweek(week = week, year = year, day = day, week_start = week_start)))
  }, "aweek")

  expect_identical(!cc, is.na(w))
  expect_identical(as.Date(w[cc]), ex_dat[cc])


})

test_that("missing days revert to day 1", {

  mm <- m
  mm[1, "day"] <- NA
  w <- try(with(mm, make_aweek(week = week, year = year, day = day, week_start = week_start)))
  expect_identical(as.Date(w), ex_dat)

  mm[, "day"] <- NA
  w <- try(with(mm, make_aweek(week = week, year = year, day = day, week_start = week_start)))
  expect_identical(as.Date(w), rep(ex_dat[1], 7))

})

test_that("invalid weeks will throw an error", {

  expect_error(make_aweek(week = 69), "Weeks must be between 1 and 53")
  expect_error(make_aweek(week = 0),  "Weeks must be between 1 and 53")
  expect_error(make_aweek(week = -9), "Weeks must be between 1 and 53")

})

test_that("invalid week_starts will throw an error", {

  expect_error(make_aweek(week_start = 69), "Weekdays must be between 1 and 7")
  expect_error(make_aweek(week_start = 0),  "Weekdays must be between 1 and 7")
  expect_error(make_aweek(week_start = -9), "Weekdays must be between 1 and 7")

})

test_that("invalid days will throw an error", {

  expect_error(make_aweek(day = 69), "Weekdays must be between 1 and 7")
  expect_error(make_aweek(day = 0),  "Weekdays must be between 1 and 7")
  expect_error(make_aweek(day = -9), "Weekdays must be between 1 and 7")

})

test_that("null arguments throw an error", {

  expect_error(make_aweek(week = NULL), "all arguments must not be NULL")
  expect_error(make_aweek(year = NULL), "all arguments must not be NULL")
  expect_error(make_aweek(day = NULL), "all arguments must not be NULL")
  expect_error(make_aweek(week_start = NULL), "all arguments must not be NULL")

})

