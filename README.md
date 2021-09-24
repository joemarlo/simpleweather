
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simpleweather

<!-- badges: start -->
<!-- badges: end -->

simpleweather is an R package that simply retrieves weather data for a
vector of dates:

``` r
library(simpleweather)
dates <- seq(Sys.Date()-10, Sys.Date()+5, by = 'day')
get_weather(dates)
#> # A tibble: 16 × 6
#>    date       temperature precipitation  wind is_forecast source     
#>    <date>           <dbl> <lgl>         <dbl> <lgl>       <chr>      
#>  1 2021-09-14        80   FALSE          6.9  FALSE       NOAA       
#>  2 2021-09-15        85   FALSE         NA    FALSE       NOAA       
#>  3 2021-09-16        76   FALSE         NA    FALSE       NOAA       
#>  4 2021-09-17        75   FALSE         NA    FALSE       NOAA       
#>  5 2021-09-18        84   FALSE         NA    FALSE       NOAA       
#>  6 2021-09-19        67.0 FALSE         11.6  FALSE       OpenWeather
#>  7 2021-09-20        70.6 FALSE          4    FALSE       OpenWeather
#>  8 2021-09-21        68.1 FALSE          5.99 FALSE       OpenWeather
#>  9 2021-09-22        72.2 FALSE          4    FALSE       OpenWeather
#> 10 2021-09-23        75.5 FALSE          5.01 FALSE       OpenWeather
#> 11 2021-09-24        75.6 TRUE          10.0  TRUE        OpenWeather
#> 12 2021-09-25        78.1 FALSE          6.93 TRUE        OpenWeather
#> 13 2021-09-26        74.4 FALSE         14.2  TRUE        OpenWeather
#> 14 2021-09-27        77.3 FALSE         14.0  TRUE        OpenWeather
#> 15 2021-09-28        77.3 FALSE         11.6  TRUE        OpenWeather
#> 16 2021-09-29        67.6 FALSE         11.6  TRUE        OpenWeather
```

Currently only works for Central Park, NY. Location argument coming
soon.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("joemarlo/simpleweather")
```
