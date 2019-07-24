#' Get/Set the environmental variable NASSQS_TOKEN to the API key
#'
#' If the API key is provided, sets the environmental variable. You can set 
#' your API key in four ways:
#'
#' 1. directly or as a variable from your `R` 
#'    program: `nassqs_auth(key = "<your api key>"`
#' 2. by setting `NASSQS_TOKEN` in your `R` environment file (you'll never have 
#'    to enter it again).
#' 3. by entering it into the console when asked (it will be stored for the 
#'    rest of the session.)
#'
#' @export
#'
#' @param key the API key (obtained from [https://quickstats.nass.usda.gov/api](https://quickstats.nass.usda.gov/api))
#' @examples
#' # Set the API key
#' nassqs_auth(key = "<your api key>")
#' Sys.getenv("NASSQS_TOKEN")
nassqs_auth <- function(key) Sys.setenv('NASSQS_TOKEN' = key)
