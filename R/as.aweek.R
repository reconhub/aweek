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
  
  test_aweek_string(x)
  .dots <- list(...)

  # TODO: change this so that it accepts multiple week_start variables
  if (length(week_start) != 1) stop("week_start must be a vector of length 1")

  if (is.character(week_start)) {
    week_start <- weekday_from_char(week_start)
  }

  attr(x, "week_start") <- week_start
  class(x) <- "aweek"
  if (length(.dots) > 0) {
    do.call("date2week", c(list(x = x, week_start = week_start), .dots))
  } else {
    x
  }

}


#' @export
#' @rdname as.aweek
as.aweek.Date <- function(x, ...) {

  date2week(x, ...)

}

