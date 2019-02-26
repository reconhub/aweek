context("conversion to aweek tests")


dats <- sprintf("%d-%02d-%02d",
                2001:2019,
                01,
                01)


dats <- as.Date(dats)

test_that("an error is thrown if something can't be converted to a date", {
                
  expect_error(date2week(iris), "iris could not be converted to a date")                
                
})

test_that("January first dates can be properly converted", {

  # ISO week
  datw    <- date2week(dats, 1)
  # Epi week
  datew   <- date2week(dats, 7, numeric = TRUE)
  datf    <- date2week(dats, 1, floor_day = TRUE)
  datn    <- date2week(dats, 1, numeric = TRUE)
  datback <- as.Date(datw)
  # isoweeks
  weeknums <- c(1, 1, 1, 1, 53, 52, 1, 1, 1, 53, 52, 52, 1, 1, 1, 53, 52, 1, 1) 
  # epiweeks
  epiweeks <- c(1, 1, 1, 53, 52, 1, 1, 1, 53, 52, 52, 1, 1, 1, 53, 52, 1, 1, 1) 
  iw       <- c("2001-W01-1", "2002-W01-2", "2003-W01-3", "2004-W01-4",
                "2004-W53-6", "2005-W52-7", "2007-W01-1", "2008-W01-2",
                "2009-W01-4", "2009-W53-5", "2010-W52-6", "2011-W52-7",
                "2013-W01-2", "2014-W01-3", "2015-W01-4", "2015-W53-5",
                "2016-W52-7", "2018-W01-1", "2019-W01-2")
  class(iw) <- "aweek"
  attr(iw, "week_start") <- 1L
  floored <-gsub("-\\d$", "-1", iw)

  # conversions are reversible
  expect_identical(as.character(dats), as.character(datback))

  # weeks print as expected
  expect_identical(datw, iw)

  # wee numbers display as expected
  expect_identical(datn, weeknums)

  expect_identical(datew, epiweeks)

  # floored weeks are handled as expected
  expect_identical(datf, floored)

})

test_that("dates can be co back and forth no matter the start day", {


  for (i in 1:7) {
    datw    <- date2week(dats, i)
    datback <- week2date(datw)

    expect_identical(as.character(dats), as.character(datback), 
                     info = sprintf("day: %d", i))
  }

})
