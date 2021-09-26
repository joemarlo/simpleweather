
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

  # TODO: test API key validity?

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
    message("API key has been installed for this session only. If you'd like to install for future sessions then use `install = TRUE`")
  }
}

#' Set API key for NOAA
#'
#' Set your NOAA API key. This stores it as an environment variable so it can be used with simpleweather functions. You can install the key to your .Renviron so calling this function is not required for each R session.
#'
#' You can obtain an API key for free here: https://www.ncdc.noaa.gov/cdo-web/webservices/v2
#'
#' @param api_key the api key string
#' @param install should the key be installed to the .Renviron file for use in future sessions?
#' @param overwrite if a key is already installed, should it be overwritten?
#'
#' @export
#'
#' @examples \dontrun{
#' set_api_key_noaa("<key>")
#' }
set_api_key_noaa <- function(api_key, install = FALSE, overwrite = FALSE){
  set_key_(.name = "token_noaa", api_key = api_key, install = install, overwrite = overwrite)
}

#' Set API key for OpenWeather
#'
#' Set your OpenWeather API key. This stores it as an environment variable so it can be used with simpleweather functions. You can install the key to your .Renviron so calling this function is not required for each R session.
#'
#' You can obtain an API key for free here: https://openweathermap.org/api/one-call-api
#'
#' @param api_key the api key string
#' @param install should the key be installed to the .Renviron file for use in future sessions?
#' @param overwrite if a key is already installed, should it be overwritten?
#'
#' @export
#'
#' @examples \dontrun{
#' set_api_key_openweather("<key>")
#' }
set_api_key_openweather <- function(api_key, install = FALSE, overwrite = FALSE){
  set_key_(.name = "token_openweather", api_key = api_key, install = install, overwrite = overwrite)
}
