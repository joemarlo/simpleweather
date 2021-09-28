
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simpleweather

<!-- badges: start -->

[![R-CMD-check](https://github.com/joemarlo/simpleweather/workflows/R-CMD-check/badge.svg)](https://github.com/joemarlo/simpleweather/actions)
[![license](https://img.shields.io/badge/license-MIT%20+%20file%20LICENSE-lightgrey.svg)](https://choosealicense.com/)
[![Last-changedate](https://img.shields.io/badge/last%20change-2021--09--28-yellowgreen.svg)](/commits/master)
<!-- badges: end -->

simpleweather is an R package that provides a simple interface to get
historical and forecasted weather. It does one thing: retrieve basic
weather data for a given latitude, longitude location. No anguish to
figure out which data source to use, esoteric weather variable to pick,
or weather station to choose.

simpleweather is focused and therefore limited to only providing
temperature (daily max in Fahrenheit), precipitation (True/False), and
wind speed (mph). The package leverages NOAA for historical data and
OpenWeather for the latest data.

``` r
library(simpleweather)
dates <- Sys.Date() + -7:2
lat <- 40.7812
long <- -73.9665
get_weather(dates, lat, long)
#> Using NOAA station NY CITY CENTRAL PARK, NY US
#> OpenWeather uses exact latitude, longitude provided
#> # A tibble: 10 × 6
#>    date       temperature precipitation  wind is_forecast source     
#>    <date>           <dbl> <lgl>         <dbl> <lgl>       <chr>      
#>  1 2021-09-21        76   FALSE         NA    FALSE       NOAA       
#>  2 2021-09-22        79   FALSE         NA    FALSE       NOAA       
#>  3 2021-09-23        73.6 TRUE          14.5  FALSE       OpenWeather
#>  4 2021-09-24        69.8 TRUE           5.75 FALSE       OpenWeather
#>  5 2021-09-25        67.8 FALSE          6.91 FALSE       OpenWeather
#>  6 2021-09-26        69.2 FALSE          0    FALSE       OpenWeather
#>  7 2021-09-27        67.9 FALSE          7    FALSE       OpenWeather
#>  8 2021-09-28        73.9 TRUE          10.4  TRUE        OpenWeather
#>  9 2021-09-29        69.8 FALSE         12.2  TRUE        OpenWeather
#> 10 2021-09-30        63.2 FALSE         12.4  TRUE        OpenWeather
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
set_api_key_noaa("<key>")
set_api_key_openweather("<key>")
```

Please credit NOAA and/or OpenWeather as your weather data provider
depending on your use.

## Data description

The data comes from different sources and is aggregated to best provide
consistent measures. Some caution is necessary if you require precise
estimates as definitions slightly differ across the data sources.

| Type        | Source      | Dataset                         | Temperature                       | Precipitation                                                     | Wind                                     |
|-------------|-------------|---------------------------------|-----------------------------------|-------------------------------------------------------------------|------------------------------------------|
| Historical  | NOAA        | Daily summaries (GHCND)         | `TMAX`: Max daily temperature     | `PRCP` &gt; 0.1 inches                                            | `WSF2`: fastest 2-minute speed in mph    |
| Last 5 days | OpenWeather | One-call time machine “current” | `temp`: TBD                       | `weather-main` one of (‘Thunderstorm’, ‘Drizzle’, ‘Rain’, ‘Snow’) | `wind_speed`: reported wind speed in mph |
| Forecast    | OpenWeather | One-call “daily”                | `temp$max`: Max daily temperature | `pop` (probability of precipitation) &gt; 0.3                     | `wind_speed`: reported wind speed in mph |

For more detailed weather data, check out the R packages
[rnoaa](https://github.com/ropensci/rnoaa) and
[owmr](https://github.com/crazycapivara/owmr). These provide nuanced
control over requesting data from the NOAA and OpenWeather APIs.

## Todo

-   Implement rate limiting messages?
-   Figure out timestamp of OpenWeather last 5 days
