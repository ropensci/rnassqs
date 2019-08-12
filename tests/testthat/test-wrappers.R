context("tests wrappers and ease of use functions.")

### Setup
params <- list(
  commodity_desc = "CORN",
  year = "2012",
  statisticcat_desc = "YIELD",
  agg_level_desc = "STATE",
  state_alpha = c("VA", "WA")
)

### Test API URLs with mock APIs ----

with_mock_api({
  test_that("nassqs_record_count forms a correct URL", {
    expect_GET(nassqs_record_count(params),
                 "https://quickstats.nass.usda.gov/api/get_counts?key=API_KEY&commodity_desc=CORN&year=2012&statisticcat_desc=YIELD&agg_level_desc=STATE&state_alpha=VA&state_alpha=WA&format=JSON")
  })

  test_that("nassqs_yield returns a correct URL", {
    expect_GET(nassqs_yields(params),
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year=2012&statisticcat_desc=YIELD&agg_level_desc=STATE&state_alpha=VA&state_alpha=WA&format=JSON")
  })

  test_that("nassqs_yield returns a correct URL even if statisticcat_desc parameter is set to a different value", {
    params[['statisticcat_desc']] <- "AREA HARVESTED"
    expect_GET(nassqs_yields(params),
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year=2012&statisticcat_desc=YIELD&agg_level_desc=STATE&state_alpha=VA&state_alpha=WA&format=JSON")
  })

  test_that("nassqs_area returns a correct URL", {
    expect_GET(nassqs_acres(params, area = "AREA BEARING"),
               "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year=2012&statisticcat_desc=AREA%20BEARING&agg_level_desc=STATE&state_alpha=VA&state_alpha=WA&unit_desc=ACRES&format=JSON")
  })

  test_that("nassqs_area returns a correct URL when multiple areas are specified", {
    expect_GET(nassqs_acres(params, area = c("AREA HARVESTED", "AREA PLANTED")),
                 "https://quickstats.nass.usda.gov/api/api_GET?key=API_KEY&commodity_desc=CORN&year=2012&statisticcat_desc=AREA%20HARVESTED&statisticcat_desc=AREA%20PLANTED&agg_level_desc=STATE&state_alpha=VA&state_alpha=WA&unit_desc=ACRES&format=JSON")
  })
})


### API tests that require the API ----
with_authentication({
  test_that("nassqs_record_count returns a numeric", {
    v <- nassqs_record_count(params)
    expect_equal(is.numeric(v$count), TRUE)
  })
})
