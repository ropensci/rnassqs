#'
#' rnassqs is a wrapper for the NASS Quickstats API to enable getting NASS
#' QuickStats data from R directly.  Based on the httr api package guide.
#'
#' The functions in this package facilitate getting data from NASS QuickStats.
#' It handles the API key checking and storage, authorization, and fetching of data.
#' @author Nicholas Potter
#' @name rnassqs-package
#' @aliases rnassqs
#' @docType package
#' @title rnassqs-package: Use the NASS Quickstats API from R
#' @keywords package rnassqs-package
#' @references \url{http://quickstats.nass.usda.gov}
#' @examples \dontrun{
#'
#' }
#' @seealso \url{http://quickstats.nass.usda.gov/api}
NULL

#' Issue a GET request to the NASS API
#'http://quickstats.nass.usda.gov/api
#' This is the core function, which several other nassqs functions use to request data.
#'
#' @importFrom httr GET
#' @export

#' @param params a named list of values to be queried.
#' @param api_path the api path. Can be "api_GET", "get_param_values", or "get_counts"
#' @param base_url the base api url. This should probably never be changed.
#' @param key your api key. If not provided the function will check for an env var and if not found, will prompt for your api key.
#' @param format format of returned data. JSON by default, but can also be XML or CSV.
#' @return data returned in the format specified.
nassqs_GET <- function(params, # a named list of queries
                       api_path=c("api_GET", "get_param_values", "get_counts"), # specific sub api call
                       base_url="http://quickstats.nass.usda.gov/api/",
                       key=nassqs_auth(), #api key
                       format=c("JSON", "XML", "CSV")) {
  #match args
  api_path = match.arg(api_path)
  format = match.arg(format)

  #get the full param list
  query = list("key"=key)
  query = append(query, params)
  query["format"] = format

  # full url
  url = paste0(base_url,api_path)

  # GET request and check
  req <- GET(url, query=query)
  nassqs_check(req)

  req
}

#' Check the request.
#'
#' @importFrom jsonlite fromJSON
#'
#' @param req request result returned from quickstats
#' @return parsed request result as json
nassqs_check <- function(req) {
  if (req$status_code < 400) {
    return(invisible()) #all good!
  }
  else if (req$status_code == 413) {
    stop("Request was too large. NASS requires that an API call returns a maximum of 50k records.", call. = FALSE)
  }
  stop("HTTP Failure: ", req$status_code, "\n", fromJSON(content(req, as="text")), call. = FALSE)
}

#' Parse the returned request.
#'
#' Returns a data frame. All values are strings.
#'
#' @importFrom httr content
#' @export
#'
#' @param req the GET request.
#' @param as indicates type of data returned. Can be one of "list", "js", or "dataframe".
#' @param ... additional parameters passed to \code{\link{nassqs_parse.json}}
#' @return a data frame of the content from the request.
nassqs_parse <- function(req, as = c("data.frame", "list", "raw"), ...) {
  as = match.arg(as)

  text <- content(req, as = "text")
  if (identical(text, "")) {
    stop("Response is empty.")
  }
  else if (identical(text, "{\"error\":[\"unauthorized\"]}")) {
    stop("Incorrect API Key.")
  }

  #process the data depending on returned data type
  if (as == "raw") {
    c = text
  }
  else if (req$headers['content-type']=="application/json") {
    c = nassqs_parse.json(text, as = as, ...)
  }
  else if (req$headers['content-type']=="application/xml") {
    #c = jsonlite::fromJSON(text, simplifyVector = FALSE)
    c = nassqs_parse.xml(text, as = as, ...)
    stop("XML is not yet implemented in rnassqs. Use JSON instead.")
  }
  else if (req$headers['content-type']=="text/plain") {
    #c = jsonlite::fromJSON(text, simplifyVector = FALSE)
    c = nassqs_parse.csv(text, as = as, ...)
    stop("CSV is not yet implemented in rnassqs. Use JSON instead.")
  }

  c
}

#' Parse a NASS QS request returned as XML.
#'
#' @param text the text returned from \code{content()}.
#' @param as indicator of output format.
#' @param ... additional parameters passed to \code{fromJSON()}.
#' @return a data frame or a list depending on the the "as" parameter.
nassqs_parse.xml <- function(text, as = c("data.frame", "list", "raw"), ...) {
  stop("XML is not yet implemented in rnassqs. Use JSON instead.")
}

#' Parse a NASS QS request returned as XML.
#'
#' @param text the text returned from \code{content()}.
#' @param as indicator of output format.
#' @param ... additional parameters passed to \code{fromJSON()}.
#' @return a data frame or a list depending on the the "as" parameter.
nassqs_parse.csv <- function(text, as = c("data.frame", "list", "raw"), ...) {
  stop("CSV is not yet implemented in rnassqs. Use JSON instead.")
}

