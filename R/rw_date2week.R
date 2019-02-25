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
#' @details Weeks differ in their start dates depending on context. The ISO 8601
#'   standard specifies that Monday starts the week while the US CDC uses Sunday
#'   as the start of the week. For example, MSF has varying start dates 
#'   depending on country in order to better coordinate response. 
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
#' print(iso_dat <- rw_date2week(dat))
#'
#' # The rainboweek class can be converted back to a date with `as.Date()`
#' as.Date(iso_dat)
#'
#' # If you remove the day portion from the result, you can convert the days to
#' # the beginning of the week:
#' print(iso_dat_trunc <- gsub("-\\d$", "", iso_dat))
#' as.Date(iso_dat_trunc)
#'
#' # ISO week definition: Monday -- 1
#' rw_date2week(dat, 1)
#'
#' # Tuesday -- 2
#' rw_date2week(dat, 2)
#'
#' # Wednesday -- 3
#' rw_date2week(dat, 3)
#'
#' # Thursday -- 4
#' rw_date2week(dat, 4)
#'
#' # Friday -- 5
#' rw_date2week(dat, 5)
#'
#' # Saturday -- 6
#' rw_date2week(dat, 6)
#'
#' # Epiweek definition: Sunday -- 7 
#' rw_date2week(dat, 7)
rw_date2week <- function(x, week_start = 1, floor_day = FALSE, numeric = FALSE, ...) {

  x <- try(as.POSIXlt(x, ...))
  if (inherits(x, "try-error")) {
    stop(sprintf("there is no method for an object of class %s", 
                 paste(class(x), collapse = ", "))) 
  }
  wday       <- as.integer(x$wday) + 1L # weekdays in R run 0:6, 0 being Sunday
  week_start <- as.integer(week_start)

  wday <- get_wday(wday, week_start)
  the_date <- as.Date(x)
  the_week_bounds <- the_date + (4L - wday)
  res <- week_in_year(the_week_bounds)

  first_week_is_last_year <- grepl("01", format(the_date, "%m")) & res >= 52
  if (!numeric) {
    the_year <- as.integer(format(the_date, "%Y"))
    res <- sprintf("%04d-W%02d-%d", 
                   the_year - first_week_is_last_year,
                   res,
                   wday
                   )
    class(res) <- "rainboweek"
    attr(res, "week_start") <- week_start 
    if (floor_day) {
      res <- gsub("-\\d", "-1", res)
    }
  }
  res
}

