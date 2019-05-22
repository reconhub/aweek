#' Helper function to find the weekday from a character string
#'
#' @param x a character string specifying the weekday in the current locale or
#'   English.
#'
#' @return an integer from 1 to 7 indicating the day of the ISO 8601 week.
#' @keywords internal
#' @noRd
#' @examples
#' 
#' # Will always work
#' weekday_from_char("Monday")
#' weekday_from_char("Tue")
#' weekday_from_char("W")
#'
#' # Change to a German locale
#' lct <- Sys.getlocale("LC_TIME")
#' Sys.setlocale("LC_TIME", "de_DE.utf8")
#'
#' weekday_from_char("Sonntag")
#' 
#' # Reset locale
#' Sys.setlocale("LC_TIME", lct)
weekday_from_char <- function(x) {

  # First try with an English locale
  w        <- c("monday", "tuesday", "wednesday", "thursday", "friday",
                "saturday", "sunday")
  weekdate <- grep(x, w, ignore.case = TRUE)

  if (length(weekdate) == 0) {
    # find the definitions of the weekdays in the current locale
    w        <- weekdays(as.Date(get_aweek(day = 1:7, week_start = 1L)))
    weekdate <- grep(x, w, ignore.case = TRUE)
  }

  if (length(weekdate) != 1) {
    msg <- paste("The weekday '%s' did not match any of the valid weekdays in", 
                 "the current locale ('%s') or an English locale:\n  %s")
    stop(sprintf(msg, x, Sys.getlocale('LC_TIME'), paste(w, collapse = ", ")), 
         call. = FALSE)
  }

  return(weekdate)

}
