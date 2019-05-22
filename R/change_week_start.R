#' Change the week start of an aweek object
#' 
#' This will change the week_start attribute of an aweek object and adjust the
#' observations accordingly. 
#'
#' @param x an aweek object
#' @param week_start the new desired week_start
#' @param ... parameters passed to [date2week()]
#'
#' @export
#' @seealso [as.aweek()], which wraps this function.
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
change_week_start <- function(x, week_start = get_week_start(), ...) {

  if (!inherits(x, "aweek")) {
    stop("x must be an aweek object")
  }

  if (length(week_start) != 1)

  if (get_week_start(x) == week_start) {
    return(x)
  }

  d <- as.Date(x)
  date2week(d, week_start = week_start, ...) 

}
