
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simpleweather

<!-- badges: start -->

[![R-CMD-check](https://github.com/joemarlo/simpleweather/workflows/R-CMD-check/badge.svg)](https://github.com/joemarlo/simpleweather/actions)
<!-- badges: end -->

simpleweather is an R package that simply retrieves daily weather data.

``` r
library(simpleweather)
dates <- Sys.Date() + -7:2
lat <- 40.7812
long <- -73.9665
get_weather(dates, lat, long)
#> Using NOAA station LAGUARDIA AIRPORT, NY US
#> OpenWeather uses exact latitude, longitude provided
#> # A tibble: 10 × 6
#>    date       temperature precipitation  wind is_forecast source     
#>    <date>           <dbl> <lgl>         <dbl> <lgl>       <chr>      
#>  1 2021-09-19        78   FALSE         18.1  FALSE       NOAA       
#>  2 2021-09-20        76   FALSE         15    FALSE       NOAA       
#>  3 2021-09-21        66.8 FALSE          6.62 FALSE       OpenWeather
#>  4 2021-09-22        72.2 FALSE          4    FALSE       OpenWeather
#>  5 2021-09-23        75.5 FALSE          5.01 FALSE       OpenWeather
#>  6 2021-09-24        69.8 TRUE           5.75 FALSE       OpenWeather
#>  7 2021-09-25        67.8 FALSE          6.91 FALSE       OpenWeather
#>  8 2021-09-26        72.9 FALSE         15.5  TRUE        OpenWeather
#>  9 2021-09-27        78.2 FALSE         15.8  TRUE        OpenWeather
#> 10 2021-09-28        73.5 TRUE          10.1  TRUE        OpenWeather
```

## Installation and setup

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("joemarlo/simpleweather")
```

Requires API keys for the [NOAA
API](https://www.ncdc.noaa.gov/cdo-web/webservices/v2) and [OpenWeather
API](https://openweathermap.org/api/one-call-api). You can request those
keys for free [here](https://www.ncdc.noaa.gov/cdo-web/token) and
[here](https://openweathermap.org/price). Historical NOAA weather data
only available for the United States.

And then log your API keys via the set\_api\_key\_\* functions.

``` r
set_api_key_noaa("<token>")
set_api_key_openweather("<token>")
```

## Todo

-   Remove `tibble` dependency
-   Figure out how to run tests w/o explicit API key
-   Double check documentation is correct of weather variables
-   Implement rate limiting messages?
