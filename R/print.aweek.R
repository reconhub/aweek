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
#' @description The method `c.aweek()` will always return an `aweek` object with
#'   the same `week_start` attribute as the first object in the list. If the
#'   first object is also a factor, then the output will be re-leveled. If
#'   week-like characters are presented (e.g. "2019-W10-1"), then these are
#'   assumed to have the same `week_start` as the first object. 
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
  NextMethod("print")
  invisible(y)

}

#' @export
#' @param i index for subsetting an aweek object.
#' @rdname aweek-class
`[.aweek` <- function(x, i) {

  ws <- attr(x, "week_start")
  y  <- NextMethod("[")
  attr(y, "week_start") <- ws
  class(y) <- union("aweek", oldClass(y))
  y

}

#' @export
#' @rdname aweek-class
`[[.aweek` <- function(x, i) {

  ws <- attr(x, "week_start")
  y  <- NextMethod("[[")
  attr(y, "week_start") <- ws
  class(y) <- union("aweek", oldClass(y))
  y

}

#' @export
#' @param value a value to add or replace in an aweek object
#' @rdname aweek-class
`[<-.aweek` <- function(x, i, value) {

  y <- x
  class(y) <- class(y)[-1]
  ffff <- is.factor(y)
  flda <- grepl("^\\d{4}-W\\d{2}$", y[1])
  # TODO: handle char objects
  # TODO: handle aweek objects (both char and factor :cringe:)
  y[i] <- date2week(value, attr(x, "week_start"), floor_day = flda, factor = ffff) 
  class(y) <- "aweek"
  y

}


#' @export
#' @rdname aweek-class
as.list.aweek <- function(x, ...) {

  xx <- NextMethod("as.list")
  xx <- lapply(xx, function(i, ws, cl){
                attr(i, "week_start") <- ws
                class(i) <- cl
                i
  }, ws = attr(x, "week_start"), cl = class(x))

  xx
}


#' @export
#' @rdname aweek-class
trunc.aweek <- function(x, ...) {

  gsub("\\-\\d", "", x)

}

#' @export
#' @rdname aweek-class
c.aweek <- function(..., recursive = FALSE, use.names = TRUE) {

  the_dots   <- list(...)
  is_factor  <- is.factor(the_dots[[1]])
  week_start <- attr(the_dots[[1]], "week_start")
  aweeks     <- vlogic(the_dots, inherits, "aweek")
  factors    <- vlogic(the_dots, inherits, "factor")
  if (any(factors)) {
    the_dots[factors] <- lapply(the_dots[factors], date2week, week_start = week_start) 
  }
  starts     <- vapply(the_dots[aweeks], attr, integer(1), "week_start")
  if (!all(starts == starts[1]) || !all(aweeks)) {
    # Find all characters that are aweeks without the attributes
    are_chars  <- !aweeks & vlogic(the_dots, inherits, c("character", "factor"))
    if (any(are_chars)) {
      the_dots[are_chars] <- lapply(the_dots[are_chars], as.character)
      are_weeks <- are_chars & vallgrep(the_dots, "\\d{4}-W\\d{2}-?[1-7]?")
      if (any(are_weeks)) {
        # convert the week chars to dates if they exist
        the_dots[are_weeks] <- lapply(the_dots[are_weeks], week2date, week_start = week_start)
      }
    }
    the_dots <- lapply(the_dots, date2week, week_start = week_start)
  }
  res        <- unlist(the_dots, recursive = recursive, use.names = TRUE)
  class(res) <- "aweek"
  attr(res, "week_start") <- week_start
  if (is_factor) {
    res <- date2week(res, week_start = week_start, factor = TRUE)
  }
  res

}
