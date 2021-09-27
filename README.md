
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simpleweather

<!-- badges: start -->

[![R-CMD-check](https://github.com/joemarlo/simpleweather/workflows/R-CMD-check/badge.svg)](https://github.com/joemarlo/simpleweather/actions)
[![license](https://img.shields.io/badge/license-MIT%20+%20file%20LICENSE-lightgrey.svg)](https://choosealicense.com/)
[![Last-changedate](https://img.shields.io/badge/last%20change-2021--09--27-yellowgreen.svg)](/commits/master)
<!-- badges: end -->

simpleweather is an R package that provides a simple interface to get
historical and forecasted weather. It does one thing: retrieve basic
weather data for a given latitude, longitude location. No anguish to
figure out which data source to use, esoteric weather variable to pick,
or weather station to choose.

simpleweather is focused and therefore limited to only providing the
temperature (daily max in Fahrenheit), precipitation (True/False), and
the wind speed (fastest 2-minute speed in mph). The package leverages
NOAA for historical data and OpenWeather for the latest data.

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
#>  1 2021-09-20        76   FALSE         15    FALSE       NOAA       
#>  2 2021-09-21        77   FALSE         15    FALSE       NOAA       
#>  3 2021-09-22        70.9 TRUE           4.83 FALSE       OpenWeather
#>  4 2021-09-23        75.5 FALSE          5.01 FALSE       OpenWeather
#>  5 2021-09-24        69.8 TRUE           5.75 FALSE       OpenWeather
#>  6 2021-09-25        67.8 FALSE          6.91 FALSE       OpenWeather
#>  7 2021-09-26        69.2 FALSE          0    FALSE       OpenWeather
#>  8 2021-09-27        79.7 FALSE         16.6  TRUE        OpenWeather
#>  9 2021-09-28        75.1 TRUE          11.3  TRUE        OpenWeather
#> 10 2021-09-29        70.2 FALSE         12.3  TRUE        OpenWeather
```

## Installation and setup

You can install the development version from
[GitHub](https://github.com/joemarlo/simpleweather) with:

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

Please credit NOAA and/or OpenWeather as your weather data provider
depending on your use.

## Data description

The data comes from different sources and is aggregated to best provide
consistent measures. Some caution is necessary if you require precise
estimates as definitions slightly differ across the data sources.

| Type        | Source      | Dataset                         | Temperature | Precipitation                | Wind         |
|-------------|-------------|---------------------------------|-------------|------------------------------|--------------|
| Historical  | NOAA        | Daily summaries (GHCND)         | `TMAX`      | `PRCP` &gt; 0.1 inches       | `WSF2`       |
| Last 5 days | OpenWeather | One-call time machine “current” | `temp`      | `weather-main` == ‘Rain’     | `wind_speed` |
| Forecast    | OpenWeather | One-call “daily”                | `temp-max`  | `pop` (probability) &gt; 0.3 | `wind_speed` |

For more detailed weather data, check out the R packages
[rnoaa](https://github.com/ropensci/rnoaa) and
[owmr](https://github.com/crazycapivara/owmr). These provide nuanced
control over requesting data from the NOAA and OpenWeather APIs.

## Todo

-   Figure out how to run tests w/o explicit API key
-   Implement rate limiting messages?
-   Add ‘show\_requests’ argument to get\_weather
-   Add API key test to set\_\* functions?
