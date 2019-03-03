context("weekday conversion tests")

test_that("English weekdays can be matched", {
            
  expect_identical(date2week(Sys.Date(), week_start = 1.0),
                   date2week(Sys.Date(), week_start = "Monday"))

})

test_that("Nonsense days will fail", {

  expect_error(date2week(Sys.Date(), week_start = "Zhian"), "Zhian")
  expect_error(date2week(Sys.Date(), week_start = "Zhian"), Sys.getlocale("LC_TIME"))

})

lct <- Sys.getlocale("LC_TIME")
suppressWarnings({
  res <- Sys.setlocale("LC_TIME", "de_DE.utf8")
})

test_that("Different locales works", {

  skip_if_not(res == "de_DE.utf8")

  expect_identical(date2week(Sys.Date(), week_start = 7),
                   date2week(Sys.Date(), week_start = "Sonntag"))
  expect_identical(date2week(Sys.Date(), week_start = 7),
                   date2week(Sys.Date(), week_start = "Sunday"))
})

Sys.setlocale("LC_TIME", lct)
