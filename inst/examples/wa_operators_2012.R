# Get NASS farm operators in the state of WA for 2012
library(rnassqs)

# Set the api key
api_key = "<put your api key here>"

#Define the query parameters
params <- list(sector_desc = "DEMOGRAPHICS",
               commodity_desc = "OPERATORS, PRINCIPAL",
               statisticcat_desc = "OPERATORS",
               state_alpha = "WA",
               agg_level_desc = "STATE",
               year = 2012)

#Check number of records
n_records <- as.integer(nassqs_record_count(params, key=api_key)[[1]])

# DL data if records are within the limit
if(n_records < 50000) {
  operators <- rnassqs::nassqs(params=params, key = api_key)
} else {stop("Too many records requested. Revise your query.")}
