library(httptest)

# If no authentication, skip
skip_if_no_auth <- function() {
  if (Sys.getenv("NASSQS_TOKEN") %in% c("", "API_KEY")) {
    skip("No authentication available")
  }
}

