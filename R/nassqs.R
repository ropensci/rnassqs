#' rnassqs is a wrapper for the United States Deparment of Agriculture's
#' National Agricultural Statistical Service (NASS) 'Quick Stats' API to enable 
#' getting NASS 'Quick Stats' data directly from R.  Based on the httr API 
#' package guide.
#'
#' The functions in this package facilitate getting data from NASS 'Quick Stats'.
#' It handles the API key checking and storage, authorization, and fetching of data.
#' @author Nicholas Potter
#' @name rnassqs-package
#' @aliases rnassqs
#' @docType package
#' @title rnassqs-package: Use the NASS 'Quick Stats' API from R.
#' @keywords package rnassqs-package
#' @references \url{http://quickstats.nass.usda.gov}
#' @seealso \url{http://quickstats.nass.usda.gov/api}
NULL

#' Questions to ask before release.
release_questions <- function() {
  c(
    "Have you submitted to winbuilder with devtools::check_win_devel?",
    "Have you submitted to winbuilder with devtools::check_win_release?",
    "Have you updated the version number?",
    "Have you run devtools::check() and updated cran-comments.md?",
    "Have you updated NEWS.md?",
    "Have you updated README.Rmd?"
  )
}


#' Issue a GET request to the NASS 'Quick Stats' API
#' 
#' This is the core function, which several other rnassqs functions use to 
#' request data from the NASS 'Quick Stats' API: 
#' https://quickstats.nass.usda.gov/api. 
#'
#' @export

#' @param params a named list of values to be queried.
#' @param key your api key. If not provided the function will check for an 
#' environmental variable and if not found, will prompt for your api key.
#' @param api_path the api path. Can be "api_GET", "get_param_values", or 
#' "get_counts".
#' @param base_url the base api url. This should probably never be changed.
#' @param url_only (logical) if TRUE, returns the URL and makes no API call.
#' @param format format of returned data. JSON by default, but can also be XML 
#' or CSV. Can also be set as a parameter.
#' @return data returned in the format specified.
#' @examples
#' \donttest{
#' # Yields for corn in 2012 in Washington
#' params = list(commodity_name="CORN", 
#'               year=2012, 
#'               agg_level_desc = "STATE",
#'               state_alpha = "WA",
#'               statisticcat_desc = "YIELD")
#' nassqs_GET(params)
#' 
#' # Equivalent to 'nassqs_record_count(params)'
#' req <- nassqs_GET(params, api_path = "get_counts")
#' nassqs_parse(req)
#' 
#' # Get the list of allowable values for the parameters 'statisticcat_desc'.
#' # Equivalent to 'nassqs_param_values("statisticcat_desc")'
#' req <- nassqs_GET(list(param = "statisticcat_desc"), 
#'                   api_path="get_param_values")
#' nassqs_parse(req, as = "list")
#' }
nassqs_GET <- function(params, # a named list of queries
                       key = nassqs_auth(), # api key
                       api_path=c("api_GET", "get_param_values", "get_counts"), # specific sub api call
                       base_url="https://quickstats.nass.usda.gov/api/",
                       url_only = FALSE,
                       format=c("JSON", "XML", "CSV")) {
  
  if(missing(key)) { 
    key <- tryCatch(nassqs_auth(), error = function(e) e)
    if("error" %in% class(key)) { stop(key$message) }
  }
  
  #match args
  api_path = match.arg(api_path)
  format = match.arg(format)

  #get the full param list
  params <- expand_list(params)
  query = list("key"=key)
  query = append(query, params)

  query["format"] = format

  # full url
  url = paste0(base_url, api_path)
  u <- httr::parse_url(url)
  u$query <- query

  # If only the URL just return the url, otherwise make GET request and check.
  if(url_only) {
    req <- httr::build_url(u)
  } else {
    req <- httr::GET(url, query=query)
    nassqs_check(req)
  }  

  req
}

#' Check the request.
#'
#' Check that the request is valid, i.e. that it doesn't exceed 50,000 records and that all the parameter values are valid. This is helpful for checking a query before submitting it so that you don't have to wait for the query to fail.
#'
#' @param req request result returned from the API
#' @return parsed request result as json
nassqs_check <- function(req) {
  if (req$status_code < 400) {
    return(invisible()) #all good!
  }
  else if (req$status_code == 413) {
    stop("Request was too large. NASS requires that an API call returns a maximum of 50k records.", call. = FALSE)
  }
  else {
    stop("HTTP Failure: ", req$status_code, "\n", jsonlite::fromJSON(httr::content(req, as="text", type="text/json", encoding = "UTF-8")), call. = FALSE)
  }
}

