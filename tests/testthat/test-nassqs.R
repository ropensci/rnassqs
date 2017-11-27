context("nassqs")



test_that("nassqs_record_count returns numeric.", {
  params = list(
    statisticcat_desc = "YIELD",
    commodity_desc = "CORN",
    year = "2012"
  )
  #v = nassqs_record_count(params)
})

test_that("nassqs_param_values returns list of characters.", {
  #v = nassqs_param_values("statisticcat_desc")
  #expect_is(v, "list")
  #expect_is(v[1], "list")
})

