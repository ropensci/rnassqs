## Test environments
* local Arch Linux Install, kernel 4.20.3-arch1-1-ARCH, R 3.5.2
* ubuntu 14.04.5 LTS (on travis-ci), R 3.5.3
* win-builder (devel and release)
* r-hub builder

## R CMD check results
There were no ERRORs, no WARNINGs, and 1 NOTEs

The NOTE is because this is a new package.

## Resubmission
This is a resubmission. In this version I have made requested changes to:

* Use single quotes around names of packages, software, and APIs (e.g. 'Quick Stats') in the title and description (and also throughout the documentation).

* Explain acronyms in the description text (e.g. NASS).

* Provide executable examples in all exported functions. Some of these cannot be tested because they require an authentication key. Those have been excluded from testing with \donttest{}.

* Switch examples that should be excluded from testing to use '\donttest' instead of '\dontrun'.

## Downstream dependencies
There are no downstream dependencies
