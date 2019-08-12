#' Get data and return a data frame
#'
#' The primary function in the `rnassqs` package, `nassqs` makes a HTTP GET
#' request to the USDA-NASS Quick Stats API and returns the data parsed as a
#' data.frame, plain text, or list. Various other functions make use of `nassqs`
#' to make specific queries. For a data request the Quick Stats API returns
#' JSON that when parsed to a data.frame contains 39 columns and a varying
#' number of rows depending on the query. Unfortunately there is not a way to
#' restrict the number of columns.
#'
#' @export
#'
#' @param ... either a named list of parameters or a series of parameters to
#'   form the query
#' @param as whether to return a data.frame, list, or text string
#'   [nassqs_GET()]
#' @return a data frame, list, or text string of requested data.
#' @seealso [nassqs_GET()], [nassqs_yields()], [nassqs_acres()]
#' @examples \donttest{
#'   # Get corn yields in Virginia in 2012
#'   params <- list(commodity_name = "CORN",
#'                  year = 2012,
#'                  agg_level_desc = "COUNTY",
#'                  state_alpha = "VA",
#'                  statisticcat_desc = "YIELD")
#'   yields <- nassqs(params)
#'   head(yields)
#' }
nassqs <- function(...,
                   as = c("data.frame", "text", "list")) {
  as = match.arg(as)
  req <- nassqs_GET(..., api_path = "api_GET")
  nassqs_parse(req, as = as)
}


#' Issue a GET request to the NASS 'Quick Stats' API
#'
#' This is the workhorse of the package that provides the core request
#' functionality to the NASS 'Quick Stats' API:
#' [https://quickstats.nass.usda.gov/api](https://quickstats.nass.usda.gov/api).
#' In most cases [nassqs()] or other high-level functions should be used.
#' `nassqs_GET()` uses [httr::GET()] to make a HTTP GET request, which returns a
#' request object which must then be parsed to a data.frame, list, or other `R`
#' object. Higher-level functions will do that parsing automatically. However,
#' if you need access to the request object directly, `nassqs_GET()` provides
#' that.
#'
#' @export
#'
#' @param ... either a named list of parameters or a series of parameters to
#'   use in the query
#' @param api_path the API path that determines the type of request being made
#' @return a [httr::GET()] response object
#' @examples \donttest{
#'   # Yields for corn in 2012 in Washington
#'   params <- list(commodity_name = "CORN",
#'                  year = 2012,
#'                  agg_level_desc = "STATE",
#'                  state_alpha = "WA",
#'                  statisticcat_desc = "YIELD")
#'
#'   # Returns a request object that must be parsed either manually or
#'   # by using nassqs_parse()
#'   response <- nassqs_GET(params)
#'   yields <- nassqs_parse(response)
#'   head(yields)
#'
#'   # Get the number of records that would be returned for a given request
#'   # Equivalent to 'nassqs_record_count(params)'
#'   response <- nassqs_GET(params, api_path = "get_counts")
#'   records <- nassqs_parse(response)
#'   records
#'
#'   # Get the list of allowable values for the parameters 'statisticcat_desc'
#'   # Equivalent to 'nassqs_param_values("statisticcat_desc")'
#'   req <- nassqs_GET(list(param = "statisticcat_desc"),
#'                     api_path = "get_param_values")
#'   statisticcat_desc_values <- nassqs_parse(req, as = "list")
#'   head(statisticcat_desc_values)
#' }
nassqs_GET <- function(...,
                       api_path = c("api_GET",
                                    "get_param_values",
                                    "get_counts")) {

  # Check that the api key is set
  key <- Sys.getenv("NASSQS_TOKEN")
  if(identical(key, "")) {
    stop("Please use 'nassqs_auth(key = <your api key>)' to set your api key",
         call. = FALSE)
  }

  # match args
  api_path <- match.arg(api_path)

  # get the full param list and make sure all arguments are in capital letters
  params <- expand_list(...)

  if (api_path == "get_param_values") {
    # parameter names are lower case, so the query requires lower case terms
    params <- lapply(params, tolower)
  } else {
    # All other API calls require query terms in upper case
    params <- lapply(params, toupper)

    # except 'format', which must be lower case and one of 'json', 'csv',
    # or 'xml'
    if("format" %in% names(params)) {
      format <- tolower(params$format)
      params[["format"]] <- format
      if(!(format %in% c("json", "xml", "csv"))) {
        stop("Your query parameters include 'format' as ", format,
                    " but it should be one of 'json', 'xml', or 'csv'.")
      }
    }
  }

  # Create the query
  query <- list(key = key)
  query <- append(query, params)

  if(!("format" %in% names(query))) query['format'] <- "JSON"

  # full url
  url <- paste0("https://quickstats.nass.usda.gov/api/", api_path)
  u <- httr::parse_url(url)
  u$query <- query

  resp <- httr::GET(url, query = query, httr::progress())
  nassqs_check(resp)
  
  resp
}

