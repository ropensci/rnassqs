#!/usr/bin/Rscript
#
# Generate response data for tests
library(rnassqs)

params = list(
  commodity_desc = "CORN",
  year = "2012",
  statisticcat_desc = "YIELD",
  agg_level_desc = "STATE",
  state_alpha = "VA"
)

### JSON
req <- nassqs_GET(params)
saveRDS(req, file = here::here("tests/testthat/testdata/request_json.rds"), version = "2")


