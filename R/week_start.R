#' Get and set the global week_start variable
#' 
#' This is a convenience wrapper around [options()] and [getOption()], which
#' allows users to input both numeric and character week start values
#'
#' @param x a character or integer specifying the day of the week for conversion
#'   between dates and weeks.
#' @param w if `NULL`, the global option "aweek.week_start" is returned. If `w`
#'   is an aweek object, then the "week_start" attribute is returned.
#'
#' @return for `set_week_start`, the old value of `week_start` is returned, 
#'   invisibly. For `get_week_start`, the current value of `week_start` is 
#'   returned.
#' 
#' @export
#' @rdname week_start
#' @seealso [change_week_start()] for changing the week_start attribute of an
#'   aweek object, [date2week()], [week2date()]
#' @examples
#' 
#' # get the current definition of the week start
#' get_week_start() # defaults to Monday (1)
#' getOption("aweek.week_start", 1L) # identical to above
#'
#' # set the week start
#' mon <- set_week_start("Sunday") # set week start to Sunday (7)
#' get_week_start()
#' print(set_week_start(mon)) # reset the default
#' get_week_start()
#' 
#' # Get the week_start of a specific aweek object.
#' w <- date2week("2019-05-04", week_start = "Sunday")
#' get_week_start(w)
set_week_start <- function(x = 1L) {
  if (is.character(x)) {
    x <- weekday_from_char(x) 
  } 

  if (x < 1L || x > 7L || as.integer(x) != x) {
    stop("week_start must be a whole number from 1 to 7, representing the days of the week.")
  }

  ows <- options(aweek.week_start = x)[[1]]
  if (is.null(ows)) invisible(1L) else invisible(ows)
}

#' @export
#' @rdname week_start
get_week_start <- function(w = NULL) {
  if (is.null(w)) {
    getOption("aweek.week_start", 1L)
  } else if (inherits(w, "aweek")) {
    attr(w, "week_start")
  } else {
    stop("w must be an 'aweek' object or NULL")
  }
}

#' Parse the week_start scalar
#'
#' This will check the length and enforce integers and non-missing
#'
#' @noRd
parse_week_start <- function(w) {

  if (is.null(w)) {
    stop("please provide a week_start")
  }
  if (length(w) != 1) {
    stop("week_start must be length 1")
  }

  if (is.na(w)) {
    stop("week_start must not be missing")
  }

  if (is.character(w)) {
    w <- weekday_from_char(w)
  } else {
    w <- as.integer(w)
  }

  stop_if_not_weekday(w)

  return(w)
}