#' Parse the returned request.
#'
#' Returns a data frame. All values are strings.
#'
#' @export
#' @importFrom utils read.table
#'
#' @param req the GET request from \code{\link{nassqs_GET}}.
#' @param as indicates type of data returned.
#' @param ... additional parameters passed to \code{jsonlite::fromJSON} or 
#' \code{read.table}.
#' @return a data frame or raw text of the content from the request.
#' @examples
#' \donttest{
#' # Set parameters and make the request
#' params = list(commodity_name="CORN", 
#'               year=2012, 
#'               agg_level_desc = "STATE",
#'               state_alpha = "WA",
#'               statisticcat_desc = "YIELD")
#' req <- nassqs_GET(params)
#' nassqs_parse(req, as = "data.frame")
#' 
#' # Return the request results as a raw string
#' nassqs_parse(req, as = "raw")
#' }
nassqs_parse <- function(req, as = c("data.frame", "list", "raw"), ...) {
  as = match.arg(as)
  if(class(req) != "response") { 
    ret <- req 
  } else {
    type <- req$headers['content-type']
    
    if (identical(req, "")) {
      warning("Response is empty.")
    }

    type <- req$headers[['content-type']]
    resp <- httr::content(req, as = "text", encoding = "UTF-8")
    
    #process the data depending on returned data type
    if(as == "raw") {
      ret <- resp
    }
    else if(type == "application/json") { # format == JSON
      ret <- jsonlite::fromJSON(resp, ...)
      if("data" %in% names(ret)) { ret <- ret$data }
    }
    else if(type == "application/xml") { # format == XML
      stop("XML not yet implemented. Use format = 'JSON' or format = 'CSV' instead.")
    }
    else if(type == "text/csv") { # format == CSV
      ret <- read.table(text = resp, sep =",", header = TRUE, ...)
      names(ret)[which(names(ret) == "CV....")] <- "CV (%)"
    }
  }
  ret
}


#' Get/Set the API key from the environment.
#'
#' If the api key is provided, sets the environmental variable. If not, first 
#' checks if the NASSQS_TOKEN environmental variable is set, and if so,
#' returns it. Otherwise asks for the key in the console. If not an interactive 
#' session, fails with error message. You can set your API key in three ways:
#'
#' (1) directly or as a variable from your R program: \code{key = nassqs_auth(`api_key`)}
#' (2) by setting it in your R environment (you'll never have to enter it again).
#' (3) by entering it into the console when asked (it will be stored for the rest of the session.)
#'

#' @export
#'
#' @param key the api key.
#' @param force a boolean to force asking in the console.
#' @return the api key.
#' @examples
#' \donttest{
#' # return the key if set, otherwise ask in the console if interactive.
#' api_key <- nassqs_auth()

#' # Set the key
#' nassqs_auth(key = api_key)
#' }
nassqs_auth <- function(key, force = FALSE) {
  env_var <- Sys.getenv('NASSQS_TOKEN')
  
  if (!missing(key)) { # Directly set the key
    Sys.setenv(NASSQS_TOKEN = key); 
    return(key) 
  } else if(!identical(env_var, "") && !force) { #Get the key if it is already set
    return(env_var)
  } else {
    if (!interactive()) {
      stop("No authentication provided and your session is not interactive. See help('nassqs_auth') for details.", call. = FALSE)
    }
    
    #If not yet set, then try to read it from the console
    message("Couldn't find env variable NASSQS_TOKEN. SEE ?nassqs_token for more details.")
    message("Please enter your NASS 'Quick Stats' API Key and press enter:")
    token <- readline(": ")
    
    #If blank, then exit with error. No API Key present.
    if (identical(token, "")) {
      stop("No authentication provided and no API Key entered. Exiting.", call. = FALSE)
    }
    
    #If not blank, then set the environmental variable so future calls in this session do not need it.
    message("Setting API KEY environmental variable: NASSQS_TOKEN for the rest of session.")
    Sys.setenv(NASSQS_TOKEN = token)
    
    return(token)
  }
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
#' @param as whether to return a raw string or process the response into a data.frame.
#' @param ... additional parameters passed to the low level function \code{\link{nassqs_GET}}.
#' @return a data frame of requested data.
#' @examples
#' \donttest{
#' # Get corn yields in Virginia in 2012
#' params = list(commodity_name="CORN", 
#'               year=2012, 
#'               agg_level_desc = "COUNTY",
#'               state_alpha="VA", 
#'               statisticcat_desc = "YIELD")
#' nassqs(params)
#' }
nassqs <- function(params, 
                   as = c("data.frame", "raw"),
                   ...) {
  as = match.arg(as)
  nassqs_parse(nassqs_GET(params, ...), as=as)
}
