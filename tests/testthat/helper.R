library(httptest)

with_mock_api <- function(expr) {
  # Set a fake token just in this context
  old_token <- Sys.getenv("NASSQS_TOKEN")
  Sys.setenv(NASSQS_TOKEN = "API_KEY")
  on.exit(Sys.setenv(NASSQS_TOKEN = old_token))

  httptest::with_mock_api(expr)
}

with_authentication <- function(expr) {
  if (!identical(Sys.getenv("NASSQS_TOKEN"), "")) {
    # Only evaluate if a token is set
    expr
  }
}
