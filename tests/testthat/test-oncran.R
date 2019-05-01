context("tests run on CRAN")

# Tests that are run on cran.
# These do not access the API directly and so don't need a authentication key.
# Tests are based on the API found here:
# https://quickstats.nass.usda.gov/api

params = list(
  commodity_desc = "CORN",
  year__GE = "2012",
  agg_level_desc = "COUNTY",
  statisticcat_desc = "AREA HARVESTED",
  state_alpha = "VA"
)


### Test authentication.
test_that("nassqs_auth returns the api key from NASSQS_TOKEN if set", {
  key = Sys.getenv("NASSQS_TOKEN")
  Sys.setenv(NASSQS_TOKEN = "API_KEY")
  expect_equal("API_KEY", nassqs_auth())
  Sys.setenv(NASSQS_TOKEN = key)
})

test_that("nassqs_auth takes a new key", {
  key <- Sys.getenv("NASSQS_TOKEN")
  Sys.unsetenv("NASSQS_TOKEN")
  nassqs_auth(key = "API_KEY")
  expect_equal("API_KEY", Sys.getenv("NASSQS_TOKEN"))
  Sys.setenv(NASSQS_TOKEN = key)
})

test_that("nassqs_auth returns error if NASSQS_TOKEN not set and session is not interactive", {
  if(interactive()) { skip("Session is interactive.") }
  
  key <- Sys.getenv("NASSQS_TOKEN")
  Sys.unsetenv("NASSQS_TOKEN")
  expect_error(nassqs_auth(), 
               "No authentication provided and your session is not interactive. See help('nassqs_auth') for details.",
               fixed = TRUE)
  Sys.setenv(NASSQS_TOKEN = key)
})

test_that("nassqs_GET returns error if no authentication provided in non-interactive session", {
  if(interactive()) { skip("Session is interactive.") }
  key <- Sys.getenv("NASSQS_TOKEN")
  Sys.unsetenv("NASSQS_TOKEN")
  expect_error(nassqs_GET(params),
               "No authentication provided and your session is not interactive. See help('nassqs_auth') for details.",
               fixed = TRUE)
  Sys.setenv(NASSQS_TOKEN = key)
})


### Test API without calls

test_that("nassqs_params returns fields/column names", {
  v <- nassqs_params()
  expect_equal(length(v), 39)
  expect_equal(class(v), "character")
  expect_equal(v[[1]], "agg_level_desc")
})

test_that("nassqs_record_count forms a correct URL", {
  v <- nassqs_record_count(params, key = "API_KEY", url_only = TRUE)
  expect_equal(v, 
               "https://quickstats.nass.usda.gov/api/get_counts?key=API_KEY&commodity_desc=CORN&year__GE=2012&agg_level_desc=COUNTY&statisticcat_desc=AREA%20HARVESTED&state_alpha=VA&format=JSON")
})

test_that("nassqs_param_values forms a correct URL", {
  v <- nassqs_param_values("statisticcat_desc", key = "API_KEY", url_only = TRUE)
  expect_equal(v, 
               "https://quickstats.nass.usda.gov/api/get_param_values?key=API_KEY&param=statisticcat_desc&format=JSON")
})

test_that("nassqs_GET forms a correct URL", {
  v <- nassqs_GET(params, key = "API_KEY", url_only = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year__GE=2012&agg_level_desc=COUNTY&statisticcat_desc=AREA%20HARVESTED&state_alpha=VA&format=JSON")
})

test_that("nassqs_yield returns a correct URL", {
  test_params <- list(commodity_desc = "CORN",
                      year__GE = "2012",
                      agg_level_desc = "COUNTY",
                      state_alpha = "VA")
  v <- nassqs_yield(test_params, key = "API_KEY", url_only = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year__GE=2012&agg_level_desc=COUNTY&state_alpha=VA&statisticcat_desc=YIELD&format=JSON")
})

test_that("nassqs_yield returns a correct URL even if statisticcat_desc parameter is set to a different value", {
  v <- nassqs_yield(params, key = "API_KEY", url_only = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year__GE=2012&agg_level_desc=COUNTY&statisticcat_desc=YIELD&state_alpha=VA&format=JSON")
})

test_that("nassqs_area returns a correct URL", {
  v <- nassqs_area(params, key = "API_KEY", url_only = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year__GE=2012&agg_level_desc=COUNTY&statisticcat_desc=AREA&statisticcat_desc=AREA%20PLANTED&statisticcat_desc=AREA%20BEARING&statisticcat_desc=AREA%20BEARING%20%26%20NON-BEARING&statisticcat_desc=AREA%20GROWN&statisticcat_desc=AREA%20HARVESTED&statisticcat_desc=AREA%20IRRIGATED&statisticcat_desc=AREA%20NON-BEARING&statisticcat_desc=AREA%20PLANTED&statisticcat_desc=AREA%20PLANTED%2C%20NET&state_alpha=VA&unit_desc=ACRES&format=JSON")
})

test_that("nassqs_area returns a correct URL even if statisticcat_desc parameter is set to a differen value", {
  v <- nassqs_area(params, area = c("AREA HARVESTED", "AREA PLANTED"), key = "API_KEY", url_only = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year__GE=2012&agg_level_desc=COUNTY&statisticcat_desc=AREA%20HARVESTED&statisticcat_desc=AREA%20PLANTED&state_alpha=VA&unit_desc=ACRES&format=JSON")
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
