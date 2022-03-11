context("test helper functions")


## Test expand_list() ----
test_that("expand_list() accepts a list of arguments with no multiple values", {
  single_params <- list(
    commodity_desc = "CORN",
    year__GE = "2012",
    state_alpha = "VA"
  )
  expect_equal(single_params, expand_list(single_params))
})

test_that("expand_list() accepts a list of arguments with multiple values", {
  multi_params <- list(
    commodity_desc = "CORN",
    year__GE = "2012",
    state_alpha = c("VA", "WA")
  )
  expect_equal(multi_params, expand_list(multi_params))
})


test_that("expand_list() accepts separate arguments", {
  expected_list <- list(
    commodity_desc = "CORN",
    year__GE = "2012",
    state_alpha = c("VA", "WA"))
  l1 <- expand_list(commodity_desc = "CORN", 
                    year__GE = "2012", 
                    state_alpha = c("VA", "WA"))
  expect_equal(expected_list, l1)
})

## Test char_to_num() ----
test_that("char_to_num() correctly converts an array of character values to numbers", {
  c_str <- c("43,345", "1", "(D)", "(Z)", "", "NA")
  c_expected <- c(43345, 1, NA, NA, NA, NA)
  expect_equal(char_to_num(c_str), c_expected)
})

test_that("char_to_num() warnings ensue when not parsed correctly", {
  c_str <- c("43,345", "1", "(D)", "(Z)", "", "NA", "(A)")
  expect_warning(char_to_num(c_str), "NAs introduced by coercion")
})