#' Parse a request returned as JSON.
#'
#' @importFrom jsonlite fromJSON
#'
#' @param text the text returned from \code{content()}.
#' @param as indicator of output format..
#' @param ... additional parameters passed to \code{fromJSON()}.
#' @return a data frame or a list depending on the input.
nassqs_parse.json <- function(text,
                              as = c("data.frame", "list", "raw"),
                              ...) {
  as = match.arg(as)

  js = jsonlite::fromJSON(text, ...)

  # return based on specified by user
  if (as=="raw") {
    df = js
  }
  else if (as=="list") {
    df = list(js)
  }
  else {
    df = data.frame(js, stringsAsFactors = FALSE)
  }

  df
}

#' Authenticate the user
#'
#' the NASS API uses a basic html API key authorization, where the key is included in the
#' html call. You can add your API key in three ways:
#'
#' (1) directly or as a variable from your R program: \code{auth = nassqs_auth(`api_key`)}
#' (2) by setting it in your R environment (you'll never have to enter it again).
#' (3) by entering it into the console when asked (it will be stored for the rest of the session.)
#'
#' @param key api key. If not specified, looks for an env variable named NASSQS_TOKEN and if not available, asks at the console.
#' @return authentication token.
nassqs_auth <- function(key = nassqs_token()) {
  key
}

#' Get the user's API key from the environment
#'
#' First checks if the NASSQS_TOKEN environmental variable is set, and if so,
#' returns it. Otherwise asks the console. If not an interactive session,
#' fails with error msg.
#'
#' @export
#'
#' @param force a boolean to force asking in the console.
#' @return the api key.
#'
nassqs_token <- function(force = FALSE) {
  env <- Sys.getenv('NASSQS_TOKEN')
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env variable NASSQS_TOKEN to your NASS Quickstats API Key.", call. = FALSE)
  }

  #If not yet set, then try to read it from the console
  message("Couldn't find env variable NASSQS_TOKEN. SEE ?nassqs_token for more details.")
  message("Please enter your NASS Quickstats API Key and press enter:")
  token <- readline(": ")

  #If blank, then exit with error. No API Key present.
  if (identical(token, "")) {
    stop("No API Key entered.", call. = FALSE)
  }

  #If not blank, then set the environmental variable so future calls in this session do not need it.
  message("Setting API KEY environmental variable: NASSQS_TOKEN for the rest of session.")
  Sys.setenv(NASSQS_TOKEN = token)

  token
}

#####################################################
# From here on out, wrapper functions for ease of use

#' Get data and return a data frame
#'
#' Calls nassqs_GET and nassqs_parse and returns a data frame by default.
#'
#' @export
#'
#' @param params a named list of parameters to pass to quick stats
#' @param ... additional parameters passed to low level functions \code{\link{nassqs.single}}
#' and \code{\link{nassqs.multi}}.
#' @return a data frame of requested data.
#' @examples
#' \dontrun{
#' params = list(COMMODITY_NAME="Corn", YEAR=2012, STATE_ALPHA="WA")
#' nassqs(params)
#' }
nassqs <- function(params, ...) {
  params_are_single = TRUE
  for (p in params) {
    if (length(params[p])!=1) {
      # we need the much more complication function
      params_are_single = FALSE
    }
  }

  if (params_are_single) {
    nassqs.single(params, ...)
  }
  else {
    #
    nassqs.multi(params, ...)
  }
}

#' Get data and return a data frame, in which each parameter selected has only one value.
#'
#' Calls nassqs_GET and nassqs_parse to return a data frame
#'
#' @export
#'
#' @param params a named list of parameters to pass to quick stats. One value per parameter.
#' @param as a string naming the format the data should be returned as. Default is dataframe.
#' @param ... additional parameters passed to \code{\link{nassqs_GET}}.
#' @return a data frame of requested data.
nassqs.single <- function(params,
                          as = c("data.frame", "list", "raw"),
                          ...) {

  as = match.arg(as)
  nassqs_parse(nassqs_GET(params, ...), as=as)
}

#' Get data and return a data frame, can handle multiple values for parameters.
#'
#' Warning - the NASS QS API does not allow more than a single value per GET request.
#' To handle multiple values, this function splits the parameters into a set of single
#' value requests and issues a GET request for each set of values, then combines the
#' results into a single data frame. As a result, this can take some time to run...
#'
#' @export
#'
#' @param params a named list of parameters and the query values.
#' @param as determines the output. Can be "js", "list", or "dataframe".
#' @param ... additional parameters passed to \code{\link{nassqs.single}}.
#' @return a dataframe of data
nassqs.multi <- function(params,
                         as = c("data.frame", "list", "raw"),
                         ...) {
  #get a list of each parameter combination
  #TODO
  param_set = NULL

  #run the request for each parameter combination and add the result to a data frame
  df = data.frame()
  for (params in param_set) {
    d = nassqs.single(params, ...)
    #TODO: concatenate the new df to the aggregate one
  }
  df
}






