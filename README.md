
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/aweek)](https://cran.r-project.org/package=aweek)

# Welcome to the *aweek* package\!

This package will convert dates to
[epiweeks](http://www.cmmcp.org/epiweek.htm),
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

``` r
library(aweek)
set.seed(2019-02-26)
onset <- Sys.Date() + sort(sample(-6:7, 20, replace = TRUE))
onset
```

    ##  [1] "2019-02-20" "2019-02-20" "2019-02-20" "2019-02-22" "2019-02-23"
    ##  [6] "2019-02-23" "2019-02-24" "2019-02-25" "2019-02-25" "2019-02-25"
    ## [11] "2019-02-27" "2019-02-28" "2019-03-01" "2019-03-01" "2019-03-02"
    ## [16] "2019-03-03" "2019-03-03" "2019-03-04" "2019-03-04" "2019-03-05"

``` r
date2week(onset, week_start = 1) # ISO weeks starting on Monday (default)
```

    ## <aweek start: 1>
    ##  [1] "2019-W08-3" "2019-W08-3" "2019-W08-3" "2019-W08-5" "2019-W08-6"
    ##  [6] "2019-W08-6" "2019-W08-7" "2019-W09-1" "2019-W09-1" "2019-W09-1"
    ## [11] "2019-W09-3" "2019-W09-4" "2019-W09-5" "2019-W09-5" "2019-W09-6"
    ## [16] "2019-W09-7" "2019-W09-7" "2019-W10-1" "2019-W10-1" "2019-W10-2"

``` r
date2week(onset, week_start = 7) # EPI week starting on Sunday
```

    ## <aweek start: 7>
    ##  [1] "2019-W08-4" "2019-W08-4" "2019-W08-4" "2019-W08-6" "2019-W08-7"
    ##  [6] "2019-W08-7" "2019-W09-1" "2019-W09-2" "2019-W09-2" "2019-W09-2"
    ## [11] "2019-W09-4" "2019-W09-5" "2019-W09-6" "2019-W09-6" "2019-W09-7"
    ## [16] "2019-W10-1" "2019-W10-1" "2019-W10-2" "2019-W10-2" "2019-W10-3"

``` r
date2week(onset, week_start = 6) # EPI week starting on Saturday
```

    ## <aweek start: 6>
    ##  [1] "2019-W08-5" "2019-W08-5" "2019-W08-5" "2019-W08-7" "2019-W09-1"
    ##  [6] "2019-W09-1" "2019-W09-2" "2019-W09-3" "2019-W09-3" "2019-W09-3"
    ## [11] "2019-W09-5" "2019-W09-6" "2019-W09-7" "2019-W09-7" "2019-W10-1"
    ## [16] "2019-W10-2" "2019-W10-2" "2019-W10-3" "2019-W10-3" "2019-W10-4"

``` r
x <- date2week(onset, week_start = 6, floor_day = TRUE) # truncate to just the weeks
table(x)
```

    ## x
    ## 2019-W08-1 2019-W09-1 2019-W10-1 
    ##          4         10          6

``` r
table(week2date(x))
```

    ## 
    ## 2019-02-16 2019-02-23 2019-03-02 
    ##          4         10          6

## Installing the package

To benefit from the latest features and bug fixes, install the
development, *github* version of the package using:

``` r
remotes::install_github("zkamvar/aweek")
```

Note that this requires the package *remotes* installed.

# Main Features

  - `date2week()` converts dates to a week format (YYYY-Www-d) that can
    start on any day.
  - `week2date()/as.Date()` does the backwards conversion from
    (YYYY-Www(-d)) to a numeric date.
  - Dependencies only on R itself.

## Getting help online

Bug reports and feature requests should be posted on *github* using the
[*issue*](http://github.com/reconhub/aweek/issues) system. All other
questions should be posted on the **RECON forum**: <br>
<http://www.repidemicsconsortium.org/forum/>

Contributions are welcome via **pull requests**.

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
