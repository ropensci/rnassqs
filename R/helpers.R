#' Get all values for a specific parameter.
#'
#' Equivalent to \code{nassqs_GET(list('param'=param_name))}
#'
#' @export
#'
#' @param param the name of a NASS quickstats field.
#' @param ... additional parameters passed to \code{\link{nassqs_GET}}.
#' @return a list containing values for that parameter.
#' @examples \donttest{
#'   # See all values available for the statisticcat_desc field. Values may not
#'   # be available in the context of other parameters you set, for example
#'   # a given state may not have any 'YIElD' in blueberries if they don't grow
#'   # blueberries in that state.
#'   # Requires an API key:
#'   #nassqs_param_values("statisticcat_desc", key = "my api key")
#' }
nassqs_param_values <- function(param, ...) {
  params = list("param"=param)
  nassqs_parse(nassqs_GET(params, ..., api_path="get_param_values"), as="list")[[1]]
}

#' Get a count of number of records for given parameters.
#'
#' Returns the number of records that fit a set of parameters. Useful if your
#' current parameter set returns more than the 50,000 record limit.
#'
#' @export
#'
#' @param params a named list of parameters and values.
#' @param ... additional parameters passed to \code{\link{nassqs_GET}}.
#' @return integer that is the number of records that fits those parameter values.
#' @examples \donttest{
#'   #Check the number of records returned for corn in 1995, Washington state
#'   params = list(
#'     commodity_desc = "CORN",
#'     year = "2005",
#'     agg_level_desc = "STATE",
#'     state_name = "WASHINGTON"
#'   )
#'   
#'   nassqs_record_count(params) #returns 17.
#'
#' }
nassqs_record_count <- function(params, ...) {
  nassqs_parse(nassqs_GET(params, ..., api_path="get_counts"))
}

#' Get yield records for a specified crop.
#'
#' Convenience function to take a list of parameters and add a parameter to
#' specify yield. Equivalent to \code{nassqs(list(..., "statisticcat_desc" = "YIELD"))}
#'
#' @export
#'
#' @param params a named list of parameters
#' @param ... additional parameters passed to \code{\link{nassqs}}
#' @return a dataset of NASSQS data.
#' @examples \donttest{
#'   #get yields for wheat in 2012, all geographies
#'   params = list(commodity_desc="WHEAT", year="2012")
#'   nassqs_yield(params)
#' }
nassqs_yield <- function(params, ...) {
  params[['statisticcat_desc']] <- "YIELD"
  nassqs(params, ...)
}

#' Get NASS Area given a set of parameters.
#'
#' @export
#'
#' @param params a named list of parameters to select records.
#' @param area the type of area to return. Default is all types.
#' @param ... additional parameters passed to \code{nassqs()}.
#' @return a data frame of NASSQS data.
#' @examples \donttest{
#'   #Get Area bearing for Apples in Washington, 2012.
#'   params = list(
#'     commodity_desc = "APPLES",
#'     year = "2012",
#'     state_name = "WASHINGTON",
#'     agg_level_desc = "STATE"
#'   )
#'   nassqs_area(params, area = "AREA BEARING")
#' }
nassqs_area <- function(params,
                        area=c("AREA", "AREA PLANTED", "AREA BEARING", "AREA BEARING & NON-BEARING",
                               "AREA GROWN", "AREA HARVESTED", "AREA IRRIGATED", "AREA NON-BEARING",
                               "AREA PLANTED", "AREA PLANTED, NET"),
                        ...) {
  area = match.arg(area, several.ok = TRUE)
  params[['statisticcat_desc']] <- area
  params[['unit_desc']] <- "ACRES"

  nassqs(params, ...)
}

#' Expand an ellipsis list.
#' @importFrom stats setNames
#' @importFrom utils stack
#' 
#' @param listx a list to be expanded.
#' @return an expanded list.
expand_list <- function(listx){
  res <- stack(listx)
  as.list(setNames(res$values, res$ind))
}
