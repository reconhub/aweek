context("conversion to rainboweek tests")


dats <- sprintf("%d-%02d-%02d",
                2001:2019,
                01,
                01)


dats    <- as.Date(dats)


test_that("January first dates can be properly converted", {

  datw    <- rw_date2week(dats, 1)
  datn    <- rw_date2week(dats, 1, numeric = TRUE)
  datback <- rw_week2date(datw, 1)
  weeknums <- c(1, 1, 1, 1, 53, 52, 1, 1, 1, 53, 52, 52, 1, 1, 1, 53, 52, 1, 1) 
  ew       <- c("2001-W01-1", "2002-W01-2", "2003-W01-3", "2004-W01-4",
                "2004-W53-6", "2005-W52-7", "2007-W01-1", "2008-W01-2",
                "2009-W01-4", "2009-W53-5", "2010-W52-6", "2011-W52-7",
                "2013-W01-2", "2014-W01-3", "2015-W01-4", "2015-W53-5",
                "2016-W52-7", "2018-W01-1", "2019-W01-2")

  # conversions are reversible
  expect_identical(as.character(dats), as.character(datback))

  # weeks print as expected
  expect_identical(datw, ew)

  # wee numbers display as expected
  expect_identical(datn, weeknums)

})

test_that("dates can be co back and forth no matter the start day", {


  for (i in 1:7) {
    datw    <- rw_date2week(dats, i)
    datback <- rw_week2date(datw, i)

    expect_identical(as.character(dats), as.character(datback), 
                     info = sprintf("day: %d", i))
  }

})
