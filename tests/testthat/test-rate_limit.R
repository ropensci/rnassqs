context("test rate limiting functionality")

test_that("rate_limit respects set time", {
  # Save original settings to restore later
  old_settings <- list(
    rate_seconds = getOption("nassqs.rate_seconds", 0.2),
    override = getOption("nassqs.override_rate_limit", FALSE),
    last_request_time = getOption("nassqs.last_request_time", NULL)
  )
  
  # Clean up after test
  on.exit({
    options(nassqs.rate_seconds = old_settings$rate_seconds)
    options(nassqs.override_rate_limit = old_settings$override)
    if (is.null(old_settings$last_request_time)) {
      options(nassqs.last_request_time = NULL)
    } else {
      options(nassqs.last_request_time = old_settings$last_request_time)
    }
  })
  
  # Set rate limiting parameters for testing
  test_rate <- 1  # 1 second rate limit for faster tests
  options(nassqs.rate_seconds = test_rate)
  options(nassqs.override_rate_limit = FALSE)
  options(nassqs.last_request_time = NULL)
  
  # First call should not wait
  start_time <- Sys.time()
  wait_time <- rate_limit(rate_seconds = test_rate)
  elapsed <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
  expect_lt(elapsed, 0.1)  # Should be near-instantaneous
  
  # Second call should wait ~test_rate seconds
  start_time <- Sys.time()
  wait_time <- rate_limit(rate_seconds = test_rate)
  elapsed <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
  expect_gte(elapsed, test_rate * 0.9)  # Allow for small timing differences
  expect_lt(elapsed, test_rate + 0.5)   # But not too much
})

test_that("rate_limit can be overridden", {
  # Save original settings
  old_settings <- list(
    rate_seconds = getOption("nassqs.rate_seconds", 0.2),
    override = getOption("nassqs.override_rate_limit", FALSE),
    last_request_time = getOption("nassqs.last_request_time", NULL)
  )
  
  # Clean up after test
  on.exit({
    options(nassqs.rate_seconds = old_settings$rate_seconds)
    options(nassqs.override_rate_limit = old_settings$override)
    if (is.null(old_settings$last_request_time)) {
      options(nassqs.last_request_time = NULL)
    } else {
      options(nassqs.last_request_time = old_settings$last_request_time)
    }
  })
  
  # Set rate limiting to 5 seconds
  options(nassqs.rate_seconds = 5)
  
  # First request to set time
  rate_limit()
  Sys.sleep(0.1)  # Small delay
  
  # This would normally wait ~5 seconds, but we'll override it
  start_time <- Sys.time()
  wait_time <- rate_limit(override = TRUE)
  elapsed <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
  
  # Should be near-instantaneous since we've overridden the rate limit
  expect_lt(elapsed, 0.1)
})

test_that("nassqs_rate_limit function properly sets options", {
  # Save original settings
  old_settings <- list(
    rate_seconds = getOption("nassqs.rate_seconds", 0.2),
    override = getOption("nassqs.override_rate_limit", FALSE)
  )
  
  # Clean up after test
  on.exit({
    options(nassqs.rate_seconds = old_settings$rate_seconds)
    options(nassqs.override_rate_limit = old_settings$override)
  })
  
  # Test setting rate limit
  nassqs_rate_limit(rate_seconds = 7, override = TRUE)
  expect_equal(getOption("nassqs.rate_seconds"), 7)
  expect_true(getOption("nassqs.override_rate_limit"))
  
  # Test restoring defaults
  nassqs_rate_limit(rate_seconds = 0.2, override = FALSE)
  expect_equal(getOption("nassqs.rate_seconds"), 0.2)
  expect_false(getOption("nassqs.override_rate_limit"))
})
