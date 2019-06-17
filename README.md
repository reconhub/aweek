
<!-- badges: start -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version-ago/aweek)](https://cran.r-project.org/package=aweek)
[![Codecov test
coverage](https://codecov.io/gh/reconhub/aweek/branch/master/graph/badge.svg)](https://codecov.io/gh/reconhub/aweek?branch=master)
[![Travis build
status](https://travis-ci.org/reconhub/aweek.svg?branch=master)](https://travis-ci.org/reconhub/aweek)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/66xj9134ac3yg62l/branch/master?svg=true)](https://ci.appveyor.com/project/zkamvar/aweek)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/aweek?color=ff69b4)](https://cran.r-project.org/package=aweek)
[![DOI](https://zenodo.org/badge/172648833.svg)](https://zenodo.org/badge/latestdoi/172648833)

<!-- badges: end -->

# Welcome to the *aweek* package\!

This package will convert dates to [US CDC
epiweeks](https://wwwn.cdc.gov/nndss/document/MMWR_Week_overview.pdf),
[isoweeks](https://en.wikipedia.org/wiki/ISO_week_date), and all others
in between with minimal overhead.

## Installing the package

To install the stable package version from CRAN, you can use

``` r
install.packages("aweek")
```

To benefit from the latest features and bug fixes, install the
development, *github* version of the package using:

``` r
# install.packages("remotes")
remotes::install_github("reconhub/aweek")
```

# Main Features

  - `date2week()` converts dates to a week format (YYYY-Www-d) that can
    start on any day.
  - `week2date()` / `as.Date()` does the backwards conversion from
    (YYYY-Www(-d)) to a numeric date.
  - `get_aweek()` generates an aweek object from a week number
  - `get_date()` converts a week number to a date
  - `as.aweek()` converts dates, characters, and factors to aweek
    objects.
  - `factor_aweek()` creates an aggregated factor of weeks where the
    levels contain all weeks within range.
  - Dependencies only on R itself.

<!-- -->

## Dates to weeks

With the *aweek* package, converting dates to weeks is simple. All you
need to know is what weekday represents the beginning of your week and a
vector of dates.

``` r
# generate dates
set.seed(2019-02-26)
onset <- as.Date("2019-02-26") + sort(sample(-6:7, 20, replace = TRUE))

# load aweek
library("aweek")
set_week_start("Monday") # set the default start of the week

print(onset)
```

    ##  [1] "2019-02-21" "2019-02-21" "2019-02-22" "2019-02-22" "2019-02-22"
    ##  [6] "2019-02-23" "2019-02-23" "2019-02-23" "2019-02-25" "2019-02-26"
    ## [11] "2019-02-26" "2019-02-27" "2019-02-28" "2019-02-28" "2019-03-02"
    ## [16] "2019-03-03" "2019-03-04" "2019-03-05" "2019-03-05" "2019-03-05"

``` r
date2week(onset) # convert dates to weeks
```

    ## <aweek start: Monday>
    ##  [1] "2019-W08-4" "2019-W08-4" "2019-W08-5" "2019-W08-5" "2019-W08-5"
    ##  [6] "2019-W08-6" "2019-W08-6" "2019-W08-6" "2019-W09-1" "2019-W09-2"
    ## [11] "2019-W09-2" "2019-W09-3" "2019-W09-4" "2019-W09-4" "2019-W09-6"
    ## [16] "2019-W09-7" "2019-W10-1" "2019-W10-2" "2019-W10-2" "2019-W10-2"

If you want to override the default, you can use the `week_start`
attribute of
`date2week()`:

``` r
date2week(onset, week_start = 1) # ISO weeks starting on Monday (default)
```

    ## <aweek start: Monday>
    ##  [1] "2019-W08-4" "2019-W08-4" "2019-W08-5" "2019-W08-5" "2019-W08-5"
    ##  [6] "2019-W08-6" "2019-W08-6" "2019-W08-6" "2019-W09-1" "2019-W09-2"
    ## [11] "2019-W09-2" "2019-W09-3" "2019-W09-4" "2019-W09-4" "2019-W09-6"
    ## [16] "2019-W09-7" "2019-W10-1" "2019-W10-2" "2019-W10-2" "2019-W10-2"

``` r
date2week(onset, week_start = 7) # EPI week starting on Sunday
```

    ## <aweek start: Sunday>
    ##  [1] "2019-W08-5" "2019-W08-5" "2019-W08-6" "2019-W08-6" "2019-W08-6"
    ##  [6] "2019-W08-7" "2019-W08-7" "2019-W08-7" "2019-W09-2" "2019-W09-3"
    ## [11] "2019-W09-3" "2019-W09-4" "2019-W09-5" "2019-W09-5" "2019-W09-7"
    ## [16] "2019-W10-1" "2019-W10-2" "2019-W10-3" "2019-W10-3" "2019-W10-3"

``` r
date2week(onset, week_start = 6) # EPI week starting on Saturday
```

    ## <aweek start: Saturday>
    ##  [1] "2019-W08-6" "2019-W08-6" "2019-W08-7" "2019-W08-7" "2019-W08-7"
    ##  [6] "2019-W09-1" "2019-W09-1" "2019-W09-1" "2019-W09-3" "2019-W09-4"
    ## [11] "2019-W09-4" "2019-W09-5" "2019-W09-6" "2019-W09-6" "2019-W10-1"
    ## [16] "2019-W10-2" "2019-W10-3" "2019-W10-4" "2019-W10-4" "2019-W10-4"

``` r
x <- date2week(onset, week_start = "sat", floor_day = TRUE) # truncate to just the weeks
table(x)
```

    ## x
    ## 2019-W08 2019-W09 2019-W10 
    ##        5        9        6

``` r
table(week2date(x))
```

    ## 
    ## 2019-02-16 2019-02-23 2019-03-02 
    ##          5          9          6

## Weeks to dates

If you have numeric weeks, you can rapidly convert to dates with
`get_date()`. Here are all the dates for the first day of last 10 ISO
weeks of
    2015:

``` r
get_date(week = 44:53, year = 2015)
```

    ##  [1] "2015-10-26" "2015-11-02" "2015-11-09" "2015-11-16" "2015-11-23"
    ##  [6] "2015-11-30" "2015-12-07" "2015-12-14" "2015-12-21" "2015-12-28"

``` r
# you can also use this to generate aweek objects
get_aweek(week = 44:53, year = 2015)
```

    ## <aweek start: Monday>
    ##  [1] "2015-W44-1" "2015-W45-1" "2015-W46-1" "2015-W47-1" "2015-W48-1"
    ##  [6] "2015-W49-1" "2015-W50-1" "2015-W51-1" "2015-W52-1" "2015-W53-1"

If you have weeks recorded from different data sets that start on
different days, you can account for that by using the `start` option.
For example, 2018-01-01 is a Monday, but 2018-W01-1 starting on a Sunday
is 2017-12-31

``` r
get_date(week = 1, year = 2018, day = 1, start = c("Sunday", "Monday"))
```

    ## [1] "2017-12-31" "2018-01-01"

``` r
# get_aweek will align them to the default week_start
get_aweek(week = 1, year = 2018, day = 1, start = c("Sunday", "Monday"))
```

    ## <aweek start: Monday>
    ## [1] "2017-W52-7" "2018-W01-1"

## Factors

You can also automatically calculate factor levels, which is useful in
tabulating across weeks and including missing values.

``` r
set.seed(2019-02-26)
onset <- as.Date("2019-02-26") + sort(sample(-48:49, 20, replace = TRUE))
x     <- date2week(onset, week_start = "sat", factor = TRUE)
x
```

    ## <aweek start: Saturday>
    ##  [1] 2019-W03 2019-W03 2019-W04 2019-W04 2019-W04 2019-W05 2019-W05
    ##  [8] 2019-W05 2019-W06 2019-W06 2019-W06 2019-W09 2019-W09 2019-W10
    ## [15] 2019-W11 2019-W12 2019-W12 2019-W14 2019-W15 2019-W15
    ## 13 Levels: 2019-W03 2019-W04 2019-W05 2019-W06 2019-W07 ... 2019-W15

``` r
table(x)
```

    ## x
    ## 2019-W03 2019-W04 2019-W05 2019-W06 2019-W07 2019-W08 2019-W09 2019-W10 
    ##        2        3        3        3        0        0        2        1 
    ## 2019-W11 2019-W12 2019-W13 2019-W14 2019-W15 
    ##        1        2        0        1        2

## Locales

It’s also possible to specify the week\_start in terms of the current
locale, however it is important to be aware that code like this may not
be portable.

``` r
# workaround because of differing locale specifications
german <- if (grepl("darwin", R.version$os)) "de_DE.UTF-8" else "de_DE.utf8"
lct <- Sys.getlocale("LC_TIME")
res <- Sys.setlocale("LC_TIME", german)

date2week(as.Date("2019-02-26"), week_start = "Sonntag")
```

    ## <aweek start: Sonntag>
    ## [1] "2019-W09-3"

``` r
date2week(as.Date("2019-02-26"), week_start = "Sunday")
```

    ## <aweek start: Sonntag>
    ## [1] "2019-W09-3"

``` r
Sys.setlocale("LC_TIME", lct)
```

    ## [1] "en_GB.UTF-8"

## Getting help online

Bug reports and feature requests should be posted on *github* using the
[*issue*](https://github.com/reconhub/aweek/issues) system. All other
questions should be posted on the **RECON forum**: <br>
<https://www.repidemicsconsortium.org/forum/>

Contributions are welcome via **pull requests**.

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.

## Similar Work

There are other packages that can define ISOweeks and/or epiweeks.
However, the ability to easily switch between day and week intervals is
only available for the ISOweek package and all of the packages above
have dependencies that require compiled code.

  - [ISOweek](https://cran.r-project.org/package=ISOweek) converts dates
    to ISO weeks as the “%W” and “%u” formats don’t exist in windows
  - [lubridate](https://github.com/tidyverse/lubridate) performs general
    datetime handling with some auxilary functions that return the week
    or day of the week.
  - [surveillance](https://surveillance.r-forge.r-project.org/)
    implements ISOWeekYear.
