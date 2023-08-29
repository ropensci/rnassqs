## Test environments
* local windows 11 install, R 4.3.1
* github action R-CMD-CHECK: macos-latest (release), ubuntu-latest (devel), ubuntu-latest (oldrel-1), ubuntu-latest (release), windows-latest (release)
* win-builder.r-project.org (devel)

## R CMD check results
There were no ERRORs, no WARNINGs, and 1 NOTEs.

The note is due to "unable to verify current time" message when verifying file timestamps. From what I can tell, this is due to `check` attempting to access http://worldclockapi.com/, which is no longer available. This note will be resolved if/when the R core team changes this function.

## Downstream dependencies
There are no downstream dependencies
