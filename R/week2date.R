#' @export
#' @rdname date2week
week2date <- function(x, week_start = 1, floor_day = FALSE) {

  if (!inherits(x, "aweek")) {
    class(x) <- "aweek"
    week_start <- if (is.character(week_start)) weekday_from_char(week_start) else as.integer(week_start)
    attr(x, "week_start") <- week_start
  }
  return(as.Date(x, floor_day))

}

