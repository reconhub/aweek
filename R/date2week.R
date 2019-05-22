#' Convert date to a an arbitrary week definition
#'
#' @param x a [Date], [POSIXt], [character], or any data that can be easily
#'   converted to a date with [as.POSIXlt()]. 
#'
#' @param week_start a number indicating the start of the week based on the ISO
#'   8601 standard from 1 to 7 where 1 = Monday OR an abbreviation of the
#'   weekdate in an English or current locale. _Note: using a non-English locale
#'   may render your code non-portable._ Defaults to the value of 
#'   [get_week_start()]
#' 
#' @param floor_day when `TRUE`, the days will be set to the start of the week.
#'
#' @param numeric if `TRUE`, only the numeric week be returned. If `FALSE`
#'   (default), the date in the format "YYYY-Www-d" will be returned.  
#'
#' @param factor if `TRUE`, a factor will be returned with levels spanning the
#'   range of dates. This should only be used with `floor_day = TRUE` to
#'   produce the sequence of weeks between the first and last date as the
#'   factor levels.  Currently, `floor_date = FALSE` will still work, but will
#'   produce a message indicating that it is deprecated. _Take caution when
#'   using this with a large date range as the resulting factor can contain all
#'   days between dates_.
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
#' @note `date2week()` will initially convert the input with [as.POSIXlt()] and
#'   use that to calculate the week. If the user supplies character input, it
#'   is expected that the input will be of the format yyyy-mm-dd _unless_ the 
#'   user explicitly passes the "format" parameter to [as.POSIXlt()]. If the
#'   input is not in yyyy-mm-dd and the format parameter is not passed, 
#'   `date2week()` will result in an error.
#'
#' @author Zhian N. Kamvar
#' @export
#' @seealso [set_week_start()], [as.Date.aweek()], [print.aweek()], [as.aweek()],
#'   [get_aweek()]
#' @examples
#'
#' ## Dates to weeks -----------------------------------------------------------
#'
#' # The same set of days will occur in different weeks depending on the start
#' # date. Here we can define a week before and after today
#'
#' print(dat <- as.Date("2018-12-31") + -6:7)
#' 
#' # By default, the weeks are defined as ISO weeks, which start on Monday
#' print(iso_dat <- date2week(dat))
#' 
#' # This can be changed by setting the global default with set_week_start()
#' 
#' set_week_start("Sunday")
#'
#' date2week(dat)
#'
#' # If you want lubridate-style numeric-only weeks, you need look no further
#' # than the "numeric" argument
#' date2week(dat, numeric = TRUE)
#' 
#' # To aggregate weeks, you can use `floor_day = TRUE`
#' date2week(dat, floor_day = TRUE)
#'
#' # If you want aggregations into factors that include missing weeks, use
#' # `floor_day = TRUE, factor = TRUE`:
#' date2week(dat[c(1, 14)], floor_day = TRUE, factor = TRUE)
#'
#'
#' ## Weeks to dates -----------------------------------------------------------
#'
#' # The aweek class can be converted back to a date with `as.Date()`
#' as.Date(iso_dat)
#' 
#' # If you don't have an aweek class, you can use week2date(). Note that the
#' # week_start variable is set by the "aweek.week_start" option, which we will
#' # set to Monday:
#' 
#' set_week_start("Monday")
#' week2date("2019-W01-1") # 2018-12-31
#'
#' # This can be overidden by the week_start argument;
#' week2date("2019-W01-1", week_start = "Sunday") # 2018-12-30
#'
#' # If you want to convert to the first day of the week, you can use the 
#' # `floor_day` argument
#' as.Date(iso_dat, floor_day = TRUE)
#'
#' ## The same two week timespan starting on different days --------------------
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
date2week <- function(x, week_start = get_week_start(), floor_day = factor, numeric = FALSE, factor = FALSE, ...) {

  format_exists <- !is.null(list(...)$format)
  nas  <- is.na(x)
  nams <- names(x)

  week_start <- parse_week_start(week_start)

  if (!inherits(x, "aweek") && is.character(x) && !format_exists) {
    iso_std <- grepl("^[0-9]{4}[^[:alnum:]]+[01][0-9][^[:alnum:]]+[0-3][0-9]$", trimws(x))
    iso_std[nas] <- TRUE # prevent false alarms
    if (!all(iso_std)) {
      msg <- paste("Not all dates are in ISO 8601 standard format (yyyy-mm-dd).",
                   "The first incorrect date is %s"
      )
      stop(sprintf(msg, x[!iso_std][1]))
    }
  }
  x  <- tryCatch(as.POSIXlt(x, ...), error = function(e) e)

  if (inherits(x, "error")) {
    mc <- match.call()
    msg <- "%s could not be converted to a date. as.POSIXlt() returned this error:\n%s"
    stop(sprintf(msg, deparse(mc[["x"]]), x$message))
  }

  wday       <- as.integer(x$wday) + 1L # weekdays in R run 0:6, 0 being Sunday

  stop_if_not_weekday(wday)

  wday     <- get_wday(wday, week_start)
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
    # set the missing data back to missing
    the_week[nas] <- NA
    if (floor_day) {
      the_week <- gsub("\\-\\d", "", the_week)
    }

    if (factor) {
      if (!floor_day) {
        msg <- "In future versions of aweek, `factor = TRUE` must also include"
        msg <- paste(msg, "`floor_day = TRUE`")
        message(msg)
      }
      # find the minimum and maximum dates
      dmin   <- which.min(the_date)
      dmax   <- which.max(the_date)
      drange <- the_week[c(dmin, dmax)]
      # convert back to dates to get the first days of the week
      drange <- week2date(drange, week_start = week_start)
      # create the sequence from the first week to the last week
      lvls   <- seq.Date(drange[1], drange[2], by = if (floor_day) 7L else 1)
      # convert to weeks to use for levels
      lvls   <- date2week(lvls, 
                          week_start = week_start, 
                          floor_day = floor_day,
                          factor = FALSE,
                          numeric = FALSE)
      # convert to factor
      the_week <- factor(the_week, levels = lvls)
    }
    # add the class attributes
    class(the_week) <- c("aweek", oldClass(the_week))
    attr(the_week, "week_start") <- week_start 
  }
  names(the_week) <- names(x)
  the_week
}

