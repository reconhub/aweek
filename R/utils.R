#' create a date for each row in the week matrix
#'
#' @param mat a integer matrix with four columns representing the year, week, day, and week_start
#' @return a vector of dates the same lengths as the number of rows in the matrix.
#' @noRd
#' @examples
#' mat <- matrix(c(
#'   2019, 11, 1, 7, # 2019-03-10
#'   2019, 11, 2, 7,
#'   2019, 11, 3, 7,
#'   2019, 11, 4, 7,
#'   2019, 11, 5, 7,
#'   2019, 11, 6, 7,
#'   2019, 11, 7, 7  # 2019-03-16
#' ), ncol = 4, byrow = TRUE)
#' colnames(mat) <- c("year", "week", "day", "week_start")
#' mat
#' d <- date_from_week_matrix(mat)
#' identical(d, as.Date("2019-03-10") + 0:6)
#' d
#' mat[, "week_start"] <- 7:1
#' date_from_week_matrix(mat)
#' date2week(date_from_week_matrix(mat))
#'
date_from_week_matrix <- function(mat) {
  # Steps:
  #
  # 1. find the weekday (relative to week_start) that represents 1 January.
  #
  # 2. subtract a week if the weekday is before the 4th day because that means
  #    that the previous year was included in the week counts
  #    
  # 3. determine the first date of the year by subtracting the weekday (relative
  #    to week_start) from 1 January
  #
  # 4. add the weeks_as_days plus the number of days minus one to get the dates

  # replace any truncated aweeks with the first day of the week
  mat[, "day"] <- ifelse(is.na(mat[, "day"]), 1L, mat[, "day"])

  # throw an error if any of these days are incorrect
  stop_if_not_weekday(mat[, "day"])
  stop_if_not_weekday(mat[, "week_start"])

  # missing years are set to NA 
  january_1 <- ifelse(is.na(mat[, "year"]), NA, sprintf("%s-01-01", mat[, "year"]))
  january_1 <- iso_date(january_1)
  j1_day    <- get_wday(january_1, mat[, "week_start"]) - 1L

  # If the previous year is included in this year's first date, subtract a week
  j1_is_first <- as.integer(j1_day < 4)
  weeks_as_days <- (mat[, "week"] - j1_is_first) * 7L
  first_week <- january_1 - j1_day

  unname(first_week + (weeks_as_days + mat[, "day"] - 1L))
}

#' Template the week matrix
#'
#' @param n the number of rows for the matrix to have
#' @noRd
template_week_matrix <- function(n = 1L) {
  out           <- matrix(NA_integer_, ncol = 4, nrow = n)
  colnames(out) <- c("year", "week", "day", "week_start")
  out
}

#' Helpers for getting the integer components of an aweek string
#' @noRd
int_year <- function(x) as.integer(substr(x, 1, 4))
int_week <- function(x) as.integer(substr(x, 7, 8))
int_wday <- function(x) as.integer(substr(x, 10, 10))

#' Get the weekday given an integer/date and a start date
#'
#' @param x a Date or an integer day relative to the ISO week
#' 
#' @param s an integer representing the day to start the week
#'
#' @return the day of the week for x relative to s
#'
#' @note R stores its dates on a Sunday -- Saturday week where the numbering
#'   starts with 0 to 6. Happily, this doesn't affect the calculation since
#'   1 + (0 + 6) %% 7 is the same as 1 + (7 + 6) %% 7
#' @noRd
#'
#' @examples
#'
#' get_wday(1:7, 1) # The isoweekdays get returned
#' get_wday(as.Date("2007-01-01"), 1) # this is a Monday
#' get_wday(as.Date("2007-01-01"), 7) 
#' get_wday(1, 5) # Monday is the fourth day in a Friday - Saturday week
get_wday <- function(x, s) { 

  if (inherits(x, c("Date", "POSIXt"))) {
    x <- as.integer(as.POSIXlt(x, tz = "UTC")$wday) # + 1L)
  }

  return(1L + (x + (7L - s)) %% 7L)

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
  jan1 <- iso_date(sprintf("%s-01-01", format(the_date, "%Y")))
  1L + (as.numeric(the_date) - as.numeric(jan1)) %/% 7L
}

#' Convert ISO date strings to a date, quickly
#' 
#' This is basically the quick version of as.Date()
#'
#' @param d a date string in ISO 8601 format
#' @return a Date object
#'
#' @noRd
iso_date <- function(d) as.Date(strptime(d, format = "%Y-%m-%d", tz = "UTC"))


vlogic <- function(x, FUN, ...) {

  vapply(x, FUN = match.fun(FUN), FUN.VALUE = logical(1), ...)

}
