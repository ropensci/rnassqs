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
#' @details
#' `nassqs()` accepts all parameters that are accepted by the USDA-NASS Quick 
#' Stats. These parameters are listed in [nassqs_params()], and are used to form
#' the data query.
#' 
#' Parameters can be modified by operations, which are appended to the parameter
#' name. For example, "year__GE = 2020" will fetch data in 2020 and after. 
#' Operations can take the following form:
#' - __LE: less than or equal (<=)
#' - __LT: less than (<)
#' - __GT: greater than (>)
#' - __GE: = >=
#' - __LIKE = like
#' - __NOT_LIKE = not like
#' - __NE = not equal 
#' 
#'   
#' @export
#'
#' @param ... either a named list of parameters or a series of additional
#'   parameters that include operations, e.g. `year__GE = 2010` for all
#'   records in 2010 and later. See `details` for information on available 
#'   operators.
#' @param agg_level_desc Geographic level ("AGRICULTURAL DISTRICT", "COUNTY",
#'   "INTERNATIONAL", "NATIONAL", "REGION : MULTI-STATE", "REGION : SUB-STATE",
#'   "STATE", "WATERSHED", or "ZIP CODE").
#' @param asd_code Agriculture statistical district code.  
#' @param asd_desc Agriculture statistical district name / description.
#' @param begin_code Week number indicating when the data series begins.
#' @param class_desc Commodity class.
#' @param commodity_desc Commodity, the primary subject of interest (e.g.,
#'   "CORN", "CATTLE", "LABOR", "TRACTORS", "OPERATORS").
#' @param congr_district_code Congressional District codes.
#' @param country_code Country code.
#' @param country_name Country name.
#' @param county_ansi County ANSI code.
#' @param county_code County FIPS code.
#' @param county_name County name.
#' @param domaincat_desc Domain category within a domain (e.g., 
#'   under domain_desc = "SALES", domain categories include $1,000 TO $9,999, 
#'   $10,000 TO $19,999, etc).
#' @param domain_desc Domain, a characteristic of operations that produce a 
#'   particular commodity (e.g., "ECONOMIC CLASS", "AREA OPERATED", "NAICS 
#'   CLASSIFICATION", "SALES"). For chemical usage data, the domain describes 
#'   the type of chemical applied to the commodity. The domain_desc: = "TOTAL" 
#'   will have no further breakouts; i.e., the data value pertains completely 
#'   to the short_desc.
#' @param end_code = Week number that the data series ends.
#' @param freq_desc Time period type covered by the data ("ANNUAL", "SEASON", 
#'   "MONTHLY", "WEEKLY", "POINT IN TIME"). "MONTHLY" often covers more than one
#'   month. "POINT IN TIME" is for a particular day.
#' @param group_desc Commodity group within a sector (e.g., under sector_desc =
#'   "CROPS", the groups are "FIELD CROPS", "FRUIT & TREE NUTS", "HORTICULTURE",
#'   and "VEGETABLES").
#' @param load_time Date and time of the data load, e.g. "2015-02-17 16:05:20".
#' @param location_desc Location code, e.g. 5-digit fips code for counties.
#' @param prodn_practice_desc Production practice, (e.g. "UNDER PROTECTION", 
#'   "OWNED, RIGHTS, LEASED", "ORGANIC, TRANSITIONING", "HIRED MANAGER").
#' @param reference_period_desc Reference period of the data (e.g. "JUN", 
#'   "MID SEP", "WEEK #32").
#' @param region_desc Region name (e.g. "TEXAS", "WA & OR", "WEST COAST", 
#'   "UMATILLA").
#' @param sector_desc Sector, the five high level, broad categories useful to
#'   narrow down choices. ("ANIMALS & PRODUCTS", "CROPS", "DEMOGRAPHICS",
#'   "ECONOMICS", or "ENVIRONMENTAL").
#' @param short_desc A concatenation of six columns: `commodity_desc`, 
#'   `class_desc`, `prodn_practice_desc`, `util_practice_desc`, 
#'   `statisticcat_desc`, and `unit_desc`.
#' @param source_desc Source of data ("CENSUS" or "SURVEY"). Census program 
#'   includes the Census of Ag as well as follow up projects. Survey program 
#'   includes national, state, and county surveys.
#' @param state_alpha 2-character state abbreviation, e.g. "NM".
#' @param state_ansi State ANSI code.
#' @param state_fips_code State FIPS code.
#' @param state_name Full name of the state, e.g. "ALABAMA".
#' @param statisticcat_desc Statistical category of the data (e.g., 
#'   "AREA HARVESTED", "PRICE RECEIVED", "INVENTORY", "SALES").
#' @param unit_desc The units of the data (e.g. "TONS / ACRE", "TREES", 
#'   "OPERATIONS", "NUMBER", "LB / ACRE", "BU / PLANTED ACRE").
#' @param util_practice_desc Utilization practice (e.g. "WIND", "SUGAR", "SILAGE", 
#'   "ONCE REFINED", "FEED", "ANIMAL FEED").
#' @param watershed_code Watershed code as 8-digit HUC (e.g. "13020100").
#' @param watershed_desc Watershed/HUC name (e.g. "UPPER COLORADO").
#' @param week_ending Date of ending week (e.g. "1975-11-22").
#' @param year Year of the data. Conditional values are possible by appending an
#'   operation to the parameter, e.g. "year__GE = 2020" will return all records
#'   with year >= 2020. See `details` for more on operations.
#' @param zip_5 5-digit zip code.
#' @param as_numeric Whether to convert data to numeric format. Conversion will
#'   replace missing notation such as "(D)" or "(Z)" with NA, but removes the 
#'   need to convert to numeric format after querying.
#' @param progress_bar Whether or not to display the progress bar.
#' @param format The format to return the query in. Only useful if as = "text".
#' @param as whether to return a data.frame, list, or text string. See 
#'   [nassqs_parse()].
#' @return a data frame, list, or text string of requested data.
#' @seealso [nassqs_GET()], [nassqs_parse()], [nassqs_yields()], [nassqs_acres()]
#' @examples \dontrun{
#'   # Get corn yields in Virginia in 2012
#'   params <- list(commodity_desc = "CORN",
#'                  year = 2012,
#'                  agg_level_desc = "COUNTY",
#'                  state_alpha = "VA",
#'                  statisticcat_desc = "YIELD")
#'   yields <- nassqs(params)
#'   head(yields)
#' }
nassqs <- function(...,
                   agg_level_desc = NULL,
                   asd_code = NULL,
                   asd_desc = NULL,
                   begin_code = NULL,
                   class_desc = NULL,
                   commodity_desc = NULL,
                   congr_district_code = NULL,
                   country_code = NULL,
                   country_name = NULL,
                   county_ansi = NULL,
                   county_code = NULL,
                   county_name = NULL,
                   domaincat_desc = NULL,
                   domain_desc = NULL,
                   end_code = NULL,
                   freq_desc = NULL,
                   group_desc = NULL,
                   load_time = NULL,
                   location_desc = NULL,
                   prodn_practice_desc = NULL,
                   reference_period_desc = NULL,
                   region_desc = NULL,
                   sector_desc = NULL,
                   short_desc = NULL,
                   source_desc = NULL,
                   state_alpha = NULL,
                   state_ansi = NULL,
                   state_fips_code = NULL,
                   state_name = NULL,
                   statisticcat_desc = NULL,
                   unit_desc = NULL,
                   util_practice_desc = NULL,
                   watershed_code = NULL,
                   watershed_desc = NULL,
                   week_ending = NULL,
                   year = NULL,
                   zip_5 = NULL,
                   as_numeric = TRUE,
                   progress_bar = TRUE,
                   format = "csv", 
                   as = "data.frame") {

  # Get a list of parameters, named ones and from the dots
  env_params <- as.list(environment())
  for(v in c("params", "as_numeric", "progress_bar", "format", "as")) { 
    env_params[[v]] <- NULL 
  }
  
  dot_params <- expand_list(...)
  params <- if(length(dot_params) > 0) c(env_params, dot_params) else env_params

  # Make the request
  req <- nassqs_GET(params, api_path = "api_GET", 
                    progress_bar = progress_bar, format = format)
  nassqs_parse(req, as_numeric = as_numeric, as = as)
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
#' @param api_path the API path that determines the type of request being made.
#' @param progress_bar whether to display the project bar or not.
#' @param format The format to return the query in. Only useful if as = "text".
#' @return a [httr::GET()] response object
#' @examples \dontrun{
#'   # Yields for corn in 2012 in Washington
#'   params <- list(commodity_desc = "CORN",
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
                                    "get_counts"),
                       progress_bar = TRUE,
                       format = c("csv", "json", "xml")) {
  
  # match args
  api_path <- match.arg(api_path)
  format <- match.arg(format)

  params <- expand_list(...)

  # Check that names of the parameters are in the valid parameter list
  for(x in names(params)) { parameter_is_valid(x) }
  
  # Check that the api key is set
  key <- Sys.getenv("NASSQS_TOKEN")
  if(identical(key, "")) {
    stop("Please use 'nassqs_auth(key = <your api key>)' to set your api key",
         call. = FALSE)
  }
  
  if(api_path == "get_param_values") {
    # parameter names are lower case, so the query requires lower case terms
    params <- lapply(params, tolower)
  } else {
    # All other API calls require query terms in upper case
    params <- lapply(params, toupper)
  }
  
  
  
  # Add the format
  params[["format"]] <- toupper(format)

  # Flatten multiple values before using httr
  params <- flatten(params)
  

  # Create the query
  query <- list(key = key)
  query <- append(query, params)

  # full url
  url <- paste0("https://quickstats.nass.usda.gov/api/", api_path)
  u <- httr::parse_url(url)
  u$query <- query

  if(progress_bar) {
    resp <- httr::GET(url, query = query, httr::progress())    
  } else {
    resp <- httr::GET(url, query = query)    
  }

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
  if(response$status_code < 400) {
    return(TRUE) #all good!
  }
  else if(response$status_code == 413) {
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
                                          as = "text",
                                          type = "text/json",
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
#' @param as_numeric whether to convert values to numeric format.
#' @param as whether to return a data.frame, list, or text string
#' @param ... additional parameters passed to [jsonlite::fromJSON()] or
#'   [utils::read.csv()]
#' @return a data frame, list, or text string of the content from the response.
#' @examples \dontrun{
#'   # Set parameters and make the request
#'   params <- list(commodity_desc = "CORN",
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
nassqs_parse <- function(req, 
                         as_numeric = TRUE, 
                         as = c("data.frame", "list", "text"), 
                         ...) {
  
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
    ret <- read.csv(text = resp, sep = ",", header = TRUE, 
                    colClasses = "character", ...)
    names(ret)[which(names(ret) == "CV....")] <- "CV (%)"
  } else {
    stop("Response is not in the expected json, xml, or csv format. ",
         "Use `as = 'text'` to see the unparsed response data, or ",
         "modify your parameters to include `format = 'json'` to ",
         "make the request in json.")
  }

  # Convert "Value" to numeric
  if(as_numeric & as != "text") { ret$Value <- char_to_num(ret$Value) }
  
  ret
}


