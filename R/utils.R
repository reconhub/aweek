#' Get the weekday given an integer/date and a start date
#'
#' @param x an integer day or a Date where 1 represents Monday
#' 
#' @param s an integer representing the day to start the week
#'
#' @return the day of the week for x relative to s
#'
#' @noRd
#'
#' @examples
#'
#' get_wday(1, 5) # Monday is the third day in a Friday - Saturday week
get_wday <- function(x, s) { 
  if (inherits(x, c("Date", "POSIXt"))) {
    x <- as.integer(as.POSIXlt(x, tz = "UTC")$wday + 1L)
  }
  if (s != 7L) 1L + (x + (6L - s)) %% 7L else x
}

#' Retrieve the week in the year
#'
#' This finds the number of days between the current date and January 1 of that
#' year and performs integer division to obtain the number of weeks. 
#'
#' @param the_date a date/POSIXt object
#' 
#' @return the numeric week of the year
#'
#' @noRd
#'
week_in_year <- function(the_date) {
  jan1 <- as.Date(sprintf("%s-01-01", format(the_date, "%Y")))
  1L + (as.numeric(the_date) - as.numeric(jan1)) %/% 7L
}
