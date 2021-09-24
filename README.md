
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simpleweather

<!-- badges: start -->
<!-- badges: end -->

simpleweather is an R package that simply retrieves weather data for a
vector of dates.

``` r
library(simpleweather)
dates <- seq(Sys.Date() - 10, Sys.Date() + 5, by = 'day')
weather <- get_weather(dates)
tail(weather, 10)
#> # A tibble: 10 × 6
#>    date       temperature precipitation  wind is_forecast source     
#>    <date>           <dbl> <lgl>         <dbl> <lgl>       <chr>      
#>  1 2021-09-20        70.6 FALSE          4    FALSE       OpenWeather
#>  2 2021-09-21        68.1 FALSE          5.99 FALSE       OpenWeather
#>  3 2021-09-22        72.2 FALSE          4    FALSE       OpenWeather
#>  4 2021-09-23        75.5 FALSE          5.01 FALSE       OpenWeather
#>  5 2021-09-24        76.1 TRUE          10.0  TRUE        OpenWeather
#>  6 2021-09-25        78.1 FALSE          6.93 TRUE        OpenWeather
#>  7 2021-09-26        74.4 FALSE         14.2  TRUE        OpenWeather
#>  8 2021-09-27        77.3 FALSE         14.0  TRUE        OpenWeather
#>  9 2021-09-28        77.3 FALSE         11.6  TRUE        OpenWeather
#> 10 2021-09-29        67.6 FALSE         11.6  TRUE        OpenWeather
```

Currently only works for Central Park, NY. Location argument in the
works

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("joemarlo/simpleweather")
```

Requires API keys for the [NOAA
API](https://www.ncdc.noaa.gov/cdo-web/webservices/v2) and [OpenWeather
API](https://openweathermap.org/api/one-call-api).
