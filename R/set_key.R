
#' Set API key
#'
#' Helper function to set API keys as environment variables
#'
#' @param .name name of the environment variable to set
#' @param api_key the api key string
#' @param install should the key be installed to the .Renviron file for use in future sessions?
set_key_ <- function(.name, api_key, install){

  # TODO: error handling
  # TODO: global install

  # set the key
  expr <- paste0("Sys.setenv(", .name, " = '", api_key, "')")
  eval(parse(text = expr))
}

#' Set API key for NOAA
#'
#' Set your NOAA API key. This stores it as an environment variable so it can be used with simpleweather functions. You can install the key to your .Renviron so calling this function is not required for each R session.
#'
#' @param api_key the api key string
#' @param install should the key be installed to the .Renviron file for use in future sessions?
#'
#' @export
#'
#' @examples
#' # set_api_key_noaa("<token>")
set_api_key_noaa <- function(api_key, install = FALSE){
  set_key_(.name = "token_noaa", api_key = api_key, install = install)
}

#' Set API key for OpenWeather
#'
#' Set your OpenWeather API key. This stores it as an environment variable so it can be used with simpleweather functions. You can install the key to your .Renviron so calling this function is not required for each R session.
#'
#' @param api_key the api key string
#' @param install should the key be installed to the .Renviron file for use in future sessions?
#'
#' @export
#'
#' @examples
#' # set_api_key_openweather("<token>")
set_api_key_openweather <- function(api_key, install = FALSE){
  set_key_(.name = "token_openweather", api_key = api_key, install = install)
}
