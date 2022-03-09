context("test parameter functions")

### API tests with mock API calls ----

# Tests
with_mock_api({
  test_that("nassqs_param_values forms a correct URL", {
    expect_GET(nassqs_param_values("source_desc"),
               "https://quickstats.nass.usda.gov/api/get_param_values?key=API_KEY&param=source_desc&format=CSV")
  })
})



### Tests with real API calls ----

with_authentication({
  test_that("nassqs_param_values returns parameter values", {
    v = nassqs_param_values("source_desc")
    expect_is(v, "character")
    expect_is(v[[1]], "character")
    expect_equal(nassqs_param_values("source_desc"), c("CENSUS", "SURVEY"))
    expect_equal(nassqs_param_values("SOURCE_DESC"), c("CENSUS", "SURVEY"))
    expect_equal(nassqs_param_values(param = "SOURCE_DESC"), c("CENSUS", "SURVEY"))
  })

  test_that("nassqs_param_values returns parameter values filtered for other parameters", {
    v = nassqs_param_values(param = "source_desc", year = 2012, county_name = "YAKIMA",
                            group_desc = "EXPENSES", sector_desc = "DEMOGRAPHICS")
    expect_equal(v, c("CENSUS"))

    expect_equal(
      nassqs_param_values(param = "county_code", year = 2012, 
                          state_alpha = "WA", agg_level_desc = "COUNTY",
                          group_desc = "EXPENSES", 
                          sector_desc = "DEMOGRAPHICS")[1:2],
      c("001", "005"))
   }) 
})


### Tests not involving the API ----
test_that("nassqs_params() returns a list of parameters", {
  expected_param_list <- c("agg_level_desc", "asd_code", "asd_desc",
                           "begin_code", "class_desc", "commodity_desc",
                           "congr_district_code", "country_code",
                           "country_name", "county_ansi",
                           "county_code", "county_name", "domaincat_desc",
                           "domain_desc", "end_code", "freq_desc", "group_desc",
                           "load_time", "location_desc", "prodn_practice_desc",
                           "reference_period_desc", "region_desc",
                           "sector_desc", "short_desc", "state_alpha",
                           "state_ansi", "state_name", "state_fips_code",
                           "statisticcat_desc", "source_desc", "unit_desc",
                           "util_practice_desc", "watershed_code",
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
