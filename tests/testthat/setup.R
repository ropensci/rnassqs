library(httptest)
library(here)

# First evaluate the API KEY if available
api_key <- Sys.getenv("NASSQS_TOKEN") 
api_file <- here::here("tests/testthat/api-key.txt")
if(nchar(Sys.getenv("NASSQS_TOKEN") ) != 36 & file.exists(api_file)) {
  Sys.setenv(NASSQS_TOKEN = readLines(api_file))
}

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


# Parameters
params <- list(
  agg_level_desc = "STATE",
  commodity_desc = "CORN",
  domaincat_desc = "NOT SPECIFIED",
  state_alpha = "VA",
  statisticcat_desc = "AREA HARVESTED",
  year = "2012"
)





