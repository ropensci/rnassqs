#!/usr/bin/Rscript
#
# Generate response data for tests
library(rnassqs)

key_file <- here::here(".secret")
if(file.exists(key_file)) {
  con <- file(key_file)
  key <- readLines(con)
  close(con)
}  

params = list(
  commodity_desc = "CORN",
  year = "2012",
  statisticcat_desc = "YIELD",
  agg_level_desc = "STATE",
  state_alpha = "VA"
)

### JSON
req <- nassqs_GET(params, key = key, format = "JSON")
saveRDS(req, file = here::here("tests/data/request_json.rds"))

### XML
req <- nassqs_GET(params, key = key, format = "XML")
saveRDS(req, file = here::here("tests/data/request_xml.rds"))

### CSV
req <- nassqs_GET(params, key = key, format = "CSV")
saveRDS(req, file = here::here("tests/data/request_csv.rds"))


