#' Convert dates to weeks and back again
#'
#' The aweek package is a lightweight solution for converting dates to weeks
#' that can start on any weekday. It implements the [aweek class][aweek-class],
#' which can easily be converted to date and weeks that start on different days.
#'
#' 
#' @section Before you begin: 
#'
#' When you work with aweek, you will want to make sure that you set the default
#' `week_start` variable to indicate which day of the week your weeks should
#' begin. This can be done with [set_week_start()]. It will ensure that all of
#' your weeks will begin on the same day.
#'  
#'  - [get_week_start()] returns the global week_start option
#'  - [set_week_start()] sets the global week_start option
#'
#' @section Conversions:
#'
#' \subsection{Dates to weeks}{
#'
#' This conversion is the simplest because dates are unambiguous.
#' 
#'  - [date2week()] converts dates, datetimes, and characters that look like dates to weeks
#'  - [as.aweek()] is a wrapper around [date2week()] that converts dates and datetimes
#' 
#' }
#' \subsection{Week numbers to weeks or dates}{
#' 
#' If you have separate columns for week numbers and years, then this is the
#' option for you. This allows you to specify a different start for each week
#' element using the `start` argument.
#'
#'  - [get_aweek()] converts week numbers (with years and days) to [aweek objects][aweek-class].
#'  - [get_date()] converts week numbers (with years and days) to [Dates][Date].
#'
#' }
#' \subsection{ISO week strings (YYYY-Www-d or YYYY-Www) to weeks or dates}{
#'
#'  - [as.aweek()] converts ISO-week formatted strings to [aweek objects][aweek-class]. 
#'  - [week2date()] converts ISO-week formatted strings to [Date][Date].
#'
#' }
#' \subsection{aweek objects to dates or datetimes}{
#'
#' This conversion is simple for [aweek][aweek-class] objects since their
#' week_start is unambiguous
#'
#'  - [as.Date()][as.Date.aweek()] converts to [Date][Date]. 
#'  - [as.POSIXlt()][as.POSIXlt.aweek()] converts to [POSIXlt][POSIXlt]. 
#'
#' }
#'
#' \subsection{aweek objects to characters}{
#'
#'  You can strip the week_start attribute of the aweek object by converting to
#'  a character with [as.character()]
#'
#' }
#' @section Manipulating aweek objects:
#'   
#'  - [trunc()] removes the weekday element of the ISO week string.
#'  - [factor_aweek()] does the same thing as trunc(), but will create a factor
#'    with levels spanning all the weeks from the first week to the last week.
#'    Useful for creating tables with zero counts for unobserved weeks.
#'  - [change_week_start()] will change the week_start attribute and adjust the
#'    weeks accordingly so that the dates will always be consistent. 
#'
#' When you combine aweek objects, they must have the same week_start attribute.
#' Characters can be added to aweek objects as long as they are in ISO week
#' format and you can safely assume that they start on the same weekday. Dates
#' are trivial to add to aweek objects. See the [aweek-class][aweek-class]
#' documentation for details.
#'
#'
#' @name aweek-package
#' @docType package 
#' @examples
#' # At the beginning of your analysis, set the week start to the weeks you want
#' # to use for reporting
#' ow <- set_week_start("Sunday")
#'
#' # convert dates to weeks
#' d <- as.Date(c("2014-02-11", "2014-03-04"))
#' w <- as.aweek(d) 
#' w
#' 
#' # get the week numbers
#' date2week(d, numeric = TRUE)
#'
#' # convert back to date
#' as.Date(w)
#' 
#' # convert to factor
#' factor_aweek(w)
#' 
#' # append a week
#' w[3] <- as.Date("2014-10-31")
#' w 
#'
#' # change week start variable (if needed)
#' change_week_start(w, "Monday")
#' 
#' # note that the date remains the same
#' as.Date(change_week_start(w, "Monday"))
#'
#' # Don't forget to reset the week_start at the end
#' set_week_start(ow)
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
