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

test_that("nassqs_record_count forms a correct URL", {
  v = nassqs_record_count(params, key = "API_KEY", debug = TRUE)
  expect_equal(v, 
               "https://quickstats.nass.usda.gov/api/get_counts?key=API_KEY&commodity_desc=CORN&year__GE=2012&state_alpha=VA&format=JSON")
})

test_that("nassqs_param_values forms a correct URL", {
  v = nassqs_params_values("statisticcat_desc", key = "API_KEY", debug = TRUE)
  expect_equal(v, 
               "https://quickstats.nass.usda.gov/api/get_param_values?key=API_KEY&param=statisticcat_desc&format=JSON")
})

test_that("nassqs_field_values forms a correct URL", {
  v = nassqs_field_values("statisticcat_desc", key = "API_KEY", debug = TRUE)
  expect_equal(v, 
               "https://quickstats.nass.usda.gov/api/get_param_values?key=API_KEY&param=statisticcat_desc&format=JSON")
})

test_that("nassqs_GET forms a correct URL", {
  v = nassqs_GET(params, key = "API_KEY", debug = TRUE)
  expect_equal(v,
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year__GE=2012&state_alpha=VA&format=JSON")
})