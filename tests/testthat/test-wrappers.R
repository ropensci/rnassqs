context("tests wrappers and ease of use functions.")


### Tests with no authentication required
test_that("nassqs_record_count performs parameter validation", {
  expect_error(
    nassqs_record_count(setor_desc = "TEST SECTOR"), 
    "Parameter 'setor_desc' is not a valid parameter. Use `nassqs_params()`\n    for a list of valid parameters.", fixed = TRUE)
  Sys.sleep(1)
})


### Test API URLs with mock APIs ----

with_mock_api({
  test_that("nassqs_record_count forms a correct URL", {
    expected_url <- "https://quickstats.nass.usda.gov/api/get_counts?key=API_KEY&agg_level_desc=STATE&commodity_desc=CORN&domaincat_desc=NOT%20SPECIFIED&state_alpha=VA&statisticcat_desc=AREA%20HARVESTED&year=2012&format=CSV"
    expect_GET(nassqs_record_count(params), expected_url)
  })

  test_that("nassqs_yield returns a correct URL", {
    expected_url <- "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&agg_level_desc=STATE&commodity_desc=CORN&domaincat_desc=NOT%20SPECIFIED&state_alpha=VA&statisticcat_desc=YIELD&year=2012&format=CSV"
    expect_GET(nassqs_yields(params), expected_url)
  })

  test_that("nassqs_yield returns a correct URL even if statisticcat_desc parameter is set to a different value", {
    expected_url <- "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&agg_level_desc=STATE&commodity_desc=CORN&domaincat_desc=NOT%20SPECIFIED&state_alpha=VA&statisticcat_desc=YIELD&year=2012&format=CSV"
    params[['statisticcat_desc']] <- "AREA HARVESTED"
    expect_GET(nassqs_yields(params), expected_url)
  })

  test_that("nassqs_area returns a correct URL", {
    expected_url <- "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&agg_level_desc=STATE&commodity_desc=CORN&domaincat_desc=NOT%20SPECIFIED&state_alpha=VA&statisticcat_desc=AREA%20BEARING&year=2012&unit_desc=ACRES&format=CSV"
    expect_GET(nassqs_acres(params, area = "AREA BEARING"), expected_url)
  })

  test_that("nassqs_area returns a correct URL when multiple areas are specified", {
    expected_url <- "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&agg_level_desc=STATE&commodity_desc=CORN&domaincat_desc=NOT%20SPECIFIED&state_alpha=VA&statisticcat_desc=AREA%20HARVESTED&statisticcat_desc=AREA%20PLANTED&year=2012&unit_desc=ACRES&format=CSV"
    expect_GET(nassqs_acres(params, area = c("AREA HARVESTED", "AREA PLANTED")), expected_url)
  })
})


### API tests that require the API ----
with_authentication({
  test_that("nassqs_record_count returns a numeric", {
    v <- nassqs_record_count(params)
    expect_equal(is.numeric(v$count), TRUE)
    Sys.sleep(1)
  })

  test_that("nassqs_record_count takes a list of parameters", {
    v <- nassqs_record_count(params)
    expect_equal(is.numeric(v$count), TRUE)
    Sys.sleep(1)
  })

  test_that("nassqs_record_count takes parameters", {
    v <- nassqs_record_count(sector_desc = "SECTOR")
    expect_equal(is.numeric(v$count), TRUE)
    Sys.sleep(1)
  })
  
  test_that("nassqs_byfips returns correct data", {
    fips <- c("19001", "17005", "17001")
    r <- nassqs_byfips(
      fips = fips,
      commodity_desc = "CORN",
      util_practice_desc = "GRAIN",
      year = 2019,
      statisticcat_desc = "YIELD")
    
    expect_equal(unique(r$year), "2019")
    expect_equal(sort(r$county_name), c("ADAIR", "ADAMS", "BOND"))
    expect_equal(sort(r$state_name), c("ILLINOIS", "ILLINOIS", "IOWA"))
  })
  
})
