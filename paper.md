---
<<<<<<< HEAD
title: "The rnassqs R package: access the USDA National Agricultural Statistics Service (NASS) 'Quick Stats' API"
tags:
  - R
  - reproducibility
  - workflow
=======
title: "rnassqs: An `R` package to access agricultural data via the USDA 
  National Agricultural Statistics Service (USDA-NASS) 'Quick Stats' API"
>>>>>>> a3e820c98d6e779d0974f640a3c9e616ad9d9e33
authors:
- affiliation: 1
  email: potter.nicholas@gmail.com
  name: Nicholas A. Potter
  orcid: 0000-0002-3410-3732
date: "09 June 2019"
output: pdf_document
bibliography: paper.bib
tags:
- R
- API
- reproducibility
affiliations:
- index: 1
  name: Washington State University
---

# Summary

The [rnassqs](https://github.com/ropensci/rnassqs) `R` package [@rnassqs] is an API wrapper for the United States Department of Agriculture National Agricultural Statistics Service (USDA-NASS) '[Quick Stats](https://quickstats.nass.usda.gov/)' API [@quickstats]. The core functionality allows the user to query agricultural data from 'Quick Stats' in a reproducible and automated way. 

`rnassqs` manages API authentication by setting a system environmental variable for the duration of the `R` session. Convenience functions facilitate querying common data. Users can also use `rnassqs` to query the list of data parameters and available values for a given parameter (for example, to see the commodities available). The query can request data in JSON or CSV formats, and parses that
data into a `data.frame` object.

`rnassqs` was written to address issues that arise from accessing data via a point-and-click interface, particularly in terms of automation and reproducibility of data requests. 


# About USDA-NASS data and 'Quick Stats'

'Quick Stats' is a web interface to access data produced by USDA-NASS. The data 
comes primarily from the Census of Agriculture [@agCensus], but also includes
data from USDA-NASS surveys on a wide range of topics. The Census of Agriculture
is conducted every five years in years ending in '2' and '7'. The most recent
census was completed in 2017. 'Quick Stats' provides access to census data 
beginning in 1997, and some survey data as far back as 1850.

Aggregate data from the census and surveys is released primarily at the 
national, state, and county level, though some data may be released for 
congressional districts, watersheds, and zip codes. It includes a range of data
classified under five sectors: Animals & Products, Crops, Demographics, 
Economics, and Environmental. Examples of data available in these sectors 
include counts of farms, farm operators, acres of cropland, farm sales, farm 
expenses, and crop yields, to name a few.


# Benefits of `rnassqs` over 'Quick Stats'

'Quick Stats' provides a number of selection fields in which the user can select
categories of data. Selections available in each field change to reflect 
available options based on other selections that the user has made. Data 
requests are limited to 50,000 records. This works well for exploration of 
available data or quick access to data for a single use. However, there are 
several cases in which the 'Quick Stats' interface is not ideal:

- Requests for a combination of crops, years, and 
  geographies that exceed 50,000 records.
- Requests for newly released data that are identical to previous requests.
- Requests that are reproducible.

`rnassqs` addresses each of these issues by making the 'Quick Stats' API 
accessible with `R` code. This allows the user to loop over a series of requests
to address the first issue, to execute (perhaps automated on a schedule) a data 
request repeatedly to access new data with the same query to address the 
second, and to make code available that allows others to reproducibly access 
the same data to address the third.

For example, there are currently there are currently 332,125 records of crop 
yields in all U.S. counties from 2000 to 2018. Accessing this data through 
'Quick Stats' would require manually selecting either a set of years or a set 
of states to reduce each request to less than 50,000 records and then 
aggregating that data. With `rnassqs` this can be done with:


```r
# Access yields for all counties and all crops
params <- list(sector_desc = "CROPS",
               group_desc = c("FIELD CROPS", "FRUIT & TREE NUTS", 
                              "HORTICULTURE", "VEGETABLES"),
               statisticcat_desc = "YIELD", 
               agg_level_desc = "COUNTY")

# Get all years from 2000 to 2018 in a list of data.frames
data_list <- lapply(2000:2018, function(yr) { 
  params$year <- yr
  rnassqs::nassqs(params, url_only = TRUE)
})

# Aggregate the list of data.frames into a single data.frame
d <- do.call("rbind", data_list)
```

# Alternatives to `rnassqs`

USDA-NASS also provides FTP access to text data files^[Available at: 
[ftp://ftp.nass.usda.gov/quickstats/](ftp://ftp.nass.usda.gov/quickstats/)]. 
By accessing the data via FTP users can avoid using the selection interface of
'Quick Stats' and avoid limitations on the number of records per request, but do 
not resolve issues of automated repeated requests or of making data requests 
reproducible.
>>>>>>> a3e820c98d6e779d0974f640a3c9e616ad9d9e33

# Acknowledgements

Thank you to Jonathan Adams, Julia Piaskowski, and Joseph Stachelek for contributions.

# References
