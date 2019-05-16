context("Data frame conversion tests")

d <- as.Date("2019-05-15") + (-5:5)
w <- date2week(d, week_start = "Sunday")
f <- date2week(d, week_start = "Sunday", factor = TRUE, floor_day = TRUE)
names(f) <- as.character(d)

wd <- data.frame(w, d)
fd <- data.frame(f, d)

test_that("the resulting data frame contain the right classes", {

  expect_is(wd, "data.frame")
  expect_identical(wd$w, w)
  expect_identical(wd$d, d)
  expect_identical(as.Date(wd$w), wd$d)

  expect_is(fd, "data.frame")
  expect_identical(fd$f, unname(f))
  expect_identical(fd$d, d)
  expect_identical(as.Date(fd$f), as.Date(wd$w, floor_day = TRUE))

})

test_that("the data can be merged", {

  fwd <- merge(wd, fd)
  
  expect_is(fwd, "data.frame")
  expect_identical(fwd$d, d)
  expect_identical(fwd$f, unname(f))
  expect_identical(fwd$w, w)

})

test_that("data frames can be combined", {

  # straightforward appending
  wdwd <- rbind(wd, wd)

  # appending week on top of date and vice-versa
  wddw <- rbind(wd, setNames(rev(wd), names(wd)))
  
  # appending aweek on date objects. 
  ddwd <- rbind(setNames(wd[c(2, 2)],names(wd)), wd)

  # appending aweek object on characters
  cd   <- wd
  cd$w <- as.character(cd$w)
  cdwd <- rbind(cd, wd)
  # wdcd <- rbind(wd, cd)

  expect_identical(wdwd, wddw)
  expect_identical(dwwd$d, c(d, d))
  expect_identical(dwwd$w, c(d, d))
  expect_is(wdwd$w, "aweek")
  expect_identical(wdwd$w, c(w, w))
  expect_identical(wdwd$d, c(d, d))

  # wdfd <- rbind(wd, setNames(fd, names(wd)))

})

