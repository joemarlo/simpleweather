
#' Set API key
#'
#' Helper function to set API keys as environment variables
#'
#' @param .name name of the environment variable to set
#' @param api_key the api key string
#' @param install should the key be installed to the .Renviron file for use in future sessions?
#' @param overwrite if a key is already installed, should it be overwritten?
#'
#' @importFrom utils write.table
set_key_ <- function(.name, api_key, install, overwrite){

  if (!is.character(api_key)) stop('api_key must be a character string')

  # set the key for this session
  expr <- paste0("Sys.setenv(", .name, " = '", api_key, "')")
  eval(parse(text = expr))

  if (isTRUE(install)){
    rhome <- Sys.getenv("HOME")
    renv <- file.path(rhome, ".Renviron")

    # if there is already a .Renviron file, then create a backup, otherwise create the file
    if (file.exists(renv)){
      date_time <- gsub("-|:| ", "", Sys.time())
      file_name <- file.path(rhome, paste0('.Renviron_', date_time))
      file.copy(renv, file_name)
      message(paste0("Original .Renviron file has been backed up here ", file_name))
    } else {
      file.create(renv)
    }

    # read in .Renviron
    renv_old <- readLines(renv)
    is_duplicate <- any(grepl(.name, renv_old))
    if (isTRUE(is_duplicate) & isFALSE(overwrite)) stop(paste0('A ', .name, ' key already exists. Overwrite with overwrite = TRUE'), call. = FALSE)
    if (isFALSE(is_duplicate) | isTRUE(overwrite)){

      # remove any duplicates
      renv_new <- renv_old[!grepl(.name, renv_old)]

      # add in new key and write out
      renv_new <- c(renv_new, paste0(.name, "='", api_key, "'"))
      write.table(renv_new, renv, quote = FALSE, sep = '\n', row.names = FALSE, col.names = FALSE)
      message('API key has been installed for future sessions')
    }
  } else {
    # message("API key has been installed for this session only. If you'd like to install for future sessions then use `install = TRUE`")
  }
}

#' Set API key for NOAA
#'
#' Set your NOAA API key. This stores it as an environment variable so it can be used with simpleweather functions. You can install the key to your .Renviron so calling this function is not required for each R session.
#'
#' You can obtain an API key for free here: https://www.ncdc.noaa.gov/cdo-web/webservices/v2
#'
#' @param api_key the api key string
#'
#' @export
#'
#' @examples \dontrun{
#' set_api_key_noaa("<key>")
#' }
set_api_key_noaa <- function(api_key){
  set_key_(.name = "token_noaa", api_key = api_key, install = FALSE, overwrite = FALSE)
  test_key_noaa()
}

#' Set API key for OpenWeather
#'
#' Set your OpenWeather API key. This stores it as an environment variable so it can be used with simpleweather functions. You can install the key to your .Renviron so calling this function is not required for each R session.
#'
#' You can obtain an API key for free here: https://openweathermap.org/api/
#'
#' @param api_key the api key string
#'
#' @export
#'
#' @examples \dontrun{
#' set_api_key_openweather("<key>")
#' }
set_api_key_openweather <- function(api_key){
  set_key_(.name = "token_openweather", api_key = api_key, install = FALSE, overwrite = FALSE)
  test_key_openweather()
}

test_key_noaa <- function(){

  # construct call to NOAA API
  token <- Sys.getenv('token_noaa')
  if (identical(token, '')) stop('Cannot find API key')
  date_start <- as.Date('2021-09-10')
  date_end <- as.Date('2021-09-22')
  date_start_char <- paste0('startdate=', date_start)
  date_end_char <- paste0('enddate=', date_end)
  station <- 'stationid=GHCND:USW00094728' # GHCND:USW00094728 Central Park
  dataset <- 'datasetid=GHCND'
  datatype <- 'datatypeid=TMAX,PRCP,WSF2'
  units <- 'units=standard'
  limit <- 'limit=1000' # 1000 is the max
  args <- paste(dataset, datatype, station, date_start_char, date_end_char, units, limit, sep = '&')
  url_base <- 'https://www.ncdc.noaa.gov/cdo-web/api/v2/data?'
  url_complete <- paste0(url_base, args)

  # make the GET request and check the reponse code
  resp <- GET(url_complete, add_headers("token" = token), user_agent('https://github.com/joemarlo/simpleweather'))
  status <- httr::status_code(resp)
  if (!identical(status, 200L)) stop('API key not accepted by the API. Do you just receive the key? If so, try again in ~15 minutes.')
}

test_key_openweather <- function(){

  # construct call to OpenWeather API
  token <- Sys.getenv('token_openweather')
  if (identical(token, '')) stop('Cannot find API key')
  token <- paste0('appid=', token)
  lat <- 'lat=40.7812'
  long <- 'lon=-73.9665'
  exclude <- 'exclude=current,minutely,hourly,alerts'
  units <- 'units=imperial'
  args <- paste(lat, long, exclude, units, token, sep = '&')
  url_base <- 'https://api.openweathermap.org/data/2.5/onecall?'
  url_complete <- paste0(url_base, args)

  # make the GET request and check the response code
  resp <- GET(url_complete, user_agent('https://github.com/joemarlo/simpleweather'))
  status <- httr::status_code(resp)
  if (!identical(status, 200L)) stop('API key not accepted by the API. Do you just receive the key? If so, try again in ~15 minutes.')
}
