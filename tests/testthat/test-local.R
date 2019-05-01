context("tests run locally.")
# These tests require an authentication key

key_file <- here::here(".secret")
if(file.exists(key_file)) { 
  con <- file(key_file)
  key <- readLines(con)
  close(con)
} else {
  key = Sys.getenv("NASSQS_TOKEN")
}
nassqs_auth(key = key)



# If no authentication, skip
skip_if_no_auth <- function() {
  if (identical(Sys.getenv("NASSQS_TOKEN"), "")) {
    skip("No authentication available")
  }
}

### Setup
params = list(
  commodity_desc = "CORN",
  year = "2012",
  statisticcat_desc = "YIELD",
  agg_level_desc = "STATE",
  state_alpha = "VA"
)

### Tests for API calls --------------------------------------------------------
test_that("nassqs_record_count returns a numeric", {
  skip_if_no_auth()
  
  v = nassqs_record_count(params, key = key)
  expect_equal(is.numeric(as.numeric(v$count)), TRUE)
})

test_that("nassqs_param_values returns list of characters.", {
  skip_if_no_auth()
  
  v = nassqs_param_values("sector_desc")
  expect_is(v, "character")
  expect_is(v[[1]], "character")
})

test_that("nassqs_param_values returns the correct output from API documentation.", {
  skip_if_no_auth()

  v = nassqs_param_values("sector_desc")
  expect_equal(v, c("ANIMALS & PRODUCTS", "CROPS", "DEMOGRAPHICS", "ECONOMICS", "ENVIRONMENTAL"))
})


### Test for API error messages ------------------------------------------------








