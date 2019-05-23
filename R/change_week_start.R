#' Change the week start of an aweek object
#' 
#' This will change the week_start attribute of an aweek object and adjust the
#' observations accordingly. 
#'
#' @param week_start a number indicating the start of the week based on the ISO
#'   8601 standard from 1 to 7 where 1 = Monday OR an abbreviation of the
#'   weekdate in an English or current locale. _Note: using a non-English locale
#'   may render your code non-portable._ Unlike [date2week()], this defaults to
#'   NULL, which will throw an error unless you supply a value.
#' 
#' @inheritParams date2week
#'
#' @export
#' @seealso [get_week_start()] for accessing the global and local `week_start`
#'   attribute, [as.aweek()], which wraps this function.
#' @examples
#' # New Year's 2019 is the third day of the week starting on a Sunday
#' s <- date2week(as.Date("2019-01-01"), week_start = "Sunday")
#' s 
#'
#' # It's the second day of the week starting on a Monday
#' m <- change_week_start(s, "Monday") 
#' m
#'
#' # When you compare the underlying dates, they are exactly the same
#' identical(as.Date(s), as.Date(m))
#'
#' # Since this will pass arguments to `date2week()`, you can modify other
#' # aspects of the aweek object this way, but this is not advised.
#'
#' change_week_start(s, "Monday", floor_day = TRUE)
change_week_start <- function(x, week_start = NULL, ...) {

  if (!inherits(x, "aweek")) {
    stop("x must be an aweek object")
  }

  week_start <- parse_week_start(week_start)

  d <- as.Date(x)
  date2week(d, week_start = week_start, ...) 

}
