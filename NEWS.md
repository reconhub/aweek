# aweek 0.2.0

* Subsetting and concatenating methods added to the `aweek` class (see #1)
* Documentation divided into smaller chunks
* `as.POSIXlt()` bug where `tz` was not being passed was fixed.
* `date2week()`: an error is now issued if users specify non-ISO 8601 dates OR
  don't specify a `format` option. (found: @scottyaz, #2)
* Best practices added to vignette
* Fix test that would fail every seven days on CRAN

# aweek 0.1.0

* First official release of aweek on CRAN

# aweek 0.0.5.9000

* `date2week()` and `week2date()` can now take days represented as characters in
  the current or English locale. 

# aweek 0.0.4.9000

* `date2week()` gains a `factor` argument, which will automatically compute the
  levels within the date range.

# aweek 0.0.3.9000

* `date2week()` now properly accounts for dates in December that occur in the
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
