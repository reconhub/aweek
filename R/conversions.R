#' @export
#' @param tz passed on to [as.POSIXlt()]
#' @rdname date2week
as.POSIXlt.aweek <- function(x, tz, floor_day = FALSE, ...) {

  as.POSIXlt(as.Date(x, floor_day), tz, ...)

}


#' @export
#' @rdname date2week
as.character.aweek <- function(x, ...) {

  attr(x, "week_start") <- NULL
  NextMethod()

}
