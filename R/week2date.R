#' @export
#' @rdname date2week
week2date <- function(x, week_start = get_week_start(), floor_day = FALSE) {

  if (!inherits(x, "aweek")) {
    x <- as.aweek(x, start = week_start, week_start = week_start)
  }
  return(as.Date(x, floor_day))

}

