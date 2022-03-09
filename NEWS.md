# rnassqs 0.6.0

- The default download is CSV format instead of JSON to reduce download sizes.
- Additional tests have been added.
- Parameters have been clarified so that only the parameters usable in a query are returned by `nassqs_params()` and `format` is a specific argument to `nassqs()`. Although `CV` and `Value` are returned columns from Quick Stats, they are not queriable parameters.
- By default, `nassqs()` now converts the character `Value` to numeric. Raw character `Value` can be obtained by `as_numeric = FALSE`.
- Documentation for query parameters has been improved and available query parameters are explicit in `nassqs()` now. Functionality is unchanged but parameter names are listed and available in help. Thanks to Robert Dinterman for the initial contribution.
- An option to see valid parameter values given a query of other values in `nassqs_param_values()` has been added.
- `nassqs_record_count()` now validates parameters. 


# rnassqs 0.5.0

- Approval for rOpensci inclusion!
- Additional testing to improve code coveral by @nealrichardson
- Small changes for rOpensci review process
- Switch to rOpensci repository
- Change in syntax to allow for lower case query parameter values
- Change in syntax to allow for specifying each parameter as a separate function argument rather than as a single list (in addition to specifying a single list)
- Create package website with pkgdown
- Standardize code style in package code, examples, and vignette
- Simplify authentication
- Expanded test coverage with use of httptest::with_mock_api()
- Better clarification in documentation and documentation examples
- Improved README and vignette

# rnassqs 0.4.0.9000

- Development version

# rnassqs 0.4.0

- Add automated unit tests that work locally and others that work on CRAN.
- Improve documentation for core functions.
- Add parsing for CSV formatted data.
- Improve authentication.
- Simplify function calls to eliminate redundant calls.
- Add working examples and tests.
- fix name error in the function `nassqs_params_values` to `nassqs_param_values`

# rnassqs 0.3.0

- Prepare package for CRAN submission.
- Vignettes and README.md are up to date with respect to current functions.
- Fix tests.
- Minor spelling fixes contributed by Julia Piaskowski <@jpiaskowski>
- Remove test code that couldn't be run due to API needing authentication.
