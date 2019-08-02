library(httptest)

# If no authentication, skip
skip_if_no_auth <- function() {
  if (Sys.getenv("NASSQS_TOKEN") %in% c("", "API_KEY")) {
    skip("No authentication available")
  }
}

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
