#' Retrieve historical weather data from the NOAA API
#'
#' Returns daily temperature (Fahrenheit), precipitation (T/F), or wind (mph) data using the NOAA API. Must set API key via set_api_key_noaa() prior to use. Request key here get key here https://www.ncdc.noaa.gov/cdo-web/token.
#'
#' @param .date_start the starting date to retrieve data for
#' @param .date_end the end date to retrieve data for
#' @param noaa_station the id of the NOAA station
#'
#' @return a tibble of weather data
#'
#' @import httr
#' @importFrom dplyr transmute select mutate as_tibble left_join ends_with
#' @importFrom purrr map_dfr
#' @importFrom tidyr pivot_wider
#'
#' @references https://www.ncdc.noaa.gov/cdo-web/webservices/v2
#'
#' @examples \dontrun{
#' set_api_key_noaa('<key>')
#' date_start <- '2021-09-10'
#' date_end <- '2021-09-22'
#' noaa_station <- 'GHCND:USW00094728'
#' get_noaa(date_start, date_end, noaa_station)
#' }
get_noaa <- function(.date_start, .date_end, noaa_station){

  # coerce to dates
  date_start <- as.Date(.date_start)
  date_end <- as.Date(.date_end)

  if (!inherits(date_start, 'Date') | !inherits(date_end, 'Date')) stop('date_start & date_end must be coercible to dates')
  if ((date_end - date_start) > 365) stop('Date range must be less than a year due to API restrictions')

  # construct call to NOAA API
  token <- Sys.getenv('token_noaa')
  if (token == '') stop('No API key set for NOAA. Please use simpleweather::set_api_key_noaa()', call. = FALSE)
  date_start_char <- paste0('startdate=', date_start)
  date_end_char <- paste0('enddate=', date_end)
  station <- paste0('stationid=', noaa_station) # GHCND:USW00094728 Central Park
  dataset <- 'datasetid=GHCND'
  datatype <- 'datatypeid=TMAX,PRCP,WSF2'
  units <- 'units=standard'
  limit <- 'limit=1000' # 1000 is the max
  args <- paste(dataset, datatype, station, date_start_char, date_end_char, units, limit, sep = '&')
  url_base <- 'https://www.ncdc.noaa.gov/cdo-web/api/v2/data?'
  url_complete <- paste0(url_base, args)

  # make the GET request and flatten the response into a dataframe
  resp <- GET(url_complete, add_headers("token" = token), user_agent('https://github.com/joemarlo/simpleweather'))
  stop_for_status(resp)
  warn_for_status(resp)
  resp_content <- content(resp)$results
  resp_df <- map_dfr(resp_content, as_tibble)

  # clean up dataframe
  value <- precipitation <- NULL # only to satisfy CMD check 'no visible binding for global variable' note
  resp_df <- transmute(resp_df, date = as.Date(date), datatype = datatype, value = value)
  resp_df <- pivot_wider(resp_df, names_from = datatype)
  resp_df <- left_join(tibble(date = resp_df$date, TMAX = NA, PRCP = NA, WSF2 = NA), resp_df, by = 'date')
  resp_df <- select(resp_df, date, !ends_with('x'))
  colnames(resp_df) <- gsub(".y$", "", colnames(resp_df))
  resp_df <- select(resp_df, date, temperature = 'TMAX', precipitation = 'PRCP', wind = 'WSF2')
  resp_df <- mutate(resp_df,
                    precipitation = precipitation > 0.1,
                    is_forecast = FALSE,
                    source = 'NOAA')

  return(resp_df)
}

#' Retrieve forecasted weather data from the OpenWeather API
#'
#' Returns the 7-day temperature (Fahrenheit), precipitation (T/F), and wind speed (mph). Precipitation defined as >= 0.35 forecasted probability of rain. Must set API key via set_api_key_openweather() prior to use. Request key here get key here https://openweathermap.org/full-price#current.
#'
#' @param lat a double representing latitude
#' @param long a double representing longitude
#'
#' @return a tibble of weather data
#'
#' @import httr
#' @importFrom dplyr tibble
#' @importFrom purrr map_dfr
#'
#' @references https://openweathermap.org/api/one-call-api
#'
#' @examples \dontrun{
#' set_api_key_openweather('<key>')
#' lat <- 40.7812
#' long <- -73.9665
#' get_openweather_forecast(lat, long)
#' }
get_openweather_forecast <- function(lat, long){

  # construct call to OpenWeather API
  token <- Sys.getenv('token_openweather')
  if (token == '') stop('No API key set for OpenWeather. Please use simpleweather::set_api_key_openweather()', call. = FALSE)
  token <- paste0('appid=', token)
  lat <- paste0('lat=', lat) #40.7812
  long <- paste0('lon=', long) #-73.9665'
  exclude <- 'exclude=current,minutely,hourly,alerts'
  units <- 'units=imperial'
  args <- paste(lat, long, exclude, units, token, sep = '&')
  url_base <- 'https://api.openweathermap.org/data/2.5/onecall?'
  url_complete <- paste0(url_base, args)

  # make the GET request and flatten the response into a dataframe
  resp <- GET(url_complete, user_agent('https://github.com/joemarlo/simpleweather'))
  stop_for_status(resp)
  warn_for_status(resp)
  resp_content <- content(resp)$daily
  resp_df <- map_dfr(resp_content, function(item){

    # extract data and put in a dataframe
    date <- as.Date(as.POSIXct(item$dt, origin = "1970-01-01"))
    temp <- item$temp$max
    precip <- item$pop >= 0.3
    wind <- item$wind_speed
    resp_df <- tibble(
      date = date,
      temperature = temp,
      precipitation = precip,
      wind = wind,
      is_forecast = TRUE,
      source = 'OpenWeather'
    )
    return(resp_df)
  })

  return(resp_df)
}

