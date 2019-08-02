context("test parameter functions")


### API tests with mock API calls ----

# First set the API KEY to a static value
key <- Sys.getenv("NASSQS_TOKEN")
nassqs_auth(key = "API_KEY")

# Tests
with_mock_api({
  test_that("nassqs_param_values forms a correct URL", {
    expect_GET(nassqs_param_values("source_desc"),
               "https://quickstats.nass.usda.gov/api/get_param_values?key=API_KEY&param=source_desc&format=JSON")
  })
})

# Set the key after finishing mock tests
nassqs_auth(key = key)


### Tests with real API calls ----
with_authentication({
  test_that("nassqs_param_values returns parameter values", {
    v = nassqs_param_values("source_desc")
    expect_is(v, "character")
    expect_is(v[[1]], "character")
    expect_equal(nassqs_param_values("source_desc"), c("CENSUS", "SURVEY"))
  })
})

### Tests not involving the API ----
test_that("nassqs_params() returns a list of parameters", {
  expected_param_list <- c("agg_level_desc", "asd_code", "asd_desc",
                           "begin_code", "class_desc", "commodity_desc",
                           "congr_district_code", "country_code",
                           "country_name", "county_ansi",
                           "county_code", "county_name", "CV", "domaincat_desc",
                           "domain_desc", "end_code", "freq_desc", "group_desc",
                           "load_time", "location_desc", "prodn_practice_desc",
                           "reference_period_desc", "region_desc",
                           "sector_desc", "short_desc", "state_alpha",
                           "state_ansi", "state_name", "state_fips_code",
                           "statisticcat_desc", "source_desc", "unit_desc",
                           "util_practice_desc", "Value", "watershed_code",
                           "watershed_desc", "week_ending", "year", "zip_5")
  expect_equal(nassqs_params(), expected_param_list)
})

test_that("nassqs_params() accepts a single argument", {
  expected_output <- "source_desc: Data source. Either 'CENSUS' or 'SURVEY'"
  expect_equal(nassqs_params("source_desc"), expected_output)
})

test_that("nassqs_params() accepts multiple arguments", {
  expected_output <- c(
    "source_desc: Data source. Either 'CENSUS' or 'SURVEY'",
    "county_name: County name")
  expect_equal(nassqs_params("source_desc", "county_name"), expected_output)
})

test_that("nassqs_params() accepts a single simple list argument", {
  expected_output <- c(
    "source_desc: Data source. Either 'CENSUS' or 'SURVEY'",
    "county_name: County name")
  expect_equal(nassqs_params(c("source_desc", "county_name")), expected_output)
})
