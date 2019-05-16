
<!-- badges: start -->

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version-ago/aweek)](https://cran.r-project.org/package=aweek)
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
[isoweeks](http://en.wikipedia.org/wiki/ISO_week_date), and all others
in between with minimal overhead. Other packages such as
[lubridate](https://github.com/tidyverse/lubridate),
[ISOweek](https://cran.r-project.org/package=ISOweek), and
[surveillance](http://surveillance.r-forge.r-project.org/) have the
ability to define ISOweeks and/or epiweeks have the ability to define
ISOweeks and/or epiweeks, the ability to easily switch between day and
week intervals is only available for ISOweeks. However, the ability to
easily switch between day and week intervals is only available for
ISOweeks and all of the packages above have dependencies that require
compiled code.

## Installing the package

To install the stable package version from CRAN, you can use

``` r
install.packages("aweek")
```

To benefit from the latest features and bug fixes, install the
development, *github* version of the package using:

``` r
remotes::install_github("reconhub/aweek")
```

Note that this requires the package *remotes* installed.

# Main Features

  - `date2week()` converts dates to a week format (YYYY-Www-d) that can
    start on any day.
  - `week2date()` / `as.Date()` does the backwards conversion from
    (YYYY-Www(-d)) to a numeric date.
  - Dependencies only on R itself.

<!-- -->

## Dates to weeks

``` r
library(aweek)
set.seed(2019-02-26)
onset <- as.Date("2019-02-26") + sort(sample(-6:7, 20, replace = TRUE))
onset
```

    ##  [1] "2019-02-20" "2019-02-20" "2019-02-20" "2019-02-22" "2019-02-23"
    ##  [6] "2019-02-23" "2019-02-24" "2019-02-25" "2019-02-25" "2019-02-25"
    ## [11] "2019-02-27" "2019-02-28" "2019-03-01" "2019-03-01" "2019-03-02"
    ## [16] "2019-03-03" "2019-03-03" "2019-03-04" "2019-03-04" "2019-03-05"

``` r
date2week(onset, week_start = 1) # ISO weeks starting on Monday (default)
```

    ## <aweek start: Monday>
    ##  [1] "2019-W08-3" "2019-W08-3" "2019-W08-3" "2019-W08-5" "2019-W08-6"
    ##  [6] "2019-W08-6" "2019-W08-7" "2019-W09-1" "2019-W09-1" "2019-W09-1"
    ## [11] "2019-W09-3" "2019-W09-4" "2019-W09-5" "2019-W09-5" "2019-W09-6"
    ## [16] "2019-W09-7" "2019-W09-7" "2019-W10-1" "2019-W10-1" "2019-W10-2"

``` r
date2week(onset, week_start = 7) # EPI week starting on Sunday
```

    ## <aweek start: Sunday>
    ##  [1] "2019-W08-4" "2019-W08-4" "2019-W08-4" "2019-W08-6" "2019-W08-7"
    ##  [6] "2019-W08-7" "2019-W09-1" "2019-W09-2" "2019-W09-2" "2019-W09-2"
    ## [11] "2019-W09-4" "2019-W09-5" "2019-W09-6" "2019-W09-6" "2019-W09-7"
    ## [16] "2019-W10-1" "2019-W10-1" "2019-W10-2" "2019-W10-2" "2019-W10-3"

``` r
date2week(onset, week_start = 6) # EPI week starting on Saturday
```

    ## <aweek start: Saturday>
    ##  [1] "2019-W08-5" "2019-W08-5" "2019-W08-5" "2019-W08-7" "2019-W09-1"
    ##  [6] "2019-W09-1" "2019-W09-2" "2019-W09-3" "2019-W09-3" "2019-W09-3"
    ## [11] "2019-W09-5" "2019-W09-6" "2019-W09-7" "2019-W09-7" "2019-W10-1"
    ## [16] "2019-W10-2" "2019-W10-2" "2019-W10-3" "2019-W10-3" "2019-W10-4"

``` r
x <- date2week(onset, week_start = "sat", floor_day = TRUE) # truncate to just the weeks
table(x)
```

    ## x
    ## 2019-W08 2019-W09 2019-W10 
    ##        4       10        6

``` r
table(week2date(x))
```

    ## 
    ## 2019-02-16 2019-02-23 2019-03-02 
    ##          4         10          6

## Factors

You can also use it to automatically calculate factor levels, which is
useful in tabulating across weeks and including missing values.

``` r
set.seed(2019-02-26)
onset <- as.Date("2019-02-26") + sort(sample(-48:49, 20, replace = TRUE))
x <- date2week(onset, week_start = "sat", floor_day = TRUE, factor = TRUE)
x
```

    ## <aweek start: Saturday>
    ##  [1] 2019-W02 2019-W02 2019-W02 2019-W04 2019-W05 2019-W05 2019-W06
    ##  [8] 2019-W07 2019-W08 2019-W08 2019-W10 2019-W10 2019-W11 2019-W11
    ## [15] 2019-W13 2019-W13 2019-W14 2019-W14 2019-W14 2019-W16
    ## 15 Levels: 2019-W02 2019-W03 2019-W04 2019-W05 2019-W06 ... 2019-W16

``` r
table(x)
```

    ## x
    ## 2019-W02 2019-W03 2019-W04 2019-W05 2019-W06 2019-W07 2019-W08 2019-W09 
    ##        3        0        1        2        1        1        2        0 
    ## 2019-W10 2019-W11 2019-W12 2019-W13 2019-W14 2019-W15 2019-W16 
    ##        2        2        0        2        3        0        1

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
[*issue*](http://github.com/reconhub/aweek/issues) system. All other
questions should be posted on the **RECON forum**: <br>
<http://www.repidemicsconsortium.org/forum/>

Contributions are welcome via **pull requests**.

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
