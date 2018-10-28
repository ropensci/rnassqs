#' Return list of NASS QS parameters.
#' @export
nassqs_params <- function() {
  c(
    "agg_level_desc",
    "asd_code",
    "asd_desc",
    "begin_code",
    "class_desc",
    "commodity_desc",
    "congr_district_code",
    "country_code",
    "country_name",
    "county_ansi",
    "county_code",
    "county_name",
    "CV",
    "domaincat_desc",
    "domain_desc",
    "end_code",
    "freq_desc",
    "group_desc",
    "load_time",
    "location_desc",
    "prodn_practice_desc",
    "reference_period_desc",
    "region_desc",
    "sector_desc",
    "short_desc",
    "state_alpha",
    "state_ansi",
    "state_name",
    "state_fips_code",
    "statisticcat_desc",
    "source_desc",
    "unit_desc",
    "util_practice_desc",
    "Value",
    "watershed_code",
    "watershed_desc",
    "week_ending",
    "year",
    "zip_5")
}

#' Deprecated: Return list of NASS QS parameters.
#'
#' Deprecated. Use \code{nassqs_params()} instead.
#' @export
nassqs_fields <- function() { nassqs_params() }
