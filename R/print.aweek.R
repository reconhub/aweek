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
#' @description The methods for combining or modifying aweek objects require
#'   that any aweek obe
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
#' # Combining multiple aweek objects will only work if they have the same
#' # week_start day
#' c(w[1], w[3], w[5], as.aweek(as.Date("2018-12-01"), week_start = "Sunday"))
#'
#' # differing week_start days will throw an error
#' mon <- date2week(as.Date("2018-12-01"), week_start = "Monday")
#' mon
#' try(c(w, mon))
#'
#' # combining Dates will be coerced to aweek objects under the same rules
#' c(w, Sys.Date())
#'
#' # truncated aweek objects will be un-truncated
#' w2 <- date2week(d[1:5], week_start = "Sunday", floor_day = TRUE)
#' w2
#' c(w[1:5], w2)
print.aweek <- function(x, ...) {

  tmp <- week2date("2019-W08-1", attr(x, "week_start"))
  cat(sprintf("<aweek start: %s>\n", format(tmp, "%A"))) 
  y <- x
  attr(x, "week_start") <- NULL
  class(x) <- class(x)[class(x) != "aweek"]
  NextMethod("print")
  invisible(y)

}

#' @export
#' @param i index for subsetting an aweek object.
#' @rdname aweek-class
`[.aweek` <- function(x, i) {

  cl <- oldClass(x)
  ws <- attr(x, "week_start")
  xx  <- NextMethod("[")
  attr(xx, "week_start") <- ws
  oldClass(xx) <- cl
  xx

}

#' @export
#' @rdname aweek-class
`[[.aweek` <- function(x, i) {

  cl <- oldClass(x)
  ws <- attr(x, "week_start")
  xx  <- NextMethod("[[")
  attr(xx, "week_start") <- ws
  oldClass(xx) <- cl
  xx

}

#' @export
#' @param value a value to add or replace in an aweek object
#' @rdname aweek-class
`[<-.aweek` <- function(x, i, value) {

  ws <- attr(x, "week_start")
  cl <- oldClass(x)

  if (inherits(value, "aweek")) {
    if (ws != attr(value, "week_start")) {
      stop("aweek objects must have the same week_start attribute")
    }
  }

  if (inherits(value, c("Date", "POSIXt"))) {
    value <- date2week(value, week_start = ws)
  }

  xx <- NextMethod("[")

  attr(xx, "week_start") <- ws
  oldClass(xx) <- cl
  xx

}


#' @export
#' @rdname aweek-class
as.list.aweek <- function(x, ...) {

  xx <- NextMethod("as.list")
  xx <- lapply(xx, function(i, ws, cl){
                attr(i, "week_start") <- ws
                oldClass(i) <- cl
                i
  }, ws = attr(x, "week_start"), cl = oldClass(x))

  xx
}


#' @export
#' @rdname aweek-class
trunc.aweek <- function(x, ...) {

  if (inherits(x, "factor")) {
    levels(x) <- gsub("\\-\\d", "", levels(x))
  } else {
    x <- gsub("\\-\\d", "", x)
  }

  x

}


#' @export
#' @rdname aweek-class
rep.aweek <- function(x, ...) {

  ws <- attr(x, "week_start")
  cl <- oldClass(x)
  xx <- NextMethod("rep")
  attr(xx, "week_start") <- ws
  oldClass(xx) <- cl
  xx

}


#' @export
#' @rdname aweek-class
c.aweek <- function(..., recursive = FALSE, use.names = TRUE) {

  # Find all the aweek objects and test that they all have the same week_start
  # attribute. Throw an error if this isn't true
  the_dots   <- list(...)
  week_start <- get_week_start(the_dots[[1]])
  aweeks     <- vlogic(the_dots, inherits, "aweek")
  identical_week_starts <- vapply(the_dots[aweeks], get_week_start, integer(1)) == week_start

  if (!all(identical_week_starts)) {
    stop("All aweek objects must have the same week_start attribute. Please use change_week_start() to adjust the week_start attribute if you wish to combine these objects.")
  }

  # Find all the dates and convert them to aweek objects
  dates            <- vlogic(the_dots, inherits, c("Date", "POSIXt"))
  the_dots[dates]  <- lapply(the_dots[dates], date2week, week_start = week_start)

  # convert everything to characters and unlist them
  res <- unlist(lapply(the_dots, as.character), recursive = recursive, use.names = TRUE)
  
  # convert the characters to aweek objects
  as.aweek(res, week_start = week_start)

}
