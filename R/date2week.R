#' Convert date to a an arbitrary week definition
#'
#' @param x a [Date], [POSIXt], [character], or any data that can be easily
#'   converted to a date with [as.POSIXlt()]. 
#'
#' @param week_start The start of the week from 1 to 7 where 1 = Monday
#' 
#' @param floor_day when `TRUE`, the days will be set to the start of the week.
#'
#' @param numeric if `TRUE`, only the numeric week be returned. If `FALSE`
#'   (default), the date in the format "YYYY-Www-d" will be returned.  
#' 
#' @param ... arguments passed to [as.POSIXlt()], unused in all other cases.
#' 
#' @details Weeks differ in their start dates depending on context. The ISO
#'   8601 standard specifies that Monday starts the week
#'   (<http://en.wikipedia.org/wiki/ISO_week_date>) while the US CDC uses
#'   Sunday as the start of the week (<http://www.cmmcp.org/epiweek.htm>). For
#'   example, MSF has varying start dates depending on country in order to
#'   better coordinate response. 
#'
#'   While there are package that conver conversion for ISOweeks and epiweeks,
#'   these do not provide seamless conversion from dates to epiweeks with 
#'   non-standard start dates. This package provides a lightweight utility to
#'   be able to convert each day.
#'
#' @author Zhian N. Kamvar
#' @export
#' @examples
#'
#' # The same set of days will occur in different weeks depending on the start
#' # date. Here we can define a week before and after today
#'
#' print(dat <- Sys.Date() + -6:7)
#' 
#' # By default, the weeks are defined as ISO weeks, which start on Monday
#' print(iso_dat <- date2week(dat))
#'
#' # If you want lubridate-style numeric-only weeks, you need look no further
#' # than the "numeric" argument
#' date2week(dat, 1, numeric = TRUE)
#'
#' # The aweek class can be converted back to a date with `as.Date()`
#' as.Date(iso_dat)
#'
#' # If you want to show only the first day of the week, you can use the 
#' # `floor_day` argument
#' as.Date(iso_dat, floor_day = TRUE)
#'
#' # ISO week definition: Monday -- 1
#' date2week(dat, 1)
#'
#' # Tuesday -- 2
#' date2week(dat, 2)
#'
#' # Wednesday -- 3
#' date2week(dat, 3)
#'
#' # Thursday -- 4
#' date2week(dat, 4)
#'
#' # Friday -- 5
#' date2week(dat, 5)
#'
#' # Saturday -- 6
#' date2week(dat, 6)
#'
#' # Epiweek definition: Sunday -- 7 
#' date2week(dat, 7)
date2week <- function(x, week_start = 1, floor_day = FALSE, numeric = FALSE, ...) {

  ox <- x
  x  <- tryCatch(as.POSIXlt(x, ...), error = function(e) e)

  if (inherits(x, "error")) {
    mc <- match.call()
    msg <- "%s could not be converted to a date. as.POSIXlt() returned this error:\n%s"
    stop(sprintf(msg, deparse(mc[["x"]]), x$message))
  }
  wday       <- as.integer(x$wday) + 1L # weekdays in R run 0:6, 0 being Sunday
  week_start <- as.integer(week_start)

  wday <- get_wday(wday, week_start)
  the_date <- as.Date(x)
  the_week_bounds <- the_date + (4L - wday)
  the_week <- week_in_year(the_week_bounds)

  # adjust for cases where the year is different than the date
  december <- format(the_date, "%m") == "12"
  january  <- format(the_date, "%m") == "01"
  boundary_adjustment <- integer(length(the_date))
  
  # Shift the year backwards if the date is in january, but the week is not
  boundary_adjustment[january  & the_week >= 52] <- -1L

  # Shift the year forwards if the date is in december, but it's the first week
  boundary_adjustment[december & the_week == 1]  <- 1L

  if (!numeric) {
    the_year <- as.integer(format(the_date, "%Y"))
    the_week <- sprintf("%04d-W%02d-%d", 
                   the_year + boundary_adjustment,
                   the_week,
                   wday
                   )
    class(the_week) <- "aweek"
    attr(the_week, "week_start") <- week_start 
    if (floor_day) {
      the_week <- gsub("-\\d", "", the_week)
    }
  }
  the_week
}

