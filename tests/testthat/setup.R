library(httptest)

# First resolve API KEY
if(!(Sys.getenv("NASSQS_TOKEN") %in% c("", "API_KEY"))) {
  api_key <- Sys.getenv("NASSQS_TOKEN")
} else if(file.exists("api-key.txt")) { 
  api_key <- readLines("api-key.txt") 
} else {
  api_key <- ""
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





