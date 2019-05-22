#' @export
#' @rdname aweek-conversions
as.Date.aweek <- function(x, floor_day = FALSE, ...) {

  # The objective of this is to convert something like YYYY-Www(-d) to a date
  # with the additional information of the starting day of the week, represented
  # as the weekdays 1--7 starting on Monday.
  #
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
  out <- matrix(NA_integer_, ncol = 4, nrow = length(x))
  colnames(out) <- c("year", "week", "day", "week_start")
  out[, "week_start"] <- week_start

  ywdnames <- c("year", "week", "day")

  for (i in seq_along(res)) {
    if (is.na(x[[i]])) next # skip if x[[i]] is nothing
    p   <- attributes(res[[i]]) 
    ywd <- substring(x[[i]], 
                     first = p$capture.start, 
                     last  = p$capture.start + p$capture.length - 1)
    names(ywd) <- p$capture.names
    out[i, ywdnames] <- as.integer(ywd[ywdnames])
  }

  the_dates <- date_from_week_matrix(out)
  names(the_dates) <- names(x)
  the_dates

}

