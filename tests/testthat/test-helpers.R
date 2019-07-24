context("test helper functions")

single_params <- list(
  commodity_desc = "CORN",
  year__GE = "2012",
  state_alpha = "VA"
)
multi_params <- list(
  commodity_desc = "CORN",
  year__GE = "2012",
  state_alpha = c("VA", "WA")
)
multi_expected_list <- list(commodity_desc = "CORN",
                      year__GE = "2012",
                      state_alpha = "VA",
                      state_alpha = "WA")

## Test expand_list() ----
test_that("expand_list() accepts a list of arguments with no multiple values", {
  l1 <- expand_list(single_params)
  expect_equal(single_params, l1)
})

test_that("expand_list() accepts a list of arguments with multiple values", {
  l1 <- expand_list(multi_params)
  expect_equal(multi_expected_list, l1)
})


test_that("expand_list() accepts separate arguments", {
  expected_list <- list(
    commodity_desc = "CORN",
    year__GE = "2012",
    state_alpha = "VA",
    state_alpha = "WA"
  )
  l1 <- expand_list(commodity_desc = "CORN", 
                    year__GE = "2012", 
                    state_alpha = c("VA", "WA"))
  expect_equal(expected_list, l1)
})