#' Retrieve last 5 days weather data from the OpenWeather API
#'
#' Returns the last 5 days temperature (Fahrenheit), precipitation (T/F), and wind speed (mph). Must set API key via set_api_key_openweather() prior to use. Request key here get key here https://openweathermap.org/full-price#current.
#'
#' @param lat a double representing latitude
#' @param long a double representing longitude
#'
#' @return a tibble of weather data
#'
#' @import httr
#' @importFrom dplyr tibble
#' @importFrom purrr map_dfr
#'
#' @references https://openweathermap.org/api/one-call-api
#'
#' @examples \dontrun{
#' set_api_key_openweather('<key>')
#' lat <- 40.7812
#' long <- -73.9665
#' get_openweather_historical(lat, long)
#' }
get_openweather_historical <- function(lat, long){

  # construct call to OpenWeather API
  token <- Sys.getenv('token_openweather')
  if (token == '') stop('No API key set for OpenWeather. Please use simpleweather::set_api_key_openweather()', call. = FALSE)
  token <- paste0('appid=', token)
  lat <- paste0('lat=', lat) #40.7812
  long <- paste0('lon=', long) #-73.9665'
  units <- 'units=imperial'
  url_base <- 'https://api.openweathermap.org/data/2.5/onecall/timemachine?'

  # make a call for each of the last 5 days
  dates <- as.numeric(as.POSIXct(Sys.Date()-1:5))
  resp_df <- map_dfr(dates, function(dt){

    # finish API construction
    dt <- paste0('dt=', dt)
    args <- paste(lat, long, units, dt, token, sep = '&')
    url_complete <- paste0(url_base, args)

    # make the GET request and flatten the response into a dataframe
    resp <- GET(url_complete, user_agent('https://github.com/joemarlo/simpleweather'))
    stop_for_status(resp)
    warn_for_status(resp)
    resp_content <- content(resp)$current
    resp_df <- tibble(date = as.Date(as.POSIXct(resp_content$dt, origin = "1970-01-01")),
                      temperature = resp_content$temp,
                      precipitation = resp_content$weather[[1]]$main == 'Rain', # not a perfect solution but seems to work
                      wind = resp_content$wind_speed,
                      is_forecast = FALSE,
                      source = 'OpenWeather')

    return(resp_df)
  })

  return(resp_df)
}

#' Retrieve historical or forecasted weather
#'
#' Returns historical or forecasted temperature (F), precipitation (T/F), and wind speed (mph). Only available for United States locations. Forecast limited to next seven days.
#'
#' Temperature is the max daily temperature, precipitation is TRUE if historical is greater than 0.1 inches or forecast probability is greater than 0.35, and wind speed is the fastest 2-minute wind speed.
#'
#' @param .dates a vector of dates
#' @param lat a double representing latitude in decimal format
#' @param long a double representing longitude in decimal format
#'
#' @return a tibble of weather data with nrows == length(.dates)
#' @export
#'
#' @importFrom purrr map2_dfr
#' @importFrom dplyr bind_rows left_join case_when distinct
#'
#' @examples \dontrun{
#' set_api_key_noaa('<key>')
#' set_api_key_openweather('<key>')
#' dates <- Sys.Date() + -10:5
#' lat <- 40.7812
#' long <- -73.9665
#' get_weather(dates, lat, long)
#' }
get_weather <- function(.dates, lat, long){

  dates <- as.Date(.dates)
  if (!inherits(dates, 'Date')) stop('.dates must be coercible to date format', call. = FALSE)
  if (max(dates) > Sys.Date() + 7) warning('Forecasts only available for the next seven days', call. = FALSE)

  # figure out which dates require which API
  current_date <- Sys.Date()
  dates <- sort(unique(dates))
  sources <- case_when(
    dates >= current_date ~ 'OpenWeather_forecast',
    dates >= (current_date - 5) ~ 'OpenWeather_historical',
    TRUE ~ 'NOAA'
  )

  # if (length(dates) > 1000) stop('.dates vector exceeds 1000 days between min and max date. NOAA API limited to 1000.')

  # call the APIs and get the data
  OpenWeather_forecast <- NULL
  OpenWeather_historical <- NULL
  NOAA <- NULL
  if ('OpenWeather_forecast' %in% sources) OpenWeather_forecast <- get_openweather_forecast(lat, long)
  if ('OpenWeather_historical' %in% sources) OpenWeather_historical <- get_openweather_historical(lat, long)
  if ('NOAA' %in% sources){
    date_start <- min(dates)
    date_end <- max(dates[sources == 'NOAA'])

    # get closest NOAA station
    station <- get_closest_noaa_station(date_start, date_end, lat, long)

    # break dates into 6 month segments b/c API restrictions
    breaks <- seq(date_start, date_end, by = '6 months')
    breaks <- sort(as.Date(union(breaks, date_end), origin = '1970-01-01'))
    date_starts <- breaks[-length(breaks)]
    date_ends <- breaks[-1]

    # make API call(s)
    NOAA <- map2_dfr(date_starts, date_ends, function(date_start, date_end) get_noaa(date_start, date_end, station))
  }

  # construct dataframe and ensure its the same order as the original vector
  weather_data <- bind_rows(OpenWeather_forecast, OpenWeather_historical, NOAA)
  weather_data <- distinct(weather_data, date, .keep_all = TRUE)
  weather_data <- left_join(tibble(date = .dates), weather_data, by = 'date')

  # make sure output is same length as input
  if (nrow(weather_data) != length(.dates)) stop("Internal error: output data does not match input .dates. If this continues, please raise an issue on https://github.com/joemarlo/simpleweather/issues")

  return(weather_data)
}
