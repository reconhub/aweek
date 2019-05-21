#' Convert characters or dates to aweek objects
#'
#' @param x a correctly formated character or date vector
#' @param ... (for the `Date` method) arguments passed on to [date2week()]
#' @inheritParams date2week
#' @return an aweek object
#' @export
#' @examples
#'
#' # aweek objects can only be created from valid weeks:
#'
#' as.aweek("2018-W10-5", week_start = 7) # works!
#' try(as.aweek("2018-10-5", week_start = 7)) # doesn't work :(
#' 
#' # you can also convert dates
#' as.aweek(as.Date("2018-03-09"))
#'
#' # all functions get passed to date2week, so you can use any of its arguments:
#' as.aweek("2018-W10-5", week_start = 7, floor_day = TRUE, factor = TRUE) 
#' as.aweek(as.Date("2018-03-09"), floor_day = TRUE, factor = TRUE)
as.aweek <- function(x, ...) UseMethod("as.aweek")

#' @export
#' @rdname as.aweek
as.aweek.character <- function(x, week_start = get_week_start(), ...) {
  
  stop_if_not_aweek_string(x)
  .dots <- list(...)

  # if the week_start is length one, then we can just add it as a week
  # attribute and be done with it. Otherwise, we will have to convert to date
  # and then back to week.
  easy_week <- length(week_start) == 1

  if (is.character(week_start)) {
    if (easy_week) {
      week_start <- weekday_from_char(week_start)
    } else {
      week_start <- vapply(week_start, weekday_from_char, integer(1))
    }
  }

  if (easy_week) {
    # There's only one week_start, so we can handle it from here ^_^
    attr(x, "week_start") <- week_start
    class(x) <- "aweek"
  } else {
    # each of these characters represents a different week, so they need to be
    # converted separately.
    x <- make_aweek(week = substr(x, 7, 8), 
                    year = substr(x, 1, 4),
                    day  = substr(x, 10, 11),
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

