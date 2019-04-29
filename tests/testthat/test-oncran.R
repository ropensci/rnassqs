context("tests run on CRAN")

# Tests that are run on cran.
# These do not access the API directly and so don't need a authentication key.
# Tests are based on the API found here:
# https://quickstats.nass.usda.gov/api

params = list(
  commodity_desc = "CORN",
  year__GE = "2012",
  state_alpha = "VA"
)
test_that("nassqs_params returns fields/column names", {
  v <- nassqs_params()
  expect_equal(length(v), 39)
  expect_equal(class(v), "character")
  expect_equal(v[[1]], "agg_level_desc")
})

test_that("nassqs_record_count forms a correct URL", {
  v <- nassqs_record_count(params, key = "API_KEY", debug = TRUE)
  expect_equal(v, 
               "https://quickstats.nass.usda.gov/api/get_counts?key=API_KEY&commodity_desc=CORN&year__GE=2012&state_alpha=VA&format=JSON")
})

test_that("nassqs_param_values forms a correct URL", {
  v <- nassqs_params_values("statisticcat_desc", key = "API_KEY", debug = TRUE)
  expect_equal(v, 
               "https://quickstats.nass.usda.gov/api/get_param_values?key=API_KEY&param=statisticcat_desc&format=JSON")
})

test_that("nassqs_field_values forms a correct URL", {
  v = nassqs_field_values("statisticcat_desc", key = "API_KEY", debug = TRUE)
  expect_equal(v, 
               "https://quickstats.nass.usda.gov/api/get_param_values?key=API_KEY&param=statisticcat_desc&format=JSON")
})

test_that("nassqs_GET forms a correct URL", {
  v <- nassqs_GET(params, key = "API_KEY", debug = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year__GE=2012&state_alpha=VA&format=JSON")
})
test_that("nassqs_yield returns a correct URL", {
  v <- nassqs_yield(params, key = "API_KEY", debug = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&statisticcat_desc=YIELD&commodity_desc=CORN&year__GE=2012&state_alpha=VA&format=JSON")
})

test_that("nassqs_area returns a correct URL", {
  v <- nassqs_area(params, area = c("AREA HARVESTED", "AREA PLANTED"), key = "API_KEY", debug = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&statisticcat_desc=AREA%20HARVESTED&statisticcat_desc=AREA%20PLANTED&unit_desc=ACRES&commodity_desc=CORN&year__GE=2012&state_alpha=VA&format=JSON")
})


### Test for data type processing and response parsing

# JSON
test_that("nassqs_parse parses JSON to data.frame", {
  test_file <- system.file("testdata", "request_json.rds", package = "rnassqs")
  req <- readRDS(test_file)
  d <- nassqs_parse(req)
  expect_equal(class(d), "data.frame")
  expect_equal(nrow(d), 12)
})

# CSV
test_that("nassqs_parse parses CSV to data.frame", {
  test_file <- system.file("testdata", "request_csv.rds", package = "rnassqs")
  req <- readRDS(test_file)
  d <- nassqs_parse(req)
  expect_equal(class(d), "data.frame")
  expect_equal(nrow(d), 12)
  expect_true("CV (%)" %in% names(d))
})


# Raw
test_that("nassqs_parse parses a csv response to text", {
  test_file <- system.file("testdata", "request_csv.rds", package = "rnassqs")
  req <- readRDS(test_file)
  d <- nassqs_parse(req, as = "raw")
  expect_equal(class(d), "character")
})
test_that("nassqs_parse parses a json response to text", {
  test_file <- system.file("testdata", "request_json.rds", package = "rnassqs")
  req <- readRDS(test_file)
  d <- nassqs_parse(req, as = "raw")
  expect_equal(class(d), "character")
})
test_that("nassqs_parse parses a xml response to text", {
  test_file <- system.file("testdata", "request_xml.rds", package = "rnassqs")
  req <- readRDS(test_file)
  d <- nassqs_parse(req, as = "raw")
  expect_equal(class(d), "character")
})
