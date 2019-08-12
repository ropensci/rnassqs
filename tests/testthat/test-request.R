context("test HTTP GET related functions")

# Parameters
params <- list(
  commodity_desc = "CORN",
  year = "2012",
  agg_level_desc = "STATE",
  statisticcat_desc = "AREA HARVESTED",
  domaincat_desc = "NOT SPECIFIED",
  state_alpha = "VA"
)

lower_params <- list(
  commodity_desc = "corn",
  year = "2012",
  agg_level_desc = "state",
  statisticcat_desc = "area harvested",
  domaincat_desc = "not specified",
  state_alpha = "va"
)

### Test API URLs with mock APIs ----

with_mock_api({
  expected_url <- "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year=2012&agg_level_desc=STATE&statisticcat_desc=AREA%20HARVESTED&domaincat_desc=NOT%20SPECIFIED&state_alpha=VA&format=JSON"

  test_that("nassqs forms a correct URL", {
    expect_GET(nassqs(params), url = expected_url)
  })

  test_that("nassqs_GET() forms a correct URL", {
    expect_GET(nassqs_GET(params), url = expected_url)
  })

  test_that("nassqs_GET() works with lower case values", {
    expect_GET(nassqs(lower_params), url = expected_url)
  })

  test_that("Too-large request error is handled", {
    p2 <- params
    p2$year <- 2013
    expect_error(
      nassqs(p2),
      "Request was too large. NASS requires that an API call returns a max"
    )
  })

  test_that("Other server error is handled", {
    p3 <- params
    p3$year <- 2102
    expect_error(
      nassqs(p3),
      "HTTP Failure: 404"
    )
  })

  test_that("Invalid format is handled", {
    expect_error(
      nassqs(format = "png"),
      "Your query parameters include 'format' as png"
    )
  })
})


### API tests that make real API calls if local and have an API key ----
with_authentication({
  test_that("nassqs_GET successfully makes a request to the Quick Stats API", {
    req <- nassqs_GET(params)
    expect_is(req, "response")
  })

  test_that("nassqs_GET with api_path = 'api_GET' successfully makes a request to the Quick Stats API", {
    req <- nassqs_GET(params, api_path = 'api_GET')
    expect_is(req, "response")
  })

  test_that("nassqs_GET with api_path = 'get_param_values' successfully makes a request to the Quick Stats API", {
    req <- nassqs_GET(param = "source_desc", api_path = "get_param_values")
    expect_is(req, "response")

    values <- nassqs_parse(req)
    expect_is(values, "list")
  })

  test_that("nassqs_GET with api_path = 'get_counts' successfully makes a request to the Quick Stats API", {
    req <- nassqs_GET(params, api_path = "get_counts")
    expect_is(req, "response")

    n <- nassqs_parse(req)
    expect_is(n$count, "integer")
  })

  test_that("nassqs_parse successfully parses a request to the Quick Stats API", {
    req <- nassqs_GET(params)
    d <- nassqs_parse(req)
    expect_is(d, "data.frame")
    expect_equal(ncol(d), 39)
  })

  test_that("nassqs_parse successfully parses CSV data", {
    csv_params <- params
    csv_params[['format']] <- "csv"
    req <- nassqs_GET(csv_params)
    d <- nassqs_parse(req)
    expect_is(d, "data.frame")
    expect_equal(ncol(d), 39)
  })
})

### Non-API tests ---
test_that("nassqs_GET returns error if no authentication provided in non-interactive session", {
  key <- Sys.getenv("NASSQS_TOKEN")
  Sys.unsetenv("NASSQS_TOKEN")
  on.exit(Sys.setenv(NASSQS_TOKEN = key))
  expect_error(nassqs_GET(params),
               "Please use 'nassqs_auth(key = <your api key>)' to set your api key",
               fixed = TRUE)
})


## Test for data type processing and response parsing

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


# Text
test_that("nassqs_parse parses a csv response to text", {
  test_file <- system.file("testdata", "request_csv.rds", package = "rnassqs")
  req <- readRDS(test_file)
  d <- nassqs_parse(req, as = "text")
  expect_equal(class(d), "character")
})
test_that("nassqs_parse parses a json response to text", {
  test_file <- system.file("testdata", "request_json.rds", package = "rnassqs")
  req <- readRDS(test_file)
  d <- nassqs_parse(req, as = "text")
  expect_equal(class(d), "character")
})
test_that("nassqs_parse parses a xml response to text", {
  test_file <- system.file("testdata", "request_xml.rds", package = "rnassqs")
  req <- readRDS(test_file)
  d <- nassqs_parse(req, as = "text")
  expect_equal(class(d), "character")
})
