#' Create an aweek object from an integer vector of weeks
#'
#' This is a vectorized function that takes in integer vectors and returns
#' an aweek object, making it easier to convert bare weeks to dates. 
#'
#' @param week an integer vector, defaults to 1, representing the first week of the year.
#' @param year an integer vector, defaults to the current year
#' @param day  an integer vector, defaults to 1, representing the first day of
#'   the first week of the year.
#' @param week_start an integer (or character) vector of days that the weeks
#'   start on
#' @param ... parameters passed on to [date2week()] 
#'
#' @note The aweek objects can only have one week_start attribute, which will
#'   default to the first one observed. If there is more than one week_start,
#'   then the weeks are first converted to dates with their respective 
#'   week_start variables and then converted to aweek objects with the first
#'   week_start variable. This allows for standardisation within a single data
#'   set. 
#' @export
#' @examples
#'
#' # The default results in the first week of the year
#' make_aweek()
#' as.Date(make_aweek())
#' 
#' # If you have a data frame of dates, you can use it to convert easily
#' mat <- matrix(c(
#'   2019, 11, 1, 7, # 2019-03-10
#'   2019, 11, 2, 7,
#'   2019, 11, 3, 7,
#'   2019, 11, 4, 7,
#'   2019, 11, 5, 7,
#'   2019, 11, 6, 7,
#'   2019, 11, 7, 7
#' ), ncol = 4, byrow = TRUE)
#' colnames(mat) <- c("year", "week", "day", "week_start")
#' m <- as.data.frame(mat)
#' m
#' sun <- with(m, make_aweek(week, year, day, week_start))
#' sun
#' as.Date(sun)
#' 
#' # You can also change starts
#' mon <- with(m, make_aweek(week, year, day, "Monday"))
#' mon
#' as.Date(mon)
#'
#' # If you use multiple week starts, it will convert to date and then to
#' # the correct week, so it won't appear to match up with the original
#' # data frame.
#' 
#' sft <- with(m, make_aweek(week, year, day, 7:1))
#' sft
#' as.Date(sft)
#'
make_aweek <- function(
                       week = 1L,
                       year = as.integer(format(Sys.Date(), "%Y")),
                       day  = 1L,
                       week_start = get_week_start(),
                       ...
                      ) {

  # if the week_start is length one, then we can just add it as a week
  # attribute and be done with it. Otherwise, we will have to convert to date
  # and then back to week.
  easy_week <- length(week_start) == 1

  if (is.character(week_start)) {
    if (easy_week) {
      week_start <- weekday_from_char(week_start)
    } else {
      week_start <- vapply(week_start, weekday_from_char, integer(1))
    }
  }
  stop_if_not_weekday(day)
  stop_if_not_weekday(week_start)

  if (easy_week) {
    out <- sprintf("%04d-W%02d-%d", year, week, day)
    attr(out, "week_start") <- week_start
    class(out) <- "aweek"
    return(out)
  }

  # converting to date and then to week
  mat <- matrix(NA_integer_, 
                ncol = 4L,
                nrow = max(length(year), length(week), length(day), length(week_start)),
               )
  colnames(mat) <- c("year", "week", "day", "week_start")
  mat[, "year"] <- year
  mat[, "week"] <- week
  mat[, "day"]  <- day
  mat[, "week_start"] <- week_start

  date2week(date_from_week_matrix(mat), week_start = week_start[1], ...)
}
