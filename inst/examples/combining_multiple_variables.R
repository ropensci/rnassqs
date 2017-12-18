# A more complex example that creates a data.frame from several variables.
#
# Here we fetch several variables at a county level, checking that each query
# does not exceed the 50000 API record limit, and appending the query results
# to a single data frame

# Libraries --------------------------------------------------------------------
library(rnassqs)
library(jsonlite)

# Functions to get data --------------------------------------------------------

#' wrapper to download quickstats data for different parameters
#' 
#' @param params a named list of parameters.
#' @param api_key character api key for nass quickstats.
#' @return a data.frame.
get_data <- function(params, api_key) {
  n_records <- as.integer(nassqs_record_count(params, key=api_key)[[1]])
  if(n_records <= 50000) {
    df_raw <- nassqs(params=params, key = api_key)
    return(df_raw)
  } else {stop("Too many records requested. Revise your query.")}
}

# Need an API key from NASS ----------------------------------------------------
# Get one here: https://quickstats.nass.usda.gov/api
api_key <- fromJSON(file(".secret"))$nassqs

## The set of queries, includes ------------------------------------------------
# 1. Cash rents by county since 2000
# 2. acres of cropland by county since 1997
# 3. irrigated acres of cropland by county since 1997
# 4. acres of pastureland by county since 1997
# 5. acres of all irrigated land by county since 1997
# 6. Total ag sales by county since 1997

param_list <- list(
  cash_rents = list(sector_desc = "ECONOMICS",
                    commodity_desc = "RENT",
                    agg_level_desc = "COUNTY",
                    year__GE = 2000),
  ag_cropland = list(sector_desc = "ECONOMICS",
                     commodity_desc = "AG LAND",
                     agg_level_desc = "COUNTY",
                     class_desc = "CROPLAND",
                     unit_desc = "ACRES",
                     statisticcat_desc = "AREA",
                     year__GE = 1997),
  ag_cropland_irr = list(sector_desc = "ECONOMICS",
                         commodity_desc = "AG LAND",
                         agg_level_desc = "COUNTY",
                         class_desc = "CROPLAND",
                         unit_desc = "ACRES",
                         prodn_practice_desc = "IRRIGATED",
                         statisticcat_desc = "AREA",
                         year__GE = 1997),
  ag_pastureland = list(sector_desc = "ECONOMICS",
                        commodity_desc = "AG LAND",
                        agg_level_desc = "COUNTY",
                        class_desc = "PASTURELAND",
                        unit_desc = "ACRES",
                        statisticcat_desc = "AREA",
                        year__GE = 1997),
  ag_irrigatedland = list(sector_desc = "ECONOMICS",
                          commodity_desc = "AG LAND",
                          agg_level_desc = "COUNTY",
                          prodn_practice_desc = "IRRIGATED",
                          class_desc = "ALL CLASSES",
                          unit_desc = "ACRES",
                          domain_desc = "TOTAL",
                          year__GE = 1997),
  ag_sales = list(sector_desc = "ECONOMICS",
                  commodity_desc = "COMMODITY TOTALS",
                  agg_level_desc = "COUNTY",
                  statisticcat_desc = "SALES",
                  util_practice_desc = "ALL UTILIZATION PRACTICES",
                  unit_desc = "$",
                  domain_desc = "TOTAL",
                  domaincat_desc = "NOT SPECIFIED",
                  year__GE = 1997)
  )

# Fetch and aggregate the data
data <- rbindlist(
  lapply(names(param_list), function(data_source) {
    print(paste0("Downloading ", data_source, "..."))
    d <- get_data(param_list[[data_source]], api_key)
    d$variable <- data_source
    return(d)
  })
)
