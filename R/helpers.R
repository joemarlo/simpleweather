#' Find the closest NOAA station
#'
#' Finds the closest NOAA station based on a given latitude, longitude. Only considers NOAA stations that contain temperature, precipitation, and wind speed for the provided dates and are within +/- 1 degree.
#'
#' @param .date_start the starting date that the NOAA station should contain data for
#' @param .date_end the ending date that the NOAA station should contain data for
#' @param lat a double representing latitude
#' @param long a double representing longitude
#'
#' @return string containing the NOAA station ID
#'
#' @import httr
#' @importFrom dplyr bind_rows
#'
#' @examples \dontrun{
#' set_api_key_noaa('<token>')
#' date_start <- '2021-09-10'
#' date_end <- '2021-09-22'
#' lat <- 40.7812
#' long <- -73.9665
#' get_closest_noaa_station(date_start, date_end, lat, long)
#' }
get_closest_noaa_station <- function(.date_start, .date_end, lat, long){

  # coerce to dates
  date_start <- as.Date(.date_start)
  date_end <- as.Date(.date_end)
  if (!inherits(date_start, 'Date') | !inherits(date_end, 'Date')) stop('date_start & date_end must be coercible to dates')

  # construct call to NOAA API to get all the stations that are close
  token <- Sys.getenv('token_noaa')
  if (identical(token, '')) stop('No API key set for NOAA. Please use simpleweather::set_api_key_noaa()', call. = FALSE)
  date_start_char <- paste0('startdate=', date_start)
  date_end_char <- paste0('enddate=', date_end)
  range <- 1
  boundary <- paste0("extent=", paste(lat - range, long - range, lat + range, long + range, sep = ','))
  dataset <- "datasetid=GHCND"
  datatype <- 'datatypeid=TMAX,PRCP,WSF2'
  limit <- "limit=1000"
  args <- paste(date_start_char, date_end_char, boundary, dataset, datatype, limit, sep = "&")
  url_base <- 'https://www.ncdc.noaa.gov/cdo-web/api/v2/stations?'
  url_complete <- paste0(url_base, args)

  # call the API and get the data
  resp <- GET(url_complete, add_headers("token" = token), user_agent('https://github.com/joemarlo/simpleweather'))
  stop_for_status(resp)
  warn_for_status(resp)
  resp_content <- bind_rows(content(resp)$results)
  if (nrow(resp_content) == 0) stop(paste0('No NOAA station found within +/- ', range, ' degrees that contains data for all dates provided.'))

  # calculate closest station based on lat long
  # euclidean distance should work well enough
  distance_from_original <- dist_euclidean(lat, long, resp_content$latitude, resp_content$longitude)
  closest_station <- resp_content[which.min(distance_from_original)[1],]

  # let user know which station was selected
  message(paste0("Using NOAA station ", closest_station$name[1]))
  message('OpenWeather uses exact latitude, longitude provided')

  # return station ID
  return(closest_station$id[1])
}

dist_euclidean <- function(lat1, long1, lat2, long2){
  a <- lat2 - lat1
  b <- long2 - long1
  sqrt(a^2 + b^2)
}
