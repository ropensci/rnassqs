context("test authentication")

### Test authentication.
test_that("nassqs_auth takes a new key", {
  key <- Sys.getenv("NASSQS_TOKEN")
  Sys.unsetenv("NASSQS_TOKEN")
  nassqs_auth(key = "API_KEY")
  expect_equal("API_KEY", Sys.getenv("NASSQS_TOKEN"))
  Sys.setenv(NASSQS_TOKEN = key)
})
