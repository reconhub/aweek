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

  xx <- NextMethod("as.character", x)
  names(xx) <- names(x)
  xx

}

#' @export
#' @rdname aweek-conversions
as.Date.aweek <- function(x, floor_day = FALSE, ...) {

  # The objective of this is to convert something like YYYY-Www(-d) to a date
  # with the additional information of the starting day of the week, represented
  # as the weekdays 1--7 starting on Monday.
  #
  # Steps:
  #
  # 1. create a matrix with three columns representing the year, week, and day
  #
  # 2. find the weekday (relative to week_start) that represents 1 January.
  #
  # 3. subtract a week if the weekday is before the 4th day because that means
  #    that the previous year was included in the week counts
  #    
  # 4. determine the first date of the year by subtracting the weekday (relative
  #    to week_start) from 1 January
  #
  # 5. add the weeks_as_days plus the number of days minus one to get the dates
  #
  week_start <- attr(x, "week_start")
  x          <- as.character(x)
  # Regex pattern for YYYY-Www(-d).
  #
  # note: ?<name> is a way to name the output
  if (floor_day) {
    pat <- "^(?<year>[0-9]{4})-W(?<week>[0-9]{2})"
  } else {
    pat <- "^(?<year>[0-9]{4})-W(?<week>[0-9]{2})-*(?<day>[0-9])*$"
  }
  # Search the strings ane return a list where the result is either 1 or NA
  # with a bunch of attributes attached. 
  #
  # Example:
  # attributes(gregexpr(pat, "2019-W10", perl = TRUE)[[1]])
  # $match.length
  # [1] 8
  # 
  # $index.type
  # [1] "chars"
  # 
  # $useBytes
  # [1] TRUE
  # 
  # $capture.start
  #      year week day
  # [1,]    1    7   0
  # 
  # $capture.length
  #      year week day
  # [1,]    4    2   0
  # 
  # $capture.names
  # [1] "year" "week" "day" 
  # 
  res <- gregexpr(pat, x, perl = TRUE)
  out <- matrix(NA_integer_, ncol = 3, nrow = length(x))

  for (i in seq_along(res)) {
    if (is.na(x[[i]])) next # skip if x[[i]] is nothing
    p   <- attributes(res[[i]]) 
    ywd <- substring(x[[i]], 
                     first = p$capture.start, 
                     last  = p$capture.start + p$capture.length - 1)
    names(ywd) <- p$capture.names
    out[i, ] <- as.integer(ywd[c("year", "week", "day")])
  }

  colnames(out) <- c("year", "week", "day")

  # replace any truncated aweeks with the first day of the week
  out[, "day"] <- ifelse(is.na(out[, "day"]), 1L, out[, "day"])

  # missing years are set to NA 
  january_1 <- ifelse(is.na(out[, "year"]), NA, sprintf("%s-01-01", out[, "year"]))
  january_1 <- as.Date(january_1, tz = "UTC")
  j1_day    <- get_wday(january_1, week_start) - 1L

  # If the previous year is included in this year's first date, subtract a week
  j1_is_first <- as.integer(j1_day < 4)
  weeks_as_days <- (out[, "week"] - j1_is_first) * 7L
  first_week <- january_1 - j1_day

  the_dates <- first_week + (weeks_as_days + out[, "day"] - 1L)
  names(the_dates) <- names(x)
  the_dates

}

