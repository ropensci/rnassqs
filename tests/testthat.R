library(testthat)

# Set rate limiting override for testing to avoid unnecessary delays
old_override <- getOption("nassqs.override_rate_limit", FALSE)
options(nassqs.override_rate_limit = TRUE)

# Run tests
test_check("rnassqs")

# Reset rate limiting option to original value
options(nassqs.override_rate_limit = old_override)
