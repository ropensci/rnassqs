#' Return list of NASS QS parameters.
#' 
#' Contains a simple hard-coded list of all available parameters. If no 
#' parameter name is provided, returns a list of all parameters. More 
#' information can be found in the API documentation on parameters found at
#' [https://quickstats.nass.usda.gov/api#param_define](https://quickstats.nass.usda.gov/api#param_define).
#' 
#' @export
#' 
#' @param ... a parameter, series of parameters, or a list of parameters that 
#'   you would like a description of. If missing, a list of all available 
#'   parameters is returned.
#' @return a list of all available parameters or a description of a subset
#' @examples 
#' # Get a list of all available parameters
#' nassqs_params()
#' 
#' # Get information about specific parameters
#' nassqs_params("source_desc", "group_desc")
nassqs_params <- function(...) {
  param_list <- list(
    agg_level_desc = paste0("Geographical level of data. Often 'county', ",
                            "'state', or 'national', but can include other ",
                            "levels as well"),
    asd_code = paste0("Agriculural Statistics Districts (ASD) code. ASDs are ",
                      "groupings of counties"),
    asd_desc = paste0("Agriculural Statistics Districts (ASD) name. ASDs are ",
                      "groupings of counties."),
    begin_code = "Beginning of the reference period.",
    class_desc = paste0("Class of the variable in 'commodity_desc'. May be a ",
                        "crop class, a demographic class, or other category"),
    commodity_desc = paste0("Commodity or other variable of interest. ",
                            "Non-commodity values include 'SNOW', 'PPITW', ",
                            "'TRUCKS & AUTOS', 'OPERATORS', and many others"),
    congr_district_code = "Congressional district code",
    country_code = "Four-digit country code",
    country_name = "Country name",
    county_ansi = "County FIPS code",
    county_code = paste0("County FIPS code. Includes USDA-NASS specific codes ",
                         "like '098' and '099'"),
    county_name = "County name",
    CV = paste0("Coefficient of variation, an estimate of the reliability of ",
                "the data"),
    domaincat_desc = "Domain category.",
    domain_desc = paste0("Domain of the commodity. Includes values like ",
                         "'PRODUCER', 'ORGANIC STATUS', and many others"),
    end_code = "End of the reference period",
    freq_desc = "Frequency of measurement",
    group_desc = "Commodity group category. A subset of the sector",
    load_time = "Date and time of data load",
    location_desc = paste0("Code describing the geographic location. For ",
                           "example, a FIPS code or a congressional district ",
                           "code."),
    prodn_practice_desc = paste0("Production practice. Includes 'OWNED', ",
                                 "'ORGANIC', and many other values"),
    reference_period_desc = paste0("Reference time period of the data. May be ",
                                   "a week number like 'WEEK #48', a range of ",
                                   "months like 'JUL THRU SEP', or other time ",
                                   "period"),
    region_desc = paste0("Data region. Generally multi-state but can be ",
                         "sub-state as well"),
    sector_desc = paste0("Data sector. Can be one of 'ANIMALS & PRODUCTS', ",
                         "'CROPS', 'DEMOGRAPHICS', 'ECONOMICS', ",
                         "'ENVIRONMENTAL'"),
    short_desc = paste0("Data description that includes a concatenation of ",
                        "other parameters"),
    state_alpha = "Two-character state abbreviation",
    state_ansi = "State fips code.",
    state_name = "State name",
    state_fips_code = paste0("State fips code. Includes USDA-NASS specific ",
                             "codes such as '00', 98', and '99' to indicate ",
                             "non-state entities"),
    statisticcat_desc = paste0("Data category. May include 'YIELD', 'AREA', ",
                               "'TIME OPERATED', or other measures of the ",
                               "value reported"),
    source_desc = "Data source. Either 'CENSUS' or 'SURVEY'", 
    unit_desc = "Unit of the value",
    util_practice_desc = paste0("Utilization description. May include end ",
                                "use, end use location, end market, ",
                                "processing or fresh, crop type, or other ",
                                "category"),
    Value = paste0("Value of data. Can include character entries '(D)' and ",
                   "'(Z)' for missing data"),
    watershed_code = "Watershed Code",
    watershed_desc = "Watershed Name",
    week_ending = "Date of end of week in format 'YYYY-MM-DD'",
    year = "Year",
    zip_5 = "Zip code")
  
  if(missing(...)) {
    return(names(param_list))
  } else {
    x <- list(...)
    params <- if(length(nchar(x[[1]])) == 1) x else x[[1]]
    p_desc <- sapply(params, function(p) { 
      paste0(p, ": ", param_list[[p]]) 
    }, USE.NAMES = FALSE)
    return(p_desc)
  }
}


#' Get all values for a specific parameter.
#'
#' Returns a list of all possible values for a given parameter. 
#'
#' @export
#'
#' @param param the name of a NASS quickstats parameter
#' @return a list containing all valid values for that parameter
#' @examples \donttest{
#'   # See all values available for the statisticcat_desc field. Values may not
#'   # be available in the context of other parameters you set, for example
#'   # a given state may not have any 'YIELD' in blueberries if they don't grow
#'   # blueberries in that state.
#'   # Requires an API key:
#'   
#'   nassqs_param_values("source_desc")
#' }
nassqs_param_values <- function(param) {
  params <- list(param = param)
  nassqs_parse(nassqs_GET(params, api_path = "get_param_values"), as = "list")[[1]]
}


#' Deprecated: Return list of NASS QS parameters.
#'
#' Deprecated. Use [nassqs_params()] instead.
#' @export
#' 
#' @param ... a parameter, series of parameters, or a list of parameters that 
#'   you would like a description of. If missing, a list of all available 
#'   parameters is returned.
nassqs_fields <- nassqs_params
