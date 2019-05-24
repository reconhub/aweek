#' Convert characters or dates to aweek objects
#'
#' @param x a [Date][Date], [POSIXct][POSIXct], [POSIXlt][POSIXlt], or a
#'   correctly formatted (YYYY-Www-d) character string that represents the year,
#'   week, and weekday. 
#' @param ... arguments passed on to [date2week()] and [as.POSIXlt()]
#' @inheritParams get_aweek
#' @inheritParams date2week
#' @return an [aweek][aweek-class] object
#'
#' @seealso ["aweek-class"][aweek-class] for details on the aweek object, 
#'   [get_aweek()] for converting numeric weeks to weeks or dates,
#'   [date2week()] for converting dates to weeks, [week2date()] for converting
#'   weeks to dates.
#'
#' @details The `as.aweek()` will coerce character, dates, and datetime objects 
#'   to aweek objects. Dates are trivial to convert to weeks because there is
#'   only one correct way to convert them with any given `week_start`. 
#' 
#'   There is a bit of nuance to be aware of when converting
#'   characters to aweek objects:
#'
#'    - The characters must be correctly formatted as `YYYY-Www-d`, where YYYY
#'      is the year relative to the week, Www is the week number (ww) prepended
#'      by a W, and d (optional) is the day of the week from 1 to 7 where 1
#'      represents the week_start. This means that characters formatted as
#'      dates will be rejected.
#'    - By default, the `week_start` and `start` parameters are identical. If
#'      your data contains heterogeneous weeks (e.g. some dates will have the
#'      week start on Monday and some will have the week start on Sunday), then
#'      you should use the `start` parameter to reflect this. Internally, the
#'      weeks will first be converted to dates with their respective starts and
#'      then converted back to weeks, unified under the `week_start` parameter.
#' 
#' @note factors are first converted to characters before they are converted to
#'   aweek objects.
#'      
#' @export
#' @examples
#'
#' # aweek objects can only be created from valid weeks:
#'
#' as.aweek("2018-W10-5", week_start = 7) # works!
#' try(as.aweek("2018-10-5", week_start = 7)) # doesn't work :(
#' 
#' # you can also convert dates or datetimes
#' as.aweek(Sys.Date())
#' as.aweek(Sys.time())
#'
#' # all functions get passed to date2week, so you can use any of its arguments:
#' as.aweek("2018-W10-5", week_start = 7, floor_day = TRUE, factor = TRUE) 
#' as.aweek(as.Date("2018-03-09"), floor_day = TRUE, factor = TRUE)
#'
#' # If you have a character vector where different elements begin on different
#' # days of the week, you can use the "start" argument to ensure they are
#' # correctly converted.
#' as.aweek(c(mon = "2018-W10-1", tue = "2018-W10-1"), 
#'          week_start = "Monday", 
#'          start = c("Monday", "Tuesday"))
#'
#' # you can convert aweek objects to aweek objects:
#' x <- get_aweek()
#' as.aweek(x)
#' as.aweek(x, week_start = 7)
as.aweek <- function(x, week_start = get_week_start(), ...) UseMethod("as.aweek")


#' @export
#' @rdname as.aweek
as.aweek.default <- function(x, week_start = NULL, ...) {

  cl <- paste(class(x), collapse = ", ")
  stop(sprintf("There is no method to convert an object of class '%s' to an aweek object.", cl))

}

#' @export
#' @rdname as.aweek
as.aweek.NULL <- function(x, week_start = NULL, ...) {

  stop("aweek objects can not be NULL")

}

#' @export
#' @rdname as.aweek
as.aweek.character <- function(x, week_start = get_week_start(), start = week_start, ...) {
  
  # Sanity checks --------------------------------------------------------------
  stop_if_not_aweek_string(x)
  week_start <- parse_week_start(week_start)

  # if the week_start is length one, then we can just add it as a week
  # attribute and be done with it. Otherwise, we will have to convert to date
  # and then back to week.
  easy_week <- length(start) == 1

  if (is.character(start)) {
    if (easy_week) {
      start <- weekday_from_char(start)
    } else {
      start <- vapply(start, weekday_from_char, integer(1))
    }
  }

  stop_if_not_weekday(start)
  
  # Processing -----------------------------------------------------------------
  # preserve the names
  nx <- names(x)

  if (easy_week) {
    # There's only one start, so we can handle it from here ^_^
    attr(x, "week_start") <- start
    class(x) <- "aweek"
    if (week_start != start) {
      x <- change_week_start(x, week_start)
    }
  } else {
    # each of these characters represents a different week, so they need to be
    # converted separately.
    x <- get_aweek(week = int_week(x), 
                   year = int_year(x),
                   day  = int_wday(x),
                   start = start,
                   week_start = week_start
                  )
  }

  # ensuring the names are correct
  names(x) <- nx
  
  # Process extra arguments ----------------------------------------------------

  .dots <- list(...)

  if (length(.dots) > 0) {
    # if the user specified options like "factor" or "floor_day"
    x <- do.call("date2week", c(list(x = x, week_start = week_start), .dots))
  } 
  
  x
}

#' @rdname as.aweek
#' @export
as.aweek.factor <- function(x, week_start = get_week_start(), ...) {

  as.aweek(as.character(x), week_start = week_start, ...)

}


#' @export
#' @rdname as.aweek
as.aweek.Date <- function(x, week_start = get_week_start(), ...) {

  date2week(x, week_start = week_start, ...)

}

#' @export
#' @rdname as.aweek
as.aweek.POSIXt <- as.aweek.Date

#' @export
#' @rdname as.aweek
as.aweek.aweek <- function(x, week_start = NULL, ...) {

  if (is.null(week_start)) return(x)
  change_week_start(x, parse_week_start(week_start), ...)

}

