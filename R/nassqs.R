#' @title nassqs-package: Use the NASS Quickstats API from R
#'
#' @description This package wraps around the NASS Quickstats API so you can make R calls
#' to fetch data. Based on the httr api package guide.
#'
#' @author Nicholas Potter
#' @docType package
#' @name nassqs
#' @aliases nassqs
#' @keywords package nassqs-package
#' @examples
#' \dontrun{get.user.repositories("potterzot")}
#' @seealso \code{jsonlite}
#' @seealso \url{http://quickstats.nass.usda.gov/api}
NULL

#' Issue a GET request to the NASS API
#'http://quickstats.nass.usda.gov/api
#' This is the core function, which several other nassqs functions use to request data.
#'
#' @param params a named list of values to be queried.
#' @param path the api path. Can be "api_GET", "get_param_values", or "get_counts"
#' @param base_url the base api url. This should probably never be changed.
#' @param key your api key. If not provided the function will check for an env var and if not found, will prompt for your api key.
#' @param format format of returned data. JSON by default, but can also be XML or CSV.
#' @return data returned in the format specified
nassqs_GET <- function(params, # a named list of queries
                       ...,
                       path="api_GET", # specific sub api call
                       base_url="http://quickstats.nass.usda.gov/api/",
                       key=nassqs_auth(), #api key
                       format='JSON') {
  #path must be:
  path_must_be = c("api_GET", "get_param_values", "get_counts")
  if (is.element(path, path_must_be)==FALSE) {
    stop("path must be one of ", path_must_be)
  }

  #format must be:
  format_must_be = c("JSON", "XML", "CSV")
  if (is.element(format, format_must_be)==FALSE) {
    stop("Format must be one of ", format_must_be)
  }

  #get the full param list
  query = list("key"=key)
  for (name in names(params)) { query[name] = params[name]}
  query["format"] = format

  # full url
  url = paste0(base_url,path)

  # GET request and check
  req <- GET(url, query=query)
  nassqs_check(req)

  req
}

#' Check the request
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
  stop("HTTP Failure: ", req$status_code, "\n", message, call. = FALSE)
}

#' Parse the returned request
#'
#' Returns a data frame. All values are strings.
#'
#' @param req the GET request
#' @return a data frame of the content from the request
nassqs_parse <- function(req, ..., as="dataframe") {
  text <- content(req, as = "text")
  if (identical(text, "")) {
    stop("Response is empty.")
  }
  else if (identical(text, "{\"error\":[\"unauthorized\"]}")) {
    stop("Incorrect API Key.")
  }

  #process the data depending on returned data type
  if (req$headers['content-type']=="application/json") {
    c = nass_parse.json(text, as, ...)
  }
  else if (req$headers['content-type']=="application/xml") {
    #c = jsonlite::fromJSON(text, simplifyVector = FALSE)
    stop("XML is not yet implemented in rnassqs. Use JSON instead.")
  }
  else if (req$headers['content-type']=="text/plain") {
    #c = jsonlite::fromJSON(text, simplifyVector = FALSE)
    stop("CSV is not yet implemented in rnassqs. Use JSON instead.")
  }

  c
}

#' Parse a request returned as JSON
#'
#'
#' @param text the text returned from content()
#' @returns a data frame or a list depending on the input.
nass_parse.json <- function(text, as, ...) {
  js = jsonlite::fromJSON(text,...)

  # return based on specified by user
  if (as=="raw") {
    df = js
  }
  else if (as=="list") {
    df = list(js)
  }
  else {
    df = data.frame(js)
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
#' @return authentication token
nassqs_auth <- function(key = nassqs_token()) {
  key
}

#' Get the user's API key from the environment
#'
#' First checks if the NASSQS_TOKEN environmental variable is set, and if so,
#' returns it. Otherwise asks the console. If not an interactive session,
#' fails with error msg.
#'
#' @param force a boolean to force asking in the console.
#' @return the api key
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
#' @param params a named list of parameters to pass to quick stats
#' @param as a string indicating the desired format. Default is "dataframe". Can also be "json" or "list".
#' @return a data frame of requested data.
get_nass <- function(params, ..., as="dataframe") {
  params_are_single = TRUE
  for (p in params) {
    if (length(params[p])!=1) {
      # we need the much more complication function
      params_are_single = FALSE
    }
  }

  if (params_are_single) {
    get_nass.single(params, ..., as)
  }
  else {
    #
    get_nass.multi(params, ..., as)
  }
}

#' Get data and return a data frame, in which each parameter selected has only one value.
#'
#' Calls nassqs_GET and nassqs_parse to return a data frame
#'
#' @param params a named list of parameters to pass to quick stats. One value per parameter.
#' @as a string naming the format the data should be returned as. Default is dataframe.
#' @return a data frame of requested data.
get_nass.single <- function(params, ..., as="dataframe") {
  nassqs_parse(nassqs_GET(params, ...), as)
}

#' Get data and return a data frame, can handle multiple values for parameters.
#'
#' Warning - the NASS QS API does not allow more than a single value per GET request.
#' To handle multiple values, this function splits the parameters into a set of single
#' value requests and issues a GET request for each set of values, then combines the
#' results into a single data frame. As a result, this can take some time to run...
#'
#' @param params a named list of parameters and the query values.
#' @return a dataframe of data
get_nass.multi <- function(params, ..., as="dataframe") {
  #get a list of each parameter combination
  #TODO
  param_set = NULL

  #run the request for each parameter combination and add the result to a data frame
  df = data.frame()
  for (params in param_set) {
    d = get_nass.single(params, ...)
    #TODO: concatenate the new df to the aggregate one
  }
  df
}


#' Get all values for a specific parameter.
#'
#' Equivalent to \code{nassqs_GET(list('param'=param_name))}
#'
#' @param param the name of a NASS quickstats parameterc = transform(c, Value=as.numeric(Value))
#' @return single column data frame containing values for that parameter.
#'
get_param_values <- function(param, ...) {
  params = list("param"=param)
  nassqs_parse(nassqs_GET(params, ..., path="get_param_values"), as="list")
}

#' Get a count of number of records for given parameters.
#'
#' Returns the number of records that fit a set of parameters. Useful if your
#' current parameter set returns more than the 50,000 record limit.
#'
#' @param params a named list of parameters and values.
#' @return integer that is the number of records that fits those parameter values.
get_record_count <- function(params, ...) {
  nassqs_GET(params, ..., path="get_counts")
}

#'
#'
#'
get_nass_yield <- function(params, ...) {
  q = list('statisticcat_desc'='YIELD')
  for (p in names(params)) {
    q[p] = params[p]
  }
  get_nass(q, ...)
}





