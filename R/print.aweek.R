#' The aweek class
#'
#' The aweek class is a character or factor in the format YYYY-Www(-d) with a
#' "week_start" attribute containing an integer specifying which day of the ISO
#' 8601 week each week should begin. This documentation shows how to print or
#' subset the object.
#'
#' @param x an object of class `aweek`
#' @param ... a series of `aweek` objects (unused in `print.aweek()`)
#' @param recursive,use.names parameters passed on to [unlist()]
#'
#' @return an object of class `aweek`
#'
#'
#' @export
#' @rdname aweek-class
#' @seealso [date2week()], [as.Date.aweek()]
#' @examples
#' d <- as.Date("2018-12-20") + 1:40
#' w <- date2week(d, week_start = "Sunday")
#' print(w)
#'
#' # subsetting acts as normal
#' w[1:10]
#' 
#' # Combining multiple aweek objects
#' c(w[1], w[3], w[5])
#'
#' # differing week_start days will default to the attribute of the first 
#' # aweek object
#' mon <- date2week(Sys.Date(), week_start = "Monday")
#' mon
#' c(w, mon)
#' c(mon, w)
#'
#' # combining Dates will be coerced to aweek objects under the same rules
#' c(w, Sys.Date())
#'
#' # truncated aweek objects will be un-truncated
#' w2 <- date2week(d[1:5], week_start = "Monday", floor_day = TRUE)
#' w2
#' c(w[1:5], w2)
print.aweek <- function(x, ...) {

  tmp <- week2date("2019-W08-1", attr(x, "week_start"))
  cat(sprintf("<aweek start: %s>\n", format(tmp, "%A"))) 
  y <- x
  attr(x, "week_start") <- NULL
  class(x) <- class(x)[class(x) != "aweek"]
  NextMethod()
  invisible(y)

}

#' @export
#' @param i index for subsetting an aweek object.
#' @rdname aweek-class
`[.aweek` <- function(x, i) {

  ws <- attr(x, "week_start")
  x <- NextMethod()
  class(x) <- "aweek"
  attr(x, "week_start") <- ws
  x

}

#' @export
#' @param
#' @rdname aweek-class
c.aweek <- function(..., recursive = FALSE, use.names = TRUE) {

  the_dots   <- list(...)
  week_start <- attr(the_dots[[1]], "week_start")
  aweeks     <- vapply(the_dots, inherits, logical(1), "aweek")
  starts     <- vapply(the_dots[aweeks], attr, integer(1), "week_start")
  if (!all(starts == starts[1]) || !all(aweeks)) {
    the_dots <- lapply(the_dots, date2week, week_start = week_start)
  }
  res        <- unlist(the_dots, recursive = recursive, use.names = TRUE)
  class(res) <- "aweek"
  attr(res, "week_start") <- week_start
  res

}
