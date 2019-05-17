
stop_if_not_weekday <- function(x) {

  not_date <- !inherits(x, c("Date", "POSIXt"))

  if (not_date && any(!is.na(x) & (x < 1L | x > 7L))) {
    stop("Weekdays must be between 1 and 7")
  }

  invisible(NULL)

}

stop_if_not_valid_week <- function(x) {

  if (any(!is.na(x) & (x > 53 | x < 1))) {
    stop("Weeks must be between 1 and 53")
  }
  invisible(NULL)

}

test_aweek_string <- function(x) {

  nas  <- is.na(x)
  okay <- grepl("[0-9]{4}-W(?=[0-5])[0-9]-?[1-7]?", x, perl = TRUE)
  if (!all(okay[!nas])) {
    stop(sprintf(
         "aweek strings must match the pattern 'YYYY-Www-d'. The first incorrect string was: '%s'",
         x[!nas & !okay][1]
        ))
  }

  invisible(NULL)
 
}
