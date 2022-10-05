#' Convert aweek objects to characters or dates
#'
#' @param x an object of class [aweek][print.aweek]. 
#' @param tz passed on to [as.POSIXlt()]
#' @param ... parameters passed to `as.POSIXlt()`.
#' @inheritParams date2week
#'
#' @export
#' @rdname aweek-conversions
#' @seealso [date2week()] [print.aweek()]
#' @examples
#' w <- date2week(Sys.Date(), week_start = "Sunday")
#' w
#' # convert to POSIX
#' as.POSIXlt(w)
#' as.POSIXlt(w, floor_day = TRUE)
#' as.POSIXlt(w, floor_day = TRUE, tz = "KST")
#'
#' # convert to date
#' as.Date(w)
#' as.Date(w, floor_day = TRUE)
#' 
#' # convert to character (strip attributes)
#' as.character(w)
as.POSIXlt.aweek <- function(x, tz = "", floor_day = FALSE, ...) {

  as.POSIXlt(as.Date(x, floor_day), tz = tz, ...)

}


#' @export
#' @rdname aweek-conversions
as.character.aweek <- function(x, ...) {

  xx <- NextMethod("as.character", x)
  names(xx) <- names(x)
  xx

}

