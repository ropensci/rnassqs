context("tests run locally.")

# These tests require an authentication key

params = list(
  commodity_desc = "CORN",
  year__GE = "2012",
  state_alpha = "VA"
)

test_that("nassqs_record_count returns a numeric", {
  skip_on_cran()
  #skip_on_travis()
  key_file <- here::here(".secret")
  if(file.exists(key_file)) {
    con <- file(key_file)
    key <- readLines(con)
    close(con)
  } else {
    key = Sys.getenv("NASSQS_TOKEN")
  }
  
  v = nassqs_record_count(params, key = key)
  expect_equal(is.numeric(as.numeric(v)), TRUE)
})

test_that("nassqs_param_values returns list of characters.", {
  skip_on_cran()
  #skip_on_travis()
  key_file <- here::here(".secret")
  if(file.exists(key_file)) { 
    con <- file(key_file)
    key <- readLines(con)
    close(con)
  } else {
    key = Sys.getenv("NASSQS_TOKEN")
  }
  
  v = nassqs_params_values("statisticcat_desc", key = key)
  expect_is(v, "list")
  expect_is(v[[1]], "character")
})
