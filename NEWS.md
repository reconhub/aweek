# aweek 0.0.3.9000

* `date2week()` now properly accounts for dates in december that occur in the
  first week of the next year. 

# aweek 0.0.2.9000

* `floor_day` now truncates the week instead changing the last digit to 1 for
  aesthetics. (Thanks to @aspina7 for the suggestion)
q `print.aweek()` now displays the day of the week in the current locale.

# aweek 0.0.1.9000

* First version of package
* `date2week()` converts dates to `aweek` objects
* `week2date()` converts `aweek` objects or character strings to dates
* `as.Date()` does the same thing as above
* `as.POSIXlt()` as well
* `as.character()` unclasses the `aweek` object
* Added a `NEWS.md` file to track changes to the package.
