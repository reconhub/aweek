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

  as.POSIXlt(as.character(as.Date(x, floor_day)), tz = tz, ...)

}


#' @export
#' @rdname aweek-conversions
as.character.aweek <- function(x, ...) {

  attr(x, "week_start") <- NULL
  NextMethod()

}

#' @export
#' @rdname aweek-conversions
as.Date.aweek <- function(x, floor_day = FALSE, ...) {

  week_start <- attr(x, "week_start")
  x          <- as.character(x)
  if (floor_day) {
    pat <- "^(?<year>[0-9]{4})-W(?<week>[0-9]{2})"
  } else {
    pat <- "^(?<year>[0-9]{4})-W(?<week>[0-9]{2})-*(?<day>[0-9])*$"
  }
  res <- gregexpr(pat, x, perl = TRUE)
  out <- matrix(NA_integer_, ncol = 3, nrow = length(x))

  for (i in seq_along(res)) {
    if (is.na(x[[i]])) next
    p   <- attributes(res[[i]]) 
    ywd <- substring(x[[i]], 
                     first = p$capture.start, 
                     last  = p$capture.start + p$capture.length - 1)
    names(ywd) <- p$capture.names
    out[i, ] <- as.integer(ywd[c("year", "week", "day")])
  }

  colnames(out) <- c("year", "week", "day")
  out[, "day"] <- ifelse(is.na(out[, "day"]), 1, out[, "day"])
  january_1 <- ifelse(is.na(out[, "year"]), NA, sprintf("%s-01-01", out[, "year"]))
  january_1 <- as.Date(january_1, tz = "UTC")
  j1_day    <- get_wday(january_1, week_start) - 1L

  # If the previous year is included in this year's first date, subtract a week
  j1_is_first <- as.integer(j1_day < 4)
  weeks_as_days <- (out[, "week"] - j1_is_first) * 7L
  first_week <- january_1 - j1_day

  unname(first_week + (weeks_as_days + out[, "day"] - 1L))

}

