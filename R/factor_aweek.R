#' Coerce an aweek object to factor to include missing weeks
#'
#' @param x an aweek object
#' @return an aweek object that inherits from [factor()] with levels that span
#'   the range of the weeks in the object.
#'
#' @note when factored aweek objects are combined with other aweek objects, they
#'   are converted back to characters. 
#'
#' @export
#' @examples
#' w <- get_aweek(week = 1:2 * 5, year = 2019)
#' w
#' wf <- factor_aweek(w)
#' wf
#' 
#' # factors are destroyed if combined with aweek objects
#' c(w, wf)
factor_aweek <- function(x) {

  if (!inherits(x, "aweek")) {
    stop("x must be an 'aweek' object")
  }

  week_start <- get_week_start(x)

  # convert back to dates to get the first days of the week
  drange <- week2date(range(x, na.rm = TRUE), week_start = week_start)
  # create the sequence from the first week to the last week
  lvls   <- seq.Date(drange[1], drange[2], by = 7L)
  # convert to weeks to use for levels
  lvls   <- date2week(lvls, 
                      week_start = week_start, 
                      floor_day = TRUE,
                      factor = FALSE,
                      numeric = FALSE)
  # convert to factor
  xx <- factor(trunc(x), levels = lvls)
  attr(xx, "week_start") <- week_start
  class(xx) <- c("aweek", oldClass(xx))

  xx
}
