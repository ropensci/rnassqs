context("nassqs")



test_that("nassqs_record_count returns numeric.", {
  params = list(
    statisticcat_desc = "YIELD",
    commodity_desc = "CORN",
    year = "2012"
  )
  v = nassqs_record_count(params)
  expect_equal(is.numeric(as.numeric(v)), TRUE)
})

test_that("nassqs_param_values returns list of characters.", {
  v = nassqs_params_values("statisticcat_desc")
  expect_is(v, "list")
  expect_is(v[[1]], "character")
})

test_that("passing vectors as arguments works.", {
  # Can't run this automatically because we need an api key
  #params = list("commodity_desc"="CORN",
  #              "domain_desc" = "AREA OPERATED",
  #              "year__GE"=2012, 
  #              "state_alpha"=c("VA", "PA"))
  #df = nassqs(params=params, key = key)
  #expect_equal(nrow(df), 280)
})
