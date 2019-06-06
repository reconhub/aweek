#' @export
#' @rdname aweek-conversions
as.Date.aweek <- function(x, floor_day = FALSE, ...) {

  # out           <- matrix(NA_integer_, ncol = 4, nrow = length(x))
  # colnames(out) <- c("year", "week", "day", "week_start")

  out <- template_week_matrix(length(x))

  week_start <- attr(x, "week_start")
  x          <- as.character(x)

  out[, "week_start"] <- week_start
  out[, "year"]       <- int_year(x) # as.integer(substr(x, 1, 4))
  out[, "week"]       <- int_week(x) # as.integer(substr(x, 7, 8))
  if (!floor_day) {
    out[, "day" ] <- int_wday(x) # as.integer(substr(x, 10, 11))
  }

  # Convert the dates to week
  the_dates        <- date_from_week_matrix(out)
  names(the_dates) <- names(x)
  the_dates

}

