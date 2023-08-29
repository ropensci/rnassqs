library(httptest)
library(here)

# First evaluate the API KEY if available
api_key <- Sys.getenv("NASSQS_TOKEN") 
api_file <- here::here("tests/testthat/api-key.txt")
if(nchar(Sys.getenv("NASSQS_TOKEN") ) != 36 & file.exists(api_file)) {
  Sys.setenv(NASSQS_TOKEN = readLines(api_file))
}


# Parameters
params <- list(
  agg_level_desc = "STATE",
  commodity_desc = "CORN",
  domaincat_desc = "NOT SPECIFIED",
  state_alpha = "VA",
  statisticcat_desc = "AREA HARVESTED",
  year = "2012"
)


### Generate error response data objects if needed
#testparams <- params

## 400 error
# testparams$year <- 2102
# query <- list(key = api_key)
# query <- append(query, flatten(testparams))
# r <- httr::GET("https://quickstats.nass.usda.gov/api/api_GET", query = query)
#saveRDS(r, file = test_path("testdata", "qsresponse_400.rds"))
# r <- httr::GET("http://httpbin.org/status/400")
# saveRDS(r, file = test_path("testdata", "response_400.rds"))

# # 413 error
# query <- list(key = api_key)
# query <- append(query, flatten(list(year__GET = 2000)))
# r <- httr::GET("https://quickstats.nass.usda.gov/api/api_GET", query = query)   
# saveRDS(r, file = test_path("testdata", "qsresponse_413.rds"))
#r <- httr::GET("http://httpbin.org/status/413")
#saveRDS(r, file = test_path("testdata", "response_413.rds"))

# 429 error
# r <- httr::GET("http://httpbin.org/status/429")
# saveRDS(r, file = test_path("testdata", "response_429.rds"))


with_mock_api <- function(expr) {
  # Set a fake token just in this context
  old_token <- Sys.getenv("NASSQS_TOKEN")
  Sys.setenv(NASSQS_TOKEN = "API_KEY")
  on.exit(Sys.setenv(NASSQS_TOKEN = old_token))
  
  httptest::with_mock_api(expr)
}

with_authentication <- function(expr) {
  if (nchar(Sys.getenv("NASSQS_TOKEN")) == 36) {
    # Only evaluate if a token is set
    expr
  }
}







