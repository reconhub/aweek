# aweek 1.0.1

## CRAN MAINTENANCE

* `as.POSIXlt()` now converts NULL to an empty POSIXlt object, so a test that
  was previously checking for an error failed. That test has been fixed
  (#33, @zkamvar)

# aweek 1.0.0

## NEW FUNCTIONS

* `change_week_start()` allows the user to change the `week_start` attribute of
  an aweek object, adjusting the weeks to match the new attribute accordingly.
* `get_aweek()` can generate aweek objects from a vector of week numbers. It has
  the ability to take into account different week start times. 
* `get_date()` is similar to `get_aweek()`, but returns dates instead.
* `as.aweek()` allows users to create aweek object directly from characters with
  validation. It also allows for dates by passing to `date2week()`.
* `as.data.frame.aweek()` is a new function that allows aweek objects to be
  directly incorporated into data frames.
* `as.list.aweek()` will now preserve the aweek structure in lists
* `trunc.aweek()` will truncate the day to the first day of the week. 
* `rep.aweek()` allows repeating aweek characters.
* `factor_aweek()` allows the user to create aggregated aweek objects on the fly.

## BREAKING CHANGES

There are a couple of breaking changes coming to aweek that will improve
stability by removing unclear coercion methods
(see https://github.com/reconhub/aweek/issues/20).

* It is no longer possible to combine aweek objects if they do not share the
  same `week_start` attribute. This will result in an error informing the user
  to adjust the `week_start` attribute with the `change_week_start()` function.
* Factors will no longer coerce factors when combining aweek objects. 
* Using `date2week()` with `factor = TRUE` and `floor_day = FALSE` now throws an
  error instead of a warning (as prophesized in #13).

## DOCUMENTATION

* The vignette has been updated to include an explanation of the underlying
  week calculation from date.
* The aweek class documentation has been updated to detail the different
  elements of the object and the calculations. 
* Package documentation `package?aweek` has been added for an introduction.

## BUG FIX

* conversions will now retain the names of the object.

## MISC

* More checks that weekdays and weeks are within the correct bounds have been
  added. 
* as.Date.aweek has been simplified to no longer rely on regex since the aweek
  class is standard.
* The internal `get_wday()` has been vastly simplified with improved speed.

# aweek 0.3.0

* The `week_start` argument now defaults to the global option `aweek.week_start`,
  which will be a number from 1 to 7, representing the days of the week in the
  ISO 8601 standard.
* `set_week_start()` is a convenience allowing the user to set the default 
  `aweek.week_start` option via integer or character input.
* `get_week_start()` is a wrapper for `getOption("aweek.week_start", 1L)` and
  `attr(w, "week_start")` for aweek objects.

# aweek 0.2.2

* Simplified conversion to factors.
* Using `factor = TRUE` without `floor_day = TRUE` will now issue a message
  indicating that this is deprecated in future versions of aweek (see #13).

# aweek 0.2.1

* Fix bug where NAs threw errors in the dates (found: @aspina7, #12)

* `as.data.frame.aweek()` will now convert aweek objects to columns of data
  frames without losing class or attributes
* The introduction vignette has been updated to reflect this change. 

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
* `as.character()` will unclass the `aweek` object
* Added a `NEWS.md` file to track changes to the package.
