
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simpleweather

<!-- badges: start -->

[![R-CMD-check](https://github.com/joemarlo/simpleweather/workflows/R-CMD-check/badge.svg)](https://github.com/joemarlo/simpleweather/actions)
[![license](https://img.shields.io/badge/license-MIT%20+%20file%20LICENSE-lightgrey.svg)](https://choosealicense.com/)
[![Last-changedate](https://img.shields.io/badge/last%20change-2021--10--04-yellowgreen.svg)](/commits/master)
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
#> Using NOAA station LAGUARDIA AIRPORT, NY US
#> OpenWeather uses exact latitude, longitude provided
#> # A tibble: 10 × 6
#>    date       temperature precipitation  wind is_forecast source     
#>    <date>           <dbl> <lgl>         <dbl> <lgl>       <chr>      
#>  1 2021-09-27        82   FALSE         23    FALSE       NOAA       
#>  2 2021-09-28        75   FALSE         21    FALSE       NOAA       
#>  3 2021-09-29        NA   NA            NA    NA          <NA>       
#>  4 2021-09-30        65.2 FALSE          7    FALSE       OpenWeather
#>  5 2021-10-01        67.1 FALSE          5.01 FALSE       OpenWeather
#>  6 2021-10-02        76.0 FALSE          8.99 FALSE       OpenWeather
#>  7 2021-10-03        77.7 FALSE         12.0  FALSE       OpenWeather
#>  8 2021-10-04        70.0 TRUE          11.2  TRUE        OpenWeather
#>  9 2021-10-05        71.1 FALSE         10.4  TRUE        OpenWeather
#> 10 2021-10-06        74.5 FALSE          6.31 TRUE        OpenWeather
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

## Data definitions

The data comes from different sources and is aggregated to best provide
consistent measures. Some caution is necessary if you require precise
estimates as definitions slightly differ across the data sources.

| Type        | Source      | Dataset                      | Temperature                            | Precipitation                                                                                            | Wind                                                           |
|-------------|-------------|------------------------------|----------------------------------------|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------|
| Historical  | NOAA        | Daily summaries (GHCND)      | `TMAX`: Max daily temperature          | `PRCP`: precipitation &gt; 0.1 inches                                                                    | `WSF2`: fastest 2-minute speed in mph                          |
| Last 5 days | OpenWeather | One-call time machine “hour” | `temp`: Max of the hourly temperatures | `weather-main`: description is one of (‘Thunderstorm’, ‘Drizzle’, ‘Rain’, ‘Snow’) in any hour of the day | `wind_speed`: maximum of the hourly reported wind speed in mph |
| Forecast    | OpenWeather | One-call “daily”             | `temp$max`: Max daily temperature      | `pop`: probability of precipitation &gt; 0.3                                                             | `wind_speed`: reported wind speed in mph                       |

For more detailed weather data, check out the R packages
[rnoaa](https://github.com/ropensci/rnoaa) and
[owmr](https://github.com/crazycapivara/owmr). These provide nuanced
control over requesting data from the NOAA and OpenWeather APIs.

## Todo

-   Fix issue with 5 days prior OpenWeather data. Probably due to
    overlap with UTC time
-   Set key install doesn’t work on Macs (b/c permissions?)
