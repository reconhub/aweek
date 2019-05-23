#' The aweek class
#'
#' The aweek class is a character or factor in the format YYYY-Www(-d) with a
#' "week_start" attribute containing an integer specifying which day of the ISO
#' 8601 week each week should begin. 
#'
#' @param x an object of class `aweek`
#' @param ... a series of `aweek` objects, characters, or Dates, (unused in `print.aweek()`)
#' @param recursive,use.names parameters passed on to [unlist()]
#'
#' @return an object of class `aweek`
#'
#' @details Weeks differ in their start dates depending on context. The ISO
#'   8601 standard specifies that Monday starts the week
#'   (<https://en.wikipedia.org/wiki/ISO_week_date>) while the US CDC uses
#'   Sunday as the start of the week
#'   (<https://wwwn.cdc.gov/nndss/document/MMWR_Week_overview.pdf>). For
#'   example, MSF has varying start dates depending on country in order to
#'   better coordinate response. 
#'
#'   While there are packages that provide conversion for ISOweeks and epiweeks,
#'   these do not provide seamless conversion from dates to epiweeks with 
#'   non-standard start dates. This package provides a lightweight utility to
#'   be able to convert each day.
#'
#'   \subsection{Structure of the aweek object}{
#'   
#'   The aweek object is a character vector in either the precise ISO week
#'   format (YYYY-Www-d) or imprecise ISO week format (YYYY-Www) with 
#'   a `week_start` attribute indicating which ISO week day the week begins.
#'   The precise ISO week format can be broken down like this:
#'
#'    - **YYYY** is an ISO week-numbering year, which is the year relative to
#'      the week, not the day. For example, the date 2016-01-01 would be 
#'      represented as 2015-W53-5 (ISO week), because while the date is in the
#'      year 2016, the week is still part of the final week of 2015.
#'    - W**ww** is the week number, prefixed by the character "W". This ranges
#'      from 01 to 52 or 53, depending on whether or not the year has 52 or 53
#'      weeks.
#'    - **d** is a digit representing the weekday where 1 represents the first
#'      day of the week and 7 represents the last day of the week. The day of
#'      of the week (d) relative to the week start (s) is calculated using the
#'      ISO week day (i) via `d = 1L + ((i + (7L - s)) %% 7L)`. 
#'
#'    The attribute `week_start` represents the first day of the week as an ISO
#'    week day. This defaults to 1, which is Monday. If, for example, an aweek
#'    object represented weeks starting on Friday, then the `week_start`
#'    attribute would be 5, which is Friday of the ISO week.
#'
#'   Imprecise formats (YYYY-Www) are equivalent to the first day of the week.
#'   For example, 2015-W53 and 2015-W53-1 will be identical when converted to
#'   date. 
#'
#'   }
#'
#' @note when combining aweek objects together, you must ensure that they have
#'   the same week_start attribute. You can use [change_week_start()] to adjust
#'   it.
#'  
#'
#' @export
#' @aliases aweek-class
#' @rdname aweek-class
#' @seealso [date2week()], [get_aweek()], [as.Date.aweek()], [change_week_start()]
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

  if (inherits(value, "character")) {
    value <- as.aweek(value, week_start = get_week_start(x)) 
  }

  if (inherits(value, c("Date", "POSIXt"))) {
    value <- date2week(value, week_start = ws)
  }

  if (all(is.na(value))) {
    value <- as.aweek(as.character(value), week_start = ws)
  }

  if (!inherits(value, "aweek")) {
    stop(sprintf("Cannot add an object of class '%s' to an aweek object", 
         paste(class(value), collapse = ", ")))
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
  res <- unlist(lapply(the_dots, as.character), recursive = recursive, use.names = FALSE)
  
  date_chars <- grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", res, perl = TRUE)
  res[date_chars] <- as.character(date2week(res[date_chars], week_start = week_start))
  # convert the characters to aweek objects
  out <- get_aweek(week = substr(res, 7, 8), 
                   year = substr(res, 1, 4),
                   day  = substr(res, 10, 11),
                   start = week_start,
                   week_start = week_start
                   ) 
  names(out) <- names(res)
  out

}
