#' Convert aweek objects to a data frame
#'
#' @param x an aweek object
#' @param ... unused
#'
#' @return a data frame with an aweek column
#' @export
#' @seealso [date2week()] [print.aweek()]
#' @examples
#'
#' d  <- as.Date("2019-03-25") + 0:6
#' w  <- date2week(d, "Sunday")
#' dw <- data.frame(date = d, week = w)
#' dw
#' dw$week
as.data.frame.aweek <- function(x, ...) {
  nm <- deparse(substitute(x))
  as.data.frame.vector(x, ..., nm = nm, stringsAsFactors = FALSE)
}
