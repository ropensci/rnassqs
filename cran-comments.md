## Test environments
* local Arch Linux Install, kernel 5.16.10-arch1-1, R 4.1.2
* win-builder (devel and release)
* r-hub builder

## R CMD check results
There were no ERRORs, no WARNINGs, and 1 NOTEs.

The note is due to resubmitting after a single day. I'm very embarrassed to have to submit this again so quickly. There was a bug that for some reason testthat wasn't picking up due to differences in the environment(). I fixed that, no other changes. My deep apologies for taking up unnecessary time, I thought I had triple-checked everything.

## Downstream dependencies
There are no downstream dependencies
