#' Convert characters or dates to aweek objects
#'
#' @param x a correctly formated character or date vector
#' @param ... (for the `Date` method) arguments passed on to [date2week()]
#' @inheritParams get_aweek
#' @inheritParams date2week
#' @return an aweek object
#' @export
#' @examples
#'
#' # aweek objects can only be created from valid weeks:
#'
#' as.aweek("2018-W10-5", start = 7, week_start = 7) # works!
#' try(as.aweek("2018-10-5", week_start = 7)) # doesn't work :(
#' 
#' # you can also convert dates
#' as.aweek(as.Date("2018-03-09"))
#'
#' # all functions get passed to date2week, so you can use any of its arguments:
#' as.aweek("2018-W10-5", start = 7, week_start = 7, floor_day = TRUE, factor = TRUE) 
#' as.aweek(as.Date("2018-03-09"), floor_day = TRUE, factor = TRUE)
#'
#' # you can convert aweek objects to aweek objects:
#' x <- get_aweek()
#' as.aweek(x)
#' as.aweek(x, week_start = 7)
as.aweek <- function(x, ...) UseMethod("as.aweek")

#' @export
#' @rdname as.aweek
as.aweek.character <- function(x, start = week_start, week_start = get_week_start(), ...) {
  
  stop_if_not_aweek_string(x)

  week_start <- parse_week_start(week_start)

  .dots <- list(...)

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

  start <- as.integer(start)

  stop_if_not_weekday(start)

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
    x <- get_aweek(week = substr(x, 7, 8), 
                   year = substr(x, 1, 4),
                   day  = substr(x, 10, 11),
                   start = start,
                   week_start = week_start
                  )

  }

  # return the aweek object 
  if (length(.dots) > 0) {
    # if the user specified options like "factor" or "floor_day"
    return(do.call("date2week", c(list(x = x, week_start = week_start), .dots)))
  } else {
    return(x)
  }

}


#' @export
#' @rdname as.aweek
as.aweek.Date <- function(x, ...) {

  date2week(x, ...)

}

#' @export
#' @rdname as.aweek
as.aweek.aweek <- function(x, week_start = NULL, ...) {

  if (is.null(week_start)) return(x)
  change_week_start(x, parse_week_start(week_start), ...)
}

