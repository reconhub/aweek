rw_date2week <- function(x, week_start = 7, numeric = FALSE, ...) {

  x <- try(as.POSIXlt(x))
  if (inherits(x, "try-error")) {
    stop(sprintf("there is no method for an object of class %s", 
                 paste(class(x), collapse = ", "))) 
  }
  wday       <- as.integer(x$wday) + 1L # bring the date to 1:7
  week_start <- as.integer(week_start)

  wday <- get_wday(wday, week_start)
  the_date <- as.Date(x)
  the_week_bounds <- the_date + (4L - wday)
  res <- week_in_year(the_week_bounds)
  
  first_week_is_last_year <- grepl("01", format(the_date, "%m")) && res >= 52
  if (!numeric) {
    the_year <- as.integer(format(the_date, "%Y"))
    res <- sprintf("%04d-W%02d-%d", 
                   the_year - first_week_is_last_year,
                   res,
                   wday
                   )
  }
  res
}

get_wday <- function(x, s) { 
  if (inherits(x, c("Date", "POSIXt"))) {
    x <- as.integer(as.POSIXlt(x, tz = "UTC")$wday + 1L)
  }
  if (s != 7L) 1L + (x + (6L - s)) %% 7L else x
}

week_in_year <- function(the_date) {
  jan1 <- as.Date(sprintf("%s-01-01", format(the_date, "%Y")))
  1L + (as.numeric(the_date) - as.numeric(jan1)) %/% 7L
}

rw_week2date <- function(x, week_start = 7) {

  pat <- "^(?<year>[0-9]{4})-W(?<week>[0-9]{2})-(?<day>[0-9])$"
  res <- gregexpr(pat, x, perl = TRUE)
  out <- matrix(NA_integer_, ncol = 3, nrow = length(x))

  for (i in seq_along(res)) {
    p <- attributes(res[[i]]) 
    ywd <- substring(x[[i]], 
                     first = p$capture.start, 
                     last  = p$capture.start + p$capture.length - 1)
    names(ywd) <- p$capture.names
    out[i, ] <- as.integer(ywd)
  }
  colnames(out) <- c("year", "week", "day")
  january_1 <- ifelse(is.na(out[, "year"]), NA, sprintf("%s-01-01", out[, "year"]))
  january_1 <- as.Date(january_1, tz = "UTC")
  j1_day    <- get_wday(january_1, week_start) - 1L
  j1_is_first <- as.integer(j1_day < 3)
  weeks_as_days <- (out[, "week"] - j1_is_first) * 7L
  first_week <- january_1 - j1_day
  
  unname(first_week + (weeks_as_days + out[, "day"] - 1L))

}

