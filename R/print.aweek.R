#' @export
#' @rdname date2week
print.aweek <- function(x, ...) {

  tmp <- week2date("2019-W08-1", attr(x, "week_start"))
  cat(sprintf("<aweek start: %s>\n", format(tmp, "%A"))) 
  y <- x
  attr(x, "week_start") <- NULL
  class(x) <- class(x)[class(x) != "aweek"]
  NextMethod()
  invisible(y)

}

