#' Convert date to a an arbitrary week definition
#'
#' @param x a [Date], [POSIXt], [character], or any data that can be easily
#'   converted to a date with [as.POSIXlt()]. 
#'
#' @param week_start a number indicating the start of the week based on the ISO
#'   8601 standard from 1 to 7 where 1 = Monday OR an abbreviation of the
#'   weekdate in an English or current locale. _Note: using a non-English locale
#'   may render your code non-portable._
#' 
#' @param floor_day when `TRUE`, the days will be set to the start of the week.
#'
#' @param numeric if `TRUE`, only the numeric week be returned. If `FALSE`
#'   (default), the date in the format "YYYY-Www-d" will be returned.  
#'
#' @param factor if `TRUE`, a factor will be returned with levels spanning the
#'   range of dates. If `floor_date = FALSE`, then this will use the sequence
#'   of days between the first and last date, but if `floor_date = TRUE`, then
#'   the sequence of weeks between the first and last date will be used. _Take
#'   caution when using this with a large date range as the resulting factor can
#'   contain all days between dates_.
#' 
#' @param ... arguments passed to [as.POSIXlt()], unused in all other cases.
#' 
#' @details Weeks differ in their start dates depending on context. The ISO
#'   8601 standard specifies that Monday starts the week
#'   (<https://en.wikipedia.org/wiki/ISO_week_date>) while the US CDC uses
#'   Sunday as the start of the week
#'   (<https://wwwn.cdc.gov/nndss/document/MMWR_Week_overview.pdf>). For
#'   example, MSF has varying start dates depending on country in order to
#'   better coordinate response. 
#'
#'   While there are packages that provide conversion for ISOweeks and epiweeks,
#'   these do not provide seamless conversion from dates to epiweeks with 
#'   non-standard start dates. This package provides a lightweight utility to
#'   be able to convert each day.
#'
#' @author Zhian N. Kamvar
#' @export
#' @seealso [as.Date.aweek()], [print.aweek()]
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
#' # You can also convert to factor and include all of the missing dates, but
#' # beware that this may result in a very large factor due to the number of
#' # levels present
#' date2week(Sys.Date() + c(0, 10), factor = TRUE)
#'
#'
#' # The aweek class can be converted back to a date with `as.Date()`
#' as.Date(iso_dat)
#'
#' # If you want to show only the first day of the week, you can use the 
#' # `floor_day` argument
#' as.Date(iso_dat, floor_day = TRUE)
#'
#' # This also works with `factor`:
#' as.Date(iso_dat, floor_day = TRUE, factor = TRUE)
#'
#' # ISO week definition: Monday -- 1
#' date2week(dat, 1)
#' date2week(dat, "Monday")
#'
#' # Tuesday -- 2
#' date2week(dat, 2)
#' date2week(dat, "Tuesday")
#'
#' # Wednesday -- 3
#' date2week(dat, 3)
#' date2week(dat, "W") # you can use valid abbreviations
#'
#' # Thursday -- 4
#' date2week(dat, 4)
#' date2week(dat, "Thursday")
#'
#' # Friday -- 5
#' date2week(dat, 5)
#' date2week(dat, "Friday")
#'
#' # Saturday -- 6
#' date2week(dat, 6)
#' date2week(dat, "Saturday")
#'
#' # Epiweek definition: Sunday -- 7 
#' date2week(dat, 7)
#' date2week(dat, "Sunday")
date2week <- function(x, week_start = 1, floor_day = FALSE, numeric = FALSE, factor = FALSE, ...) {

  x  <- tryCatch(as.POSIXlt(x, ...), error = function(e) e)

  if (inherits(x, "error")) {
    mc <- match.call()
    msg <- "%s could not be converted to a date. as.POSIXlt() returned this error:\n%s"
    stop(sprintf(msg, deparse(mc[["x"]]), x$message))
  }

  if (is.character(week_start)) {
    week_start <- weekday_from_char(week_start)
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
    if (floor_day) {
      the_week <- gsub("-\\d", "", the_week)
    }

    if (factor) {
      min_date <- which.min(the_date)
      max_date <- which.max(the_date)
      drange   <- date2week(range(the_date), week_start = week_start, 
                            floor_day = floor_day, factor = FALSE, numeric = FALSE)
      drange   <- week2date(drange, week_start = week_start)
      lvls     <- seq.Date(drange[1], drange[2], by = if (floor_day) 7L else 1)
      lvls     <- date2week(lvls, week_start = week_start, floor_day = floor_day)
      the_week <- factor(the_week, levels = lvls)
    }
    class(the_week) <- c("aweek", oldClass(the_week))
    attr(the_week, "week_start") <- week_start 
  }
  the_week
}

