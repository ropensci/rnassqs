---
title: "The rnassqs R package: access the USDA National Agricultural Statistics Service (NASS) 'Quick Stats' API"
tags:
  - R
  - reproducibility
  - high-performance computing
  - pipeline
  - workflow
  - Make
authors:
  - name: Nicholas A. Potter
    orcid: 0000-0002-3410-3732
    email: potter.nicholas@gmail.com
    affiliation: 1
affiliations:
  - name: Washington State University
    index: 1
date: 01 June 2019
bibliography: paper.bib
---

# Summary

The [rnassqs](https://github.com/ropensci/rnassqs) `R` package [@rnassqs] is an API wrapper for the United States Department of Agriculture
National Agricultural Statistics Service (NASS) ‘[Quick
Stats](https://quickstats.nass.usda.gov/)’ API [@quickstats]. The core
functionality allows the user to query and parse agricultural data from
‘Quick Stats’ in a reproducible and automated way. It manages API
authentication by setting a system environmental variable for the
duration of the `R` session. Several convenience functions allow the
user to easily query common data, as well as see the parameters and
valid parameter values that are available with which to query. The query
can return both JSON and CSV formats, and parsing converts both of these
formats to a data.frame object.

Without a programmatic interface to an API, the initial collection of
data can be one of the most difficult stages of research make
reproducible. The [rnassqs](https://github.com/ropensci/rnassqs) package
makes the collection of data reproducible, improving both the
reliability of the research and the accessibility for others seeking to
replicate or expand on it.

In addition, developers of web tools or generated reports can use
[rnassqs](https://github.com/ropensci/rnassqs) to repeatedly query data,
which would have previously required explicitly constructing html GET
requests.

# Acknowledgements

Thank you to Jonathan Adams, Julia Piaskowski, and Joseph Stachelek for contributions.

# References