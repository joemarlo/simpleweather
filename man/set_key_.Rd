% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_key.R
\name{set_key_}
\alias{set_key_}
\title{Set API key}
\usage{
set_key_(.name, api_key, install, overwrite)
}
\arguments{
\item{.name}{name of the environment variable to set}

\item{api_key}{the api key string}

\item{install}{should the key be installed to the .Renviron file for use in future sessions?}

\item{overwrite}{if a key is already installed, should it be overwritten?}
}
\description{
Helper function to set API keys as environment variables
}
