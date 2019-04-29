context("tests run locally.")
# These tests require an authentication key

### Setup
params = list(
  commodity_desc = "CORN",
  year = "2012",
  statisticcat_desc = "YIELD",
  agg_level_desc = "STATE",
  state_alpha = "VA"
)

### Test authentication.
test_that("nassqs_auth returns the api key from NASSQS_TOKEN if set", {
  skip_on_cran()
  key = Sys.getenv("NASSQS_TOKEN")
  expect_equal(key, nassqs_auth())
})

test_that("nassqs_auth takes a new key", {
  skip_on_cran()
  skip_on_travis()
  key <- Sys.getenv("NASSQS_TOKEN")
  Sys.unsetenv("NASSQS_TOKEN")
  nassqs_auth(key = "API_KEY")
  expect_equal("API_KEY", Sys.getenv("NASSQS_TOKEN"))
  Sys.setenv(NASSQS_TOKEN = key)
})

test_that("nassqs_auth returns error is NASSQS_TOKEN not set and not interactive", {
  skip_on_cran()
  skip_on_travis()
  key <- Sys.getenv("NASSQS_TOKEN")
  Sys.unsetenv("NASSQS_TOKEN")
  expect_error(nassqs_auth(), 
               "Session is not interactive, so please set env variable NASSQS_TOKEN to your NASS Quickstats API Key.")
})


### Tests for API calls --------------------------------------------------------

test_that("nassqs_record_count returns a numeric", {
  skip_on_cran()
  key_file <- here::here(".secret")
  if(file.exists(key_file)) { 
    con <- file(key_file)
    key <- readLines(con)
    close(con)
  } else {
    key = Sys.getenv("NASSQS_TOKEN")
  }
  
  
  v = nassqs_record_count(params, key = key)
  expect_equal(is.numeric(as.numeric(v$count)), TRUE)
})

test_that("nassqs_param_values returns list of characters.", {
  skip_on_cran()
  key_file <- here::here(".secret")
  if(file.exists(key_file)) { 
    con <- file(key_file)
    key <- readLines(con)
    close(con)
  } else {
    key = Sys.getenv("NASSQS_TOKEN")
  }
  
  
  v = nassqs_params_values("sector_desc", key = key)
  expect_is(v, "character")
  expect_is(v[[1]], "character")
})

test_that("nassqs_param_values returns the correct output from API documentation.", {
  skip_on_cran()
  key_file <- here::here(".secret")
  if(file.exists(key_file)) { 
    con <- file(key_file)
    key <- readLines(con)
    close(con)
  } else {
    key = Sys.getenv("NASSQS_TOKEN")
  }
  
  v = nassqs_params_values("sector_desc", key = key)
  expect_equal(v, c("ANIMALS & PRODUCTS", "CROPS", "DEMOGRAPHICS", "ECONOMICS", "ENVIRONMENTAL"))
})




### Test for API error messages ------------------------------------------------
