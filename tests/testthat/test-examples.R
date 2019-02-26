context("real world example tests")

dats <-"date  week
2005-01-01 	2004-W53-6
2005-01-02 	2004-W53-7
2005-12-31 	2005-W52-6
2006-01-01 	2005-W52-7
2006-01-02 	2006-W01-1
2006-12-31 	2006-W52-7
2007-01-01 	2007-W01-1 
2007-12-30 	2007-W52-7
2007-12-31 	2008-W01-1
2008-01-01 	2008-W01-2
2008-12-28 	2008-W52-7
2008-12-29 	2009-W01-1
2008-12-30 	2009-W01-2
2008-12-31 	2009-W01-3
2009-01-01 	2009-W01-4
2009-12-31 	2009-W53-4
2010-01-01 	2009-W53-5
2010-01-02 	2009-W53-6
2010-01-03 	2009-W53-7
"
dats <- read.table(text = dats, stringsAsFactors = FALSE, header = TRUE)

test_that("Wikipedia ISO week definitions hold up", {

  w <- as.character(date2week(dats$date, week_start = 1))
  expect_identical(dats$week, w)

})