#' Check the response.
#'
#' Check that the response is valid, i.e. that it doesn't exceed 50,000 records
#' and that all the parameter values are valid. This is used to ensure that
#' the query is valid before querying to reduce wait times before receiving an
#' error.
#'
#' @param response a [httr::GET()] request result returned from the API.
#' @return nothing if check is passed, or an informative error if not passed.
nassqs_check <- function(response) {
  if (response$status_code < 400) {
    return(TRUE) #all good!
  }
  else if (response$status_code == 413) {
    stop("Request was too large. NASS requires that an API call ",
         "returns a maximum of 50,000 records. Consider subsetting ",
         "your request by geography or year to reduce the size of ",
         "your query.", call. = FALSE)
  }
  else {
    stop("HTTP Failure: ",
         response$status_code,
         "\n",
         jsonlite::fromJSON(httr::content(response,
                                          as="text",
                                          type="text/json",
                                          encoding = "UTF-8")),
         call. = FALSE)
  }
}

#' Parse a response object from `nassqs_GET()`.
#'
#' Returns a data frame, list, or text string. If a data.frame, all columns
#' except `year` strings because the 'Quick Stats' data returns suppressed data
#' as '(D)', '(Z)', or other character indicators which mean different things.
#' Converting the value to a numerical results in NA, which loses that
#' information.
#'
#' @export
#' @importFrom utils read.csv
#'
#' @param req the GET response from [nassqs_GET()]
#' @param as whether to return a data.frame, list, or text string
#' @param ... additional parameters passed to [jsonlite::fromJSON()] or
#'   [utils::read.csv()]
#' @return a data frame, list, or text string of the content from the response.
#' @examples \donttest{
#'   # Set parameters and make the request
#'   params <- list(commodity_name = "CORN",
#'                  year = 2012,
#'                  agg_level_desc = "STATE",
#'                  state_alpha = "WA",
#'                  statisticcat_desc = "YIELD")
#'   response <- nassqs_GET(params)
#'
#'   # Parse the response to a data frame
#'   corn <- nassqs_parse(response, as = "data.frame")
#'   head(corn)
#'
#'   # Parse the response into a raw character string.
#'   corn_text<- nassqs_parse(response, as = "text")
#'   head(corn_text)
#'
#'   # Get a list of parameter values and parse as a list
#'   response <- nassqs_GET(list(param = "statisticcat_desc"),
#'                     api_path = "get_param_values")
#'   statisticcat_desc_values <- nassqs_parse(response, as = "list")
#'   head(statisticcat_desc_values)
#' }
nassqs_parse <- function(req, as = c("data.frame", "list", "text"), ...) {
  as = match.arg(as)

  type <- req$headers[['content-type']]
  resp <- httr::content(req, as = "text", encoding = "UTF-8")

  # process the data depending on returned data type
  if(as == "text") {
    ret <- resp
  } else if(type %in% c("application/json", "application/json; charset=UTF-8")) {
    # format == JSON
    # Handle error where response is truncated if too long (only happens)
    # when making a call to the "get_param_values" api_path for 'domaincat_desc'
    ret <- tryCatch(jsonlite::fromJSON(resp),
                    error = function(e) {
                      stop("JSON is malformed. This is a problem with ",
                           "the Quick Stats API, not the rnassqs ",
                           "package. \n",
                           e) })
    if("data" %in% names(ret)) ret <- ret$data

  } else if(type %in% c("application/xml", "application/xml; charset=UTF-8")) {
    # format == XML
    stop("XML not yet implemented. Use format = 'JSON' or format = ",
         "'CSV' instead.")
  } else if(type %in% c("text/csv", "text/csv; charset=UTF-8")) {
    # format == CSV
    ret <- read.csv(text = resp, sep =",", header = TRUE, ...)
    names(ret)[which(names(ret) == "CV....")] <- "CV (%)"
  } else {
    stop("Response is not in the expected json, xml, or csv format. ",
         "Use `as = 'text'` to see the unparsed response data, or ",
         "modify your parameters to include `format = 'json'` to ",
         "make the request in json.")
  }
  ret
}
